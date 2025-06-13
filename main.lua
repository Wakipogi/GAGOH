require "import"
import "init"
import "init"
import "init"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "AndLua"
import "http"
import "android.content.Context"
import "android.content.Intent"
import "android.provider.Settings"
import "android.net.Uri"
import "android.content.pm.PackageManager"
import "android.graphics.Typeface"
import "Floating"
import "android.text.Html"
import "com.nirenr.Color"
import "android.graphics.Color"
import "layout"
function onCreate()
  local loginlayout={
    LinearLayout;
    orientation="vertical";
    id="logindialog";
    layout_height="fill";
    gravity="center";
    layout_width="fill";
    {
      LinearLayout;
      gravity="center";
      orientation="vertical";
      layout_height="150%w";
      layout_width="fill";
      {
        ImageView;
        layout_gravity="center";
        layout_width="100dp";
        layout_height="100dp";
        src="icon.png";
        layout_margin="2dp";
        padding="7dp";
        id="guest";
      };
      {
        LinearLayout;
        layout_height="10dp";
        gravity="center";
        layout_width="wrap";
      };
      {
        TextView;
        layout_gravity="center";
        layout_marginBottom="1dp";
        text="PLEASE LOGIN";
        textSize="15sp";
        textColor="0xFFFFFFFF";
        id="plogin";
      };
      {
        LinearLayout;
        layout_height="30dp";
        gravity="center";
        layout_width="wrap";
      };
      {
        LinearLayout;
        layout_width="82%w";
        gravity="center";
        id="us";
        orientation="horizontal";
        layout_height="wrap";
        {
          LinearLayout;
          orientation="horizontal";
          layout_height="wrap";
          layout_width="wrap";
          gravity="center";
          {
            ImageView;
            src="us.png";
            padding="7dp";
            layout_height="40dp";
            layout_width="40dp";
            colorFilter="0xffffffff";
            layout_gravity="center";
          };
          {
            LinearLayout;
            layout_height="wrap";
            gravity="center";
            layout_width="2dp";
          };
          {
            EditText;
            TextColor="0xFFFFFFFF";
            id="username";
            layout_width="70%w";
            padding="5dp";
            layout_height="40dp";
            hintTextColor="0xBDFFFFFF";
            hint="Username";
          };
        };
      };
      {
        LinearLayout;
        layout_height="5dp";
        gravity="center";
        layout_width="wrap";
      };
      {
        LinearLayout;
        layout_width="82%w";
        gravity="center";
        id="pw";
        orientation="horizontal";
        layout_height="wrap";
        {
          LinearLayout;
          orientation="horizontal";
          layout_height="wrap";
          layout_width="wrap";
          gravity="center";
          {
            ImageView;
            src="key.png";
            padding="7dp";
            layout_height="40dp";
            layout_width="40dp";
            colorFilter="0xffffffff";
            layout_gravity="center";
          };
          {
            LinearLayout;
            layout_height="wrap";
            gravity="center";
            layout_width="2dp";
          };
          {
            EditText;
            TextColor="0xFFFFFFFF";
            id="password";
            layout_width="70%w";
            padding="5dp";
            layout_height="40dp";
            hintTextColor="0xBDFFFFFF";
            hint="Password";
            inputType="textPassword"
          };
        };
      };
      {
        LinearLayout;
        layout_height="20dp";
        gravity="center";
        layout_width="wrap";
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_height="wrap";
        layout_width="wrap";
        gravity="center";

        {
          Button;
          background="transparent";
          id="getkey";
          layout_height="37dp";
          textColor="0xFFFFFFFF";
          text="GET KEY";
        };
        {
          LinearLayout;
          layout_height="wrap";
          gravity="center";
          layout_width="50dp";
        };
        {
          Button;
          background="transparent";
          id="login";
          layout_height="37dp";
          textColor="0xFFFFFFFF";
          text="LOGIN";
        };
        {
          ProgressBar;
          layout_width="35dp";
          style="?android:attr/progressBarStyleSmall";
          id="imgx";
          layout_height="35dp";
          --ColorFilter="0xFF3F8EFF";
          --src="res/restwo/circle (1).png";
          visibility="gone";
          padding="5dp";
        };
      };
    };
  }

  dialogs=AlertDialog.Builder(activity)
  dialogs.setView(loadlayout(loginlayout))
  if dm==0 then
    dialogs.setCancelable(false)
  end
  dialogs2=dialogs.show()
  window = dialogs2.getWindow();
  dialogs3 = window.getAttributes();
  dialogs2.setCancelable(false)
  local radiu=10
  dialogs2.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(0x00000000))

  function login1(link)
    Http.get(link,nil,"utf8",nil,function(code,content)
      if code==200 then
        user=content:match("【Email】(.-)【Email】")
        pass_id=content:match("【pass】(.-)【pass】")
        function login.onClick()
          imgx.setVisibility(View.VISIBLE)
          login.setVisibility(View.GONE)
          task(3500,function()
            imgx.setVisibility(View.GONE)
            login.setVisibility(View.VISIBLE)
            if username.Text== user and password.Text == pass_id then

              print("CORRECT")
              dialogs2.dismiss()
            end
          end)
        end
       else
        print("WRONG")
      end
    end)
  end
  login1("https://pastebin.com/raw/54WWvR9c")


  function CircleButtonZ(view,LD1,LD2,LD3,LD4,LD5,LD6,LD7)
    drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setCornerRadii({LD3, LD3, LD4, LD4, LD5, LD5, LD6, LD6})
    drawable.setColor(LD1)
    drawable.setStroke(2, LD2)
    view.setBackgroundDrawable(drawable)
  end

  function CircleButtonX(view,LD1,LD2,LD3,LD4,LD5,LD6,LD7)
    drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setCornerRadii({LD3, LD3, LD4, LD4, LD5, LD5, LD6, LD6})
    drawable.setColor(LD1)
    drawable.setStroke(4, LD2)
    view.setBackgroundDrawable(drawable)
  end

  CircleButtonX(logindialog,0x30000000,0x30FF0000,30,30,30,30)
  CircleButtonZ(pw,0x00000000,0xFFFF0000,1000,1000,1000,1000)
  CircleButtonZ(us,0x00000000,0xFFFF0000,1000,1000,1000,1000)
  CircleButtonZ(password,0x00000000,0x00000000,20,20,20,20)
  CircleButtonZ(username,0x00000000,0x00000000,20,20,20,20)
  CircleButtonZ(guest,0x00000000,0xFFFF0000,1000,1000,1000,1000)
  CircleButtonZ(login,0x00000000,0xFFFF0000,1000,1000,1000,1000)
  CircleButtonZ(getkey,0x00000000,0xFFFF0000,1000,1000,1000,1000)
  CircleButtonZ(imgx,0x00000000,0xFFFF0000,1000,1000,1000,1000)


  username.setTypeface(Typeface.MONOSPACE)
  password.setTypeface(Typeface.MONOSPACE)
  login.setTypeface(Typeface.DEFAULT_BOLD)
  getkey.setTypeface(Typeface.DEFAULT_BOLD)
  plogin.setTypeface(Typeface.DEFAULT_BOLD)



  getkey.onClick=function()
    url = "https://t.me/divinenxchhy"
    activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
  end
end
-- LOGIN END



if pcall(function()
    activity.getPackageManager().getPackageInfo("com.httpcanary.pro", 0)
  end
  )
  then
  os.exit()
  isMax = true
 else
end

if pcall(function()
    activity.getPackageManager().getPackageInfo("com.sstoolpro.dgz", 0)
  end
  )
  then
  os.exit()
  isMax = true
 else
end

if pcall(function()
    activity.getPackageManager().getPackageInfo("com.luaida.dgz", 0)
  end
  )
  then
  os.exit()
  isMax = true
 else
end

if pcall(function()
    activity.getPackageManager().getPackageInfo("com.guoshi.httpcanary.premium", 0)
  end
  )
  then
  os.exit()
  isMax = true
 else
end

import "android.media.MediaPlayer"
local mp
function play(path)
  if mp then
    mp.release()
  end
  mp = MediaPlayer()
  mp.setDataSource(path)
  mp.prepare()
  mp.setLooping(true)
  mp.start()
end
function stopAudio()
  if mp and mp.isPlaying() then
    mp.stop()
    mp.release()
    mp = nil
  end
end
local audioPath = activity.getLuaDir().."/sound.mp3"
play(audioPath)
function onPause()
  stopAudio()
end
function onResume()
  play(audioPath)
end

activity.setContentView(loadlayout(layout))
LayoutVIP=activity.getSystemService(Context.WINDOW_SERVICE)
HasFocus=false
WmHz =WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then WmHz.type =WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
 else WmHz.type =WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
end
import "android.graphics.PixelFormat"
WmHz.format =PixelFormat.RGBA_8888
WmHz.flags=WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
WmHz.gravity = Gravity.LEFT| Gravity.TOP
WmHz.x = 333
WmHz.y = 333
WmHz.width = WindowManager.LayoutParams.WRAP_CONTENT
WmHz.height = WindowManager.LayoutParams.WRAP_CONTENT
mainWindow = loadlayout(winlay)
minWindow = loadlayout(minlay)
function close.onClick(v)
  HasLaunch=false
  LayoutVIP.removeView(mainWindow)
end
isMax=true
function close22.onClick()
  if isMax==false then
    isMax=true
    LayoutVIP.removeView(minWindow)
    LayoutVIP.addView(mainWindow,WmHz)
   else
    isMax=false
    LayoutVIP.removeView(mainWindow)
    LayoutVIP.addView(minWindow,WmHz)
  end end
function Win_minWindow.onClick(v)
  if isMax==false then
    isMax=true
    LayoutVIP.removeView(minWindow)
    LayoutVIP.addView(mainWindow,WmHz)
   else
    isMax=false
    LayoutVIP.removeView(mainWindow)
    LayoutVIP.addView(minWindow,WmHz)
  end end
function Win_minWindow.OnTouchListener(v,event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstX=event.getRawX()
    firstY=event.getRawY()
    wmX=WmHz.x
    wmY=WmHz.y
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    WmHz.x=wmX+(event.getRawX()-firstX)
    WmHz.y=wmY+(event.getRawY()-firstY)
    LayoutVIP.updateViewLayout(minWindow,WmHz)
   elseif event.getAction()==MotionEvent.ACTION_UP then
  end return false end
function win_move1.OnTouchListener(v,event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstX=event.getRawX()
    firstY=event.getRawY()
    wmX=WmHz.x
    wmY=WmHz.y
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    WmHz.x=wmX+(event.getRawX()-firstX)
    WmHz.y=wmY+(event.getRawY()-firstY)
    LayoutVIP.updateViewLayout(mainWindow,WmHz)
   elseif event.getAction()==MotionEvent.ACTION_UP then
  end return true end
function win_move2.OnTouchListener(v,event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstX=event.getRawX()
    firstY=event.getRawY()
    wmX=WmHz.x
    wmY=WmHz.y
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    WmHz.x=wmX+(event.getRawX()-firstX)
    WmHz.y=wmY+(event.getRawY()-firstY)
    LayoutVIP.updateViewLayout(mainWindow,WmHz)
   elseif event.getAction()==MotionEvent.ACTION_UP then
  end return true end
pg.addOnPageChangeListener{
  onPageScrolled=function(a,b,c)
  end,
  onPageSelected=function(page)
  end,
  onPageScrollStateChanged=function(state)
  end,}

showhack.onClick=function()
  if HasLaunch==true then return else
    if Settings.canDrawOverlays(activity) then else intent=Intent("android.settings.action.MANAGE_OVERLAY_PERMISSION");
      intent.setData(Uri.parse("package:" .. this.getPackageName())); this.startActivity(intent); end HasLaunch=true
    local ret={pcall(function() LayoutVIP.addView(mainWindow,WmHz) end)}
    if ret[1]==false then end end import "java.io.*" file,err=io.open("/data/data/andlua.layout.vip/files/Memory")
  if err==nil then 打开app("andlua.layout.vip") else end end

function startgame.onClick()
  this.startActivity(activity.getPackageManager().getLaunchIntentForPackage("com.garena.game.codm"));
end

function tg.onClick()
  vibrator = activity.getSystemService(Context.VIBRATOR_SERVICE)
  vibrator.vibrate( long{0,10} ,-1)
  Waterdropanimation(telegram,100)
  activity.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse("https://t.me/divinenxchhy")))
end

function Waterdropanimation(Controls,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls,"scaleX",{1,.8,1.3,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls,"scaleY",{1,.8,1.3,.9,1}).setDuration(time).start()
end


function CircleButtonZ(view,InsideColor,radiu,InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(3, InsideColor1)
  view.setBackgroundDrawable(drawable)
end

CircleButtonZ(win_mainview,0xf5696969,0,0x0f000000)
CircleButtonZ(tg,0xFF000000,100,0xffffffff)
CircleButtonZ(showhack,0xFF000000,100,0xffffffff)
CircleButtonZ(startgame,0xFF000000,200,0xffffffff)
CircleButtonZ(inglob,0xFF000000,30,0xffffffff)
CircleButtonZ(ingtext,0xFF000000,50,0xffffffff)
CircleButtonZ(close,0xFF000000,10,0xffffffff)
CircleButtonZ(close22,0xFF000000,10,0xffffffff)
CircleButtonZ(skinhacksss,0xFF000000,50,0xffffffff)

skinDrawer.setVisibility(View.GONE)
toggleSkinDrawer.setOnCheckedChangeListener{
  onCheckedChanged = function(v, isChecked)
    if isChecked then
      skinDrawer.setVisibility(View.VISIBLE)
     else
      skinDrawer.setVisibility(View.GONE)
    end
  end
}

charDrawer.setVisibility(View.GONE)
bitchass.setOnCheckedChangeListener{
  onCheckedChanged = function(v, isChecked)
    if isChecked then
      charDrawer.setVisibility(View.VISIBLE)
     else
      charDrawer.setVisibility(View.GONE)
    end
  end
}




function floatToHexRaw(float)
  local bytes = string.pack("<f", float)
  return string.format("h%02X %02X %02X %02X", bytes:byte(1), bytes:byte(2), bytes:byte(3), bytes:byte(4))
end






view=mainLayout
color1 = 0xFFFF0000;
color2 = 0xFF39FF00;
color3 = 0xFF022CD5;
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Color"
colorAnim = ObjectAnimator.ofInt(view,"textColor",{color1, color2, color3,color4})
colorAnim.setDuration(2000)
colorAnim.setEvaluator(ArgbEvaluator())
colorAnim.setRepeatCount(ValueAnimator.INFINITE)
colorAnim.setRepeatMode(ValueAnimator.REVERSE)
colorAnim.start()
view=win_move2
color1 = 0xFFFF0000;
color2 = 0xFF39FF00;
color3 = 0xFF022CD5;
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Color"
colorAnim = ObjectAnimator.ofInt(view,"textColor",{color1, color2, color3,color4})
colorAnim.setDuration(2000)
colorAnim.setEvaluator(ArgbEvaluator())
colorAnim.setRepeatCount(ValueAnimator.INFINITE)
colorAnim.setRepeatMode(ValueAnimator.REVERSE)
colorAnim.start()
view=MenuA
color1 = 0xFFFF0000;
color2 = 0xFF39FF00;
color3 = 0xFF022CD5;
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Color"
colorAnim = ObjectAnimator.ofInt(view,"textColor",{color1, color2, color3,color4})
colorAnim.setDuration(2000)
colorAnim.setEvaluator(ArgbEvaluator())
colorAnim.setRepeatCount(ValueAnimator.INFINITE)
colorAnim.setRepeatMode(ValueAnimator.REVERSE)
colorAnim.start()

import "java.io.File"
function FontN(FontX, file)
  if not FontX then
    print("Warning: FontX is nil, cannot set typeface.")
    return
  end
  if not file then
    print("Warning: file path is nil.")
    return
  end
  pcall(function()
    FontX.setTypeface(Typeface.createFromFile(File(file)))
  end)
end

FontN(win_move2, activity.getLuaDir().."/it.ttf")
FontN(MenuA, activity.getLuaDir().."/it.ttf")
FontN(inglob, activity.getLuaDir().."/it.ttf")
FontN(ingtext, activity.getLuaDir().."/it.ttf")
FontN(aimbot, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(fps, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(hitbox, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(wall, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(nopp, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(noqa, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(Adv, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(antz, activity.getLuaDir().."/font/Boldfinger.ttf")

FontN(slide, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(close, activity.getLuaDir().."/font/Vmpire6.ttf")
FontN(close22, activity.getLuaDir().."/font/Vmpire6.ttf")
FontN(logs, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(recoil, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin1, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin2, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin3, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin4, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin5, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin6, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin7, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin8, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin9, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin10, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin11, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(skin12, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(char1, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(char2, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(char3, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(bypass, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(char4, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(toggleSkinDrawer, activity.getLuaDir().."/font/Boldfinger.ttf")
toggleSkinDrawer.ButtonDrawable.setColorFilter(PorterDuffColorFilter(4294967295, PorterDuff.Mode.SRC_ATOP))
FontN(skinhacksss, activity.getLuaDir().."/it.ttf")
import "Memory"
bitchass.ButtonDrawable.setColorFilter(PorterDuffColorFilter(4294967295, PorterDuff.Mode.SRC_ATOP))
FontN(bitchass, activity.getLuaDir().."/font/Boldfinger.ttf")
FontN(aimbot_label, activity.getLuaDir().."/font/Boldfinger.ttf")



Date = "20250710"
date = os.date("%Y%m%d")
if date >= Date then
  vibrator = activity.getSystemService(Context.VIBRATOR_SERVICE)
  vibrator.vibrate(long({650, 650}), -1)
  dialog = AlertDialog.Builder(this).setTitle("ASTRA X EZYR INJECTOR EXPIRED").setCancelable(false).setMessage("IF YOU WANT TO CONTINUE PLEASE MESSAGE ME ON TELEGRAM TO BUY").setPositiveButton("EXIT", {
    onClick = function(A0_19)
      os.exit()
    end

  }).setNeutralButton("CHECK CHANNEL", {
    onClick = function(A0_20)
      url = "https://t.me/divinenxchhy"
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
      os.exit()
    end

  }).show()
  import("android.text.SpannableString")
  import("android.text.style.ForegroundColorSpan")
  import("android.text.Spannable")
  texttitle = SpannableString("ASTRA X EZYR INJECTOR EXPIRED")
  texttitle.setSpan(ForegroundColorSpan(4294901760), 0, #texttitle, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  dialog.setTitle(texttitle)
  return
end


-- Login tracking
import "http"
local username = user_input -- replace with your actual username variable
local body = [[{"username":"]] .. username .. [["}]]
Http.post("https://your-render-url.onrender.com/login_event", body, "application/json", function(code, response)
  print("Login status sent: " .. code)
end)
