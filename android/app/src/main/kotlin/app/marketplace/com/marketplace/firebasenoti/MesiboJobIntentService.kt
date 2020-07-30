package app.marketplace.com.marketplace.firebasenoti

import android.content.Context
import android.content.Intent
import android.os.Handler

import android.widget.Toast
import androidx.core.app.JobIntentService

/**
 * Require WAKE_LOCK persmission for API level earlier than Android O
 */

class MesiboJobIntentService : JobIntentService() {

    internal val mHandler = Handler()

    override fun onHandleWork(intent: Intent) {
        try {
            intent.extras?.let { MesiboRegistrationIntentService.sendMessageToListener(it, true) }
        } catch (e: Exception) {

        }

    }

    override fun onDestroy() {
        super.onDestroy()
    }

    // Helper for showing tests
    internal fun toast(text: CharSequence) {
        mHandler.post { Toast.makeText(this@MesiboJobIntentService, text, Toast.LENGTH_SHORT).show() }
    }

    companion object {
        internal val JOB_ID = 1000

        /**
         * Convenience method for enqueuing work in to this service.
         */
        internal fun enqueueWork(context: Context, work: Intent) {
            try {
                JobIntentService.enqueueWork(context, MesiboJobIntentService::class.java, JOB_ID, work)
            } catch (e: Exception) {

            }

        }
    }
}
