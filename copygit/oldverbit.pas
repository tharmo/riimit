unit oldverbit;
interface
uses
  Classes, SysUtils,strutils,nomutils,math;

{$mode objfpc}{$H+}
type tverlka=record kot,ekasis,vikasis:word;vahva:boolean;end;
type tversis=record ekaav,vikaav:word;sis:string[8];end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tverav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lisää viekä .takia - se josta etuvokaalit alkavat
type tvsana=record san:string[15];akon:string[3];takavok:boolean;end;
type tsija=record
  vv,hv:boolean;
  num,vparad,hparad:byte;
  vmuomids,hmuomids:array[1..12] of byte;
  ending:string[15];

end;

type tvhaku=record hakunen:string[15];sija:byte;takavok:boolean;end;
type tvhakuset=array of tvhaku;


  //var protomids:array[0..11] of string[15];
//type tsana=array[0..15] of ansichar;//record letters:array[0..16] of ansichar;end;
//  sis:75 av:399 /w:9368
type ztverbit=class(tobject)
    //lmmids:array[0..49] of array[0..24] of array[0..8] oF ANSICHAR;  //would this be more efficient?
    lmmids:array[0..49] of array[0..65] of string[15];
    protomids:array[0..49] of array[0..11] of string[15];
     // lk:60 lv:130 av:683
     lkat,lktot,latot,avtot,taivluokkia:word;
     //sijat:array[0..49] of array[0..75] of string[8];
     sijat:array[0..65] of tsija;
     lUOKS:array[0..27] of tverlka; //78-52+1:+1 varalla
     sisS:array[0..127] of tversis;
     AVS:array[0..1023] of tverav;
     //VOKS:array[0..160] of tverlvok;
     //sanat:array[0..27816] of tsana;
     sanat:array[0..16383] of tvsana;
     hakuset:tvhakuset;//array of tvhaku;
     //soinnut:array[0..30000] of boolean;
    //procedure etsi;
    //procedure haesijat(haku:ansistring;sikalauma:tstringlist);
    //procedure luemuodot(muotofile:string);
    //procedure lataasanat(lfile:string);
    procedure etsi;
    procedure uusetsi;
    procedure listaasijat;
    procedure luesanat;
    procedure listaasanat;
    procedure luesijat;
    procedure luemids;
    constructor create;
    procedure createsija(si:integer;ss:ansistring);
    procedure haeverbihaku(var hakusetti:tvhakuset;hakufile:string);
    procedure haesijat(haku:ansistring;sikalauma:tstringlist);
end;

const VprotoLOPut:array[0..11] of ansistring =('a','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme');
const
vHEIKOTSIJAT =[5,6,7,8,9,10,13,14,15,24,25,26,27,29,30,31,32,33,34,35,36];
//VVAHVAT: ,0,1,2,3,4,11,12,16,17,18,19,20,21,22,23,28,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65
hHEIKOTSIJAT=[0,1,2,3,4,13,14,15,16,17,18,19,20,21,22,29,30,31,32,33,34,35,36,37,38,62,63,64,65];


implementation

constructor tverbit.create;
begin
writeln('luemids');
luemids;
writeln('luettu,luesijat');
writeln('lue');
luesijat;
writeln('luettu,listaa');
//listaasijat;
writeln('listattu');
 luesanat;
 writeln('<hr>etsi<hr>');
  uusetsi;
//  writeln('<hr>listaakaikki<hr>');
//   listaasanat;
  writeln('<hr>listaSkaikki<hr>');
end;
procedure tverbit.haesijat(haku:ansistring;sikalauma:tstringlist);
var i,lk,hitpos:integer;mylop:ansistring;j:ptrint;a:ansichar;
begin
 // KAIKKI ON JO REVERSOITU

for j:=0 to 65 do
 begin
    mylop:=sijat[j].ending; ////VERBEISSA EI loppupäätteissä toistoja kuten nominien illatiivissä
    if mylop='' then hitpos:=1 else
    //if matchendvar(haku,mylop,alku) then  //EIIKÄ TÄTÄ KUN KAIKKI ON KÄÄNNETTU
    hitpos :=POS(mylop,haku);
    //writeln(' [',haku+' !',mylop, hitpos,'] ');
    if hitpos=1 then  //EIIKÄ TÄTÄ KUN KAIKKI ON KÄÄNNETTU
   begin
    sikalauma.addobject(copy(haku,length(mylop)+1),tobject(j));//@sijat[j]));  //TEMPPUILUA, NUMERO PANNAAN OBJEKTIPOINTTERIIN
    //writeln('+++',j);
   end;
 end;
end;

procedure tsekkaa(haku:ansistring;etuko:boolean;hits,riimit:tstringlist);
var   hittavut,tofindtavut:tstringlist; etuhit:boolean;
i,tavucount:integer;
hitw:ansistring;
begin
  hittavut:=tstringlist.create;
  tofindtavut:=tstringlist.create;
  hyphenfi(haku,tofindTAVUT);
  writeln('<li>tutkitavut:',haku,'|||',hits.commatext,hits.count,'</li>');
  //writeln('<li>tutkittavat:',haku,'|||',hits.commatext,hits.count);
  tavucount:=tofindtavut.count;
  for i:=0 to hits.count-1 do
  begin
      hitw:=hits[i];//(trim(copy(hits[i],1)));
      hyphenfi(hitw,hittavut);   //tavus pitäis olla käänt.järj. ja pakattuina ttavuiksi. myöhemmin
      write('?<li>haku:',haku,'/kohde:',hitw,'#', hittavut.count,tavucount,'-' );
      if abs(hittavut.count-tavucount) mod 2=0 then
      begin
        writeln('/tav?',hittavut.count,hittavut.commatext,tofindtavut.count,tofindtavut.commatext);
        if  matchtavut(hittavut,tofindtavut) then
        begin
          //if etuhit then hitw:=etu(hitw);
          riimit.add(hitw);
          hittavut.clear;
          writeln('++',hitw);
        end;// else writeln('!!!!!!!!!!!!',etuhit,etuko);
      end ;// else writeln('<strike>::',hittavut.commatext,'</strike>')
    end;
  hittavut.free;tofindtavut.free;
end;
procedure TVERBIT.etsi;
var
 i,j,ha,lu,siat,sisus,sikanum,av,sa:integer;
 sss,haku:ANSIstring;
 sika:tsija;
 l_sija,l_lu,l_sis,l_av,l_san:string;
 myav,a_sija,a_lu,a_sis,a_av,a_san:string;
 cut,lkcut:WORD;
 //xhakusanat,
  sikalauma, riimit,resu,allresus:tstringlist;
 vahvako,takako,xkon:boolean;
 eka,vika:integer;
  //string[15];

  function muotosopii(anas,uppol:ansistring;var tamaj,tamahit:ansistring;vAR cut:word):boolean;
  begin
   result:=false;
   cut:=0;
   xkon:=false;
   if lu+52=67 then writeln('<li>#x#',anas,'|',uppol,'=',tamaj,result,'(',uppol,'/',pos('*',uppol),')');
   while (uppol<>'') and (pos('-',uppol)=length(uppol)) do
   begin cut:=cut+1;
       delete(uppol,length(uppol),1);
       //delete(anas,1,1);
    end;
   if pos('*',uppol)>0 then if pos(anas[1],konsonantit)>0 then
   begin
       //uppol[length(
       xkon:=true;
       uppol:=anas[1];
      //xkon:=anas[1];
      // delete(uppol,1,1);
      // delete(anas,1,1);

       writeln('asterisk:',anas,'#',uppol,lu+52,anas[1]);
    end;

   if anas='' then
   begin
    writeln('<li>lyhythit:',lu,' ',sa);
    //resu.add(tamaj+'..');
    result:=true;tamahit:='';
    exit;
   end;
   tamaj:='';
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    tamaj:=copy(anas,length(trim(uppol))+1);
    tamahit:=trim(uppol);
   end;
   if lu=11 then writeln('<li> #X:',anas,'|',uppol,'=',tamaj,result,pos(uppol,anas),'/cut;',cut);
  end;

  function sopii(anas,uppol:string;var alku,loppu:string;cut:word):boolean;
  begin
   //loppu reversoitu, mikä ei kai hyvä ...
   // alku = pala joka todetaan sopivaksi ja poistetaan hausta , loppu= jäljelle jäävä (sanan alku, kun reversoitu).
   result:=false;
   if lu=11 then writeln('<li> #X:',anas,'|',uppol,'/cut;',cut);
   WHILE (uppol<>'') AND (cut>0) do BEGIN delete(uppol,1,1);cut:=cut-1;END;
   if lu=11 then writeln('<li> #X:',anas,'|',uppol,'=',pos(uppol,anas),'/cut;',cut);
   if anas='' then
   begin
    writeln('<li>lyhythit:',lu,' ',sa);
    //resu.add(tamaj+'..');
    result:=true;
    exit;
   end;
   alku:='';
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    loppu:=copy(anas,length(trim(uppol))+1);
    alku:=uppol;
   end;
   if lu=11 then writeln('<li> #X:',anas,'|',uppol,'=alku:',alku,'+loppu:',loppu,result,'/cut;',cut);
  end;
begin
writeln('</ul></ul></ul></ul>HAKUSIA:');
   //hakusanat:=tstringlist.create;
   sikalauma:=tstringlist.create;
   allresus:=tstringlist.create;  //haikkien hakujen riimit
   resu:=tstringlist.create;       //yhden haun mahd. rmiit
   riimit:=tstringlist.create;     //yhten haun tsekatut viimit
   //haehaku(hakusanat,'haku.lst');
   haeverbihaku(hakuset,'haku.lst');
   // exit;
   //lu:=0;ko:=0;vo:=0;av:=0;
   riimit:=tstringlist.create;
   //writeln('<h4>ETSI:',hakusanat.commatext,'</h4><UL>');
   for ha:=0 to length(hakuset)-1 do writeln('<li>HAKUNEN;',hakuset[ha].hakunen,'!</li>');
   //exit;
   for ha:=0 to length(hakuset)-1 do //hakusanat.count-1 do //yksi hakusana koko listasta
   begin
    //haku:=reversestring(hakusanat[ha]);
    //haku:=reversestring(hakusanat[ha]);
    resu.clear;
     haku:=reversestring(hakuset[ha].hakunen);
     takako:=hakuset[ha].takavok;
     writeln('<li>etsisiat:',haku);
     sikalauma.clear;
     haesijat(haku,sikalauma);  //sijamuodot joiden pääte mätsää hakusanaan
     writeln('<ul>');
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO

         sikanum:=ptrint(sikalauma.objects[siat]);
        if length(sikalauma[siat])<1 then continue;
        sika:=sijat[sikanum];
        l_sija:=sikalauma[siat];
      writeln('<hr>HAKU:',sika.num,' /cut:',sika.ending+'/left:<b>['+l_sija,']</b>',sikanum,'/v:',sika.vparad,'/h:',sika.hparad,'/v:',sika.vparad,'/h:',sika.hparad);
        for lu:=0 to 25 do writeln(' ',lu+52,':',lmmids[lu,sikanum]);
        writeln('</ul><ul>');
        //sika.vparad,'/',sika.vparad);
        //continue;
        for lu:=0 to 25 do
        begin
        cut:=lkcut;
        if muotosopii(l_sija,lmmids[lu,sikanum],l_lu,a_lu,cut) then
        begin   //TAIVUTUSLUOKKA
             if luoks[lu].vahva then begin if sika.vv then vahvako:=true else vahvako:=false;end
             else begin if sika.hv then vahvako:=true else vahvako:=false;end;
           writeln('<li>luokka:',lu+52,'#',sikanum,' <b>[',l_lu,'_',a_lu+']</b> /mid:',lmmids[lu,sikanum],'/cut',cut,' ',sika.ending+'+'+a_lu+' ='+l_lu);
            //saisin nisias LKA: nisi+as  SIS- nisin+a+is


             for sisus:=luoks[lu].ekasis to luoks[lu].vikasis do writeln('(',(siss[sisus].sis),')');
             writeln('<ul>');
             for sisus:=luoks[lu].ekasis to luoks[lu].vikasis do
               if sopii(l_lu,siss[sisus].sis,a_sis,l_sis,cut) then
             begin                  //SISUSKALUT
              writeln('<li>SIS<b>[',l_sis,'_',a_sis,']</b>/cut:',cut,' ',sika.ending+'+'+a_lu+'+'+a_sis+'='+l_sis,xkon);
                 if xkon then if siss[sisus].sis[1]<>a_lu[1] then begin writeln('<li>latefail::',siss[sisus].sis[1],'!=',a_lu[1]);continue; end;
                for av:=siss[sisus].ekaav to siss[sisus].vikaav do writeln('(',avs[av].v,'|',avs[av].h+')');
                 writeln('<ul>');
                 //#X:as|a=a|sTRUE/cut;0
                 // SIS[a_s]/cut:1 nisi++s=a (|)
               for av:=siss[sisus].ekaav to siss[sisus].vikaav do
               begin   //AV
                   myav:=ifs(vahvako,avs[av].v,avs[av].h);
                   if not sopii(l_sis,myav,a_av,l_av,0) then continue;  //instead of testing at head of loop
                   //if xkon then myav:=l_av[1] else myav:='';
                   if hakuset[ha].takavok=true then begin eka:=avs[av].ekasana; vika:=eka+avs[av].takia-1;end
                   else  begin eka:=avs[av].ekasana+avs[av].takia; vika:=avs[av].vikasana;end;
                   if vika-eka>10000 then begin writeln('<li>xyz:',eka,'...',vika);vika:=eka;end;
                   //continue;
                 writeln('<li> AV: <b>[',l_av,'_',a_av,']</b>'
                 ,' ',sika.ending+'+'+a_lu+'+'+a_sis+'+'+a_av+'='+l_av,
                   eka,'/',vika,hakuset[ha].takavok,
                   '%',avs[av].ekasana,'..', avs[av].takia,'..', avs[av].vikasana,' \\\\', eka,'..', vika);//, ' ',l_sis,':', avs[av].ekasana,'..',avs[av].takia,'..', avs[av].vikasana,' <b>',eka,'...',vika,'</b>',hakuset[ha].takavok);
                   for sa:=avs[av].ekasana to min(avs[av].ekasana+2000,avs[av].vikasana) do writeln(' (',sa,sanat[sa].san,'_',sanat[sa].akon,')');
                   writeln(' <ul>');
                   for sa:=eka to vika do
                   //for sa:=avs[av].ekasana to avs[av].vikasana  do
                   if sopii(l_av,sanat[sa].san,l_san,a_san,0) then
                   begin //SANA
                       if sa=avs[av].takia then writeln('<hr>');
                       //sss:=(ansireversestring(siss[sisus].sis+'.'+myav+'.'+sanat[sa].san+sanat[sa].akon)  +'-'+lmmids[lu,sikanum]+'/'+reversestring(sika.ending));
                       //sss:=(ansireversestring(sika.ending+a_sis+']'+myav+'!'+sanat[sa].san+sanat[sa].akon)
                        sss:=reversestring(sika.ending+a_lu+''+a_sis+a_av+''+sanat[sa].san+sanat[sa].akon);
                         if sanat[sa].takavok then sss:=etu(sss);
                     writeln('<li> sana: <b>[',l_san,'_',a_san,']</b>' ,l_sis,':', avs[av].ekasana,'..',avs[av].takia,'..', avs[av].vikasana,' <b>',eka,'...',vika,'</b>',hakuset[ha].takavok);
                         writeln('<li><b>hit:',sss,' ',lu+52,' ',sa,'</b>(',SANAT[SA].san,'.',SANAT[SA].akon,'/',a_av+'\'+l_av,')</li>');
                         resu.add(sss);
                   end else writeln(' (!',sa,sanat[sa].san,'_',sanat[sa].akon,')');//writeln('-',sanat[sa].akon,reversestring(sanat[sa].san));
                   writeln('</ul>');//SANA
               end;  writeln('</ul>');//AV
             end;   writeln('</ul>');//SISUSKALUT
          end;  writeln('</ul>');//,siss[sisus].sis);//TAIVUTUSLUOKKA
          end
      end; writeln('</ul>',haku);// SIJAMUOTO
    tsekkaa(hakuset[ha].hakunen,not takako,resu,riimit);
    writeln('<hr><h1>hakunen:',riimit.count,haku,'</h1>');
    allresus.addobject(reversestring(haku),resu);
  end; writeln('</ul>/hakutuloksest:<ul>'); //HAKUSANA
  for i:=0 to allresus.count-1 do
  begin
      haku:=allresus[i];
      writeln('<li>',reversestring(haku),':<ul>');
      resu:=tstringlist(allresus.objects[i]);

      for j:=0 to resu.count-1 do
      begin
        sss:=resu[j];
         writeln('<li>',sss,':</li>');
      end;
      writeln('</ul></li>');

  end;
  writeln('<li>RIIMIT:',riimit.commatext,':<ul>');
  for i:=99990 to riimit.count-1 do
  begin
      haku:=riimit[i];
      writeln('<li>',reversestring(haku),':<ul>');
  end;
end;


procedure tverbit.listaasanat;
var lu,sis,av,sa:word;sss:ansistring;
  //string[15];
procedure taivutasana;
var i:word;myav:ansistring;
begin
     WRITELN('<LI>');
     //for i:=0 to 65 do //1 to7 65 do
    for i:=0 to 65 do //1 to7 65 do
    begin
     if (lu<12) or (lu>23) then begin if (I in vheikotsijat) then myav:=avs[av].h else myav:=avs[av].v;end   //vain perusmuot
     else if (I in hheikotsijat) then myav:=avs[av].h else myav:=avs[av].v;   //vain perusmuot
     sss:=(ansireversestring(siss[sis].sis+myAV+sanat[sa].san+sanat[sa].akon)+''+lmmids[lu,i]+''+sijat[I].ending);//+inttostr(sijat[i].vparad));
     if sanat[sa].takavok then sss:=etu(sss);
     writeln(sss,' ');
     //writeln(myav+ansireversestring(siss[sis].sis)+'<b>'+lmmids[lu,i],'</b>'+sijat[i].ending,' ');
   end;
end;

begin
    for lu:=0 to 27 do
    begin
       writeln('</ul><li>luokka:',lu+52,luoks[lu].vahva,'<ul>');
       for sis:=luoks[lu].ekasis to luoks[lu].vikasis do
       begin
         writeln('<li> {',siss[sis].sis,'} ');
         for av:=siss[sis].ekaav to siss[sis].vikaav do
         begin
          writeln('<li> (',avs[av].v,avs[av].h,') ');
           for sa:=avs[av].ekasana to Min(avs[av].vikasana,avs[av].ekasana+2) do
           begin
             TAIVUTASANA;
           end;

         end;
       end;

    end;
end;
{lUOKS:array[0..27] of tverlka; //78-52+1:+1 varalla
sisS:array[0..1100] of tversis;
AVS:array[0..3100] of tverav;
sanat:array[0..10000] of tvsana;
}
procedure tverbit.luesanat;
var sl:tstringlist;ms:tsija;sanafile:textfile;sana,konsti,myav:ansistring;i:word;differ:byte;
  prevsl:tstringlist;
  clka,csis,cav,csan:integer;
  prlim:word;
  //VMASK,HMASK:ARRAY 0..65] OF BOOLEAN;
begin
    //FOR i:=0 to 65 do if
//try
   prlim:=0;
  clka:=0;csis:=0;cav:=0;csan:=0;
  assign(sanafile,'verbsall.csv');
  reset(sanafile);
  sl:=tstringlist.create;
  prevsl:=tstringlist.create;
  //readln(sanafile,sana);
  //prevsl.commatext:=sana;
  prevsl.commatext:='52,i,t,d,1,hesli,h';
  writeln('<ul><li>alku:::<ul><li>lka<ul><li>sis<ul><li>AV',sana);
  luoks[0].vahva:=true;
  while not eof(sanafile) do
  begin
     readln(sanafile,sana);
     sl.commatext:=sana;
     konsti:=sl[6]+ ansireversestring(sl[1]+sl[2]+sl[5]);
     konsti:=ifs(sl[4]='1',etu(konsti),konsti);
     differ:=4;
     for i:=0 to sl.count-1 do if prevsl[i]<>sl[i] then begin differ:=i;break; end;
     if differ=3 then differ:=2;
     writeln('.');
     if differ<3 THEN
      writeln('(',avs[cav].ekasana,',,,',avs[cav].takia,',,,',avs[cav].vikasana,')');
     for i:=differ to 2 do
     begin
            writeln('</ul>');
     end;
    if (differ<1) then   //UUSI TAIVUTUSLUOKKA
     try
     begin
      luoks[clka].vikasis:=csis;
      clka:=clka+1;
      luoks[clka].ekasis:=csis+1;
      if (clka<12) or (clka>23) then   luoks[clka].vahva:=true else  luoks[clka].vahva:=false;
      prlim:=0;
      writeln('<h2>luokka:',clka+52,'</h2>');
      //luoks[clka].kot:=strtointdef(awl[0],99);
    end;

    except writeln('faillka');end;
    try
    if (differ<2) then   //UUSI LOPPUKONSONANTTI
    begin
        siss[csis].vikaav:=cav;
        csis:=csis+1;
        siss[csis].ekaav:=cav+1;
        siss[csis].sis:=sl[1];
        prlim:=0;
        writeln('<li>SIS:',sl.commatext,' <b>',siss[csis].sis,'</b><ul>');
    end;
    except writeln('failsis');end;

    try
    if (differ<4) then //UUSI ASTEVAIHTELULUOKKA
    begin
       avs[cav].vikasana:=csan-1;
       writeln('<li>//',avs[cav].v,avs[cav].h,avs[cav].ekasana,'__',avs[cav].vikasana);
       cav:=cav+1;
       //if sl[4]='0' then begin avs[cav].ekasana:=csan+1;end else  begin avs[cav].ekasana:=9999; avs[cav].takia:=csan+1;end;
       avs[cav].ekasana:=csan;
       avs[cav].takia:=0;

       avs[cav].v:=sl[2];
       avs[cav].h:=sl[3];
       if avs[cav].v='a' then avs[cav].v:=avs[cav].h  //"a" käytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
       else prlim:=0;
       prlim:=0;
       //if prlim<3 then
        begin writeln('<li><small>av:',sl.commatext+' ',cav,'<b> [',avs[cav].v,avs[cav].h,']</b>','#',avs[cav].ekasana,'</small>');end;
        writeln('<ul>');
    end;//  else      deb:=deb+'___';
    //if sl[4]='0' then avs[cav].takia:=csan+1; //pitäis olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
    sanat[csan].san:=sl[5];
    sanat[csan].takavok:=sl[4]='1';
    sanat[csan].akon:=reversestring(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;

    csan:=csan+1;
    prevsl.commatext:=sana;
    prlim:=prlim+1;
    except writeln('failav');end;
    if clka>=12  then myav:=avs[cav].h else myav:=avs[cav].v;   //vain perusmuot
    if (clka<12) or (clka>23) then myav:=avs[cav].v else myav:=avs[cav].h;   //vain perusmuot
    if prlim<9999 then
        begin
          writeln('{',sl.commatext,'#',csan,'}');
          //' ',differ,'<b title="',sl.commatext,'">',
          //  sanat[csan].akon,ANSIREVERSESTRING('a'+ansireversestring(lmmids[clka,0])+''+siss[csis].sis+''+myav+''+sanat[csan].san),'</b>',csan);//,'&nbsp;&nbsp;&nbsp;&nbsp; ',sl.commatext,'</li>');
          for i:=099 to 11  do //1 to 65 do
          begin
           if (clka<12) or (clka>23) then begin if (I in vheikotsijat) then myav:=avs[cav].h else myav:=avs[cav].v;end   //vain perusmuot
           else if (I in hheikotsijat) then myav:=avs[cav].h else myav:=avs[cav].v;   //vain perusmuot
           writeln(myav+ansireversestring(siss[csis].sis)+'<b>'+lmmids[clka,i],'</b>'+sijat[i].ending,' ');
          end;
        end;
     //avs[cav].vikasana:=csan+1;
   end;
  writeln('<h1>sis:',csis,' av:',cav,' /w:',csan,'</h1>');
end;

procedure tverbit.listaasijat;
var i,j:word;
begin
  writeln('<table border="1">');
  for i:=0 to 60 do
  begin
    writeln('<tr><td>','</td');
    for j:=0 to 11 do
     writeln('<td>','</td');

   end;
   writeln('</table');
end;
procedure tverbit.createsija(si:integer;ss:ansistring);
var sl:tstringlist;ms:tsija; j:word;
begin
try
sl:=tstringlist.create;
sl.commatext:=ss;
//ms:=sijat[si];
sijat[si].num:=strtointdef(sl[0],98);
sijat[si].vparad:=strtointdef(sl[1],255);
sijat[si].hparad:=strtointdef(sl[3],255);
sijat[si].vv:=sl[2]='v1';
sijat[si].hv:=sl[4]='h1';
sijat[si].ending:=reversestring(sl[5]);
writeln('<li>',si,sijat[si].vv,sijat[si].hv,'----',sijat[si].ending+'</li>');
for j:=0 to 27 do
 if (j<12) or (j>23) then
 lmmids[j,si]:=reversestring(protomids[j,sijat[si].vparad])
 else //for j:=12 to 27 do
 lmmids[j,si]:=reversestring(protomids[j,sijat[si].hparad]);

except
writeln('<li>fail:',si,':',sl.count,'!</li>');
end;
sl.free;
end;

procedure tverbit.luesijat;
var i,j:integer;
 vheikot,hheikot,vvahvat,hvahvat:string;
 slist:tstringlist;
begin

slist:=tstringlist.create;
try
 slist.loadfromfile('vsijat.csv');
 //for i:=1 to 30 do lvokcounts[i]:=0;
 //writeln('<pre>');
 for i:=0 to slist.count-1 do     // 0..65
 begin
  //writeln('',slist[i]);
  createsija(i,slist[i]);
  if sijat[i].vv then  vvahvat:=vvahvat+','+inttostr(i) else vheikot:=vheikot+','+inttostr(i);
  if sijat[i].hv then hvahvat:=hvahvat+','+inttostr(i) else hheikot:=hheikot+','+inttostr(i);
 end;
 //slist.customsort(@comparestring);
 //writeln('<li>VHEIKOT: ',vheikot); writeln('<li>VVAHVAT: ',vvahvat); writeln('<li>HHEIKOT: ',hheikot); writeln('<li>HVAHVAT: ',hvahvat); writeln('<hr>PROTOT');
 for i:=1 to 11 do
  begin
    writeln('<li>',i,Vprotoloput[i],':');
   for j:=1 to slist.count-1 do
     if (sijat[j].vparad=i) or (sijat[j].hparad=i) then write('*');
  end;
 //writeln('<li>',tstringlist(slist.objects[I]).commatext);
 exit;
 writeln('SIJAT <pre>');
 for i:=0 to 27 do
  begin
     write(i+52,' ');
     for j:=0 to 65 do write(copy(lmmids[i,j]+'|'+sijat[j].ending+'                   ',1,16));
     writeln;
   end;
 writeln('</pre>');
 finally
 slist.free;end;
end;


procedure tverbit.luemids;
var i,j:integer;

 slist,mlist:tstringlist;
begin
slist:=tstringlist.create;
mlist:=tstringlist.create;
  slist.loadfromfile('vmids.csv');
  //writeln('<pre>');
  for i:=0 to slist.count-1 do
  begin
     writeln('<li>ZZZ:');//,slist[i]);
     mlist.commatext:=slist[i];
     for j:=1 to 11 do
     begin
      protomids[i,j]:=trim(mlist[j]);
      writeln(' ',protomids[i,j]);
     end;
  end;

end;
procedure tverbit.haeverbihaku(var hakusetti:tvhakuset;hakufile:string);
VAR I,j:WORD;takav:boolean;hakulist:tstringlist;
//var hakusetti2:array of tvhaku;
BEGIN
 hakulist:=tstringlist.create;
 hakulist.loadfromfile(hakufile);
 setlength(hakusetti,hakulist.count);
 writeln('<h1>hakuja',hakulist.commatext,'</h1>');
 //hakusetti:=hakusetti2;
 for i:=0 to hakulist.count-1 do
 begin write(i);
   hakusetti[i].takavok:=false;
   for j:=1 to length(hakulist[i]) do
   if pos(hakulist[i][j],'aou')>0 then
   begin
   hakusetti[i].takavok:=true;
   writeln('***',hakulist[i]);
   end else    writeln('?',hakulist[i]);


   hakusetti[i].hakunen:=taka(hakulist[i]);

writeln('<h4>',hakuset[i].hakunen,hakuset[i].takavok,hakulist[i],'</h4>');
  end;
 hakulist.free;
END;


function hyphen(w:ansistring;tavus:tstringlist):ansistring;
   var i,k,len,vpos:integer;hy,vocs,alkkon:ansistring;ch,chprev:ansichar;lasttag:ansistring;haddif:boolean;

 begin
   tavus.clear;
   len:=length(w);
  if len=0 then exit;
  result:='';//w[len];
  chprev:=' ';//w[len];   //o
  haddif:=false;
  alkkon:='';
  if (pos(w[1],konsonantit)>0) then
  for i:=2 to 3 do if (pos(w[i],konsonantit)>0) then alkkon:=alkkon+w[i-1] else break;
  if alkkon<>'' then w:=ansilowercase(copy(w,length(alkkon)+1,99));

  len:=length(w);
  for i:=len downto 1 do
  begin
     ch:=w[i]; //d  kons alkaa uuden tavun paitsi jos ed=kons
     if (pos(chprev,vokaalit)>0) then  //jos ed on vokaali
     begin        //a ie  prev:e nyt:i  ie on dift
       if (pos(ch,konsonantit)>0)  then  begin haddif:=false;result:=result+'-'+ch+hy;tavus.insert(0,ch+hy);hy:='';ch:=' ';end
       else  if haddif then begin haddif:=false;result:=result+'-'+hy;tavus.insert(0,hy);hy:=ch end
       else
       if (not isdifto(ch,chprev)) then
       begin
         result:=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
       end else  //diftongi, mutta tulossa vielÃ¤ yksi vokaali
        if ((i>1)
         and (isdifto(w[i-1],ch))) then begin
          result :=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
        end else
        begin haddif:=true;hy:=ch+hy;
        end; //ignoroi kolmoiskons - mukana vain ei-yhd.sanojen perusmuodot,
    end else hy:=ch+hy;
     if i=1 then begin result:=result+'_'; if hy<>'' then tavus.insert(0,hy);end else
    chprev:=ch;
  end;

  if alkkon<>'' then tavus.insert(0,alkkon+'')
  else tavus.insert(0,'');//  tryin this .. maybe breaks something
  result:=alkkon+'_'+result;
   result:=tavus.commatext;
 end;


{
verbiluokat 52 - 78 (26 kpl)
vahvat 52-61, 77,78  (1..11)
heikot 62-76

}

procedure TVERBIT.uusetsi;
var
 i,j,ha,lu,siat,sisus,sikanum,av,sa:integer;
 sss,haku:ANSIstring;
 sika:tsija;
 l_sija,l_lu,l_sis,l_av,l_san:string;
 myav,a_sija,a_lu,a_sis,a_av,a_san:string;
 cut,lkcut:WORD;
 //xhakusanat,
  sikalauma, riimit,resu,allresus:tstringlist;
 vahvako,takako,xkon:boolean;
 eka,vika:integer;
  //string[15];

  function muotosopii(anas,uppol:ansistring;var tamaj,tamahit:ansistring;vAR cut:word):boolean;
  begin
   result:=false;
   cut:=0;
   xkon:=false;
   while (uppol<>'') and (pos('-',uppol)=length(uppol)) do
   begin cut:=cut+1;
       delete(uppol,length(uppol),1);
       //delete(anas,1,1);
    end;
   if pos('*',uppol)>0 then if pos(anas[1],konsonantit)>0 then
   begin
       xkon:=true;
       uppol:=anas[1];
    end;

   if anas='' then
   begin
    result:=true;tamahit:='';
    exit;
   end;
   tamaj:='';
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    tamaj:=copy(anas,length(trim(uppol))+1);
    tamahit:=trim(uppol);
   end;
  end;

  function sopii(anas,uppol:string;var alku,loppu:string;cut:word):boolean;
  begin
   //loppu reversoitu, mikä ei kai hyvä ...
   // alku = pala joka todetaan sopivaksi ja poistetaan hausta , loppu= jäljelle jäävä (sanan alku, kun reversoitu).
   result:=false;
   WHILE (uppol<>'') AND (cut>0) do BEGIN delete(uppol,1,1);cut:=cut-1;END;
   if anas='' then
   begin
    result:=true;
    exit;
   end;
   alku:='';
   if (uppol='') or (pos(uppol,anas)=1) then
   begin
    result:=true;
    loppu:=copy(anas,length(trim(uppol))+1);
    alku:=uppol;
   end;
  end;

begin
   sikalauma:=tstringlist.create;
   allresus:=tstringlist.create;  //haikkien hakujen riimit
   riimit:=tstringlist.create;     //yhten haun tsekatut viimit
   haeverbihaku(hakuset,'haku.lst');
   riimit:=tstringlist.create;
   for ha:=0 to length(hakuset)-1 do //hakusanat.count-1 do //yksi hakusana koko listasta
   begin
     resu:=tstringlist.create;       //yhden haun mahd. rmiit
     haku:=reversestring(hakuset[ha].hakunen);
     takako:=hakuset[ha].takavok;
     sikalauma.clear;
     haesijat(haku,sikalauma);  //sijamuodot joiden pääte mätsää hakusanaan
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
         sikanum:=ptrint(sikalauma.objects[siat]);
        if length(sikalauma[siat])<1 then continue;  /// temppu :-(
        sika:=sijat[sikanum];
        l_sija:=sikalauma[siat];
        for lu:=0 to 25 do
        begin
        cut:=lkcut;
        if muotosopii(l_sija,lmmids[lu,sikanum],l_lu,a_lu,cut) then
        begin   //TAIVUTUSLUOKKA
             if luoks[lu].vahva then begin if sika.vv then vahvako:=true else vahvako:=false;end
             else begin if sika.hv then vahvako:=true else vahvako:=false;end;
             for sisus:=luoks[lu].ekasis to luoks[lu].vikasis do
               if sopii(l_lu,siss[sisus].sis,a_sis,l_sis,cut) then
             begin                  //SISUSKALUT
                 if xkon then if siss[sisus].sis[1]<>a_lu[1] then continue;//begin writeln('<li>latefail::',siss[sisus].sis[1],'!=',a_lu[1]);continue; end;
               for av:=siss[sisus].ekaav to siss[sisus].vikaav do
               begin   //AV
                   myav:=ifs(vahvako,avs[av].v,avs[av].h);
                   if not sopii(l_sis,myav,a_av,l_av,0) then continue;  //instead of testing at head of loop
                   if hakuset[ha].takavok=true then begin eka:=avs[av].ekasana; vika:=eka+avs[av].takia-1;end
                   else  begin eka:=avs[av].ekasana+avs[av].takia; vika:=avs[av].vikasana;end;
                   for sa:=eka to vika do
                   if sopii(l_av,sanat[sa].san,l_san,a_san,0) then
                   begin //SANA
                        sss:=reversestring(sika.ending+a_lu+''+a_sis+a_av+''+sanat[sa].san+sanat[sa].akon);
                         if sanat[sa].takavok then sss:=etu(sss);
                         resu.add(sss);
                   end;   //SANA
               end;  //AV
             end;   //SISUSKALUT
          end;  //TAIVUTUSLUOKKA
          end
      end; // SIJAMUOTO
     //tsekkaa(hakuset[ha].hakunen,not takako,resu,riimit);
     if not takako then haku:=etu(haku);
     tsekkaa(reversestring(haku),not takako,resu,riimit);
    writeln('<hr><h1>hakunen:',riimit.count,haku,'</h1>');
    allresus.addobject(reversestring(haku),resu);
  end; writeln('</ul>/hakutuloksest:<ul>'); //HAKUSANA
  for i:=0 to allresus.count-1 do
  begin
      haku:=allresus[i];
      writeln('<li>??',(haku),':<ul>');
      resu:=tstringlist(allresus.objects[i]);
      for j:=0 to resu.count-1 do
      begin
        sss:=resu[j];
         writeln('<li>:',sss,':</li>');
      end;
      writeln('</ul></li>');
  end;
  writeln('<li>RIIMIT:',riimit.commatext,':<ul>');
  for i:=99990 to riimit.count-1 do
  begin
      haku:=riimit[i];
      writeln('<li>',reversestring(haku),':<ul>');
  end;
end;


end.
{


-------
66 sijamuotoa, jotka jakautuvat 9 taivutustyyppiin (mutta kaikilla 65llä oma sijapääte)

kukin sija voi kuulua eri taivutustyyppiin vahvoissa ja heikoissa verbiluokissa
sijamuodot määr tiedostossa vsijat3.lst jossa
  0) numero (0..65)
  1) vahvan vluokan taivtyyppi,
  2: v0/v1 - taipuuko vahvasti (v1) vai heikosti (v0) vahvoissa vmuodoissa
  3) heikon vluokan taivtyyppi,
  4: v0/v1 - taipuuko vahvasti (h1) vai heikosti (h0) heikoissa vmuodoissa

TAIVUTUSTYYPPI MÄÄRÄÄ TAIVUTUKSEN KESKIOSAT const bfixes:array[0..12] of ansistring =('!','a', 'n', '', 'a', 'nut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme','?');
   const yhtloput:array[0..11] of ansistring =('','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme');
                                                   1    2    3   4    5     6     7     8      9      10
     soutaa:
     kutea:
 1/3 ttyypit voivat olla eri mm. sijamuodossa   /vahvat kuten 1'VInf1Lat' /  heikot 4'VPrsActSg3',  nimetä/nimeää
 SOUTAA 55,,2,t,d,1,1,,sou
   SOUTAA        lop1:A  mid1A: av:T  r:taa
   SOUDETA       lop4:A  mid4:ET  av:D r:SOU

 yleensä sija taipuu samaan tapaan heikoissa ja vahvoissa, mutta
 sijat 1,13, perusmuodot 1,8  luokisssa 58,59 ja 60 eri tavoin
   KUTEA  KUTEE
   KUTEA KUTIEN - KUTIEN (muodot 1,13, perusmuodot 1,8)

 r1:A   mid1:T  vok:U  k:L
 nekin yleensä ovat samoja haluta haluaa
taitustyypit

vahva and (not (s in [2,4,7]))) or (not vahva and (s in [2,3,6,9])
}
