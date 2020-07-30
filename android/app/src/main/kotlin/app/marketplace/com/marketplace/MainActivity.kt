package app.marketplace.com.marketplace

import android.Manifest
import android.app.AlertDialog
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.*
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.media.AudioAttributes
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.provider.ContactsContract
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import app.marketplace.com.marketplace.firebasenoti.MyFirebase
import com.google.gson.Gson
import com.mesibo.api.Mesibo
import com.mesibo.calls.MesiboCall
import com.mesibo.contactutils.ContactUtils
import com.mesibo.mediapicker.MediaPicker
import com.mesibo.messaging.MessagingActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.nio.charset.StandardCharsets
import java.util.*
import kotlin.math.log


class MainActivity : FlutterActivity(), Mesibo.ConnectionListener, Mesibo.MessageListener, Mesibo.MessageFilter, ContactUtils.ContactsListener  {

//    private val mCall: MesiboCall? = null
    var mEventsSink: EventSink? = null
    var mParameter: Mesibo.MessageParams? = null
    private val PERMISSION_REQUEST_CODE = 200
    var connected = false
     var token: String? = null




    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        appContext = applicationContext
        MediaPicker.setToolbarColor(Color.parseColor("#000000"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.MESIBO_ACTIVITY_CHANNEL).setStreamHandler(
                object : EventChannel.StreamHandler {
                    //private BroadcastReceiver chargingStateChangeReceiver;
                    var messageListener: Mesibo.ConnectionListener? = null
                    override fun onListen(arguments: Any?, events: EventSink) {
                        mEventsSink = events
                        mEventsSink?.success("Suceess")
                        Log.d("Gett","Hello");
                    }

                    override fun onCancel(arguments: Any?) {}
                }
        )
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.MESIBO_MESSAGING_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setAccessToken") {
                //get credentials from flutter
                val credentials = call.argument<ArrayList<*>>("Credentials")

                if (credentials != null) {
                    if(checkPermission()) {
                        mUserAccessToken = credentials[0].toString()
                        mPeer = credentials[1].toString()
                        token=credentials[0].toString();
                        val pref = getSharedPreferences("TokenData", 0) // 0 - for private mode
                        val editor = pref.edit()
                        editor.putString("token", mUserAccessToken)
                        editor.commit()
                        //start mesibo here

                        mesiboInit()

                        // set Mesibo MessageParams
                        mParameter = Mesibo.MessageParams(mPeer, 0, Mesibo.FLAG_DEFAULT, 0)


//                        val i = Intent(this@MainActivity, ListActivity::class.java)
//                        i.putExtra("peer", mParameter!!.peer)
//                        startActivity(i)
                    }else{
                        mUserAccessToken = credentials[0].toString()
                        mPeer = credentials[1].toString()

                        requestPermission();
                    }
                }
            } else if (call.method == "sendMessage") {
                if (null != mPeer) {
                    //send message to desired user added in mParameter
                    Mesibo.sendMessage(mParameter, Mesibo.random(), "Hello from Mesibo Flutter")
                    mEventsSink!!.success("Message Sent to " + mPeer)
                } else {
                    mEventsSink!!.success(Companion.MesiboErrorMessage)
                }
            } else if (call.method == "launchMesiboUI") {
                if (null != mPeer) {
                    //Launch Mesibo Custom UI
                    val i = Intent(this@MainActivity, ListActivity::class.java)
                    i.putExtra("peer", mParameter!!.peer)
                    startActivity(i)
                } else {
                    mEventsSink!!.success(Companion.MesiboErrorMessage)
                }
            } else if (call.method == "audioCall") {
                if (null != mPeer) {
                    val i = Intent(this@MainActivity, ListActivity::class.java)
                    i.putExtra("peer", mParameter!!.peer)
                    startActivity(i)

                    //make audio call
//                    MesiboCall.getInstance().call(this@MainActivity, Mesibo.random(), mParameter!!.profile, false)
                } else {
                    mEventsSink!!.success(Companion.MesiboErrorMessage)
                }
            } else if (call.method == "videoCall") {
                if (null != mPeer) {
                    //make Video Call
//                    MesiboCall.getInstance().call(this@MainActivity, Mesibo.random(), mParameter!!.profile, true)
                } else {
                    mEventsSink!!.success(Companion.MesiboErrorMessage)
                }
            } else {
                result.notImplemented()
            }
        }


    }


    private fun checkPermission(): Boolean {
        return if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            // Permission is not granted
            false
        } else true
    }

    private fun requestPermission() {
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.READ_EXTERNAL_STORAGE),
                PERMISSION_REQUEST_CODE)
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            PERMISSION_REQUEST_CODE -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                val pref = getSharedPreferences("TokenData", 0) // 0 - for private mode
                val editor = pref.edit()
                editor.putString("token", mUserAccessToken)
                editor.commit()
                mesiboInit()

                // set Mesibo MessageParams
                mParameter = Mesibo.MessageParams(mPeer, 0, Mesibo.FLAG_DEFAULT, 0)



                // main logic
            } else {
                Toast.makeText(applicationContext, "Permission Denied", Toast.LENGTH_SHORT).show()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                            != PackageManager.PERMISSION_GRANTED) {
                        showMessageOKCancel("You need to allow access permissions",
                                object : DialogInterface.OnClickListener {
                                    override fun onClick(dialog: DialogInterface?, which: Int) {
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                            requestPermission()
                                        }
                                    }
                                })
                    }
                }
            }
        }
    }
    private fun showMessageOKCancel(message: String, okListener: DialogInterface.OnClickListener) {
        AlertDialog.Builder(this@MainActivity)
                .setMessage(message)
                .setPositiveButton("OK", okListener)
                .setNegativeButton("Cancel", null)
                .create()
                .show()
    }
    private fun mesiboInit() {


        val api: Mesibo = Mesibo.getInstance()

        api.init(this)

        /** [OPTIONAL] Initializa calls if used   */
//        mCall = MesiboCall.getInstance()
//        mCall?.init(this)
        /** [Optional] add listener for file transfer handler
         * you only need if you plan to send and receive files using mesibo
         */
        Mesibo.setPath(Environment.getExternalStorageDirectory().absolutePath)
        val pref2 = getSharedPreferences("TokenData", 0)

        val path = Mesibo.getBasePath()
        MediaPicker.setPath(path)
        val fileTransferHelper =  MesiboFileTransferHelper(mUserAccessToken!!);
        Mesibo.addListener(fileTransferHelper);
        /** add other listener - you can add any number of listeners  */

        Mesibo.addListener(this)
        /** [Optional] enable to disable secure connection  */
        Mesibo.setSecureConnection(true)

        /** Initialize web api to communicate with your own backend servers  */
        //* set user access token



        Mesibo.setAccessToken(pref2.getString("token",""));
        Mesibo.setDatabase("mesibo.db", 0);

        // set path for storing DB and messaging files

        /* * [OPTIONAL] set up database to save and restore messages
         * Note: if you call this API before setting an access token, mesibo will
         * create a database exactly as you named it. However, if you call it
         * after setting Access Token like in this example, it will be uniquely
         * named for each user [Preferred].
//         * */


        // start mesibo
        Mesibo.start()
        val pref = getSharedPreferences("UserData", 0)
        val mGCMToken=pref.getString("fire_token","")
        Mesibo.setPushToken(mGCMToken)
        Mesibo.setKey("gcmtoken", mGCMToken)
        Log.d("Gett","GCM TOKEN"+mGCMToken)
        val restartIntent = Intent("com.mesibo.sampleapp.restart")
        Mesibo.runInBackground(this, null, restartIntent)


        /** add other listener - you can add any number of listeners  */
    }
    private fun createPostBundle(op: String): Bundle? {


        val b = Bundle()
        b.putString("op", op)
        b.putString("token", token)
        Log.d("Fire",b.toString())
        return b
    }

    override fun Mesibo_onConnectionStatus(i: Int) {
        if (i == Mesibo.STATUS_ONLINE) {
            if(checkPermission()) {
                connected=true
                mEventsSink!!.success("Mesibo Connection Status : Online")
                val pref = getSharedPreferences("UserData", 0)
                val mGCMToken=pref.getString("fire_token","")
                Mesibo.setPushToken(mGCMToken)
                Mesibo.setKey("gcmtoken", mGCMToken)
                Log.d("Gett","GCM TOKEN"+mGCMToken)
//                    val http = object : ResponseHandler() {
//                    override fun HandleAPIResponse(response: Response?) {
//                        Log.d("Gett", response?.result!!+"ffff");
//                        if (null != response && response.result!!.equals("OK", ignoreCase = true)) {
//
//                            Log.d("Fire Token", "Called")
//                        }
//                    }
//                }


            }else{
                requestPermission();
            }

        }
    }

    override fun Mesibo_onMessage(messageParams: Mesibo.MessageParams?, bytes: ByteArray?): Boolean {
        var message = ""
        try {
            message = String(bytes!!, StandardCharsets.UTF_8)
            if (!message.isEmpty()) mEventsSink!!.success("Mesibo Message Received : $message")
            //Toast.makeText(this, ""+message, Toast.LENGTH_SHORT).show();
          //  notification(messageParams?.peer.toString(),message)
        } catch (e: Exception) {
            // return false;
        }
        return false
    }


    fun notification(title: String?, body: String?) {
        val intent: Intent
        intent = Intent(applicationContext, MainActivity::class.java)
        val pi = PendingIntent.getActivity(applicationContext, 101, intent, 0)
        val nm = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        var channel: NotificationChannel? = null

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val att = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            channel = NotificationChannel("222", "my_channel", NotificationManager.IMPORTANCE_HIGH)
            nm.createNotificationChannel(channel)
        }
        var builder: NotificationCompat.Builder? = null
        builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val icon = BitmapFactory.decodeResource(applicationContext.resources,
                    R.mipmap.ic_launcher)
            NotificationCompat.Builder(
                    applicationContext, "222")
                    .setContentTitle(title)
                    .setAutoCancel(true)
                    .setLargeIcon(icon)
                    .setSmallIcon(R.mipmap.ic_launcher) //.setSound(Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.electro))
                    .setContentText(body)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentIntent(pi)
        } else {
            NotificationCompat.Builder(
                    applicationContext, "222")
                    .setContentTitle(title)
                    .setAutoCancel(true)
                    .setSmallIcon(R.drawable.app_logo) //.setSound(Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.electro))
                    .setContentText(body)
                    .setSmallIcon(R.drawable.app_logo)
                    .setContentIntent(pi)
        }
        builder.priority = NotificationCompat.PRIORITY_HIGH
        nm.notify(101, builder.build())
    }


    override fun Mesibo_onMessageStatus(messageParams: Mesibo.MessageParams?) {

    }
    override fun Mesibo_onActivity(messageParams: Mesibo.MessageParams?, i: Int) {}
    override fun Mesibo_onLocation(messageParams: Mesibo.MessageParams?, location: Mesibo.Location?) {}
    override fun Mesibo_onFile(messageParams: Mesibo.MessageParams?, fileInfo: Mesibo.FileInfo?) {}
    override fun Mesibo_onMessageFilter(messageParams: Mesibo.MessageParams?, i: Int, bytes: ByteArray?): Boolean {
Log.d("Gett","Message Recieved")

        if (1 != messageParams?.type )
            return true

        var message = ""
        try {
            message = String(bytes!!, Charsets.UTF_8)
        } catch (e: Exception) {
            return false
        }

        if (TextUtils.isEmpty(message))
            return false
         val mGson = Gson()
        var n: MesiboListeners.MesiboNotification? = null

        try {
            n = mGson.fromJson(message, MesiboListeners.MesiboNotification::class.java)
        } catch (e: Exception) {
            return false
        }

        if (null == n)
            return false

        var name = n.name
        if (!TextUtils.isEmpty(n.phone)) {
            name = ContactUtils.reverseLookup(n.phone)
            if (TextUtils.isEmpty(name))
                name = n.name
        }

        if (!TextUtils.isEmpty(n.subject)) {
            n.subject = n.subject!!.replace("%NAME%", name!!)
            n.msg = n.msg!!.replace("%NAME%", name)
            val  mNotifyUser = NotifyUser(this)
            mNotifyUser!!.sendNotification(NotifyUser.NOTIFYMESSAGE_CHANNEL_ID, NotifyUser.TYPE_OTHER, n.subject!!, n.msg!!)
        }

        return true
    }

    companion object {
        private const val MESIBO_MESSAGING_CHANNEL = "mesibo.flutter.io/messaging"
        private const val MESIBO_ACTIVITY_CHANNEL = "mesibo.flutter.io/mesiboEvents"
        private const val MesiboErrorMessage = "Mesibo has not started yet, Check Credentials"
//        private var mCall: MesiboCall? = null
        private var mUserAccessToken: String? = null
           var appContext: Context? = null
        private var mPeer: String? = null
    }

    override fun ContactUtils_onSave(p0: String?, p1: Long): Boolean {
        Mesibo.setKey("syncedContacts", p0)
        Mesibo.setKey("syncedPhoneContactTs", p1.toString())

        return true
    }

    override fun ContactUtils_onContact(p0: Int, p1: String?, p2: String?, p3: Long): Boolean {
   return  true;
    }
    abstract class ResponseHandler : Mesibo.HttpListener {
        private var http: Mesibo.Http? = null
        private var mRequest: Bundle? = null
        private var mBlocking = false
        private var mOnUiThread = false
        public var result = true
        var context: Context? = null

        override fun Mesibo_onHttpProgress(http: Mesibo.Http, state: Int, percent: Int): Boolean {
            if (percent < 0) {
                HandleAPIResponse(null)
                return true
            }

            if (100 == percent && Mesibo.Http.STATE_DOWNLOAD == state) {
                val strResponse = http.dataString
                var response: Response? = null
                Log.d("MesiboKotlin", "Exception in HTTP response"+ strResponse.toString())
                if (null != strResponse) {
                    val mGson = Gson()
                    try {
                        response = mGson.fromJson(strResponse, Response::class.java)
                    } catch (e: Exception) {
                        Log.d("MesiboKotlin", "Exception in HTTP response"+ e.toString())
                        this.result = false
                    }

                }

                if (null == response)
                    this.result = false

                val context = if (null == this.context) MainActivity.appContext else this.context

                if (!mOnUiThread) {
                   // parseResponse(response, mRequest, context, false)
                    HandleAPIResponse(response)
                } else {
                    val r = response

                    if (null == context)
                        return true

                    val uiHandler = Handler(context.mainLooper)

                    val myRunnable = Runnable {
                 //       parseResponse(r, mRequest, context, true)
                        HandleAPIResponse(r)
                    }
                    uiHandler.post(myRunnable)
                }
            }
            return true
        }

        fun setBlocking(blocking: Boolean) {
            mBlocking = blocking
        }

        fun setOnUiThread(onUiThread: Boolean) {
            mOnUiThread = onUiThread
        }

        fun sendRequest(postBunlde: Bundle, filePath: String?, formFieldName: String?): Boolean {

            postBunlde.putString("dt", Mesibo.getDeviceType().toString())
            val nwtype = Mesibo.getNetworkConnectivity()
            if (nwtype == 0xFF) {

            }

            mRequest = postBunlde
            http = Mesibo.Http()
            http!!.url = "https://app.mesibo.com/api.php"
            http!!.postBundle = postBunlde
            http!!.uploadFile = filePath
            http!!.uploadFileField = formFieldName
            http!!.notifyOnCompleteOnly = true
            http!!.concatData = true
            http!!.listener = this
            return if (mBlocking) http!!.executeAndWait() else http!!.execute()
        }

        abstract fun HandleAPIResponse(response: Response?)
//
//        companion object {
//            var result = true
//        }
    }

    interface ApiResponseHandler {
        fun onApiResponse(result: Boolean, respString: String?)
    }
    class Response internal constructor() {
        var result: String? = null
        var op: String? = null
        var error: String? = null
        var token: String? = null
        var contacts: Array<ContactsContract.Contacts>? = null
        var name: String? = null
        var status: String? = null
        var members: String? = null
        var photo: String? = null
        var phone: String? = null
        var cc: String? = null

        var share: AppConfig.Invite? = null

        var gid: Long = 0
        var type: Int = 0
        var profile: Int = 0
        var ts: Long = 0
        var tn: String? = null

        init {
            result = null
            op = null
            error = null
            token = null
            contacts = null
            gid = 0
            type = 0
            profile = 0

        }
    }

}

