  # reading klk_siivo3.srt.iso
  #BEGIN { getline"klk_lemmas.hits";getline"klk_lemmas.hits";getline"klk_lemmas.hits";getline"klk_lemmas.hits";print $0 "start----------"}
 { 
        tries=tries " " v1
        #if ($1 > nexthit) { print "***********" $1, "///", nexthit; }
           v1=$1;  v2=$2
       if ($1==thishit) print $2 ,lemma , $1, $3 > "hits.tmp"
       else if ($1==nexthit || nexthit=="") {  ##uusi slemma
             #print tries,"###",nexthit,
             tries=""
             thishit=nexthit
             while (1) {
                getline< "klk_lemmas.hits"  
                 #print  ">>>>>>>>>> " $1
                 nexthit=$1
                 plemma=lemma
                 lemma=$2
                  
                #if (plemma!=lemma)print plemma "/",lemma"++++" $1,"!!",thishit,"",nexthit
                 
                 break
              }
        }        
    
  }  
##klk_siivo2.iso ei ole oikein sortattu ...aamupäiwään ennen aamupöio
#export LC_ALL=C;export LC_COLLATE=fi_FI.ISO-8859-1;head -28000 klk_siivo2.iso |sort -f >klk_siivo3.srt.iso
