package app.marketplace.com.marketplace

import android.os.Bundle
import android.util.Log

import com.google.gson.Gson
import com.mesibo.api.Mesibo

class MesiboFileTransferHelper(token: String)  : Mesibo.FileTransferHandler {

    private var mDownloadCounter = 0
    private var mUploadCounter = 0

    var tokenUser: String? = token
    class MesiboUrl internal constructor() {
        var op: String? = null
        var file: String? = null
        var result: String? = null
        var xxx: String? = null


        init {
            result = null
            op = null
            xxx = null
            file = null
        }
    }

    init {
        Mesibo.addListener(this)


    }





    fun Mesibo_onStartUpload(params: Mesibo.MessageParams, file: Mesibo.FileInfo): Boolean {

        // we don't need to check origin the way we do in download
        if (Mesibo.getNetworkConnectivity() != Mesibo.CONNECTIVITY_WIFI && !file.userInteraction)
            return false

        // limit simultaneous upload or download
        if (mUploadCounter >= 3 && !file.userInteraction)
            return false

        val mid = file.mid
Log.d("Gett","Token Upload"+tokenUser)
        val b = Bundle()
        b.putString("op", "upload")
        b.putString("token", tokenUser)
        b.putLong("mid", mid)
        b.putInt("profile", 0)

        updateUploadCounter(1)
        val http = Mesibo.Http()

        http.url = "https://s3.mesibo.com/api.php"
        http.postBundle = b
        http.uploadFile = file.path
        http.uploadFileField = "photo"
        http.other = file
        file.fileTransferContext = http

        http.listener = Mesibo.HttpListener { config, state, percent ->
            val f = config.other as Mesibo.FileInfo

            Log.d("Gett","File Upload"+percent)
            val response11 = config.dataString
            Log.d("Gett","File Upload Response"+response11)
            if (100 == percent && Mesibo.Http.STATE_DOWNLOAD == state) {
                val response = config.dataString
                var mesibourl: MesiboUrl? = null
                try {
                    mesibourl = mGson.fromJson(response, MesiboUrl::class.java)

                } catch (e: Exception) {
                }

                if (null == mesibourl || null == mesibourl.file) {
                    Mesibo.updateFileTransferProgress(f, -1, Mesibo.FileInfo.STATUS_FAILED)
                    return@HttpListener false
                }

                //TBD, f.setPath if video is re-compressed
                f.url = mesibourl.file
            }

            var status = f.status
            if (100 == percent || status != Mesibo.FileInfo.STATUS_RETRYLATER) {
                status = Mesibo.FileInfo.STATUS_INPROGRESS
                if (percent < 0)
                    status = Mesibo.FileInfo.STATUS_RETRYLATER
            }

            if (percent < 100 || 100 == percent && Mesibo.Http.STATE_DOWNLOAD == state)
                Mesibo.updateFileTransferProgress(f, percent, status)

            if (100 == percent && Mesibo.Http.STATE_DOWNLOAD == state || status != Mesibo.FileInfo.STATUS_INPROGRESS)
                updateUploadCounter(-1)

            100 == percent && Mesibo.Http.STATE_DOWNLOAD == state || status != Mesibo.FileInfo.STATUS_RETRYLATER
        }

        mQueue?.queue(http) ?: if (http.execute()) {

        }

        return true

    }

    fun Mesibo_onStartDownload(params: Mesibo.MessageParams, file: Mesibo.FileInfo): Boolean {

        //TBD, check file type and size to decide automatic download
        if (Mesibo.getNetworkConnectivity() != Mesibo.CONNECTIVITY_WIFI && !file.userInteraction)
            return false

        // only realtime messages to be downloaded in automatic mode.
        if (Mesibo.ORIGIN_REALTIME != params.origin && !file.userInteraction)
            return false

        // limit simultaneous upload or download, 1st condition is redundant but for reference only
        if (Mesibo.getNetworkConnectivity() != Mesibo.CONNECTIVITY_WIFI && mDownloadCounter >= 3 && !file.userInteraction)
            return false

        updateDownloadCounter(1)

        val mid = file.mid

        var url = file.url
        if (!url.toLowerCase().startsWith("http://") && !url.toLowerCase().startsWith("https://")) {
            url = "https://appimages.mesibo.com/" + url
        }

        val http = Mesibo.Http()

        http.url = url
        http.downloadFile = file.path
        http.resume = true
        http.maxRetries = 10
        http.other = file
        file.fileTransferContext = http

        http.listener = Mesibo.HttpListener { http, state, percent ->
            val f = http.other as Mesibo.FileInfo

            var status = Mesibo.FileInfo.STATUS_INPROGRESS

            //TBD, we can simplify this now, don't need separate handling
            if (Mesibo.FileInfo.SOURCE_PROFILE == f.source) {
                if (100 == percent) {
                    Mesibo.updateFileTransferProgress(f, percent, Mesibo.FileInfo.STATUS_INPROGRESS)
                }
            } else {

                status = f.status
                if (100 == percent || status != Mesibo.FileInfo.STATUS_RETRYLATER) {
                    status = Mesibo.FileInfo.STATUS_INPROGRESS
                    if (percent < 0)
                        status = Mesibo.FileInfo.STATUS_RETRYLATER
                }

                Mesibo.updateFileTransferProgress(f, percent, status)

            }

            if (100 == percent || status != Mesibo.FileInfo.STATUS_INPROGRESS)
                updateDownloadCounter(-1)

            100 == percent || status != Mesibo.FileInfo.STATUS_RETRYLATER
        }

        mQueue?.queue(http) ?: if (http.execute()) {

        }

        return true
    }

    override fun Mesibo_onStartFileTransfer(file: Mesibo.FileInfo): Boolean {
        Log.d("Gett","Started "+tokenUser)
        return if (Mesibo.FileInfo.MODE_DOWNLOAD == file.mode) Mesibo_onStartDownload(file.params, file) else Mesibo_onStartUpload(file.params, file)

    }

    override fun Mesibo_onStopFileTransfer(file: Mesibo.FileInfo): Boolean {
        val http = file.fileTransferContext as Mesibo.Http
        http?.cancel()

        return true
    }

    @Synchronized
    fun updateDownloadCounter(increment: Int): Int {
        mDownloadCounter += increment
        return mDownloadCounter
    }

    @Synchronized
    fun updateUploadCounter(increment: Int): Int {
        mUploadCounter += increment
        return mUploadCounter
    }

    companion object {

        private val mGson = Gson()
        private val mQueue = Mesibo.HttpQueue(4, 0)
    }
}


