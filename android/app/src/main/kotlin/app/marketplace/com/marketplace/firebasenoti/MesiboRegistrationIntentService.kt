package app.marketplace.com.marketplace.firebasenoti

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.preference.PreferenceManager

import android.text.TextUtils
import android.util.Log
import androidx.core.app.JobIntentService

import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.FirebaseApp
import com.google.firebase.iid.FirebaseInstanceId


import java.io.IOException


class MesiboRegistrationIntentService : JobIntentService() {

    interface GCMListener {
        fun Mesibo_onGCMToken(token: String?)
        fun Mesibo_onGCMMessage(data: Bundle, inService: Boolean)
    }

    override fun onHandleWork(intent: Intent) {
        onHandleIntent(intent)
    }


    //@Override
    protected fun onHandleIntent(intent: Intent) {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)
        var token: String? = null
        try {
            // [START register_for_gcm]
            // Initially this call goes out to the network to retrieve the token, subsequent calls
            // are local.
            // Sender ID is typically derived from google-services.json.
            // See https://developers.google.com/cloud-messaging/android/start for details on this file.
            //            InstanceID instanceID = InstanceID.getInstance(this);
            //            token = instanceID.getToken(SENDER_ID, GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);

            FirebaseInstanceId.getInstance().instanceId
                    .addOnCompleteListener(OnCompleteListener { task ->
                        if (!task.isSuccessful) {
                            Log.w(TAG, "getInstanceId failed", task.exception)
                            return@OnCompleteListener
                        }

                        // Get new Instance ID token
                        val token = task.result?.token
                        val pref = getSharedPreferences("UserData", 0) // 0 - for private mode
                        val editor = pref.edit()
                        editor.putString("fire_token", token)
                        editor.commit()
                        subscribeTopics(token)
                        // Log and toast
                        if (null != mListener) {
                            mListener!!.Mesibo_onGCMToken(token)
                        }

                    })



        } catch (e: Exception) {
            Log.d(TAG, "Failed to complete token refresh", e)
        }


    }

    /**
     * Persist registration to third-party servers.
     *
     * Modify this method to associate the user's GCM registration token with any server-side account
     * maintained by your application.
     *
     * @param token The new token.
     */
    private fun sendRegistrationToServer(token: String) {
        // Add custom implementation, as needed.
        Log.d("Token", token)
    }

    /**
     * Subscribe to any GCM topics of interest, as defined by the TOPICS constant.
     *
     * @param token GCM token
     * @throws IOException if unable to reach the GCM PubSub service
     */
    // [START subscribe_topics]
    @Throws(IOException::class)
    private fun subscribeTopics(token: String?) {
        //  GcmPubSub pubSub = GcmPubSub.getInstance(this);
        for (topic in TOPICS) {
            //     pubSub.subscribe(token, "/topics/" + topic, null);
        }
    }
    // [END subscribe_topics]

    private fun checkPlayServices(): Boolean {
        val apiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = apiAvailability.isGooglePlayServicesAvailable(this)
        return resultCode == ConnectionResult.SUCCESS
    }

    companion object {

        private val TAG = "RegIntentService"
        private val TOPICS = arrayOf("global")
        private var SENDER_ID = ""
        private var mListener: GCMListener? = null

        val JOB_ID = 1
        fun enqueueWork(context: Context, work: Intent) {
            JobIntentService.enqueueWork(context, MesiboRegistrationIntentService::class.java, JOB_ID, work)
        }

        fun startRegistration(context: Context, senderId: String, listener: GCMListener?) {
            if (!TextUtils.isEmpty(senderId))
                SENDER_ID = senderId

            if (listener != null)
                mListener = listener

            try {
                val intent = Intent(context, MesiboRegistrationIntentService::class.java)
                //context.startService(intent);
                enqueueWork(context, intent)
            } catch (e: Exception) {

            }

        }

        fun sendMessageToListener(data: Bundle, inService: Boolean) {
            if (null != mListener) {
                mListener!!.Mesibo_onGCMMessage(data, inService)
            }
        }
    }
}
