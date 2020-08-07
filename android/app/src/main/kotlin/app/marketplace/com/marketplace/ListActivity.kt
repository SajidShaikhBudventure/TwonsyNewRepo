package app.marketplace.com.marketplace

import android.opengl.Visibility
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.util.Log
import android.view.MenuItem
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.app.NavUtils
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import app.marketplace.com.marketplace.firebasenoti.MesiboRegistrationIntentService
import com.mesibo.api.Mesibo
import com.mesibo.api.Mesibo.ReadDbSession
import com.mesibo.messaging.MesiboUserListFragment
import org.json.JSONObject
import java.nio.charset.StandardCharsets
import java.sql.Timestamp
import java.text.SimpleDateFormat
import java.util.*


val users = ArrayList<MessageModel>()
var adapter: CustomMessageListAdapter? = null
private var mToolbar: Toolbar? = null

class ListActivity : AppCompatActivity(),Mesibo.HttpListener,MesiboRegistrationIntentService.GCMListener, MesiboUserListFragment.FragmentListener,Mesibo.MessageListener {
     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.list_ui)
         mToolbar = findViewById(R.id.toolbar)
         //Utils.setActivityStyle(this, mToolbar);
         setSupportActionBar(mToolbar)
         val window: Window = this.getWindow()
         val data_layout  = findViewById(R.id.data_layout) as LinearLayout
         val no_data_layout  = findViewById(R.id.no_data) as FrameLayout
         val progress_circular  = findViewById(R.id.progress_circular) as ProgressBar


// clear FLAG_TRANSLUCENT_STATUS flag:

// clear FLAG_TRANSLUCENT_STATUS flag:
         window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

// add FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS flag to the window

// add FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS flag to the window
         window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)

// finally change the color

// finally change the color
         window.setStatusBarColor(ContextCompat.getColor(this, R.color.my_statusbar_color))
         //getSupportActionBar().setHomeAsUpIndicator(new RoundImageDrawable(b));
         getSupportActionBar()?.setDisplayHomeAsUpEnabled(true)
         getSupportActionBar()?.setDisplayShowHomeEnabled(true)
      setTitle("MY CHATS")
         val recyclerView = findViewById(R.id.list_ui) as RecyclerView

         //adding a layoutmanager
         recyclerView.layoutManager = LinearLayoutManager(this, RecyclerView.VERTICAL, false)



          adapter = CustomMessageListAdapter(users,this)

         //now adding the adapter to recyclerview
         recyclerView.adapter = adapter

         Handler().postDelayed({
             //doSomethingHere()
             if(users.size==0){
                 no_data_layout.visibility= View.VISIBLE
                 data_layout.visibility= View.GONE
                 progress_circular.visibility=View.GONE
             }else{
                 no_data_layout.visibility=View.GONE
                 data_layout.visibility= View.VISIBLE
                 progress_circular.visibility=View.GONE
             }

         }, 3000)
    }

    private fun createPostBundle(op: String): Bundle? {


        val b = Bundle()
        b.putString("op", op)


        return b
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.getItemId()) {
            android.R.id.home -> {
              finish()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
    override fun onResume() {
        super.onResume()
        users.clear()

        val mReadSession = ReadDbSession(null, 0, null, this)
        mReadSession.enableSummary(true);
        mReadSession.enableMessages(true)

        mReadSession.enableReadReceipt(true)
        mReadSession.read(100)
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
//        MesiboFileTransferHelper fileTransferHelper = new MesiboFileTransferHelper();
//        Mesibo.addListener(fileTransferHelper);
        /** add other listener - you can add any number of listeners  */
        Mesibo.addListener(this)
        /** [Optional] enable to disable secure connection  */
        Mesibo.setSecureConnection(true)

        /** Initialize web api to communicate with your own backend servers  */
        //* set user access token
        Mesibo.setAccessToken("1c76062d0eec7ec1196a5f86123b269ada6bbea8c136b92efeaa140d31")

        // set path for storing DB and messaging files
        Mesibo.setPath(Environment.getExternalStorageDirectory().absolutePath)

        /* * [OPTIONAL] set up database to save and restore messages
         * Note: if you call this API before setting an access token, mesibo will
         * create a database exactly as you named it. However, if you call it
         * after setting Access Token like in this example, it will be uniquely
         * named for each user [Preferred].
         * */Mesibo.setDatabase("myAppDb.db", 0)

        // start mesibo
        Mesibo.start()

        /** add other listener - you can add any number of listeners  */
    }

    override fun Mesibo_onUpdateTitle(p0: String?) {
        Log.d("Gett","Get Text" +p0)

    }

    override fun Mesibo_onClickUser(p0: String?, p1: Long, p2: Long): Boolean {
        Log.d("Gett","Get Text" +p0)
        return  true
    }

    override fun Mesibo_onUpdateSubTitle(p0: String?) {
        Log.d("Gett","Get Text" +p0)
    }

    override fun Mesibo_onUserListFilter(p0: Mesibo.MessageParams?): Boolean {
return true
    }

    override fun Mesibo_onMessageStatus(p0: Mesibo.MessageParams?) {

    }

    override fun Mesibo_onActivity(p0: Mesibo.MessageParams?, p1: Int) {

    }

    override fun Mesibo_onLocation(p0: Mesibo.MessageParams?, p1: Mesibo.Location?) {

    }

    override fun Mesibo_onMessage(params: Mesibo.MessageParams?, p1: ByteArray): Boolean {
        var message = ""


        try {
            message = String(p1, StandardCharsets.UTF_8)

            adapter?.notifyDataSetChanged();
            val stamp = Timestamp(params!!.ts)
            val date = Date(stamp.getTime())
            val format = SimpleDateFormat("dd/MM/yyy")

            users.add(MessageModel(params?.peer.toString(), message, format.format(date),params?.status.toString()))
            val staus: JSONObject  =  JSONObject()

                                    staus.put("peer", params?.peer);
                                    staus.put("status", params?.status.toString());
                                    staus.put("file", "");
                                    staus.put("ts", params?.ts);

            Log.d("Gett", params?.status.toString());
            Log.d("Gett", params?.flag.toString());
        } catch (e: Exception) {
            return false
        }



        return true

    }

    override fun Mesibo_onFile(p0: Mesibo.MessageParams?, p1: Mesibo.FileInfo?) {

    }

    override fun Mesibo_onHttpProgress(p0: Mesibo.Http?, p1: Int, p2: Int): Boolean {
    return true
    }

    override fun Mesibo_onGCMToken(token: String?) {


    }

    override fun Mesibo_onGCMMessage(data: Bundle, inService: Boolean) {

    }
}