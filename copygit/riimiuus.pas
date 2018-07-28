unit riimiuus;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,verbit,nominit,strutils,riimiutils;
const vahvatverbiluokat=[52..63,76];
const vahvatnominiluokat=[1..32,76];

type tlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;vikasana:word;end;
type tsis=record ekaav,vikaav:word;sis:string[8];vikasana:word;end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lisää viekä .takia - se josta etuvokaalit alkavat
type tsan=record san:string[15];akon:string[4];takavok:boolean;end;

type tsanasto=class(tobject)
 vcount,ncount:integer;
 lks:array[0..80] of tlka;
 siss:array[0..255] of tsis;
 avs:array[0..1200] of tav;
 sans:array[0..32767] of tsan;
 verbit:tverbit;
 nominit:tnominit;
 hakulista:tstringlist;
 //0-pohjasia, mutta data alkaa 1:stä
 procedure luesanat(fn:string);
 procedure listaa;
 procedure hae;
 function luohaku(fn:string):tstringlist;
 procedure etsiyks(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
 constructor create;
 end;

implementation
uses riimitys;

constructor tsanasto.create;
var i:word;h:thakunen;
begin
luesanat('sanatuus.csv');
verbit:=tverbit.create('sanatuus.csv','vmids.csv','vsijat.csv');
//verbit.listaasijat;exit;
nominit:=tnominit.create('nomsall.csv','nmids.csv');
//nominit.sanat:=sans^;
//nominit.listaa;
// nominit.siivoosijat;
 hae;
end;

procedure tsanasto.hae;
var i:word;
begin
   luohaku('haku.lst');
    for i:=0 to hakulista.count-1 do
    begin
        etsiyks(thakunen(hakulista.objects[i]),nil,nil);
    end;
end;
function tsanasto.luohaku(fn:string):tstringlist;
var //hakunen:tvhaku;
     ha,i,ohits,hs,hm,hakuluokka:integer;hakusana:string;
     hakunen:thakunen;
     aresulist,aresulist2,HAKULInes,uushAKUlista,ahaku:tstringlist;
     onjolist:tlist;
begin
   //exit;
   hakulista:=tstringlist.create; //tsanasto.hakulista
   hakulines:=tstringlist.create; //tmp
   ahaku:=tstringlist.create;
   hakulines.loADFROMFILE(fn);//'haku.lst');
    //!!!TEEhakulista(hakuset,HAKULISTA);
   //onjolist:=tlist.create;
   //for ha:=0 to length(hakuset)-1 do
   for hA:=0 TO hakuLInes.count-1 do
   begin
     //onjolist.clear;
     //if pos('isi',hakulista[ha])>0 then continue;
     if trim(hakulines[ha])='' then continue;
     ahaku.commatext:=hakulines[ha];
     hakusana:=ahaku[0];
     if hakusana='###' then break;
     if hakusana='' then continue;
     TRY HAKULUOKKA:=strtoint(ahaku[1]); except hakuluokka:=0;end;
     //writeln('<li><em style="color:#000">HAKU:',hakusana,ha,'/',hakulista.count,'</em> ');
     //teehaku(hakunen,hakusana,hakuluokka);
     haKUNEN:=THAKUNEN.CREATE;
     hakunen.akon:='';
     hakunen.lk:=hakuluokka;
     voksointu(hakusana,hakunen.eietu,hakunen.eitaka);
     hakunen.koko:=hakusana;
     while pos(hakusana[1],konsonantit)>0 do begin hakunen.akon:=hakusana[1]+hakunen.akon;
        delete(hakusana,1,1); end;
     hakunen.loppu:=taka(reversestring(hakusana));
     hakulista.addobject(hakusana,hakunen);
  end;
  result:=hakulista;
  hakulines.free;
end;



procedure tsanasto.luesanat(fn:string);
  var sl:tstringlist;ms:tsija;sanafile:textfile;sana:ansistring;
  i,j,k,l:word;differ:byte;
  prevsl:tstringlist;
  clka,csis,cav,csan,ulka:integer;
  prlim:word;
  procedure uusav;
    begin
      avs[cav].vikasana:=csan;
       //writeln('<li>','<b>av:',avs[cav].v,avs[cav].h,'</b>','..',csan, '   ',sl[2],sl[3],' :::',clka,'/',csis,'/',cav,'/',csan);
      cav:=cav+1;
      avs[cav].ekasana:=csan+1;
      avs[cav].takia:=0;  //takavokaalisten määrä  .. ei käytetä vielä
      avs[cav].v:=sl[2];
      avs[cav].h:=sl[3];
      if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"_" käytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
      else prlim:=0;
      //write(' >',avs[cav].v,avs[cav].h);
  end;
  procedure uussis;
    begin
    siss[csis].vikasana:=csan;
    siss[csis].vikaav:=cav;
    csis:=csis+1;
    siss[csis].ekaav:=cav+1;
    siss[csis].sis:=(sl[1]);
    prlim:=0;
    //writeln('</ul><li>SIS:<b>',siss[csis].sis,'</b> ',csis,' /sana',csan,'  /lka:<b>',clka,'/','</b> ',csan+19548,'<ul>');
  end;
  procedure uusluokka;
    var kot:integer;
    begin
    try
       lks[clka].vikasis:=csis;
       lks[clka].vikasana:=csan;
       clka:=clka+1;
       lks[clka].ekasis:=csis+1;
     try lks[clka].esim:=sl[7];except lks[clka].esim:='xxx';end;
     kot:=strtointdef(sl[0],99);//clka+51;
     lks[clka].kot:=kot;//clka+51;
     if (kot in vahvatverbiluokat+vahvatnominiluokat) then   lks[clka].vahva:=true else  lks[clka].vahva:=false;
     //writeln('</ul>-',csis,'<li>LKA <b>',kot,'</b>:',lks[clka].ekasis,'  ',sana,' //','::<b>',clka,'/',csis,'/',cav,'/',csan,'</b><ul>');
     prlim:=0;
    except writeln('faillka');end;
  end;
//tverbit.luesana
var alko:boolean;
begin
   prlim:=0;
   alko:=true;
  clka:=0;csis:=0;cav:=0;csan:=0;
  assign(sanafile,fn);//'verbsall.csv');
  reset(sanafile);
  sl:=tstringlist.create;
  prevsl:=tstringlist.create;
  prevsl.commatext:='1,x,v,h,0,x,x,x';
  {lks[0].vahva:=true;
  lks[0].ekasis:=0;
  siss[0].ekaav:=0;
  avs[0].ekasana:=0;}
  // tämmönenkin toimii:  for i in vahvatverbiluokat+vahvatnominiluokat do  writeln(i);
  while not eof(sanafile) do
  begin
     try
     readln(sanafile,sana);
     sl.commatext:=sana;
     ulka:=strtointdef(sl[0],0);
     //if ulka>58 then break;
     //if ulka<52 then continue;
     //if alko then begin prevsl.commatext:=sana;end;  //eka sana ei aloita luokkia
     differ:=4;
     if alko then differ:=0 else
     for i:=0 to sl.count-2 do if prevsl[i]<>sl[i] then begin differ:=i;break; end;
    if differ=3  then differ:=2;      // av-heikot erosivat mutta vahva oli sama. yhdistetään - AV ylipäätään oli eri
    if (differ<1) then uusluokka;
    if (differ<2) then  uussis;
    if (differ<4) then uusav;
     alko:=false;
         //if sl[4]='0' then avs[cav].takia:=csan+1; //pitäis olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
      csan:=csan+1;

    sans[csan].san:=(sl[5]);
    sans[csan].takavok:=sl[4]='0';
    sans[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten määrää av-luokassa hakujen tehostamiseksi
    //csan:=csan+1;
    alko:=false;
    prevsl.commatext:=sana;  //tähän taas seuraavaa sanaa verrataan
    prlim:=prlim+1;  //just for debug to make managable listings .. not used
    except writeln('failav');end;
   end;
    writeln('<h1>LKS:',CLKa,' /sis:',csis,' /av:',cav,' /w:',csan,'</h1>');
    for i:=0999 to clka do
    begin
       writeln('<li>',i,'<ul>');
       for j:=lks[i].ekasis to lks[i].vikasis  do
       begin
          writeln('<li>',j,':',siss[j].sis,'<ul>');
          for k:=siss[j].ekaav to siss[j].vikaav  do
          begin
             writeln('<li>',k,':',avs[k].av,avs[k].v,avs[k].h,'<ul>');
             writeln('<li>',avs[k].ekasana,sans[avs[k].ekasana].san,'',sans[avs[k].ekasana].akon,' ',avs[k].vikasana,sans[avs[k].vikasana].san,sans[avs[k].vikasana].akon);

              writeln('</ul>');
          end;

           writeln('</ul>');
       end;

       writeln('</ul>');
    end;
 end;
procedure tsanasto.listaa;
  function b(st:string):string;
    begin result:='<b>'+st+'</b>';end;
var lu,sis,av,san:Integer;myav,mysis,mymid:string;
curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;
begin
  writeln('<ul>');
  for lu:=0 to 78 do
  begin
    curlka:=lks[lu];
//    mymid:=lmmids[lu-1,1];
    writeln('<li>',lu,
    B(curlka.ESIM),' ',mymid,curlka.kot,' ',curlka.ekasis,'...',curlka.vikasis,' ',curlka.vikasana);
    writeln('<ul>');
   for  sis:=curlka.ekasis to curlka.vikasis do
   begin
     cursis:=siss[sis];
     mysis:=cursis.sis;
     //if lmmids[lu-1,1]='*' then begin mymid:=mysis[1]+'';end;// else    mymid:=lmmids[lu-1,1];
     writeln('<li>sis:',b(mysis+'.'),' ',cursis.ekaav,'...',cursis.vikaav,' ',cursis.vikasana);
     //if lu=1 then continue;
     writeln('<ul>');
    for av:=cursis.ekaav to cursis.vikaav do
    begin
      curav:=avs[av];
      if (lu+52<63) or (lu+52>76) then myav:=curav.v else  myav:=curav.h;
      writeln('<li>',b(curav.v+curav.h),' ',curav.ekasana,'...',curav.vikasana,' ',sans[curav.vikasana].san,sans[curav.vikasana].akon,' ',curav.vikasana);
      //for san:=curav.ekasana to curav.vikasana do writeln(' ',reversestring(mymid+mysis+''+myav+''+sanat[san].san+sanat[san].akon)+'a');
    end;
    writeln('</ul>');
   end;
   writeln('</ul>');
  end;
  writeln('</ul>');
end;


procedure tsanasto.etsiyks(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi:string;
    curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;//mysika:tsija;
    //cutvok,cutav:integer;
    //cut_si,cut_av,cut_lka,cut_san,i,j:integer;
    tc,hakutc:integer;
     d,hakueitaka,hakueietu,heikkomuoto,hit:boolean;
     siat,sikanum,lu:integer;sika:tsija;resst:string;
     //eatkon:boolean;
     isverb:boolean;
     vokvex,vokdbl,konvex,kondbl:boolean;
    //procedure checkhit(yht,sanax,hakux:string;sa:integer);
      function red(st:string):string;
        begin result:='<b style="color:red">'+st+'</b>';
        end;
      function blue(st:string):string;
        begin result:='<b style="color:blue">'+st+'</b>';
        end;
      function listsija(sika:tsija):string;
      begin
         with sika do  result:=' [['+inttostr(num)+' '+ name+' ('+esim+') '+inttostr(vparad)+' '+inttostr(hparad)+'):<b>'+ending+'</b>]] ';
      end;

      function sijanheikkous(isv:boolean;sika:integer):boolean;
      begin //huikko:=true
      result:=false;
      if isverb then
        if curlka.vahva then begin if  sika in vvahvanheikot then result:=true;end
        else  if  sika in vheikonheikot then result:=true;
      if not isverb then
        if curlka.vahva then begin if  not (sika in nvahvanvahvat) then result:=true;end  //vv hh
      else  if  sika in nheikonheikot then result:=true;
      //writeln('<li>heikko? ',
      end;

      procedure savehit(yht,sanax,hakux:string;sa:integer);
      var thishit:thit;sana,color:string;
      begin
        sana:=sans[sa].san;
        thishit:=thit.Create;
        with thishit.sana do
        begin
          alku:=cursan.san;
          akon:=cursan.akon;
          v:=curav.v;
          h:=curav.h;
          sis:=cursis.sis;
          luokka:=curlka.kot;
          if isverb  then  sloppu:=verbit.lmmids[luokka-52,0] else   sloppu:=nominit.lmmids[luokka,0];
          takvok:=not hakueitaka;
          sananum:=sa;   if d then writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
        end;
        //hitlist.add(thishit);
      end;

      procedure fullhit(sana,haku:string;sa:integer);
      var kokosana:string;
      begin
        try
        KOKOsana:=reversestring(sikasopi+lkasopi+''+sissopi+''+avsopi+''+sana+sans[sa].akon);
        if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       resst:=('<b style="color:green" title="'+inttostr(curlka.kot)+'#'+inttostr(sika.num)+'##'+inttostr(sa)+'">H:/'+KOKOSANA +'</b> '+inttostr(sa));
       if d then writeln(kokosana);
       hit:=true;
       except writeln('failfull');end;
      end;

      procedure shorthit(sana,haku:string;sa:integer);
      var epos:word;kokosana:string;
      begin
        epos:=length(sana)+1;
        kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon;
         if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       haku:=copy(haku,epos-1);
       if (sana<>'') and ((pos(haku[1],vokaalit)>0) and (pos(haku[2],vokaalit)>0) and  (isdifto(haku[2],haku[1]))) then   //if pos(kokosana[2],vokaalit)<1 then
       else //writeln('NOGO:',haku[1],kokosana[1], isdifto(haku[1],kokosana[1]))
       writeln('<b style="color:blue"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',
       reversestring(kokosana),'/</b>');//,sa,haku);
      end;


      procedure longhit(sana,haku:string;sa:integer);
      var epos:word;kokohaku,kokosana:string;i,tc:integer;olivok:string[2];
      begin
      kokohaku:=haku+''+avsopi+''+reversestring(sissopi)+''+reversestring(lkasopi)+''+reversestring(sikasopi);
      kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon;
      if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       epos:=length(haku)+1;
       haku:=copy(haku,epos);
       sana:=copy(sana,epos);
       try               // [u/]usi uusi: [u/]usi       [uo/]husi kuohusi:
       if  (sana<>'') and ((pos(sana[1],vokaalit)>0) and (pos(kokohaku[1],vokaalit)>0) and (isdifto(sana[1],kokohaku[1]))
       and (pos(kokohaku[2],vokaalit)<1))
        then writeln('<!--NOGO:',kokohaku,'?',sana,'-->')
       else
       begin
           tc:=1;//pitäis olla tavurajalla, eli tavu on aloitettu.. ei ei: saa uurtaa   -> RUU   aie he > ia   kapusta  ja -> SUPA
           olivok:=''; //
           for i:=1 to length(sana) do
           begin
             if pos(sana[i],vokaalit)<1 then //konsonantti
             begin
              if olivok<>'' then begin tc:=tc+1;olivok:='';end  //konsonanti vokaalin edellä
              else //kaksoiskonsonantti .. ei mitään
             end
             else //vokaali
             begin
               if olivok<>'' then  if isdifto(olivok[1],sana[i]) then begin tc:=tc+1;olivok:='';end;
               //else
                olivok:=sana[i];
             end;
           end;
           if not (sans[sa].takavok) then kokosana:=etu(kokosana);
           if (tc mod 2)= 0 then
           writeln('/<b style="color:#888"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',  reversestring(kokosana),'/</b>');//,sana,'%',tc,',');//,sa,haku);
       end;
       except writeln('FAIL:',kokohaku,'!');end;
      end;

      function sana_f(san:integer;koita,passed:string):boolean;
      var i,j:word;hakujatko,sana:string;yhtlen,slen,hlen:word;
      begin
      try
      cursan:=sans[san];
      sana:=cursan.san;
      if konvex then if curlka.kot=60 then  delete(sana,1,1);  //vain "lähteä" monikot läksin
       if hakueitaka then if cursan.takavok then exit;
       if hakueietu then if not cursan.takavok then exit;
      result:=false;
      //if xvok<>'' then if length(sana)>0 then delete(sana,1,1);//sana[1]:=xvok[1];
      //if xvok<>'' then writeln('<li>[**',xvok,'/',sana,']');
      if d then writeln('/S:',red(koita),blue(sana+cursan.akon));
      //if sana=koita then //if cursan.akon=hakunen.akon then
      if sana=koita then if cursan.akon=hakunen.akon then begin fullhit(sana,koita,san);end;
      ;//else if (sana='') or (pos(sana,koita)=1) then shorthit(sana,koita,san)
      //else if (koita='') or (pos(koita,sana)=1) then longhit(sana,koita,san)
      //else if cursan.san='' then}
      //writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
      //reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);
       except writeln('!');//,san,'/',curlka.kot);
       end;
      end;

      function av_f(av:integer;koita,passed:string):boolean;
      var san,i,j:integer;myav:string;
      begin
        curav:=avs[av];
        result:=false;;
        myav:=ifs(heikkomuoto,curav.h,curav.v);
        if d then
         writeln('<li>{',myav,'}',curav.v,curav.h,konvex,red(koita));//+xvok),blue(myav),' :',curav.v,curav.h,'/',curav.ekasana,'-',curav.vikasana);
        //if d then writeln('<li>(',myav,'=',curav.v+'/',curav.h,'\',konvex,')',red(koita),blue(myav),'/hm:',heikkomuoto,'/ver:',isverb,'/vah:',curlka.vahva);
        if konvex then if myav<>'' then begin delete(myav,1,1);end;
        if koita='' then begin result:=true;avsopi:=myav;avjatko:=koita;if d then writeln('<li>AVX:',red(koita),blue(myav)) end else
        begin
          if (myav='') or (pos(myav,koita)=1)  then result:=true
          else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
                end;
          avjatko:=copy(koita,length(myav)+1,99);//xvok;
          avsopi:=copy(koita,1,length(myav));//xvok;
        end;
        //avsopi:=myav;

          if d then writeln('/AV:',red(avjatko),blue(avsopi),' ',curav.ekasana,'..',curav.vikasana);
          try
          //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
          for san:=curav.ekasana to curav.vikasana do //!!!
                sana_f(san,avjatko,passed);
        except writeln('faILAV!!!');end;
      end;
      function sis_f(sis:integer;koita,passed:string):boolean;

      var av,i,j:integer;mysis:string;
      begin
        cursis:=siss[sis];
        mysis:=cursis.sis;

        if vokdbl then if mysis='' then mysis:='ii' else MYSIS:=MYSIS[1]+MYSIS;  //loppuii vierasp sanoissa lka 5
        if d then writeln('<li>sisu:',red(koita),'/',blue(mysis+'!'),vokvex,'/',cursis.ekaav,'-',cursis.vikaav,vokdbl);
        //writeln('<li> ', curlka.kot,' ',sis,cursis.sis,'#',cursis.ekaav,'-',cursis.vikaav);
        if koita='' then BEGIN sisjatko:=koita+mysis; sissopi:='';END
        ELSE
        begin
          //while (cut>0) and (mysis<>'') {and(koita<>'')} do
          if vokvex then
          begin if d then write('<li>?/',koita,'/',mysis,vokvex);
           if curlka.kot=64 then
            delete(mysis,2,1) else delete(mysis,1,1);
            //delete(mysis,1,1);
          END;
          //if cutvok=2 then  begin mysis:=mysis[1];END;

          result:=false;;
          if (mysis='') or (pos(mysis,koita)=1) then result:=true
          else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
          end;
          sisjatko:=copy(koita,length(mysis)+1,99);
          sissopi:=copy(koita,1,length(mysis));
          //sissopi:=mysis;
        END;
         if d then writeln('<li>Sisu:',red(koita),'/',blue(mysis+'!'),vokvex);
         if  d then   write('<b>/',sisjatko,'|',sissopi,'\</b>');
          //if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
          if d then writeln('<ul>');
        for av:=cursis.ekaav to cursis.vikaav do
         av_f(av,sisjatko,passed);
          if d then writeln('</ul>');

      end;
      function lka_f(lka,sija:integer;koita,passed:string):boolean;  //vain verbille
      var sisus,i,j:integer;luokka:word;mid:string;repeats:integer;
      begin
        //if lka<>60 then exit;
        curlka:=lks[lka];
        isverb:=lka>51;
        repeats:=1;
        //if curlka.kot<>62 then exit;
        if isverb then
        begin
          if lu=68 then repeats:=2;  //kaikilla 68'illa on kaksi taivutustapaa
          if (lu in [55,57,60]) then if sika.vparad=6 then repeats:=2;
          if (lu in [76]) then if sika.vparad=5 then repeats:=2;
          if (lu in [74,75]) then if sika.vparad=9 then repeats:=2;
        end;
       repeat
        if isverb then
          mid:=verbit.lmmids[lka-52,sija] else
          mid:=nominit.lmmids[lka,sija];
         if mid='!' then exit;
        //dbl:=false;    eatkon:=false;

        vokvex:=false;vokdbl:=false;konvex:=false;kondbl:=false;
        //if curlka.vahva then para:=sika.vparad else para:=mysika.hparad ;
        if d then writeln('<li>TRY:',lka,'#',sija,' <b>[',repeats,mid,'/',ifs(isverb,verbit.lmmids[lka-52,sija],nominit.lmmids[lka,sija]), '] </b>',curlka.kot,'!',isverb);
        if (lu=71) then { if ((sika.hparad=2) and  (sija>10)) then
        begin IF D THEN writeln('<li>!!!???');//mid:='k'
        end else    }
          if  (sija in [23,28]) then begin IF D THEN writeln('!!!');mid:='k'; end;
        //aint it pretty?
        if isverb then
        begin
        if lu=68 then if repeats=2 then begin mid:=verbit.lmmids[10,sija];end;
        if repeats=2 then if lu=55 then if sika.vparad=6 then  begin mid:='';end; //soutaa sousi
        if repeats=2 then if lu=57 then if sika.vparad=6 then  begin mid:='o';end; //kaatoi kaasi
        if repeats=2 then if lu=60 then if sika.vparad=6 then  begin mid:='sk';konvex:=true;end; //huom vain luokan 60  - vain "läksin läksit"
        if repeats=2 then if lu=76 then if sika.vparad=5 then  begin mid:='*nn';;end;  //tiennen, tainnen
        if repeats=2 then if lu in [74,75] then if sika.vparad=9 then  begin mid:='';end; //katketa nimetä katkeisi/katkeaisi
        end;
        //if lu=71 then if (sija in [23,28]) then mid:='-k';
        repeats:=repeats-1;
        result:=false;
        //cutav:=0;cutvok:=0;xvok:='';
       // if mid<>'' then
       // case mid[1] of
       //  '*': dbl
        if (mid<>'') and (mid[1]='*') then
           if lu=67 then begin delete(koita,1,1);delete(mid,1,1);kondbl:=true;end
           else begin delete(mid,1,1);konvex:=true;end;

        if (mid<>'') and (mid[1]='_') then begin if d then write('????',mid);vokdbl:=true;delete(mid,1,1);end;
        if (mid<>'') and (length(koita)>0) and (mid[1]='-') then
         begin vokvex:=true;delete(mid,1,1);delete(koita,1,0);; end;
         //av-konsonanttia ei vaadita kun on joku vakkari (s) tilalla
        if d then writeln('<li>DOTRY:',vokvex,lka,curlka.esim,' #',sija,'<b>(mid:',blue(mid),')/',//lmmids[lka,sija],
          '/</b>'    ,ifs(curlka.vahva,'v:'+inttostr(sika.vparad),'h'+inttostr(sika.vparad)),'=',' koita:',red(koita),' / ', blue(mid),vokvex,vokdbl,konvex,kondbl,'///',curlka.ekasis,'-',curlka.vikasis,'::',repeats,'</li>');
        //exit;
        if (mid='') or (koita='') OR (pos(mid,koita)=1) then result:=true
        else
        begin
             //62naida a / -12-12:: /ei:a-
           if pos(koita,mid)=1 then if d then writeln('//EOW:',koita,mid);   if d then write('/ei:',blue(koita),red(mid));
           continue;
        end;
        if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
        //if pos(koita,mid)=1 then writeln('//EOW:',koita,mid);
        lkajatko:=copy(koita,length(mid)+1,99);
        lkasopi:=copy(koita,1,length(mid));
        //lkasopi:=mid;

        heikkomuoto:=sijanheikkous(isverb,sija);
        if d then   writeln('<li>LK:',lka,red(lkajatko),' / ', blue(lkasopi), curlka.ekasis,'-',curlka.vikasis,koita,'(',mid,')',heikkomuoto,sija,'</li>');
        //if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('!\',siss[sisus].sis);
        if d then   writeln('<ul>');
        for sisus:=curlka.ekasis to curlka.vikasis do
         sis_f(sisus,lkajatko,passed);
        if d then writeln('</ul>');
       until repeats<=0;
      end;
// tverbit.etsi(
type psika=^tsija;
var sikalauma:tstringlist;passed:string;i,j:word; sikap:psika;
begin
try
    //vhitlist.clear;
     d:=false;
     //d:=true;
     sikalauma:=tstringlist.create;

     try
     sikalauma.clear;
     //if isverb then verbit.haesijat(hakunen.loppu,sikalauma)
     //else


     //nominit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden pääte mätsää hakusanaan
     verbit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden pääte mätsää hakusanaan

     //if d then     for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),nominit.sijat[ptrint(sikalauma.objects[siat])].ending);
     //if d then   writeln('<li>hae:',hakunen.akon,'|<b>',string(hakunen.koko),'</b>:',sikalauma.count);//,'<ul></li>');
     except writeln('faildosiat');end;
     resst:='';
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
        //sika:=(sikalauma.objects[siat]^);
        //sikap:=psika(sikalauma.objects[siat]);
       sika:=psika(sikalauma.objects[siat])^;
        sikanum:=sika.num;
        //sikanum:=ptrint(sikalauma.objects[siat]);
        //if sikanum<>0 then continue;
        //if hakunen.isverb then sika:=verbit.sijat[sikanum] else     sika:=nominit.sijat[sikanum];
        sikaloppu:= copy(hakunen.loppu,length(sikalauma[siat])+1);
        if sikaloppu='' then begin continue;passed:=copy(sika.ending,1,length(hakunen.loppu));
           sikasopi:=copy(sika.ending,length(hakunen.loppu),999);writeln('<li>HAKLO:',passed,'/',hakunen.loppu,'/',sikasopi);end
        ;//else continue;
        sikasopi:=sika.ending;//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        //writeln('<li>ss:',sikasopi);
        hakutc:=tavucount(hakunen.koko);
        //if d then
        //writeln('<li>muoto:',reversestring(sikaloppu),'|',reversestring(sikasopi),' //<b>',reversestring(sika.ending),'#</b>',sika.num,'! ',hakunen.koko,hakutc);
        hakutc:=hakutc mod 2;
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        if d then writeln('<li>HAKUNEN:',hakunen.lk,'#',sika.num,'><b>',hakunen.akon,reversestring(sika.ending+'.'+sikaloppu),'</b> {',listsija(sika),'} ');
        //continue;
        if d then writeln('<ul>');

        //exit;
        if sika.onverbi then begin for lu:=52 to 78 do lka_f(lu,sikanum,sikaloppu,passed);end
        else begin for lu:=1 to 50 do lka_f(lu,sikanum,sikaloppu,passed);end;
//4 do
         //???? if (hakunen.lk=0) or (hakunen.lk=lu) then
         //if lu=48 then
          //lka_f(lu,sikanum,sikaloppu,passed);

        if d then writeln('</ul>');
     end;
     if resst='' then
       writeln('<li>Eiei::',hakunen.koko,' :</li>');//,hakunen.lk,' #',sika.num,'><b>',listsija(sika),'</b> ',sikaloppu,'/ea:',hakueitaka,'/eä',hakueietu,'</li>');
     if d then writeln('</ul>');

except writeln('<li>failetsi');end;

end; //etsi
end.

