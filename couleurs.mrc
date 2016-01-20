### Panel couleurs

alias cF4 { if ($dialog(color).title != $null) { dialog -v color | halt }
  dialog -m color color
}

/*
Console de gestion des couleurs
*/
dialog color {
  title "Couleurs & Décoration"
  size -1 -1 240 250
  ; Boutons
  button "&OK" 17,135 215 100 25, ok
  button "A&fficher couleurs" 18,135 146 100 25
  button "Effa&cer couleurs" 19,135 180 100 25
  ; Couleur
  combo 4,130 40 90 100, drop size
  combo 5,20 40 90 100, drop size
  text "Texte" 45,50 23 43 15
  text "Majuscule" 55,150 23 80 15
  ; Options
  check "&Gras" 13,20 108 60 20
  check "Majuscule" 1,20 88 70 20
  check "Activ&er" 2,120 108 60 20
  check "Souligner pseudo" 3,120 88 100 20
  ; Décoration
  text "Avant" 200,20 153 35 15
  edit "" 300,20 168 45 20, autohs
  text "Après" 400,75 153 35 15
  edit "" 500,75 168 45 20, autohs
  ; Panels
  box "Couleur" 40,10 10 220 58
  box "Options" 50,10 73 220 60
  box "Décoration" 100,10 138 120 56
  box "Aperçu" 60, 10 199 120 43
}

on 1:dialog:color:init:0: {
  if (%deco.soul == on) { did -c color 3 }
  if (%deco.enable == on) { did -c color 2 }
  if (%deco.maj == on) { did -c color 1 }
  if (%deco.gras != $null) { did -c color 13 }
  did -a color 300 %deco.begin
  did -a color 500 %deco.end
  combolist
  ; Création de la fenêtre d'aperçu
  window -Bdh @Aperçu
  dcx Mark $dname color_cb
  xdialog -c color 62 window 15 214 110 20 @Aperçu
  if (%deco.soul == on) { aline @Aperçu $coloration(test  $+ $me) }
  else aline @Aperçu $coloration(test $me)
}

on 1:dialog:color:sclick:*:{
  if ($did == 18) { coul }
  if ($did == 19) {
    set %deco.color1
    set %deco.color1.sel
    set %deco.color2
    set %deco.color2.sel
    did -r color 4,5
    combolist
    color.refresh
  }
  ; Couleur majuscule
  if ($did == 4) {
    set %deco.color1.sel $did(4)
    var %c1 = $calc($did(4,1).sel - 1)
    set %deco.color1  $+ $right(0 $+ %c1, 2)
    if (%deco.color1.sel == %deco.color2.sel) { set %deco.color2 }
    color.refresh
  }
  ; Couleur texte
  if ($did == 5) {
    set %deco.color2.sel $did(5)
    var %c2 = $calc($did(5,1).sel - 1)
    if (%deco.color2.sel != %deco.color1.sel) { set %deco.color2  $+ $right(0 $+ %c2, 2) }
    else set %deco.color2
    color.refresh
  }
  ; Activation du script
  if ($did == 2) {
    if (%deco.enable == on) { %deco.enable = $null | did -u color 2 }
    elseif (%deco.enable == $null) { set %deco.enable on | did -c color 2 }
    else { set %deco.enable on | did -c color 2 }
    color.refresh
  }
  ; Activation du gras
  if ($did == 13) { 
    if (%deco.gras != $null) { %deco.gras = $null | did -u color 13 }
    elseif (%deco.gras = $null) { set %deco.gras  | did -c color 13 }
    else { set %deco.gras  | did -c color 13 }
    color.refresh
  }
  ; Activation de la majuscule
  if ($did == 1) { 
    if (%deco.maj == on) { %deco.maj = $null | did -u color 1 }
    elseif (%deco.maj == $null) { set %deco.maj on | did -c color 1 }
    else { set %deco.maj on | did -c color 1 }
    color.refresh
  }
  ; Activation des pseudos soulignés
  if ($did == 3) {
    if (%deco.soul == on) { %deco.soul = $null | did -u color 3 }
    elseif (%deco.soul == $null) { set %deco.soul on | did -c color 3 }
    else { set %deco.soul on | did -c color 3 }
    color.refresh
  }
}

on 1:dialog:color:edit:*:{
  if ($did == 300) { set %deco.begin $did(300) | color.refresh }
  if ($did == 500) { set %deco.end $did(500) | color.refresh }
}

/*
Evènement
*/
on 1:input:*:{
  ; Input problem
  var %1
  if (($1- !== ?) && ($left($1-,1) == ?) && ($left($1-,2) !== ??)) {
    var %lettre = $?="Lettre manquante ? $crlf $+ $1", %1 = %lettre $+ $right($1-,-1)
  }
  else { %1 = $1- }
  ; Exceptions
  if (%deco.enable != on ) { goto fin }         ; Le script est actif
  if (/ isin $left($1-,1)) { goto fin }         ; Ce n'est pas une /commande
  if (c isin $chan(#).mode) { goto fin }        ; Le mode +c n'est pas actif sur le canal
  if (anime isin $chan)  { goto fin }           ; "anime" n'est pas dans le nom du canal
  if (fansub isin $chan) { goto fin }           ; "fansub" n'est pas dans le nom du canal
  if (otaku isin $chan)  { goto fin }           ; "otaku" ça c'est pour mes coupaings
  if (#moetaku isin $chan) { goto fin }         ; "#moetaku" except
  if (http: isin $left($1-,5)) { goto fin }     ; Ce n'est pas une adresse "http:"
  if (https: isin $left($1-,6)) { goto fin }    ; Ce n'est pas une adresse "https:"
  if (ftp: isin $left($1-,4)) { goto fin }      ; Ce n'est pas une adresse "ftp:"
  if (www isin $left($1-,3)) { goto fin }       ; Ce n'est pas une adresse "www"
  if (! isin $left($1-,1)) { goto fin }         ; Ce n'est pas un !trigger
  if ( isin $left($1-,1)) { goto fin }         ; Le texte ne commence pas par une couleur (Ctrl+K)
  if ( isin $left($1-,1)) { goto fin }         ; Le texte n'est pas en mode reverse (Ctrl+R)
  if ( isin $left($1-,1)) { goto fin }         ; Le texte ne commence pas par Ctrl+O
  if ($active == $query($active)) { goto fin }  ; Le script est actif pour les fenêtre query aussi ... ou pas
  ; Fonction de coloration
  if ($query($active) != $null || $chan != $null) { .say $coloration(%1) | halt }
  :fin
}

/*
Coloration
*/
alias coloration {
  var %line
  ; Souligner les pseudos
  if (%deco.soul == on) {
    var %nb  = 1, %mot = $gettok($1-, %nb, 32), %punct, %reg = ^([^,.>!?;:]+)([,.>!?;:]+)$
    while (%mot != $null) {
      if ($regsub(%mot, %reg, \2, %punct) == 0) { %punct = $null }
      %mot = $regsubex(%mot, %reg, \1)
      if (%mot ison #) { var %line %line  $+ %mot $+  $+ %punct }
      else { var %line %line %mot $+ %punct }
      inc %nb
      %mot = $gettok($1-, %nb, 32)
    }
  }
  else { %line = $1- }
  ; Saut de tous les caractères Ctrl+u, Ctrl+b & Ctrl+i et arrêt à un caractère Ctrl+k
  var %c = 1
  var %txt.left = $left(%line,%c)
  while ($regex($right(%txt.left,1),[]) > 0) {
    if (%c > $len(%line)) { break }
    inc %c 
    %txt.left = $left(%line,%c)
    if ($right(%txt.left,1) == ) { return %line }
  }
  ; Application de la Majuscule
  if (%deco.maj == on) { %txt.left = $upper(%txt.left) }
  var %txt.right = $mid(%line, $calc(%c + 1))
  ; Correction problème de virgule
  if ($left(%txt.right, 1) == $chr(44)) { %txt.right = $chr(44) $+ 99 $+ %txt.right }
  ; Application des couleurs et retour de la fonction
  return %deco.begin  $+ $+(%deco.gras,%deco.color1,%txt.left,%deco.color2,%txt.right, %deco.end)
}

; Rafraichissement de la fenêtre d'aperçu
alias -l color.refresh {
  if (%deco.soul == on) { aline @Aperçu $coloration(test  $+ $me) }
  else aline @Aperçu $coloration(test $me)
}

; Alias obligatoire pour DCX
alias color_cb { if (($2 == sclick) && ($3 == 0)) { haltdef } }

; Retourne la valeur de la luminosité d'une couleur en %
alias bright { return $calc(($gettok($rgb($1),1,44) + $gettok($rgb($1),2,44) + $gettok($rgb($1),3,44)) / (3 * 2.55)) }

; Création des listes de couleurs
alias -l droplist {
  if ($2 == $3-) { return -ac color $1 $3- }
  else { return -a color $1 $3- }
}

alias -l combolist {
  did [ $droplist(5,%deco.color2.sel,Blanc) ]
  did [ $droplist(5,%deco.color2.sel,Noir) ]
  did [ $droplist(5,%deco.color2.sel,Bleu foncé) ]
  did [ $droplist(5,%deco.color2.sel,Vert) ]
  did [ $droplist(5,%deco.color2.sel,Rouge) ]
  did [ $droplist(5,%deco.color2.sel,Marron) ]
  did [ $droplist(5,%deco.color2.sel,Violet) ]
  did [ $droplist(5,%deco.color2.sel,Orange) ]
  did [ $droplist(5,%deco.color2.sel,Jaune) ]
  did [ $droplist(5,%deco.color2.sel,Vert clair) ]
  did [ $droplist(5,%deco.color2.sel,Gris vert) ]
  did [ $droplist(5,%deco.color2.sel,Bleu clair) ]
  did [ $droplist(5,%deco.color2.sel,Bleu) ]
  did [ $droplist(5,%deco.color2.sel,Rose) ]
  did [ $droplist(5,%deco.color2.sel,Gris foncé) ]
  did [ $droplist(5,%deco.color2.sel,Gris clair) ]
  did [ $droplist(4,%deco.color1.sel,Blanc) ]
  did [ $droplist(4,%deco.color1.sel,Noir) ]
  did [ $droplist(4,%deco.color1.sel,Bleu foncé) ]
  did [ $droplist(4,%deco.color1.sel,Vert) ]
  did [ $droplist(4,%deco.color1.sel,Rouge) ] 
  did [ $droplist(4,%deco.color1.sel,Marron) ] 
  did [ $droplist(4,%deco.color1.sel,Violet) ]
  did [ $droplist(4,%deco.color1.sel,Orange) ]
  did [ $droplist(4,%deco.color1.sel,Jaune) ]
  did [ $droplist(4,%deco.color1.sel,Vert clair) ]
  did [ $droplist(4,%deco.color1.sel,Gris vert) ]
  did [ $droplist(4,%deco.color1.sel,Bleu clair) ]
  did [ $droplist(4,%deco.color1.sel,Bleu) ]
  did [ $droplist(4,%deco.color1.sel,Rose) ]
  did [ $droplist(4,%deco.color1.sel,Gris foncé) ]
  did [ $droplist(4,%deco.color1.sel,Gris clair) ]
}

; Fermeture du dialog
on *:dialog:color:close:*:{ window -c @Aperçu }

/*
Aide pour tester les couleurs
*/
alias coul {
  var %txt.white = 0
  var %txt.black = 1
  if ($bright($color(0)) < 50) { %txt.white = 1 | %txt.black = 0 }
  echo -ag  $+ $color(notify) $+ ???????????????????
  var %i = 0
  while (%i < 16) {
    var %txt.color = %txt.white | if ($bright($color(%i)) > 50) { %txt.color = %txt.black }
    var %l =  $+ %txt.color $+ , $+ [ %i ] $+ %deco.c [ $+ [ %i ] ] $+  $+ [ %i ] $+ , $+ [ %i ]
    while ($len(%l) < 40) { %l = %l $+ _ }
    echo -ag $wrap(%l, $window($active).font, $window($active).fontsize, 160, 0, 1)
    inc %i
  }
  echo -ag  $+ $color(notify) $+ ???????????????????
}

on *:load:{ echo -ag  $+ $color(notice) $+ » $+ $color(info) Script Couleurs/Décoration chargé, Ctrl+F4 pour la configuration. (Vous pouvez modifier l'alias à la ligne 8 du .mrc) }

on *:unload:{ unset %deco.*
  echo -ag  $+ $color(notice) $+ » $+ $color(info) Script Couleurs/Décoration déchargé.
}
