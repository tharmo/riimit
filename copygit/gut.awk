function gadj(ana) {
 ana="xxxxxxxxxx" ana
  return "A_" substr(ana,match(ana,"Case=")+5,3) "_" substr(ana,match(ana,"Degree=")+7,3) "_" substr(ana,match(ana,"Case=")+5,3)
}
function gv(ana) {
  #ana="xxxxxxxxxx" ana
  #return "V_" substr(ana,match(ana,"Form=")+5,3) "_" substr(ana,match(ana,"Mood=")+5,3)
  #return "V_" substr(ana,match(ana,"Form=")+5,3) "_" substr(ana,match(ana,"Mood=")+5,3) "_" substr(ana,match(ana,"Case=")+5,3)
}
function gn(ana) {
  return "_" substr(ana,match(ana,"Case=")+5,3)
}
  
function turha(ana) {
  res=""
  n=split(ana,clas,"[|=]")
  if (n>1 && n %2==1) print ana >"errors.log"
  for (i=0;i*2<n;i++) { 
    #if (index("Mxood Cxase VerbForm Vxoice Dxegree", clas[2*i+1])>0)
    if (index(clas[2*i+1],"Form")>0)
     { res=res "/" clas[2*i+2]}
   }
   return res 
 }


#$4=="NOUN" {if (index($6,"Form=Fin")>100) next; an=gv("xxxxxxxxx" $6);if (length(an)>1) print an ; next}
#$4=="VERB" {if ($3!="ei") if (index($6,"Form=Fin")>100) next; an=gv("xxxxxxxxx" $6);if (length(an)>1) print an ; next}
#$4=="VERB" {if ($3!="ei") if (index($6,"Form=Fin")>100) next; an=gv("xxxxxxxxx" $6);if (length(an)>1) print an  "             " $2 $3"   " $6; next}
#{next}
BEGIN { delete(sans)}
#NF==0 { print "xxxxxxxxxxxxxxxx";next}
NF>1 { 
  if ($1=="1") { ok=1
    if (ok) {
     if (pp<2)
     if (wc>3 && wc<13) {
       # print pp,sent,length(sans),sans[1],ok 
        #print sent     
        if (1==2)
         for (wo in sans) {
            delete(mods)
             for (mo in sans) 
               if (prins[mo]==wo) 
                 mods[mo]=sans[mo] 
             if (length(mods)>0) {
             s=sans[wo] ": ";
             for (mo in mods) s=s " " mods[mo]
             print s    
           }   
        }
        for (i in sans)  print lkas[prins[i]] "/" lkas[i]  "         ///    "   sans[prins[i]]  "_"   sans[i]     
   
       print "\n"
     }  
    } 
    delete(sans);delete(prins);delete(rels);delete(lkas);delete(forms)
    sent=""
    ok=1
    wc=0
    pp=0
  }  {
  
  if ($4!="VERB" && $8=="root") {ok=0;print >"outoroot"}  ##lauselmia ilman verbiä
  if ($2==",") {ok=0;}  # monilauseisia virkkeitä
  if (wc==1) {
     toup=toupper($2)
     if (toup==$2  ){ ok=0} ##kaikki isolla.. näytelmisssä puhujatunniste 
     if (substr(toup,1,1)!=substr($2,1,1)) {ok=0}  # ei ala isolla kirjaimella.. joku väärin katkaistu lause
    
  }
  wc=wc+1
  sent=sent " " $2 
  if (1=0)
  if ($3=="ei") f="EI_" gv($6) 
  else switch($4) {
    case "VERB" : f=gv($6);break
    case "NOUN" : f="N" gn($6);break
    case "PROPN" : f="N" gn($6);break
    case "PRON" : f="P" gn($6);break
    case "ADV" : f="a";break
    case "ADJ" : f="A" gn($6) ;break
    case "PUNCT" : f="p";pp=pp+1;break
    default: f=$4   ;break
   
   }
   #if ($7=="_") next;
   if ($8=="_") rels[$1]="none"
   rels[$1]=$8
   sans[$1]=$2
   forms[$1]=$6
   prins[$1]=$7
   lkas[$1]=f
   ##print sans[$1],ok,wc,f,pp
  }
}
    


        BEGIN {sis="\n      "
       x="advcl,advmod,amod,appos,aux,case,cc,ccomp,clf,compound,conj,cop,csubj,dep,det,discourse,dislocated,expl,fixed,flat,goeswith,iobj,list,mark,nmod,nsubj,nummod,obj,obl,orphan,parataxis,punct,reparandum,root,vocative,xcomp"
       split(x,xx,",")
       for (i in xx) print xx[i]
       }
      { 
       #f ($8=="amod" && $6=="_" && $4=="ADJ") if (index(onjo,$2)<1) {onjo=onjo " " $2;print $0, index(onjo,$2)}; next       
       if (NF==0 || $2==".") {  # LAUSE LOPPUU
        if (ok) 
         #   print "\n" para wc" :::: "  expl ##>"simples.wrd";
         if (length(para)>10) 
          if (wc<7 && wc>2) 
           #if (N!=0 && V>0)
           #if (index(expl,"ccomp")>0)
           { ok=1;
            #print  para
            #print "     #" expl
            #print "\n" para  ": "  expl ##>"simples.wrd";
            #print "\n" para  ": "  expl ##>"simples.wrd";
            for (i in sans)
             if (exs[i]=="xcomp" && forms[i]!="VERB")            
             print "    " sans[i], sans[refs[i]] "        (" exs[i],  forms[i],"  " exs[refs[i]] forms[refs[i]] ")"
            #for (i in sans) {if (index(exs[i],"nmod")>0) {ok=1; para=para "\n    " i exs[i] "   /   " refs[i] "     " sans[i] " " sans[refs[i]]            }} 
            #if (ok) print "\n\n" para 
            # wc " :::: "  expl ##>"simples.wrd";
            
            }
        expl="";
        para="";
        ok=1;
        wc=0;
        frs="";
        N=0;K=0
        V=0
        delete(sans);delete(refs);delete(exs)
        delete(forms)
        next
        } # LAUSE JATKUU
       #if ($8=="det" && $4=="NOUN") {ok=1;print}
       # skipataan muut kuin yksinkertaiset lauseet
       #if ($8=="nmod") {ok=1;para=para "XXX"}
       #if (wc==0 && toupper($2)==$2)  { ok=0;next}
       if ($4=="PUNCTxxx" || $2=="jax" ) { 
         ok=0;
         para="";
         frs="";
         expl="";
         wc=0 
         next;
        } 
        else {
         #if (ok==FALSE) next
         #if (wc==0 && $4=="CONJ") next   ##lauseen eka mutta ja jos skipataan
         #if ("CONJ") ok=0  ##lauseen eka mutta ja jos skipataan
         #expl=expl "\n  " #$1 "-" $7 " :" 
         sans[$1]=$2;exs[$1]=$8;refs[$1]=$7;forms[$1]=$4
         para=para " "$1 $2 $7"/" $8;wc=wc+1
         #next;   
         if (index("NOUN PROPN",$4)>0) { expl=expl ",NOUN_" $6 " **"  $8 "**" sis
         } else  if (index("VERB AxDJ",$4)>0) {
           #if ($7=="amod" && index("aika,ensi,eri,koko,kelpo,melko,pikku,toissa,tosi,viime",$3)<1) {ok=0;next}
            expl=ind expl "," $4 "_" $6 " "  $8 sis
         } else 
           if (index("PRON AUX",$4)>0) { expl=expl ","  $4 "_"  $3 "_" $6 " "  $8 sis
         } else  
         if (index("ADV",$4)>0) { #expl=expl ",ADV"
         } else expl=expl "," $4 "_" $2
         
         #if (index("NOUN PROPN VERB ADJ",$4)>0) { exs[$1]=$4 "_" $6 "#"$8
         #} else if (index("PRON AUX",$4)>0) { exs[$1]=  $4 "_"  $3 "_" $6 "#"$8
         #} else exs[$1]=$4 " " $2 "#"$8
         #para=para " " $2;frs=frs  "        "   $4 " " $6 " " $3  " " $8
         wc=wc+1
         if ($4=="VERB") if ($3!="ei") V=V+1
         if (index("NOUN PROPN PRON",$4)>0) N=N+1
         #if (index($4,"CONJ")>0) K=K+1
         if ($4=="CONJ") K=K+1
          
        }
      
      }
      
1|N_xxx_Tra
1|N_xxx_xxx
2|N_xxx_Ine
2|N_xxx_Ins
2|P_xxx_Ine
2|V_xxx_Ine
2|V_xxx_Ins
3|N_xxx_Abe
3|N_xxx_Ade
3|N_xxx_Ela
3|N_xxx_Ill
3|N_xxx_Ine
3|N_xxx_Ins
Agt_xxx_Abe
Agt_xxx_Abl
Agt_xxx_Ade
Agt_xxx_All
Agt_xxx_Com
Agt_xxx_Ela
Agt_xxx_Ess
Agt_xxx_Gen
Agt_xxx_Ill
Agt_xxx_Ine
Agt_xxx_Ins
Agt_xxx_Nom
Agt_xxx_Par
Agt_xxx_Tra
Fin_Cnd_xxx
Fin_Imp_xxx
Fin_Ind_xxx
Fin_Pot_xxx
Fin_xxx_xxx
Neg_xxx_Abl
Neg_xxx_Ade
Neg_xxx_All
Neg_xxx_Com
Neg_xxx_Ela
Neg_xxx_Ess
Neg_xxx_Gen
Neg_xxx_Ill
Neg_xxx_Ine
Neg_xxx_Nom
Neg_xxx_Par
Neg_xxx_Tra
Pas_xxx_Abe
Pas_xxx_Abl
Pas_xxx_Ade
Pas_xxx_All
Pas_xxx_Com
Pas_xxx_Ela
Pas_xxx_Ess
Pas_xxx_Gen
Pas_xxx_Ill
Pas_xxx_Ine
Pas_xxx_Ins
Pas_xxx_Nom
Pas_xxx_Par
Pas_xxx_Tra
Pre_xxx_Abe
Pre_xxx_Abl
Pre_xxx_Ade
Pre_xxx_All
Pre_xxx_Com
Pre_xxx_Ela
Pre_xxx_Ess
Pre_xxx_Gen
Pre_xxx_Ill
Pre_xxx_Ine
Pre_xxx_Ins
Pre_xxx_Nom
Pre_xxx_Par
Pre_xxx_Tra
xxx_xxx_Ade
xxx_xxx_All
xxx_xxx_Ela
xxx_xxx_Ess
xxx_xxx_Gen
xxx_xxx_Ill
xxx_xxx_Ine
xxx_xxx_Ins
xxx_xxx_Nom
xxx_xxx_Par
xxx_xxx_Tra
xxx_xxx_xxx
    case "VERB" : f=gv($6);break
    case "NOUN" : f="N" #  substr($6,match($6,"Case=")+5,3);break
    case "PROPN" : f="N" substr($6,match($6,"Case=")+5,3);break
    case "PRON" : f="P" #substr($6,match($6,"Case=")+5,3);break
    case "ADV" : f="a";break
    case "ADJ" : f="A"gadj($6);break
    case "PUNCT" : f="p";pp=pp+1;break
    default: f=$4   ;break
