package app.marketplace.com.marketplace

import android.view.ViewGroup
import com.mesibo.api.Mesibo.MesiboMessage
import com.mesibo.api.Mesibo.MessageParams
import com.mesibo.messaging.MesiboMessagingFragment
import com.mesibo.messaging.MesiboRecycleViewHolder


class MessagingUIFragment : MesiboMessagingFragment(), MesiboRecycleViewHolder.Listener {

    var mMesiboMessage: MesiboMessage? = null
    var mMesiborecyclerView: MesiboRecycleViewHolder? = null
    override fun Mesibo_onGetItemViewType(messageParams: MessageParams, s: String): Int {

        //Get the type of message received and set type accordingly to use custom ui
        return 0
    }

    override fun Mesibo_onCreateViewHolder(viewGroup: ViewGroup, type: Int): MesiboRecycleViewHolder? {
        return null
    }

    override fun Mesibo_onBindViewHolder(mesiboRecycleViewHolder: MesiboRecycleViewHolder, type: Int, b: Boolean, messageParams: MessageParams, mesiboMessage: MesiboMessage) {}
    override fun Mesibo_oUpdateViewHolder(mesiboRecycleViewHolder: MesiboRecycleViewHolder, mesiboMessage: MesiboMessage) {}
    override fun Mesibo_onViewRecycled(mesiboRecycleViewHolder: MesiboRecycleViewHolder) {}

    companion object {
        const val TYPE_INCOMING = 0
    }
}