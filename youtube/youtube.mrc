;##################################
;#                                                                        
;#    Auteur : kikuchi
;#    Site :   http://www.zone-script.net      
;#    Titre :  Visionneur de vidéos youtube V 4.3                
;#    Testeurs : Saga, Real et Ma Ashley (Merci beaucoup)
;#    Graphisme : Merci à Ma Ashley
;#    Notre salon : /server -m irc.epiknet.net -j #zone-script 
;#
;#    Traduction Allemand : Merlin http://www.mish-script.de
;#    Traduction Portugais : Extreminador & Ruan
;#                                                                        
;#    types de liens matchés
;#    www.youtube.com/user/MissHannahMinx#p/u/1/lwbVThHOkas
;#    www.youtu.be/d9TnMUlIBKQ
;#    www.youtu.be/1hMMUJ2Gn7Y?t=1m36s
;#    www.youtube.com/user/MissHannahMinx?v=QIt_hedcBTc
;#    www.youtube.com/v/5RNePy_awq0?version=3&amp;autohide=1
;#    www.youtube.com/watch?v=ZlLHoxxJBG4&feature=player_detailpage
;#    www.youtube.com/watch?feature=g-logo&v=Fc9muM7Qy-M
;#    www.youtube-nocookie.com/v/QIt_hedcBTc
;#    www.youtube-nocookie.com/e/QIt_hedcBTc
;#    www.youtube-nocookie.com/embed/QIt_hedcBTc
;#    www.youtube.com/e/5RNePy_awq0
;#    www.youtube.com/embed/5RNePy_awq0
;#    https://youtube.googleapis.com/v/Wo8LMJuDp6o
;#    www.youtube.com/watch?feature=player_detailpage&v=oiKj0Z_Xnjc
;#
;##################################
alias logo {
  dcx WindowProps $window(-2).hwnd +t kiku`script
}
alias dcx {
  if ($isid) returnex $dll($scriptdirdcx.dll,$1,$2-)
  else !dll " $+ $scriptdirdcx.dll" $1 $2-
} 
alias udcx {
  if ($dcx(IsUnloadSafe)) $iif($menu, .timer 1 0) !dll -u dcx.dll
  else !echo 4 -qmlbfti2 [DCX] Unable to Unload Dll.
}
alias xdid {
  if ($isid) returnex $dcx( _xdid, $1 $2 $prop $3- )
  dcx xdid $2 $3 $1 $4-
}
alias  xdialog {
  if ($isid) returnex $dcx( _xdialog, $1 $prop $2- )
  dcx xdialog $2 $1 $3-
}
alias -l youtr !return $readini($scriptdiryoutube.ini,$1,$2)
alias -l youtl !return $iif($readini($scriptdirtrad.ini,$youtr(config,langue),$1),$v1,$readini($scriptdirtrad.ini,English,$1))
alias -l youtmatch !return m§(?:https?://)?(?:www\.|fr\.)?youtu(?:be(?:-nocookie)?(?:\.googleapis)?\.(?:fr|com)\S*)?(?:[&?]v=|/(?:v|e(?:mbed)?|u/1)\/|\.be/)([^&#?\s/]{9,11})§Sig
alias yc { 
  set -u1 %yctab $iif($1 isnum 1-3,$1,1)
  !dialog $iif($dialog(youtconfig),-x,-m) youtconfig youtconfig
  if $1 == 3 && $2 { ytsearch $2- } 
}
alias -l youterror {
  !echo -at Erreur 14[01,00You00,04Tube14]  $network - $$error - $read($script,n,$remove($gettok($gettok($error,2,40),1,44),line,ligne))
  if ($error) reseterror
}
alias -l youtmultid {
  var %a 1, %b $dialog(0) 
  while %a <= %b { 
    if (*yout.* iswm $dialog(%a)) .timer $+ $v2 1 1 dialog -x $v2
    inc %a
  }
}
alias -l youtfin {
  var %youtinpu $input($youtl(inputtextunload),bvywk15,$youtl(inputtitreunload))
  if (%youtinpu == $yes) .unload -rs $qt($script)
  else return
}
alias -l youtremisea0 {
  tokenize 46 config hotlink 1.config animation 1.config nombre 1.config echo 1.config mhistorique 1.config taillew 0.config tailleh 0.config lieuw 0.config lieuh 0.config clipboard 1.config focus 0.config infos 0.optionu autoplay 0.optionu autohide 0.optionu controls 1.optionu disablekb 0.optionu modestbranding 0.optionu showinfo 0.optionu theme 0.optionu color 0
  writeini $qt($scriptdiryoutube.ini) $*
  echo -ag 14[01,00You00,04Tube14] $youtl(echoreset)
}
alias -l yt.copy {
  var %a 1, %b $ini($scriptdirtrad.ini,$1,0)
  while %a <= %b {
    clipboard -an $+($ini($scriptdirtrad.ini,$1,%a),=,$readini($scriptdirtrad.ini,$1,$ini($scriptdirtrad.ini,$1,%a)))
    inc %a
  }
}
alias -l ytping {
  if $dialog(youtconfig) {
    xdid -l youtconfig 401 0
    xdid -e youtconfig 402
    xdid -t youtconfig 402 $youtl(ytch)
    xdid -t youtconfig 403 $youtl(pingch)
    xdid -t youtconfig 409 $youtl(ly)
    xdid -C youtconfig 404 +bk $rgb(0,0,0)
    sockclose yt.cherche
    unset %ytread*
    if ($hget(youtsocks)) hfree youtsocks
  }
}
alias ytsearch {
  if ($sock(yt.cherche)) sockclose yt.cherche
  sockopen yt.cherche www.youtube.com 80
  var %yccherch $+(/results?search_query=,$replace($1-,$chr(32),+))
  if $isid || %yctab {
    if $dialog(youtconfig) { sockmark yt.cherche $iif(%yctab,%yccherch,$ytchoixr) | ytycsearchregle | set %ytreadm 1 }
    else { echo -at $youtl(errorchl) | halt }
  }
  else {
    if (!$1) echo -at $youtl(syntch)
    else { sockmark yt.cherche %yccherch | if (!$window($+(@Youtube, $chr(160), $youtl(bouton3)))) window -aCde0fg0k0w3 +L $+(@Youtube, $chr(160), $youtl(bouton3)) -1 -1 950 520 tahoma 12 | else clear $+(@Youtube, $chr(160), $youtl(bouton3)) }
  }
}
on *:sockopen:yt.*:{
  if ($sockerr) return
  sockwrite -n $sockname GET $sock($sockname).mark HTTP/1.0
  sockwrite -n $sockname Host: www.youtube.com
  sockwrite -n $sockname $crlf
}
on *:sockread:yt.*:{
  if ($sockerr) return
  sockread &ytread
  if ($regex($bvar(&ytread,1-).text,<strong>([\d\54]+)<\/strong>)) $iif(%ytreadm == 1,xdid -t youtconfig 403,titlebar $+(@Youtube, $chr(160), $youtl(bouton3)) $gettok($sock(yt.cherche).mark,2-,61)) $youtl(res) $regml(1)
  if ($regex($bvar(&ytread,1-).text,/data-context-item-title="([^"]*)"/g))  set %ytreadinfo.titre $regml(1)
  if ($regex($bvar(&ytread,1-).text,/data-context-item-user="([^"]*)"/g)) set %ytreadinfo.posteur $regml(1)
  if ($regex($bvar(&ytread,1-).text,/data-context-item-id="([^"]*)"/g)) set %ytreadinfo.lien $regml(1)
  if ($regex($bvar(&ytread,1-).text,data-context-item-views="([^"]*)")) set %ytreadinfo.vue $regml(1)
  if ($regex($bvar(&ytread,1-).text,data-context-item-time="([\d\72]+)")) set %ytreadinfo.durée $regml(1)
  if %ytreadinfo.durée && %ytreadinfo.titre && %ytreadinfo.lien && %ytreadinfo.posteur && %ytreadinfo.vue {
    if (%ytreadm) {
      hadd -m youtsocks %ytreadinfo.lien $+($replace(%ytreadinfo.vue,$chr(32),$chr(9676)),$chr(32),$replace(%ytreadinfo.posteur,$chr(32),$chr(9676)),$chr(32),%ytreadinfo.durée,$chr(32),$fix(%ytreadinfo.titre))
      xdid -a youtconfig 404 0 $fix(%ytreadinfo.titre)
    }
    else {
      if ($active != $+(@Youtube, $chr(160), $youtl(bouton3))) window -a $+(@Youtube, $chr(160), $youtl(bouton3))
      echo $+(@Youtube, $chr(160), $youtl(bouton3)) 14[01,00You00,04Tube14]4 Titre : $fix(%ytreadinfo.titre) 4Durée : %ytreadinfo.durée 4Posteur : %ytreadinfo.posteur 4 $youtl(ComboV) : %ytreadinfo.vue
      echo $+(@Youtube, $chr(160), $youtl(bouton3)) 6Link :12 $+(www.youtube.com/watch?v=,%ytreadinfo.lien)
    }
    unset %ytreadinfo*
  }
}
on *:sockclose:yt.*:{
  if %ytreadm == 1 {
    xdid -e youtconfig 402
    xdid -t youtconfig 402 $youtl(ytch)
    xdid -l youtconfig 401 0
  }
  unset %ytread*
  if ($timer(ytcherche)) .timerytcherche off
}
alias callback_yout {
  if ($2 == error) echo -s Erreur 14,00[01You00,04Tube14] Dialog : $1 ID : $3 Controle : $4 Prop : $5 Commande : $6 Erreur : $7-
  if $1 = youtconfig {
    if $2 = sclick {
      if $3 isnum 1001-1003 {
        xdialog -z $1 +s $calc($3 -1000)
        dialog -t $1 $youtl(titleconfig) $youtr(config,version)
        if ($xdialog($1).zlayercurrent = $calc($3 - 1000)) halt
      }
      if $3 == 105 { writeini -n youtube\youtube.ini config langue $xdid($1,$3).seltext | ytlanguech }
      if $3 isnum 106-121 {
        var %ytcheck config.hotlink config.animation config.echo config.mhistorique optionu.autoplay config.nombre optionu.autohide optionu.controls optionu.disablekb optionu.modestbranding optionu.showinfo optionu.theme optionu.color config.clipboard config.focus config.infos
        writeini -n youtube\youtube.ini $replace($gettok(%ytcheck,$calc($3 -105),32),$chr(46),$chr(32)) $iif($xdid($1,$3).state,1,0)
        if ($3 == 106) $+(!,$iif($group(#youthot) == on,.dis,.en),able) #youthot
        elseif $3 == 121 { xdialog -S $1 -1 -1 $iif($xdid($1,$3).state,676,315) 230 | xdialog -g $1 +is $+($scriptdir,youtube,$iif($xdid($1,$3).state == 1,ecran),.png) | xdid -t $1 408 $youtl($+(resize,$iif($xdid($1,$3).state == 1,inf,max))) }
      }
      if $3 isnum 122-137 {
        var %ytcheck explicationonoff explicationanimation explicationtitrevidéo explicationhistorique explicationautoplay explicationdialogs explicationautohide explicationcontrols explicationdisablekb explicationmodestbranding explicationshowinfo explicationtheme explicationcolor explicationclipboard explicationfocus explicationinfos
        xdid -t $1 104 $youtl($gettok(%ytcheck,$calc($3 -121),32))
      }
      elseif $3 == 205 { 
        if !$xdid($1,203).text || !$xdid($1,204).text { noop $input($youtl(textinputtrad),bwo,$youtl(titleinputtrad)) }
        else { writeini -n $scriptdirtrad.ini $xdid($1,201).seltext  $xdid($1,203).text $xdid($1,204).text | noop $input($youtl(textinputtradok),bhok5,$youtl(titleinputtrad)) }
      }
      elseif ($3 == 201) xdid -t $1 208 $readini($scriptdirtrad.ini,n,$xdid($1,200).seltext,$xdid($1,201).seltext)
      elseif ($3 == 209) yt.copy $$input($youtl(textinputcopy),bmq,$youtl(titleinputcopy),anti-choix, [ $regsubex($str($chr(44),$ini($scriptdirtrad.ini,0)), //g,$ini($scriptdirtrad.ini,\n)) ] )
      elseif $3 == 402 {
        if ($xdid($1,401).text) $ytsearch($xdid(youtconfig,401).text)
        else xdid -E $1 401 $youtl(errortag)
      }
      elseif $3 == 404 { dialog -t $1 $xdid($1,404,$4).text | noop $hfind(youtsocks,& & & $xdid($1,404).seltext,0,w,youtrinfo $1 $hget(youtsocks,$1)).data }
      elseif $3 == 408 { xdialog -S $1 -1 -1 $iif($dialog($1).w = 682,315,666) 230 | xdialog -g $1 +is $+($scriptdir,youtube,$iif($dialog($1).w == 682,ecran),.png) | xdid -t $1 $3 $youtl($+(resize,$iif($dialog($1).w == 682,inf,max))) }
      elseif $3 == 409 {
        if ($xdid($1,$3).text == $youtl(liench)) xdid -t $1 403 $youtl(errornolien)
        else clipboard www.youtube.com $+ $xdid($1,$3).text
      }
      elseif $3 == 410 {
        if !$dialog(yout. $+ $xdid($1,409).text) {
          if $xdid($1,404).sel { noop $hfind(youtsocks,& & $xdid($1,406).text $xdid($1,404).seltext,0,w,if (!$dialog(yout. $+ $1)) dialog -m yout. $+ $1 yout.).data }
          else xdid -t $1 403 $youtl(errornotitre)
        }
        else xdid -t $1 403 $youtl(errorstopvideo)
      }
    }
    if ($istok(tracking pageup pagedown linedown lineup,$2,32) && $3 == 103) xdid -p $1 102 0 $calc(0 - $4) 160 500
  }
  if ($regex(code,$1-2,yout.(.{11} title))) dialog -t $1 $gettok($4-,1- $calc($numtok($4-,45) -1),45)
}
alias -l youtrinfo {
  xdid -ra youtconfig 405 $replace($3,$chr(9676),$chr(32))
  xdid -ra youtconfig 406 $4
  xdid -ra youtconfig 407 $replace($2,$chr(9676),$chr(32))
  xdid -j youtconfig 414 img = document.getElementById("miniimage"); img.src = $qt($+(http://i1.ytimg.com/vi/,$1,/mqdefault.jpg)); 
  .timer $+ $1 1 0 xdid -t youtconfig 409 /watch?v= $+ $1
}
alias -l ytycsearchregle {
  xdid -r youtconfig 404
  .timerytcherche 1 20 ytping
  xdid -t youtconfig 402 $youtl(ytattente)
  xdid -b youtconfig 402
  xdid -l youtconfig 401 1
  xdid -t youtconfig 409 $youtl(ly)
  if ($hget(youtsocks)) hfree youtsocks
}
dialog -l yout.* { 
  option pixels
  size $iif($youtr(config,lieuw),$v1,-1) $iif($youtr(config,lieuh),$v1,-1) $iif($youtr(config,taillew),$v1,431) $iif($youtr(config,tailleh),$calc($v1 +27),206)
  title Youtube
  menu $youtl(menu3) ,4
  item $youtl(menu4) ,5,4
  item $youtl(menu5) ,6,4
  menu $youtl(menu6) ,7
  item $youtl(menu7) ,8,7
  item $youtl(menu8) ,9,7
}
on *:dialog:yout.*:*:*:{
  if $devent == init {
    dcx Mark $dname callback_yout
    xdialog -c $dname 1 webctrl 0 0 $iif($youtr(config,taillew),$v1,431)  $iif($youtr(config,tailleh),$calc($v1 +27),206)
    xdid -n $dname 1 $+(http://www.youtube.com/embed/,$gettok($dname,2,46),?autoplay=,$youtr(optionu,autoplay),&autohide=,$youtr(optionu,autohide),&controls=,$youtr(optionu,controls),&disablekb=,$youtr(optionu,disablekb),&modestbranding=,$youtr(optionu,modestbranding),&showinfo=,$youtr(optionu,showinfo),&theme=,$replace($youtr(optionu,theme),1,light,0,black),&color=,$replace($youtr(optionu,color),1,white,0,red),&fs=1&feature=player_detailpage,$iif(%ythottime,&start= $+ %ythottime))
    xdialog -b $dname +zntym
    xdialog -R $dname +g 65
    xdialog -l $dname root $chr(9) +li 1 0 0 0
    xdialog -w $dname + 0 $scriptdiryoutube.ico
    if $youtr(config,animation) == 1 { xdialog -a $dname +av 500 | xdialog -a $dname -au 500 }
    if (($youtr(config,mhistorique) == 1) && ($hget(mhistorique,$remove($dname,yout.),0).data)) hdel mhistorique $remove($dname,yout.)
    .timer 1 0 youtube_afterinit $dname 
  }
  elseif $devent == menu {
    if $did == 5 { writeini -n youtube\youtube.ini config lieuw $dcx(ActiveWindow,x) | writeini -n youtube\youtube.ini config lieuh $dcx(ActiveWindow,y) | noop $input($youtl(texteinputpos),boik5,$youtl(titreinputpos)) }
    elseif $did == 6 { tokenize 32 lieuw lieuh | writeini -n youtube\youtube.ini config $* 0 | noop $input($youtl(texteinputpos),boik5,$youtl(titreinputpos)) }
    elseif $did == 8 { 
      if $dcx(ActiveWindow,w) <= 300 || $dcx(ActiveWindow,h) <= 200 || $dcx(ActiveWindow,h) >= 760 || $dcx(ActiveWindow,w) >= 1165 { noop $input($youtl(texteinputerror),bowk5,$youtl(titreinputerror)) | halt } 
      else { writeini -n youtube\youtube.ini config taillew $dcx(ActiveWindow,w) | writeini -n youtube\youtube.ini config tailleh $dcx(ActiveWindow,h) | noop $input($youtl(texteinputt),bok5,$youtl(titreinputt)) } 
    }
    elseif $did == 9 { tokenize 32 taillew tailleh | writeini -n youtube\youtube.ini config $* 0 | noop $input($youtl(texteinputtaillenormal),boik5,$youtl(titreinputtaillenormal)) }
  }
  :error
  youterror
}
alias -l youtube_afterinit xdialog -l $1 update 
#youthot on
on $*^:hotlink:$($youtmatch):*:{
  var %ytmatch $regml(1)
  if ($youtr(config,clipboard) == 1 && $hotlink(event) == sclick) clipboard $1
  elseif $hotlink(event) == dclick {
    if ($gettok($hget(yttitre,$regml(1)),1,32)) url -a $1
    else {
      if !$dialog(yout. $+ %ytmatch) {
        var %youtr $youtr(config,nombre),%youtrf $youtr(config,focus)
        if (!%youtr) youtmultid
        if ($regex($1,/(?:#|\?)t=([\ddhms]+)/S)) set -u1 %ythottime $duration($regml(1))
        dialog -m yout. $+ %ytmatch yout.
        if (%youtrf) window -a $qt($active)
      }
    }
  }
  elseif (($hotlink(event) == rclick)) noop $hfind(mhistorique,$regml(1),0,w,hdel mhistorique $1)
}
#youthot end
dialog -l youtconfig {
  title $youtl(titleconfig) $youtr(config,version)
  option pixels
  size -1 -1 $iif($youtr(config,infos) == 1,676,325) 240
}
on *:dialog:youtconfig:init:*:{
  dcx Mark $dname callback_yout
  xdialog -w $dname + 0 $scriptdiryoutube.ico
  xdialog -T $dname +
  xdialog -g $dname +is $+($scriptdir,youtube,$iif($youtr(config,infos) == 1,ecran),.png)
  xdialog -b $dname +tyn
  var %x 1
  while $youtr(menu,%x) {
    xdialog -c $dname $calc(%x + 1000) button $calc(%x *80-30) 5 75 25 bitmap
    xdid -t $dname $calc(1000 + %x) $youtr(menu,%x)
    xdialog -c $dname %x box 5 40 320 195 none transparent
    xdialog -z $dname +a %x
    xdialog -z $dname +s %x
    $youtr(menu,%x)
    inc %x
  }
  xdid -k $dname 205,1001-1003 +n $rgb(255,255,255) $scriptdirbouton.png
  Xdid -k $dname 205,1001-1003 +h $rgb(255,255,255) $scriptdirbouton2.png
  Xdid -k $dname 205,1001-1003 +s $rgb(255,255,255) $scriptdirbouton3.png
  xdialog -z $dname +s $iif(%yctab,$v1,1)
  xdid -m $dname 205,1001-1003 1
  xdid -c $dname 205,1001-1003 +nd $rgb(255,255,255)
  xdid -c $dname 205,1001-1003 +h $rgb(255,153,0)
  xdid -c $dname 205,1001-1003 +s $rgb(255,255,0)
  xdid -k $dname 122-137,209 +n $rgb(0,0,0) $scriptdiretoile.png
  xdid -k $dname 122-137,209 +h $rgb(0,0,0) $scriptdiretoile2.png
  xdid -k $dname 122-137,209 +s $rgb(0,0,0) $scriptdiretoile3.png
  xdid -C $dname 103 +b $rgb(0,0,0)
  ytlanguech
}
alias -l ytlanguech {
  dialog -t youtconfig $youtl(titleconfig) $youtr(config,version)
  tokenize 167 1001 $youtl(bouton1) §1002 $youtl(bouton2) §1003 $youtl(bouton3) §100 $youtl(Titreboxexpli) :§104 $youtl(boxinfo) §106 $youtl(option1) §107 $youtl(option2) §108 $youtl(option3) §109 $youtl(option4) §110 $youtl(option5) §111 $youtl(option6) §112 $youtl(option7) §113 $youtl(option8) §114 $youtl(option9) §115 $youtl(option10) §116 $youtl(option11) §117 $youtl(option12) §118 $youtl(option13) §119 $youtl(option14) §120 $youtl(option15) §121 $youtl(option16) § 202 $youtl(trad1) §205 $youtl(trad4) §206 $youtl(pubsite) §208 $readini($scriptdirtrad.ini,$xdid(youtconfig,200).seltext,$xdid(youtconfig,201).seltext) §402 $youtl(ytch) §403 $youtl(res) §408 $youtl($+(resize,$iif($youtr(config,infos) == 1,inf,max))) §409 $youtl(liench) §410 $youtl(go)
  xdid -t youtconfig $*
  xdid -E youtconfig 203 $youtl(trad2)
  xdid -E youtconfig 204 $youtl(trad3)
  xdid -T youtconfig 209 $youtl(tooltips)
  xdid -r youtconfig 400
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideoall)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideodate)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideoview)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideocom)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideoday)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideosemaine)
  xdid -a youtconfig 400 0 0 0 0 0 $youtl(combovideomois)
  xdid -c youtconfig 400 1
  xdid -E youtconfig 401 $youtl(fantometag)
  xdid -E youtconfig 405 $youtl(fantomeposteur)
  xdid -E youtconfig 406 $youtl(fantomeduree)
  xdid -E youtconfig 407 $youtl(fantomeview)
}
alias configuration {
  var %id $xdialog(youtconfig).zlayercurrent
  xdid -c $dname %id 100 box 5 16 140 170 center transparent rounded
  xdid -c $dname %id 101 box 150 17 145 165 transparent none
  xdid -c $dname 101 102 box 0 0 165 184 transparent none
  var %a 106, %yt.checkconf = hotlink.animation.echo.mhistorique.autoplay.nombre.autohide.controls.disablekb.modestbranding.showinfo.theme.color.clipboard.focus.infos
  while %a <= 121 {
    xdid -c $dname 102 %a check 22 $calc(((%a -105) *17)+20) 115 18
    xdid -c $dname 102 $calc(%a +16) button 4 $calc(((%a -105) *17)+20) 15 16 bitmap transparent
    xdid -t $dname $calc(%a +16) ?
    if ($youtr($iif($istok(106.107.108.109.111.119.120.121,%a,46),config,optionu),$gettok(%yt.checkconf,$calc(%a - 105),46)) == 1) xdid -c $dname %a
    inc %a
  }
  xdid -c $dname %id 103 scroll 295 14 15 171 vertical
  xdid -r $dname 103 0 144
  xdid -l $dname 103 18
  xdid -m $dname 103 15
  xdid -c $dname 100 104 text 7 15 130 170 transparent noformat
  xdid -c $dname 102 105 comboex 4 7 140 300 dropdown transparent
  var %a 1, %b $ini($scriptdirtrad.ini,0)
  while %a <= %b {
    xdid -a $dname 105 0 0 0 0 0 $ini($scriptdirtrad.ini,%a)
    inc %a
  }
  xdid -c $dname 105 $xdid($dname,105,$chr(9) $youtr(config,langue) $chr(9),W,1).find
}
alias traduction {
  var %id $xdialog(youtconfig).zlayercurrent
  xdid -c $dname %id 200 comboex 5 5 150 150 dropdown transparent
  var %a 1, %b $ini($scriptdirtrad.ini,0)
  while %a <= %b {
    xdid -a $dname 200 0 0 0 0 0 $ini($scriptdirtrad.ini,%a)
    inc %a
  }
  xdid -c $dname 200 $xdid($dname,200,$chr(9) $youtr(config,langue) $chr(9),W,1).find
  xdid -c $dname %id 201 comboex 160 5 150 150 dropdown transparent
  var %a 1, %b $ini($scriptdirtrad.ini,$youtr(config,langue),0)
  while %a <= %b {
    xdid -a $dname 201 0 0 0 0 0 $ini($scriptdirtrad.ini,$youtr(config,langue),%a)
    inc %a
  }
  xdid -c $dname 201 1
  xdid -c $dname %id 202 box 5 33 150 163 transparent rounded center
  xdid -c $dname %id 203 edit 160 33 140 18 autohs center
  xdid -c $dname %id 204 edit 160 55 140 18 autohs center
  xdid -C $dname 203,204 +bk $rgb(0,0,0)
  xdid -C $dname 203,204 +t 13422034
  xdid -x $dname 203,204 +w
  xdid -c $dname %id 205 button 158 155 120 22 bitmap
  xdid -c $dname %id 206 text 160 75 150 65 noformat center transparent
  xdid -c $dname 202 208 text 5 15 140 155 transparent noformat
  xdid -c $dname %id 209 button 283 155 20 22 tooltips bitmap transparent
}
alias Recherche {
  var %id $xdialog(youtconfig).zlayercurrent
  xdid -c $dname %id 400 comboex 10 5 165 150 dropdown
  xdid -c $dname %id 401 edit 10 29 210 18 autohs
  xdid -c $dname %id 402 button 230 29 80 20
  xdid -c $dname %id 403 box 5 50 305 135 transparent
  xdid -c $dname 403 404 list 5 15 150 131 hsbar vsbar
  xdid -c $dname 403 405 edit 160 15 140 18 autohs center
  xdid -c $dname 403 406 edit 160 35 140 18 autohs center
  xdid -c $dname 403 407 edit 160 55 140 18 autohs center
  xdid -c $dname 403 408 button 160 75 140 18
  xdid -C $dname 401,404-407 +bk $rgb(0,0,0)
  xdid -C $dname 401,404-407 +t 13422034
  xdid -x $dname 401,404-407 +w
  xdid -c $dname 403 409 link 170 95 130 15 shadow tooltips transparent
  xdid -c $dname 403 410 button 165 110 60 20
  xdialog -c $dname 414 webctrl 355 20 300 200
  xdid -n $dname 414 $scriptdirimage.html
  ;.timerytinfo 1 0 xdid -j youtconfig 414 img = document.getElementById("miniimage"); img.src = $qt(http://www.zone-script.net/remotes/youtube/ytinfo.php?r= $+ $r(1,999999999));
}
alias ytchoixr {
  if ($xdid(youtconfig,400).seltext == $youtl(combovideoall)) return $+(/results?search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+))
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideodate)) return $+(/results?search_type=videos&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+),&amp;search_sort=video_date_uploaded&amp;uni=3)
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideoview)) return $+(/results?search_type=videos&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+),&amp;search_sort=video_view_count&amp;uni=3)
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideocom)) return $+(/results?search_type=videos&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+),&amp;search_sort=video_avg_rating&amp;uni=3)
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideoday)) return $+(/results?uploaded=d&amp;search_type=videos&amp;uni=3&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+))
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideosemaine)) return $+(/results?uploaded=w&amp;search_type=videos&amp;uni=3&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+))
  elseif ($xdid(youtconfig,400).seltext == $youtl(combovideomois)) return $+(/results?uploaded=m&amp;search_type=videos&amp;uni=3&amp;search_query=,$replace($xdid(youtconfig,401).text,$chr(32),+))
}
on *:unload:echo -atg 14[01,00You00,04Tube14] $youtl(texteunload)
on *:text:*:*:if ($regex(youtlieu,$1-,$youtmatch)) youtevent $regml(youtlieu,1)
on *:action:*:*:if ($regex(youtlieu,$1-,$youtmatch)) youtevent $regml(youtlieu,1)
on *:notice:*:*:if ($regex(youtlieu,$1-,$youtmatch)) youtevent $regml(youtlieu,1)
on *:topic:#:if ($regex(youtlieu,$1-,$youtmatch)) youtevent $regml(youtlieu,1)
raw 332:*:if ($regex(youtlieu,$1-,$youtmatch)) youtevent $regml(youtlieu,1)
on *:start:run -h cmd /c $scriptdirytdl\youtube-dl.exe -U
alias -l youtevent {
  if (($youtr(config,mhistorique) == 1) && (!$hfind(mhistorique,$1,0))) hadd -m mhistorique $1 $nick $youtl(textehadd) $iif($left($target,1) == $chr(35),$target)
  sendlink
}
alias -l sendlink {
  var %a 1
  while $regml(youtlieu,%a) {
    noop $regex(title,$getpage(http://gdata.youtube.com/feeds/videos/ $+ $v1 $+ ?v=1&fields=title),/<title type='text'>([^<]+)</title>/i)
    if ($regex(titlebloque,$getpage(http://gdata.youtube.com/feeds/mobile/videos/ $+ $v1 $+ ?v=1),/name='restricted' reasonCode/i)) set -l $+(%,$replace($regml(title,1),$chr(32),$chr(181))) ok
    hadd -m yttitre $regml(youtlieu,1) $iif($eval($+(%,$replace($regml(title,1),$chr(32),$chr(181))),2),1,0) $html2ascii($regml(title,1))
    var %yttitreecho %yttitreecho $iif($regml(title,1),$iif($eval($+(%,$replace($regml(title,1),$chr(32),$chr(181))),2),$+($chr(2),$chr(3),8,$chr(44),4,$chr(47),!,$chr(92),$chr(15),$chr(3),04)) $html2ascii($regml(title,1)),$youtl(Titreerrorlag)) $iif($regml(youtlieu,0) > 1,$+($chr(2),$chr(3),07»,$chr(15),$chr(3),04))
    if $youtr(config,echo) == 1 && %a == $regml(youtlieu,0) { echo $iif($event == notice,-ta,-t) $iif($left($target,1) == $chr(35),$target,$iif($event == text,$nick,$iif($event != notice,$gettok($rawmsg,4,32)))) 01,00You00,04Tube0 $youtl(Titreecho) $+ :4 $gettok(%yttitreecho,$+(1-,$calc($numtok(%yttitreecho,187)-1)),187) }
    inc %a
  }
}
alias getpage {
  var %ytget yt $+ $ticks
  .comopen %ytget msxml2.xmlhttp
  noop $com(%ytget,Open,1,bstr,GET,bstr,$1-,bool,false) $com(%ytget,Send,1) $com(%ytget,ResponseText,2)
  var %a $mid($com(%ytget).result,1,4141)
  :error
  .comclose %ytget
  return %a
}
menu channel,nicklist,query,menubar,status {
  Youtube
  .$iif($dialog(youtconfig),$style(1) $youtl(xmenuon),$style(0) $youtl(xmenuoff)):yc
  .$iif($youtr(config,mhistorique) == 1,$iif($hget(mhistorique,0).item,$v1 $youtl(xmenu)))
  ..$youtl(xmenudelh):hfree mhistorique
  ..$submenu($mhistorique($1))
  .$youtl(xmenudelunl):youtfin
  .$youtl(menureset):youtremisea0
}
alias -l mhistorique {
  if ($istok(begin.end,$1,46)) return -
  if ($hget(mhistorique,$1).data) return .. $+ $hget(mhistorique,$1).data $+ :dialog -m yout. $+ $hget(mhistorique,$1).item yout.
}
;alias de Wiz126 - SwiftIRC - #msl
alias -l HT2AS {
  var %A quot amp apos lt gt nbsp iexcl cent pound curren yen brvbar sect uml copy ordf laquo not shy reg macr deg plusmn sup2 sup3 acute micro para middot cedil sup1 ordm raquo frac14 frac12 frac34 iquest Agrave Aacute Acirc Atilde Auml Aring AElig Ccedil Egrave Eacute Ecirc Euml Igrave Iacute Icirc Iuml ETH Ntilde Ograve Oacute Ocirc Otilde Ouml times Oslash Ugrave Uacute Ucirc Uuml Yacute THORN szlig agrave aacute acirc atilde auml aring aelig ccedil egrave eacute ecirc euml igrave iacute icirc iuml eth ntilde ograve oacute ocirc otilde ouml divide oslash ugrave uacute ucirc uuml yacute thorn yuml trade
  var %B 34 38 39 60 62 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 153
  return $chr($gettok(%B,$findtokcs(%a,$1,32),32))
}
alias -l html2ascii return $regsubex($1-, /&(.{2,6});/Ug, $iif(#* iswm \t, $chr($mid(\t,2) ), $HT2AS(\t) ))
;alias de FordLawnmower - GeekShed - #Script-Help
alias -l fix return $regsubex($remove($replace($1-,&amp;,&,&quot;,"),amp;),/&#([0-9]{2});/gi,$chr(\t))
