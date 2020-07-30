package app.marketplace.com.marketplace.firebasenoti

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.os.*
import android.util.Log
import androidx.core.app.NotificationCompat
import app.marketplace.com.marketplace.ListActivity
import app.marketplace.com.marketplace.MainActivity
import app.marketplace.com.marketplace.MesiboFileTransferHelper
import app.marketplace.com.marketplace.R
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.mesibo.api.Mesibo
import com.mesibo.mediapicker.MediaPicker
import org.json.JSONObject
import java.nio.charset.StandardCharsets


class MyFirebase : FirebaseMessagingService() {
     val REQUEST_ACCEPT: String? ="com.townsy"
    var TAG = "MyFirebaseService"
    override fun onNewToken(s: String) {
        Log.d("My Token", "Refreshed token: $s")
        val pref = getSharedPreferences("UserData", 0) // 0 - for private mode
        val editor = pref.edit()
        editor.putString("fire_token", s)
        editor.commit()
        FirebaseInstanceId.getInstance().instanceId
                .addOnCompleteListener(OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        Log.w(TAG, "getInstanceId failed", task.exception)
                        return@OnCompleteListener
                    }

                    // Get new Instance ID token
                    val token = task.result?.token

                    // Log and toast


                })

    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.e(TAG, "From: " + remoteMessage.from!!)

        if (remoteMessage == null)
            return

        // Check if message contains a notification payload.
        if (remoteMessage.notification != null) {
            val msg = remoteMessage.notification!!.body
            Log.e(TAG, "Notification Body: " + msg!!)
            // handleNotification(remoteMessage.getNotification().getBody());

            val data = Bundle()
            data.putString("body", msg)

            //Note if we send 'notification' instead of 'data', it will be under notification key
            //https://developers.google.com/cloud-messaging/concept-options#notifications_and_data_messages

            /*
        String message = data.getString("message");
        Log.d(TAG, "From: " + from);
        Log.d(TAG, "Message: " + message);

        if (from.startsWith("/topics/")) {
            // message received from some topic.
        } else {
            // normal downstream message.
        }
        */

            // String data = Objects.requireNonNull(remoteMessage.getNotification()).getBody();



        }

        // Check if message contains a data payload.
        if (remoteMessage.data.size > 0) {
            Log.e(TAG, "Data Payload: " + remoteMessage.data.toString())
        try {
          notification("New Message","You have received a new message. Please check your inbox.")
        }catch (e: Exception){
            Log.e(TAG, "Exception: " + e.message)
        }


            try {
                val json = JSONObject(remoteMessage.data.toString())
               Log.e("Gett",json.toString());
            } catch (e: Exception) {
                Log.e(TAG, "Exception: " + e.message)
            }

        }

        //        Map<String, String> params = remoteMessage.getData();
        //        JSONObject object = new JSONObject(params);
        //        Log.e("JSON_OBJECT", object.toString());


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
            channel = NotificationChannel("222", "Chat Messages", NotificationManager.IMPORTANCE_HIGH)
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


    class Test{

        companion object{

            fun  getValue(): String{

                return "TestString"

            }
        }
    }


}
