BEGIN { delete(sans);X="&"}
NF>1 { 
  if ($4=="PUNCT" || $1=="1") { 
    if (ok==ok) {
     #if (pp<2)
     #if (wc>2 && wc<20) {
        #print sent     
       #for (i in sans)  
       for (i=edpunct;i<=wc;i++)
        if (prins[i]<=wc && prins[i]>edpunct )
        if (rels[i]!="conj")
        if (rels[i]!="parataxis")
        #         print sans[i] i "/" sans[prins[i]]  prins[i] "/wc:" wc "  /P:" edpunct,"  ",rels[i]
        #else print "!!",   sans[i] i "/" sans[prins[i]]  prins[i]"!  " wc " /P:" edpunct,"  ",rels[i]       

        if (lkas[i]!="PUNCT")
         print rels[i] X lkas[i] X forms[i]   X lkas[prins[i]] X forms[prins[i]] X   perus[i] X perus[prins[i]] X   sans[i] X sans[prins[i]] X sent
        #print lkas[i] "," sans[i],forms[i] #perus[prins[i]] "," lkas[prins[i]] "," forms[prins[i]] "," perus[i] "," lkas[i] "," forms[i]       
        #print sans[i],sans[prins[i]],rels[i] "," perus[prins[i]] "," lkas[prins[i]] "," forms[prins[i]] "," perus[i] "," lkas[i] "," forms[i]       
       #print "\n"
     #}  
    } 
    
   #if ($1=="1")print sent "\n______________________________" 
   #  else print "---" edpunct ".." wc
   if ($1=="1")  { 
   sent=""
    delete(sans);delete(prins);delete(rels);delete(lkas);delete(forms);delete(perus)
    edpunct=0
    }else  edpunct=$1+1
    ok=1
    wc=0
    pp=0
    ei=0
  }  {
  
  if ($4!="VERB" && $8=="root") {ok=0;print >"outoroot"}  ##lauselmia ilman verbiä
  #if ($2==",") {ok=0;}  # monilauseisia virkkeitä
  if ($1==1) {
     toup=toupper($2)
     if (toup==$2  ){ ok=0} ##kaikki isolla.. näytelmisssä puhujatunniste 
     if (substr(toup,1,1)!=substr($2,1,1)) {ok=0}  # ei ala isolla kirjaimella.. joku väärin katkaistu lause
    
  }
  
 #if ($4=="ADJ") if (length($6)<2) print 
  # if (index($6,"Abbr")==1) {ok=0}
 if ($4=="PUNCT") pp=pp+1
  wc=$1  #wc+1
  sent=sent " " $2 wc #"_" $7
     #if ($7=="_") next;
   rels[$1]=$8
   if ($8=="_") rels[$1]="none"
   sans[$1]=$2
   perus[$1]=$3
   forms[$1]=$6
   prins[$1]=$7
   if ($3=="ei") ei=1
   #if ($4=="AUX")  lkas[$1]="VERB"   else ##muutetaan myöh
   lkas[$1]=$4
   ##print sans[$1],ok,wc,f,pp
  }
}
    
