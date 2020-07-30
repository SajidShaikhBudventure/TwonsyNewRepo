package app.marketplace.com.marketplace

import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat.startActivity
import androidx.recyclerview.widget.RecyclerView
import com.mesibo.messaging.MessagingActivity
import com.mesibo.messaging.MessagingActivityNew


class CustomMessageListAdapter(val userList: ArrayList<MessageModel>,val context : Context) : RecyclerView.Adapter<CustomMessageListAdapter.ViewHolder>() {




    //this method is returning the view for each item in the list
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CustomMessageListAdapter.ViewHolder {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.list_layout, parent, false)
        return ViewHolder(v)
    }

    //this method is binding the data on the list
    override fun onBindViewHolder(holder: CustomMessageListAdapter.ViewHolder, position: Int) {
        holder.bindItems(userList[position],context)

    }

    //this method is giving the size of the list
    override fun getItemCount(): Int {
        return userList.size
    }

    //the class is hodling the list view
    class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        fun bindItems(user: MessageModel,mContext : Context) {
            val textViewName = itemView.findViewById(R.id.textViewUsername) as TextView
            val textViewAddress  = itemView.findViewById(R.id.textMessage) as TextView
            val textViewDate  = itemView.findViewById(R.id.textDate) as TextView
            val textViewIntial  = itemView.findViewById(R.id.textIntial) as TextView
            val textViewStatus  = itemView.findViewById(R.id.status) as TextView
            val chat_row:LinearLayout =itemView.findViewById(R.id.chat_row) as LinearLayout

            textViewName.text = user.Username
            textViewAddress.text = user.message
            textViewDate.text = user.date
            var name =user.Username.toString()
            Log.d("Gett","Status : "+user.status);
            if(user.status.equals("18")){
                textViewStatus.visibility = View.VISIBLE;

            }else{
                textViewStatus.visibility = View.GONE;
            }
            textViewIntial.text = name[0].toString().toUpperCase()
            Log.d("Gett","Date : "+user.date+ "Intials :"+name[0].toString().toUpperCase())
            chat_row.setOnClickListener {
                val i = Intent(mContext, MessagingActivity::class.java)
                i.putExtra("peer", user.Username)
                mContext.startActivity(i)
            }
        }
    }
}