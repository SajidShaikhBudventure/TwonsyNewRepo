package app.marketplace.com.marketplace

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.webkit.MimeTypeMap
import android.widget.Toast
import com.mesibo.api.Mesibo
import com.mesibo.mediapicker.MediaPicker

object UIManager {
    fun launchImageViewer(context: Activity, filePath: String) {
        MediaPicker.launchImageViewer(context, filePath)
    }


    fun openMedia(context: Context, fileUrl: String, filePath: String) {

        val myMime = MimeTypeMap.getSingleton()
        val newIntent = Intent(Intent.ACTION_VIEW)
        val mimeType = myMime.getMimeTypeFromExtension(fileExt(fileUrl))
        newIntent.setDataAndType(Mesibo.uriFromFile(context, filePath), mimeType)
        newIntent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
        try {
            context.startActivity(newIntent)
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(context, "No App found for this type of file.", Toast.LENGTH_LONG).show()
        }

    }
    fun fileExt(url: String): String? {
        var url = url
        if (url.indexOf("?") > -1) {
            url = url.substring(0, url.indexOf("?"))
        }
        if (url.lastIndexOf(".") == -1) {
            return null
        } else {
            var ext = url.substring(url.lastIndexOf(".") + 1)
            if (ext.indexOf("%") > -1) {
                ext = ext.substring(0, ext.indexOf("%"))
            }
            if (ext.indexOf("/") > -1) {
                ext = ext.substring(0, ext.indexOf("/"))
            }
            return ext.toLowerCase()

        }
    }
}