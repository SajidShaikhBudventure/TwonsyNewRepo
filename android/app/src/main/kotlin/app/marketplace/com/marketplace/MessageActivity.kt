package app.marketplace.com.marketplace

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.*
import android.widget.*
import androidx.annotation.Nullable
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.view.ActionMode
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import com.mesibo.api.Mesibo
import com.mesibo.messaging.MesiboMessagingFragment
import com.mesibo.messaging.MesiboUI
import java.nio.charset.StandardCharsets
import java.util.ArrayList

class MessageActivity : AppCompatActivity(), MesiboMessagingFragment.FragmentListener, Mesibo.UIHelperListner, Mesibo.ConnectionListener, Mesibo.MessageListener, Mesibo.MessageFilter {
    private var mToolbar: Toolbar? = null
    var mFragment: MessagingUIFragment? = null
    private var mMesiboUIHelperlistener: Mesibo.UIHelperListner? = null
    private var mMesiboUIOptions: MesiboUI.Config? = null
    private var mUser: Mesibo.UserProfile? = null
    private var mProfileImage: ImageView? = null
    private var mUserStatus: TextView? = null
    private var mTitle: TextView? = null
    private var mProfileImagePath: String? = null
    private var mProfileThumbnail: Bitmap? = null
    private var mActionMode: ActionMode? = null
    private val mActionModeCallback = ActionModeCallback()
    private var mParameter: Mesibo.MessageParams? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val args = getIntent().extras ?: return
        setSupportActionBar(mToolbar)
        val window: Window = this.getWindow()

// clear FLAG_TRANSLUCENT_STATUS flag:

// clear FLAG_TRANSLUCENT_STATUS flag:
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

// add FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS flag to the window

// add FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS flag to the window
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)

// finally change the color

// finally change the color
        window.setStatusBarColor(ContextCompat.getColor(this, R.color.my_statusbar_color))

        //TBD, this must be fixed
        if (!Mesibo.isReady()) {
            finish()
            return
        }
        Mesibo.addListener(this)
        //mesiboInit();
        mMesiboUIHelperlistener = Mesibo.getUIHelperListner()





        mMesiboUIOptions = MesiboUI.getConfig()


        val peer = args.getString("peer")
        val groupId = args.getLong("groupid")
        mUser = if (groupId > 0) {
            Mesibo.getUserProfile(groupId)
        } else Mesibo.getUserProfile(peer)
        if (null == mUser) {
            mUser = Mesibo.UserProfile()
            mUser!!.address = peer
            mUser!!.name = peer
            Mesibo.setUserProfile(mUser, false)
        }
        mParameter = Mesibo.MessageParams(peer, groupId, Mesibo.FLAG_DEFAULT, 0)
        setContentView(R.layout.activity_messaging_new)
        mToolbar = findViewById(R.id.toolbar)
        //Utils.setActivityStyle(this, mToolbar);
        setSupportActionBar(mToolbar)

        //getSupportActionBar().setHomeAsUpIndicator(new RoundImageDrawable(b));
        getSupportActionBar()?.setDisplayHomeAsUpEnabled(true)
        getSupportActionBar()?.setDisplayShowHomeEnabled(true)
        mUserStatus = findViewById(R.id.chat_profile_subtitle) as TextView?
        //Utils.setTextViewColor(mUserStatus, TOOLBAR_TEXT_COLOR);
        mProfileImage = findViewById(R.id.chat_profile_pic) as ImageView?
        if (mProfileImage != null) {
            mProfileImage!!.setOnClickListener(View.OnClickListener {
                if (null == mProfileImagePath) {
                    return@OnClickListener
                }

                //MesiboUIManager.launchPictureActivity(MessagingActivity.this, mUser.name, mProfileImagePath);
            })
        }
        val nameLayout = findViewById(R.id.name_tite_layout) as RelativeLayout
        mTitle = findViewById(R.id.chat_profile_title) as TextView?
        mTitle!!.text = mUser!!.name
        //Utils.setTextViewColor(mTitle, TOOLBAR_TEXT_COLOR);

            nameLayout.setOnClickListener { //MesiboUiHelper.launchUserProfile(A.this, mParameter.peer, mParameter.groupid, v);
                if (null != mMesiboUIHelperlistener) mMesiboUIHelperlistener!!.Mesibo_onShowProfile(this@MessageActivity, mUser)

        }
        startFragment(savedInstanceState)
    }

    private fun startFragment(savedInstanceState: Bundle?) {
        // However, if we're being restored from a previous state,
        // then we don't need to do anything and should return or else
        // we could end up with overlapping fragments.
        if (findViewById<FrameLayout>(R.id.fragment_container) == null || savedInstanceState != null) {
            return
        }

        // Create a new Fragment to be placed in the activity layout
        mFragment = MessagingUIFragment()

        val bl = Bundle()

        bl.putString(MesiboUI.PEER, intent.getStringExtra("peer"))

        bl.putLong(MesiboUI.GROUP_ID, 0)


        // In case this activity was started with special instructions from an
        // Intent, pass the Intent's extras to the fragment as arguments
        mFragment!!.arguments=bl

        // Add the fragment to the 'fragment_container' FrameLayout
        getSupportFragmentManager().beginTransaction()
                .add(R.id.fragment_container, mFragment!!).commit()
    }

     override fun onStart() {
        super.onStart()
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        if (null == mMesiboUIHelperlistener) return true

    mMesiboUIHelperlistener!!.Mesibo_onGetMenuResourceId(this, FROM_MESSAGING_ACTIVITY, mParameter, menu)


        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        val id = item.itemId
        if (id == android.R.id.home) {
            finish()
            return true
        } else {
            mMesiboUIHelperlistener!!.Mesibo_onMenuItemSelected(this, FROM_MESSAGING_ACTIVITY, mParameter, id)
        }
        return super.onOptionsItemSelected(item)
    }

    //TBD, note this requires API level 10
    /*
    private Bitmap createThumbnailAtTime(String filePath, int timeInSeconds){
        MediaMetadataRetriever mMMR = new MediaMetadataRetriever();
        mMMR.setDataSource(filePath);
        //api time unit is microseconds
        return mMMR.getFrameAtTime(timeInSeconds*1000000, MediaMetadataRetriever.OPTION_CLOSEST_SYNC);
    }
    */
     override fun onDestroy() {
        super.onDestroy()
    }

    override fun onBackPressed() {
        if (mFragment!!.Mesibo_onBackPressed()) {
            return
        }
        super.onBackPressed() // allows standard use of backbutton for page 1
    }

    override fun Mesibo_onUpdateUserPicture(profile: Mesibo.UserProfile, thumbnail: Bitmap?, picturePath: String?) {
        mProfileThumbnail = thumbnail
        mProfileImagePath = picturePath
        mProfileImage!!.setImageBitmap(mProfileThumbnail)
    }

    override fun Mesibo_onUpdateUserOnlineStatus(profile: Mesibo.UserProfile, status: String?) {
        if (null == status) {
            mUserStatus!!.visibility = View.GONE
            return
        }
        mUserStatus!!.visibility = View.VISIBLE
        mUserStatus!!.text = status
        return
    }

    override fun Mesibo_onShowInContextUserInterface() {
         mActionMode = startSupportActionMode(mActionModeCallback);
    }

    override fun Mesibo_onHideInContextUserInterface() {
        mActionMode!!.finish()
    }

    override fun Mesibo_onContextUserInterfaceCount(count: Int) {
        mActionMode!!.title = count.toString()
        mActionMode!!.invalidate()
    }

    override fun Mesibo_onError(i: Int, s: String, s1: String) {

       Log.d("Error:",s)
        Log.d("Error:",s1)

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        mFragment?.Mesibo_onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, @Nullable data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        mFragment?.Mesibo_onActivityResult(requestCode, resultCode, data)
    }

    private inner class ActionModeCallback : ActionMode.Callback {
        private val TAG = ActionModeCallback::class.java.simpleName
        override fun onCreateActionMode(mode: ActionMode, menu: Menu): Boolean {
            menu.clear()
            mode.menuInflater.inflate(R.menu.selected_menu, menu)
            menu.findItem(R.id.menu_reply).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            menu.findItem(R.id.menu_star).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            menu.findItem(R.id.menu_resend).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            menu.findItem(R.id.menu_copy).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            menu.findItem(R.id.menu_forward).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            menu.findItem(R.id.menu_forward).isVisible = true
            menu.findItem(R.id.menu_forward).isEnabled =true
            menu.findItem(R.id.menu_remove).setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
            return true
        }

        override fun onPrepareActionMode(mode: ActionMode, menu: Menu): Boolean {
            val enabled: Int = mFragment!!.Mesibo_onGetEnabledActionItems()
            menu.findItem(R.id.menu_resend).isVisible =true

            //menu.findItem(R.id.menu_forward).setVisible(selection.size() == 1);
            menu.findItem(R.id.menu_copy).isVisible =  true
            menu.findItem(R.id.menu_copy).isVisible= true
            return true
        }

        override fun onActionItemClicked(mode: ActionMode, item: MenuItem): Boolean {
            var mesiboItemId = 0
            if (item.itemId == R.id.menu_remove) {
                //   mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_DELETE
            } else if (item.itemId == R.id.menu_copy) {

                ///   mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_COPY;
            } else if (item.itemId == R.id.menu_resend) {
                ///  mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_RESEND;
            } else if (item.itemId == R.id.menu_forward) {
                ////  mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_FORWARD;
            } else if (item.itemId == R.id.menu_star) {
                ///  mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_FAVORITE;
            } else if (item.itemId == R.id.menu_reply) {
                /// mesiboItemId = MessagingUIFragment.MESIBO_MESSAGECONTEXTACTION_REPLY;
            }
            if (mesiboItemId > 0) {
                  mFragment?.Mesibo_onActionItemClicked(mesiboItemId);
                mode.finish()
                return true
            }
            return false
        }

        override fun onDestroyActionMode(mode: ActionMode) {
            mFragment?.Mesibo_onInContextUserInterfaceClosed()
            mActionMode = null
        }
    }

    override fun Mesibo_onConnectionStatus(i: Int) {
        Log.d("Gett","Status : "+i);

        if (i == Mesibo.STATUS_ONLINE) {
            Toast.makeText(this@MessageActivity, "Mesibo Started - ONLINE", Toast.LENGTH_SHORT).show()
        }
    }

    override fun Mesibo_onMessage(messageParams: Mesibo.MessageParams, bytes: ByteArray): Boolean {
        var message = ""
        try {
            message = String(bytes, StandardCharsets.UTF_8)
            Toast.makeText(this, "" + message, Toast.LENGTH_SHORT).show()
        } catch (e: Exception) {
            // return false;
        }
        return false
    }

    override fun Mesibo_onMessageStatus(messageParams: Mesibo.MessageParams) {}
    override fun Mesibo_onActivity(messageParams: Mesibo.MessageParams, i: Int) {}
    override fun Mesibo_onLocation(messageParams: Mesibo.MessageParams, location: Mesibo.Location) {}
    override fun Mesibo_onFile(messageParams: Mesibo.MessageParams, fileInfo: Mesibo.FileInfo) {}
    override fun Mesibo_onMessageFilter(messageParams: Mesibo.MessageParams, i: Int, bytes: ByteArray): Boolean {
        return false
    }

    companion object {
        var FROM_MESSAGING_ACTIVITY = 1
    }

    override fun Mesibo_onSetGroup(p0: Context?, p1: Long, p2: String?, p3: Int, p4: String?, p5: String?, p6: Array<out String>?, p7: Handler?) {

    }

    override fun Mesibo_onGetMenuResourceId(p0: Context?, p1: Int, p2: Mesibo.MessageParams?, p3: Menu?): Int {
        return 0
    }

    override fun Mesibo_onMenuItemSelected(p0: Context?, p1: Int, p2: Mesibo.MessageParams?, p3: Int): Boolean {
        return false
    }

    override fun Mesibo_onGetGroup(p0: Context?, p1: Long, p2: Handler?) {

    }

    override fun Mesibo_onGetGroupMembers(p0: Context?, p1: Long): ArrayList<Mesibo.UserProfile>? {
      return  null
    }

    override fun Mesibo_onShowProfile(p0: Context?, p1: Mesibo.UserProfile?) {

    }

    override fun Mesibo_onDeleteProfile(p0: Context?, p1: Mesibo.UserProfile?, p2: Handler?) {

    }

    override fun Mesibo_onForeground(p0: Context?, p1: Int, p2: Boolean) {

    }
}

