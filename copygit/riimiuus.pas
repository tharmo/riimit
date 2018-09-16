unit riimiuus;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,verbit,nominit,strutils,riimiutils;
const vahvatverbiluokat=[52..63,76];
const vahvatnominiluokat=[1..31,76];

type tlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;vikasana:word;end;
type tsis=record ekaav,vikaav:word;sis:string[8];vikasana:word;end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lis‰‰ viek‰ .takia - se josta etuvokaalit alkavat
type tsan=record san:string[15];akon:string[4];takavok:boolean;end;
type tnod=record ru_lyh,ru_pit,yhted,jump,ed,lev,len,tavucount:word;reftavs:integer;etu,tie:boolean;letter:ansichar;end;
type txnod=record ch:ansichar;jump,ed,lev,olisana:word;taka:boolean;end;
type tlet=record c:ansichar;w:word;end;
type tmuotolista=class(tobject)
     eds:tstringlist;
     lets:array[0..64] of tlet;
     //jumps,palalen:array[1..2068] of word;
     nodes:array[0..28088] of tnod;
     //xnodes:array[0..12000] of txnod;
     //xnn:word;
     lres,sres:tstringlist;
     eithits:array[1..30000] of word;
     hitcount:word;
     sanalista:tstringlist;
 procedure listaa(slista:tstringlist);
 procedure riimit(slista:tstringlist);
 procedure ETSIlista;
 procedure teetaulu(yy:tstringlist);
   // procedure do99;
 function sexact(haku:ansistring;yy:tstringlist):word;  //kutsutaan kun haku on edellyt ekaan (k‰‰nt) vokaaliin
    end;

type tsanasto=class(tobject)
 vcount,ncount:integer;
 lks:array[0..80] of tlka;
 siss:array[0..255] of tsis;
 avs:array[0..1200] of tav;
 sans:array[0..32767] of tsan;
 sanataulu:array[0..32767] of string[20];
 verbit:tverbit;
 nominit:tnominit;
 eitaivu:tmuotolista;
 hakulista:tstringlist;
 hitlist:array[1..30000] of word;hitcount:integer;
 sanoja:tstringlist;
 function haenumero(sana:ANSISTRING):word;
 procedure expandlist(wlist:tlist;rlist:tstringlist);
 procedure numeroikaikki;
 //0-pohjasia, mutta data alkaa 1:st‰
 procedure luesanat(fn:string);
 procedure listaa;
 procedure haemuodot;
 function generateverb(resus:tstringlist;snum:word):ansistring;
 function generatenom(resus:tstringlist;snum:word):ansistring;
 procedure concor;
 function luohaku(fn:string):tstringlist;
 function etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):word;
 procedure etsimuodot(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
 constructor create;
 end;

implementation
uses riimitys,math;
function red(st:string):string; begin result:='<b style="color:red">'+st+'</b>';  end;
function blue(st:string):string;  begin result:='<b style="color:blue">'+st+'</b>';  end;

procedure tavutnoodi(VAR node:tnod;san:ansistring);
//type tnod=record rlen,yhted,jump,ed,lev,len,tavucount:word;reftavs:integer;etu,tie:boolean;letter:ansichar;end;
var i,j,len,tavus,ct,prevok:word;nod:tnod;onkon:boolean;ch:ansichar;cutps:array[0..9] of byte;
     palat:array[0..4] of string[9];
     //runks1,runks2:string;
     //rlen1,rlen2:word;
begin
 prevok:=0;  tavus:=1;
 fillchar(ct,sizeof(ct),0);
 fillchar(cutps,sizeof(cutps),0);
 fillchar(palat,sizeof(palat),0);
 len:=length(san);
 //writeln(' <h3>',san,'</h3>');
 for i:=1 to len do
 begin  // asia  aisa
  CH:=san[i];
  onkon:=pos(ch,vokaalit)<1;
  //writeln(' <li><b>:',san[i],'/tavus:',tavus,'/pvok:',prevok,'/k:',onkon,':</b>');
  if prevok=0 then  //ed oli konsonantti
  begin
     if not onkon then prevok:=prevok+1;
  end else
  begin  //ed oli vokaali
     //writeln('[',san[i],san[i-1],']');
     if onkon then //pukiso[n]a ->na
     begin
       cutps[tavus]:=i-1;  //ei huomioida konsoinanttia tavun pituuteen
       tavus:=tavus+1;
       prevok:=0;
       //ponkon:=false
     end
     else  //vokaali vokaalin j‰lkeen
     if (prevok>1) or (not isdifto(san[i],san[i-1])) then //as[i]a ->a
     begin
       //writeln('<b style="color:red">-',san[i],san[i-1],'</b>');
       cutps[tavus]:=i-1;
       tavus:=tavus+1;
       prevok:=1;
       //pONKON:=FALSE;
    end else prevok:=prevok+1;

   END;
   //ponkon:=onkon;
 END;
  if pos(san[len],vokaalit)<1 then tavus:=tavus-1  //begin tavus:=tavus+1;cutps[tavus-1]:=len;end;
  else cutps[tavus]:=len;
  node.tavucount:=tavus;
  if tavus>3 then   //ei etsit‰ yhdeb tavun riimej‰. joskus kyll‰ haluttaisiin
  begin
   node.ru_lyh:=cutps[tavus-2];
   node.ru_pit:=cutps[tavus];
  end
   else
   begin
      node.ru_lyh:=cutps[tavus];
      node.ru_pit:=cutps[tavus];
   //rlen2:=0;
   end;
  //writeln('<li>',NODE.TAVUCOUNT,' <b>',reversestring(san),' /',reversestring(copy(san,1,node.ru_lyh)),' \',reversestring(copy(san,1,node.ru_lyh)),'</b> ',node.ru_lyh,node.ru_pit);
end;

function tavuraja(a,b:ansichar):boolean;  //huom k‰‰nteinen suunta
begin  //
   result:=false;
   if pos(a,vokaalit)>0 then //a on normaalij‰rjesyksess‰ seuraava kirjain
   begin  // vailla -> av
     if pos(b,konsonantit)>0 then result:=true
     else if not (isdifto(b,a)) then begin result:=true;;end;
     //if pos(b,vokaalit)>0 then writeln(a,b,result);
    end;
   // writeln(' /',ifs(result,'<b>'+a+b+'</b>',a+b));
end;


function tavusrev(st:ansistring):word;
var i:word;turha:ansistring;pvok,isvok:boolean;
begin                                   //  ae ao ea eo ia io oa oe ua ue
   pvok:=fALSE;
   result:=0;turha:='';
   for i:=1 TO length(st) do
   begin
    isvok:=pos(st[i],vokaalit)>0;
    if pvok then
    begin
      if (isvok) and (not isdifto(st[i],st[i-1])) then result:=result+1
      else  if not isvok then  result:=result+1;
    end;
    pvok:=isvok;
    //writeln(' ',st[i-1],'<b>',st[i],'</b>',result);
   end;
   if pvok then result:=result+1;
    //for i:=2 to length(st) do begin  turha:=turha+st[i];if (tavuraja(st[i-1],st[i])) then begin  turha:=turha+'-';result:=result+1;end;end;
     //writeln(' ',result,pvok);
    //writeln('<li>',string(turha),st[length(st)],result);
end;

function tmuotolista.sexact(haku:ansistring;yy:tstringlist):word;  //kutsutaan kun haku on edellyt ekaan (k‰‰nt) vokaaliin

  procedure dofail(haku,edsana,paras:ansistring;t:boolean);
  var color:string;commons:word;
  begin
  try
  if paras<>'' then edsana:=paras;
  if pos(copy(haku,1,length(edsana)),edsana)=1 then
  begin
 //    if (pos(haku[length(edsana)+1],vokaalit+'ns-')>0) then
     //or (pos(haku[length(edsana)+1],'ns')>0) then
     //or (haku[length(edsana)-1]='n') then
      //writeln('(<span style="color:green">',reversestring(haku+':'+edsana),'</span>) ')
      //else writeln('(<span style="xcolor:red">',reversestring(haku+':'+edsana),'</span> ');
 //     writeln(reversestring(haku),'/',reversestring(edsana),'!')
 //       else
if 1=0 then        writeln('<span style="color:red" title="',haku,'/',edsana,'">!',reversestring(copy(haku,length(edsana)+1))+'</span>'+copy(reversestring(edsana),1));

     //writeln('!',haku[length(edsana)-1]);//,length(edsana)-2,haku);
  // color:='red' else color:='blue';

   exit;
  end;
  exit;
  if color='blue' then
   writeln('(<span style="color:',color,'">',reversestring(haku+':'+edsana),'</span>) ');
  except writeln('FAIL');end;
  end;
 var ww,prevww,epoint,cp,hlen,cc:integer;d:boolean;besthit:ansistring;
  begin
  d:=false;
  //d:=true;
   result:=0;
     ww:=1;
    epoint:=27954;hlen:=length(haku);
    epoint:=3000;
    cp:=1;cc:=0;
    besthit:='';   prevww:=0;
    if d then writeln('.<hr>@',ww,'..',reversestring(haku),' ',cp,' ');//<ul>');
    try
    while ww<=epoint do
    begin
       try
       if haku[1]='_' then delete(haku,1,1);
       //writeln('#',ww,'<b>!',nodes[ww].letter,'</b>');
       cc:=cc+1;if cc>600 then break;
       if nodes[ww].letter=haku[cp] then
       begin
          try
          if (nodes[ww].len=hlen) and (pos(haku,yy[ww])=1) then
          begin if d then writeln('<b style="color:green">',reversestring(yy[ww]),'</b>');result:=ww;
           hitcount:=hitcount+1;
           eithits[hitcount]:=ww;exit;
          end; //fullhit
          if not nodes[ww].tie then
           begin cp:=cp+1;
           if nodes[ww].jump>0 then epoint:=nodes[ww].jump;  //
           end;
           if (pos(copy(yy[ww],1,length(yy[ww])-0),haku)=1) then
            //besthit:=yy[ww];
              if length(yy[ww])>length(besthit) then besthit:=yy[ww];// else writeln('<li>',reversestring(yy[ww]),'/',reversestring(besthit));
          if d then writeln('<li>+',haku,cp,'<b>',nodes[ww].letter,'</b>',reversestring(yy[ww]),' ',reversestring(copy(yy[ww],cp,length(yy[ww])-0-cp))
            ,'|<b>',reversestring(copy(yy[ww],1,cp)),'</b>_',nodes[ww].letter,epoint,' /next:',haku[cp]);//,'<ul>');
          except writeln('jotainvikaa');end;
          prevww:=ww;
          ww:=ww+1;
       end //ei, koklaa seuraavaa
       else
       begin
          try
         if d then writeln('-<b>',nodes[ww].letter,'</b>','',reversestring(yy[ww]),epoint);
         if nodes[ww].jump=0 then begin dofail(haku,yy[prevww],besthit,true);exit;end;
         ww:=nodes[ww].jump;
          except writeln('FAILmiss',ww,' ',prevww);raise;end;

       end;
       if ww>epoint then dofail(haku,yy[prevww],besthit,false);
       except writeln('FAILSexact',ww,' ',prevww,'!');raise;end;
   end;
   finally writeln('</ul>');end;
  end;

 procedure tmuotolista.etsilista;
 var Etsityt:TSTRINGLIST;I:INTEGER;
begin
  writeln('wikite sanat');
  try
  //sexact(reversestring('hallinnoida'));
  Etsityt:=TSTRINGLIST.CREATE;
  //ELI.LOADFROMFILE('wikithe.ansi');
  Etsityt.LOADFROMFILE('yhdys_all.lst');
  writeln('<li>etsi: ',etsityt.count,' sanaa');
  //try sexact(reversestring('suuraakkonen'));except writeln('<li>failetsi;',ELI[I]);end;
  //exit;
  for i:=1 to etsityt.count-1 do //5000 do //50000 do
  begin
     //if i>4000 then break;
    //writeln('<li>etsi;',eli[I]);
    if etsityt[i]='' then // writeln('///<b>',string(eli[i+1]),':</b> ')
 else
    try sexact(reversestring(etsityt[i]),sanalista);except writeln('<li>failetsi;',Etsityt[I]);end;
    //writeln('<li>',eli[i]);
  end;

//   haepa('');
 //for i:=1 to 50 do etsi(ww(yy[random(2068)]));
 except writeln('eietsi<hr>');end;
 writeln('</ul></ul></ul></ul></ul></ul></ul></ul></ul></ul>');
end;


procedure tmuotolista.riimit(slista:tstringlist);
 var      kirs,adss,cc:integer;
     inf,outf,misfile:textfile;
     len,edlen,maxlen,curlev:word;
     a:word;
     d:boolean;
     syy:ansistring;
     resmat:  array of word; //P.O. dynamic packed array

     function ww(www:string):string;
     begin result:=copy(www,1,length(www)-2);
     end;
   procedure addres(r,c:word);
   var i,rhymecount,rpos,fpos,rivinalku:word; //huom resmat nollapohjainen
   begin
     rpos:=(r-1)*64; //nollas arvo on jo lˆydettyjen m‰‰r‰, sarakeindeksit ykkˆspohjaisia
     rhymecount:=resmat[rpos];
     if rhymecount>64 then begin writeln('Riimirivi  ',r,' on jo t‰ynn‰');exit;end;
     resmat[rpos+rhymecount+1]:=c; //arvo talteemn
     resmat[rpos]:=rhymecount+1; //m‰‰r‰ kasvatetaan
     exit;
     writeln('<div>sanan ',r,reversestring(slista[r]), ' arvo ',rhymecount+1,'=',c,reversestring(slista[c]),rpos div 64,': ');
     for i:=0 to 64 do writeln(resmat[rpos+i]);
     writeln('<b> ',r,reversestring(slista[r]), ' > ',c,reversestring(slista[c]),' ',rpos div 64,':',rhymecount+1,'</b>');
     writeln('</div>');
   end;

  function sopii(vert,kohde:word;kohrpit,kohrlyh:ansistring;var short:boolean):boolean;
      var nchar:ansistring; mypit,mylyh:ansistring;
     begin
       try                 //  k ampe-aisimme  h aisimme
        result:=false;
        try
        mypit:=copy(slista[vert],1,nodes[vert].ru_pit);
        mylyh:=copy(slista[vert],1,nodes[vert].ru_lyh);
        if mypit=kohrpit then result:=true
        else if mypit=kohrlyh then result:=true
        else if mylyh=kohrpit then result:=true;
        if abs(nodes[kohde].tavucount-nodes[vert].tavucount)=1 then begin syy:='eritavut';exit;end;
      exit;
      except writeln('EIEI:',slista[kohde],'/',slista[vert]);
     end;
     finally  writeln('');end;
  end;

  function eds3(sana:ansistring;snum:word):ansistring;
  var upto,lev,cc,ss,i,j,tavus,slen,let,alasana,prevlev:word;
       myshort,wp,ap,lp,lyhr,pitr:ansistring;dd,ookoo,voijatkuu:boolean;pit_ero:integer;
       //res:tlist;

   function alasanat(alasana,ss:word;short:boolean):ansistring;
    var ii:word;  d:boolean;
    begin
      try
       d:=false;
       //d:=true;
      upto:=snum;//nodes[ss].jump;
      if d then writeln('<span style="color:blue">[[',alasana,upto,':');
      while alasana<upto do
      begin
         cc:=cc+1;
         if cc>300000 then break;
         if short then
            ookoo:=(nodes[alasana].ru_pit=nodes[snum].ru_lyh) and (alasana<>snum) and (nodes[snum].ru_lyh=nodes[alasana].ru_lyh)
         else
           ookoo:=(abs(nodes[alasana].tavucount-tavus)<>1) and (alasana<>snum) and (nodes[snum].ru_pit=nodes[alasana].ru_lyh);
         //kun pitk‰‰ testaaa, voidaan hyv‰ksy‰ myˆs useampitavuiset muodot
           if ookoo then if d then
           writeln('<span style="color:',ifs(short,'magenta','blue'),'">', reversestring(slista[alasana]),
             nodes[snum].ru_pit,'.',nodes[alasana].ru_lyh,'</span>')
           else  if d then writeln('!!<span style="background:',ifs(short,'brown','red'),'">', reversestring(slista[alasana]),
               nodes[snum].ru_pit,'.',nodes[alasana].ru_lyh,'</span>');
          if d then if ookoo then writeln('>',reversestring(slista[alasana]));
          if ookoo then addres(snum,alasana);
         if (nodes[alasana].jump>alasana)
          and (pos(nodes[alasana].letter,vokaalit)>0)
            and (short) then alasana:=nodes[alasana].jump
          else alasana:=alasana+1;
         if alasana=0 then breAK;
      end;
      except writeln('FAIL',alasana,'/',ss,ifs(short,'LY','PI'));end;
            if d then writeln(']]</span> ');
    end;

  // tmuotolista.riimit
 var d,short:boolean;
  begin
  //res:=tlist.create;
  //resres:=tlist.create;
    result:='';//'#'+inttostr(nodes[snum].tavucount);//('!!'+sana);
   begin
     d:=false;
     lets[1].w:=0;
     cc:=0;
     slen:=nodes[snum].ru_lyh-1;
     tavus:=nodes[snum].tavucount; //huom tavut, ei reftavut
     let:=slen;
     pitr:=copy(sana,1,nodes[snum].ru_pit);
     lyhr:=copy(sana,1,nodes[snum].ru_lyh);
     for i:=nodes[snum].lev-1 downto 1 do //nodes[snum].ru_lyh-1 do
     begin
        try
         ss:=lets[i].w;
       //jos sana on monitavuinen, loppup‰tk‰styn vrt:n pit‰‰ m‰ts‰t‰ t‰ysin. Kokonaisen vrt:n
       //sana lyhyt, vertailtava lyhyt: pit‰‰ m‰ts‰t‰ t‰ysin
        if d then writeln('<div>','#',i,'_',ss);
        syy:='';
        ookoo:=sopii(ss,snum,pitr,lyhr,short);
        if ookoo then addres(snum,ss);
       if d then
       if ookoo then writeln(' <span style="color:green">',reversestring(slista[ss]),nodes[ss].ru_pit,'.',nodes[ss].ru_lyh,'</span>')
       else  writeln(ifs(syy<>'','<span style="color:red">'+syy+'</span>',''),reversestring(slista[ss]));
       alasana:=ss+1;
       if d then writeln('</div>');
       if nodes[snum].ru_pit=nodes[ss].lev then
            alasanat(alasana,ss,false)
       else if nodes[snum].ru_lyh<>nodes[snum].ru_pit then if nodes[snum].ru_lyh=nodes[ss].lev then
       begin  //loppup‰tk‰ sopii, mutta perussana jatkuu. Vertailtavien alasanojem  pit‰‰ mats‰t‰ kokonaan
         alasanat(alasana,ss,true);
       end;

        finally prevlev:=ss;end;
     end;
    end;
  end;
 var i,j,sn:integer;edsana,lyh,sana:ansistring;
 begin
   d:=false;
   //d:=true;
    curlev:=01;
    setlength(resmat,slista.count*64);
    fillchar(resmat[0],slista.count*64,0);
    writeln('<li>resmat:', length(resmat),' ',slista.text,lets[1].w);
    for i:=1 to slista.count-1 do
    begin
    try
     lets[nodes[i].lev].w:=i;
     lets[nodes[i].lev].c:=nodes[i].letter;

       if d=d then for j:=curlev downto nodes[i].lev do writeln('</div>');
       try
       curlev:=nodes[i].lev;
       except WRITELN('<li>XXXX',i);end;

      sana:=ww(slista[i]);
      if nodes[i].etu then
       sana:=etu(sana);
     except writeln('___');writeln('<li>########',j,'#i:',i,'/nodlev:',' /curlev:',curlev);end;
     try
     if d then
     writeln('<div>',lets[1].w,'>',i,'>',nodes[i].jump,'/',' ',reversestring(copy(slista[i],nodes[i].yhted+1))+'<b>', reversestring(copy(slista[i],1,nodes[i].yhted)),'</b> ',nodes[i].tavucount,' ',red(inttostr(nodes[i].ru_lyh)),nodes[i].ru_pit,nodes[i].ru_lyh,':: ');//,'>',nodes[i].jump,'::');
     if d then if nodes[i].ru_pit<>nodes[i].ru_lyh then writeln(reversestring(copy(slista[i],1,nodes[i].ru_lyh)));
     eds3(slista[i],i)
     //writeln(' ',eds3(slista[i],i));//,nodes[i].lev));
     except writeln('___fail');writeln('<li>zzz',j,'#i:',i,'/nodlev:',nodes[i].jump,' /curlev:',curlev);raise;end;
  end;
    writeln('<h3>lista</h3>');
     for i:=20 downto 1 do //slista.count-1 do
     begin
        //writeln('<li>',i,reversestring(slista[i]),': ');//,'#',resmat[64*(i-1)],':::');
      for j:=1 to 8 do
       if (resmat[64*(i-1)+j]<i) then if (resmat[64*(i-1)+j])>0 then//or (resmat[j,i]) then
         begin
          addres(resmat[64*(i-1)+j],i);
          //writeln(resmat[64*(i-1)+j],'/',reversestring(slista[resmat[64*(i-1)+j]]));
         end;
     end;
     writeln('<hr>');
    for i:=1 to slista.count-1 do //slista.count-1 do
    begin
      writeln('<li>',i,reversestring(slista[i]),': ');//,'#',resmat[64*(i-1)],':::');
      for j:=1 to 16 do
       if (resmat[64*(i-1)+j])>0 then //or (resmat[j,i]) then
        writeln(' ',reversestring(slista[resmat[64*(i-1)+j]]),resmat[64*(i-1)+j]);
       //writeln(' ',i+1,'/',resmat[(64*(i-1))+j],reversestring(slista[resmat[64*(i-1)+j]]),': ');
    end;
    writeln('<hr>');
 end;

procedure tmuotolista.listaa(slista:tstringlist);
var      kirs,adss,cc:integer;
    inf,outf,misfile:textfile;
    len,edlen,maxlen,curlev:word;
    a:word;
    d:boolean;
    function ww(www:string):string;begin result:=copy(www,1,length(www)-2);end;

var i,j,sn:integer;edsana,lyh,sana:ansistring;
begin
   curlev:=01;
   //exit;
   writeln('<li>listaa:',slista.count);
   for i:=1 to slista.count-1 do
   begin
   try
      for j:=curlev downto nodes[i].lev do writeln('</div>');
      try
      curlev:=nodes[i].lev;
      except WRITELN('<li>XXXX',i);end;

     sana:=ww(slista[i]);
     if nodes[i].etu then
      sana:=etu(sana);
    except writeln('___');writeln('<li>########',j,'#i:',i,'/nodlev:',' /curlev:',curlev);end;
    try
    writeln('<div>',reversestring(copy(slista[i],nodes[i].yhted))+'<b>', reversestring(copy(slista[i],1,nodes[i].yhted-1)),'</b> ',nodes[i].lev,' ',reversestring(slista[nodes[i].jump]));
   // writeln('<div>',i,';',nodes[i].lev,nodes[i].letter,'!',i,' ',nodes[i].lev,' :',nodes[i].yhted,' ',reversestring(copy(sana,nodes[i].yhted+1))
   //   +'<b style="color:blue">',reversestring(copy(sana,1,nodes[i].yhted)),'</b> ',copy(reversestring(slista[nodes[i].jump]),3),'  ->',nodes[i].jump,' ',nodes[i].yhted,'/',sanalista[i],nodes[i].tie);
    except writeln('___');writeln('<li>zzz',j,'#i:',i,'/nodlev:',nodes[i].jump,' /curlev:',curlev);raise;end;
 end;
end;

procedure tmuotolista.teetaulu(yy:tstringlist);
var      kirs,adss,cc,reftavs:integer;
    inf,outf,misfile:textfile;
    len,edlen,maxlen,curlev:word;
    a:word;
    d:boolean;
  procedure nollaa(alku:integer); var ii:integer; begin  for ii:=alku to 23 do begin lets[ii].c:=#0;lets[ii].w:=0;end;  end;
  function ww(www:string):string;begin result:=copy(www,1,length(www)-2);  end;
var i,j,sn:integer;edsana,lyh,sana:ansistring;
begin
  {yy:=tstringlist.Create;
  yy.Delimiter:=' ';yy.StrictDelimiter:=true;
  //yy.LoadFromFile('sanatall.ansi');
  yy.LoadFromFile('eitaivu.lst');
  //FOR I:=10000 TO 15000 DO  WRITELN(YY[I]);  EXIT;
  yy.sort;
  yy.Insert(0,'');
  }
  edsana:=yy[0];edlen:=length(edsana);
  fillchar(lets,sizeof(lets),0);
  for i:=1 to 23 do begin lets[i].c:=#0;lets[i].w:=0;end;
  mAXLEN:=0;curlev:=01;
  nodes[0].lev:=1;
  curlev:=0;
  nodes[0].reftavs:=0;
  d:=false;
  //d:=true;
    nodes[0].yhted:=1;
  nollaa(curlev+1);
  writeln('<h3>teetaulu:',yy.count,'</h3><style type="text/css">div { border:1px solid red;margin-left:1em}</style>');
  for i:=0 to yy.count-1 do
  begin
   try
   //writeln('.',i);
   sana:=yy[i];//ww(yy[i]);
   if sana='' then continue;
   nodes[i].tie:=false;
   nodes[i].jump:=0;
   //nodes[i]ru_lyh:=length(sana);for j:=length(sana) downto length(sana)-3  do if pos(yy[i][j],vokaalit)>0 then break else nodes[i]ru_lyh:=nodes[i]ru_lyh-1;
   nodes[i].len:=length(sana);
   tavutnoodi(nodes[i],sana);
   //nodes[i].tavucount:=tavusrev(sana);
   //nodes[i].reftavs:=reftavs;

   //writeln(' XXX',reversestring(sana),nodes[i].ru_lyh);
   nodes[i].etu:=yy[i][length(yy[i])]='0';
   except writeln('???',i,sana);raise;end;
   try
   for a:=1 to curlev+1 do //length(sana)+1 do
   begin
       if d then write('_',sana[a]);
      //writeln(a,sana[a],lets[a].c,lets[a].w);
      if a>length(sana) then //.. //ravakasti r‰v‰k‰sti  .. loppuun asti
      begin
         try
          if d then writeln('<li>koko::',reversestring(yy[i]),'/',reversestring(yy[i-1]),curlev) ;
          nodes[i].ed:=i-1;
          nodes[i-1].jump:=i;
          nodes[i-1].tie:=true;
          nodes[i].yhted:=nodes[i-1].yhted+1;
          //nodes[i].reftavs:=nodes[i-1].reftavs+1;
          nodes[i].lev:=min(a,nodes[i-1].lev);
          nodes[i].letter:=sana[curlev];
          lets[curlev].w:=i;
          //lets[nodes[i].lev-1].w:=i;
          //writeln('<li>samasana:',sana,a);
          break;
         except writeln('N???',i,yy[i]);raise;end;
      end;
  try
      if (lets[a].c=#0) //and (a<=curlev)
      then  //sana suoraa jatkoa edelliselle  .. ei tarpeen?
      begin
       try
        if d then writeln('//');
       nodes[i].yhted:=min(a,nodes[i-1].yhted+1);
       nodes[i].lev:=nodes[i-1].lev+1;
       //nodes[i].reftavs:=nodes[i-1].reftavs+1;
       nodes[i].letter:=sana[curlev+1];
       nollaa(curlev+1);
       nodes[i].ed:=i-1;
       if lets[a].w<>i then if nodes[lets[a].w].yhted>=nodes[i].yhted then  nodes[lets[a].w].jump:=i;
       curlev:=curlev+1;
       lets[curlev].w:=i;
       lets[curlev].c:=sana[curlev];
       nodes[i].lev:=curlev;
       break;
       except writeln('??');end;
      end else
      if lets[a].c<>sana[a] then  //kohta jossa poikkeaa edelt‰j‰st‰
      begin
        try
          if d then writeln('##',a);
          nollaa(a+1);
          nollaa(curlev+1);
          nodes[i].ed:=lets[a-1].w;
          nodes[i].yhted:=min(a,nodes[i-1].yhted+1);
         curlev:=a;//nodes[i].lev;
         if nodes[lets[a].w].yhted>=nodes[i].yhted then  nodes[lets[a].w].jump:=i;
         lets[a].c:=sana[a];lets[a].w:=i;
         nodes[i].lev:=a;//nodes[nodes[i].ed].lev+1;
         if d then writeln('%',lets[a-1].w);
         //nodes[i].reftavs:=nodes[lets[a-1].w].reftavs+1;
         nodes[i].letter:=sana[curlev];
        break;
        except writeln('<li>',i,' ',curlev,'?????pieleenmen',a,reversestring(yy[lets[curlev-1].w]));break;end;
      end
      else  begin  //keep going
        if d then writeln('.'); nodes[i].yhted:=a;end;
   except writeln('X???',i,yy[i]);raise;end;
   //type tnod=record ru_lyh,ru_pit,yhted,jump,ed,lev,len,tavucount:word;reftavs:integer;etu,tie:boolean;letter:ansichar;end;

   end;
   //finally //if d then writeln('\',nodes[i].reftavs,'\');      nodes[i].reftavs:=nodes[nodes[i].ed].reftavs;
   finally
     try
      nodes[i].reftavs:=nodes[nodes[i].ed].reftavs;
       if d then   with nodes[i] do writeln('<li>!:', i,' /lev:',lev,' /r:',ru_lyh,' ',ru_pit,' /yht:',yhted,'/ref',reftavs,'::',reversestring(sana), ' ');
     //if (pos(nodes[nodes[i].ed].letter,vokaalit)>0) AND (pos(nodes[i].letter,vokaalit)<1) then
        if (pos(nodes[i].letter,vokaalit)>0) and ((pos(nodes[nodes[i].ed].letter,vokaalit)<1)
        or (not isdifto(nodes[i].letter,nodes[nodes[i].ed].letter))) then
        nodes[i].reftavs:=nodes[i].reftavs+1;
          //nodes[lets[a-1].w].reftavs+1;
        except writeln('fianally???',i,yy[i]);raise;end;

   end;
  end;
  //FOR I:=0 TO 10000 DO WRITELN(yy[I]);
end;
procedure tsanasto.concor;
var numsf:textfile;line,s:ansistring;
    cc:array [0..35000] of array [0..15] of word;
    lnums:array[0..15] of word;
    function setnum(num:word):word;
     var j:word;
    begin
      for j:=0 to 15 do
       if lnums[j]=num then continue
       else if lnums[j]=0 then
       begin
         lnums[j]:=num;
         //lnums[0]:=lnums[0]+1;
         break;
       end;
    end;
    function setmat(a,b:word):word;
     var j:word;
    begin
      for j:=0 to 15 do
       if cc[a,j]=b then break
       else if cc[a,j]=0 then
       begin
         cc[a,j]:=b;
         break;
       end;
    end;
    procedure listmat;
    var row,col:word;
    begin
      for row:=0 to 30000 do
       if cc[row,0]<>0 then
       begin
         writeln('<li>',row,': ');
        for col:=0 to 15 do
        if cc[row,col]=0 then break else
         writeln(sanoja[cc[row,col]],',');
      end;
    end;

var i,j,n,b:word;c:integer;
begin
sanoja:=tstringlist.create;
sanoja.loadfromfile('sanat_ok.ansi');
assign(numsf,'syn_ok.num');  //synonyymit/liittyv‰t sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(numsf);
//writeln('<pre>');
for i:=0 to 30000 do cc[i,0]:=i;
c:=0;
 while not eof(numsf) do
 begin
  c:=c+1;//if c>5000 then break;
  readln(numsf,line);
  b:=1;
  //writeln('<li>');;
  for i:=1 to length(line) do
     if line[i]=',' then begin setnum(strtointdef(s,-999));s:='';end
    else s:=s+line[i];
  for i:=0 to 15 do if lnums[i]=0 then break else
   for j:=0 to 15 do if lnums[j]=0 then break else
    setmat(lnums[i],lnums[j]);
   //writeln(lnums[i]);
  fillchar(lnums,sizeof(lnums),0);
  cc[1]:=lnums;
 end;
 close(numsf);
 listmat;
end;

function tsanasto.generateverb(resus:tstringlist;snum:word):ansistring;

var runko,sisu,astva:str16;aresu:tstringlist;hakutakvok:boolean;
 lukn,sijax,prlim,x:integer;
sija,sikanum,ha,lkx:integer;
sika:tsija;
 d,vahvaluokka,vahvasija:boolean;
 gsana:string;
 luokka,sis,av,san:word;
 //curlkacursis,cura
  { $H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
  //mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;

function sijaa(sija:word;curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
var vokdbl,vokvex,konvex,kondbl:boolean;mid,myav,mysis,myend:ansistring;
begin
  try
   if sija=6 then exit;
   mysis:=cursis.sis;
   vahvasija:=true;

   myend:=reversestring(verbit.sijat[sija].ending);
   mid:=''+verbit.lmmids[luokka-52,sija];
   if curlka.vahva then begin if  sija in vvahvanheikot then vahvasija:=false;end
     else  if  sija in vheikonheikot then vahvasija:=false;
   myav:=ifs(vahvasija,avs[av].v,avs[av].h);     //writeln('[',mid,']');
   if (mid<>'') and (mid[1]='_') then
   begin
        if mysis='' then mysis:='ii' else begin MYSIS:=MYSIS[1]+MYSIS;delete(mid,1,1);end;
   end;
   if mid='!' then exit;
   if (mid<>'') and (mid[1]='*') then //mid[1]:=mysis[1];
      if mysis='' then  begin delete(mid,1,1);myav:=''; end else mid[1]:=mysis[1];  //loppuii vierasp sanoissa lka 5
   //if mysis=''then   mysis:='ii' else mySIS:=mySIS[1]+mySIS;  //loppuii vierasp sanoissa lka 5
   if (mid<>'')  and (mid[1]='-') then  begin delete(mid,1,1);delete(mysis,1,1); end;
     gsana:=reversestring(myend)+string(mid+mysis+myav+sans[snum].san+sans[snum].akon);
           //san; if konvex then if curlka.kot=60 then  delete(sana,1,1);  //vain "l‰hte‰" monikot l‰ksin
           //av:   if konvex then if myav<>'' then begin delete(myav,1,1);end;
           //sis;          if kondbl then if curlka.kot=67 then mysis:=MYSIS[1]+MYSIS;
                //                 if vokdbl then if mysis='' then mysis:='ii' else MYSIS:=MYSIS[1]+MYSIS;  //loppuii vierasp sanoissa lka 5
          //           if vokvex then f curlka.kot=64 //vied‰ vei then       delete(mysis,2,1) else delete(mysis,1,1);
       if not sans[snum].takavok then gsana:=etu(gsana);
       //if taka(gsana)<>taka(sanoja[snum]) then
       resus.add(gsana);
         //  writeln(' ',gsana);//,sija,vahvasija,verbit.lmmids[luokka-52,sija],'/',mid);
  except writeln('fail!!!');end;
end;

var curlka:tlka;
begin
  sija:=0;
  for lUOKKA:=0 to 78 do
  begin
    //writeln('<h4>LKA:',luokka,'</h4>');
    if lks[luokka].vikasana>=snum then
    begin
      curlka:=lks[luokka];
      vahvasija:=true;
      //if luokka<52 then
      begin
        for sis:=lks[lUOKka].ekasis to lks[lUOKka].vikasis do
        if siss[sis].vikasana>=snum then
         for AV:=SISS[SIS].ekaAV to SISS[SIS].VIKAAV do
          if avs[av].vikasana>=snum then
          //if avs[av].v<>avs[av].h then
          begin
           //writeln('<li>',snum,'#',luokka,sanoja[snum],';',curlka.kot,'.',reversestring(siss[sis].sis+'_'+avs[av].v+avs[av].h+'.'+sans[snum].san+sans[snum].akon),' ',luokka,curlka.vahva,siss[sis].sis,':');
           for sija:=0 to 45 do //sikoja do
           //for sija in [0,5,12,13,16,23,36,37,39,45] do //sikoja do
              sijaa(sija,curlka,siss[sis],avs[av],sans[snum]);
              //function sijaa(curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
              exit;
          end;
          exit;
        end;
      end;
         //for SAN:=AVS[AV].ekasana to avs[av].VIKAsana do
     //writeln('<hr>');
    end;
  end;

function tsanasto.generatenom(resus:tstringlist;snum:word):ansistring;
  function red(st:string):string; begin result:='<b style="color:red">'+st+'</b>';  end;
  function blue(st:string):string;  begin result:='<b style="color:blue">'+st+'</b>';  end;

var runko,sisu,astva:str16;aresu:tstringlist;hakutakvok:boolean;
 lukn,sijax,prlim,x:integer;
sija,sikanum,ha,lkx:integer;
sika:tsija;
 d,vahvaluokka,vahvasija:boolean;
 gsana:string;
 luokka,sis,av,san:word;
 //curlkacursis,cura
  { $H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
  //mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;

function sijaa(sija:word;curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
var vokdbl,vokvex,konvex,kondbl:boolean;mid,myav,mysis,myend:ansistring;
begin
  try
   mysis:=cursis.sis;
   vahvasija:=true;
   begin
     myend:=(nominit.sijat[sija].ending);
     mid:=nominit.lmmids[luokka,sija];
     if curlka.vahva then if  not (sija in nvahvanvahvat) then vahvasija:=false;  //vv hh
     if not curlka.vahva then if  (sija in nheikonheikot) then vahvasija:=false;  //vv hh
     myav:=ifs(vahvasija,avs[av].v,avs[av].h);     //writeln('[',mid,']');
     if (mid<>'') and (mid[1]='_') then
     begin
        if mysis='' then mysis:='ii' else begin MYSIS:=MYSIS[1]+MYSIS;delete(mid,1,1);end;
     end;
     if mid='!' then exit;
     if (mid<>'') and (mid[1]='*') then //mid[1]:=mysis[1];
        if mysis='' then  begin delete(mid,1,1);mysis:=myav; end else mid[1]:=mysis[1];  //loppuii vierasp sanoissa lka 5
     //if mysis=''then   mysis:='ii' else mySIS:=mySIS[1]+mySIS;  //loppuii vierasp sanoissa lka 5
     while (mid<>'')  and (mid[1]='-') do  begin delete(mid,1,1);if mysis='' then myav:=''  else delete(mysis,1,1); end;
     gsana:=reversestring(myend)+string(mid+mysis+myav+sans[snum].san+sans[snum].akon);
     if not sans[snum].takavok then gsana:=etu(gsana);
         //if taka(gsana)<>taka(sanoja[snum]) then
     //writeln(' ',gsana);//,sija,vahvasija,verbit.lmmids[luokka-52,sija],'/',mid);
     resus.add(gsana);
   end;
  except writeln('FAIL!!!');end;
end;

var curlka:tlka;
begin
  sija:=0;
  for lUOKKA:=0 to 50 do
  begin
    //writeln('<h4>LKA:',luokka,'</h4>');
    if lks[luokka].vikasana>=snum then
    begin
      curlka:=lks[luokka];
      vahvasija:=true;
      //if luokka<52 then
      begin
        for sis:=lks[lUOKka].ekasis to lks[lUOKka].vikasis do
        if siss[sis].vikasana>=snum then
         for AV:=SISS[SIS].ekaAV to SISS[SIS].VIKAAV do
          if avs[av].vikasana>=snum then
          //if avs[av].v<>avs[av].h then
          begin
           //writeln('<li>',luokka,sanoja[snum],';',curlka.kot,'.',reversestring(siss[sis].sis+'_'+avs[av].v+avs[av].h+'.'+sans[snum].san+sans[snum].akon),' ',luokka,curlka.vahva,siss[sis].sis,':');
           //for sija:=0 to 9 do //sikoja do
           for sija:=0 to  32 do //in [0,5,12,13,16,23,36,37,39,45] do //sikoja do
              sijaa(sija,curlka,siss[sis],avs[av],sans[snum]);
              //function sijaa(curlka:tlka;cursis:tsis;curav:tav;cursan:tsan):ansistring;
              exit;
          end;
          exit;
        end;
      end;
         //for SAN:=AVS[AV].ekasana to avs[av].VIKAsana do
     //writeln('<hr>');
    end;
  end;
 //for sana:=0 to 28000 do writeln(sans[sana].san);
 //exit;
{   d:=true;
   //d:=false;
    //if d then
    writeln('<h3>RUNKO:',runko,'/',astva,'/',sis,'</h3></ul>');
    //writeln('<li>',luokka,'/',scount);
    //for si:=0 to scount-1 do writeln('/',lmmids[luokka,si]);
    vahvaluokka:=luokka+52<63;
    for si:=0 to sikoja-1 do
    begin try
//!      mymid:=lmmids[luokka,si];
      if pos('?',mymid)>0 then continue;
//!      myend:=reversestring(sijat[si].ending);

      sofar:=runko;
      //writeln('[',mymid,'|',myend,']');
      //if pos('*',mymid)>0 then begin mymid[length(mymid)]:=sofar[length(sofar)];end;
      if pos('*',mymid)>0 then begin mymid[length(mymid)]:=SIS[length(SIS)];end;
//!      sika:=sijat[si];
      if vahvaluokka then vahvasija:=NOT(si in vvahvanHEIKOT)
      else vahvasija:=not (si in vHEIKOnheikot);
      if astva='' then myav:='' else
      if vahvasija then  myav:=astva[1] else
      if length(astva)>1 then myav:=astva[2] else myav:='';
      sofar:=sofar+myav+sis;

      while (mymid<>'') and (mymid[length(mymid)]='-') do begin delete(mymid,length(mymid),1);delete(sofar,length(sofar),1);end;
      if pos('!',mymid)=1 then continue;
      sofar:=sofar+reversestring(mymid);
      sofar:=sofar+myend;
      if not hakutakvok then sofar:=etu(sofar);
      if d then writeln('<li>',luokka+52,'#',si,' ',sofar,sana);//,' [',runko,'|',myav,'|',sis,'|',mymid,'|',myend,vAHVALUOKKA,']</li>');
       //if not hakutakvok then sofar:=etu(sofar);
      aresu.addobject(sofar,tobject(ptrint(sana)));
      except writeln('nomuoto',luokka,'#',si);end;
     end;
     if d then writeln('</ul>');
   //end;
 }
//end;
procedure tsanasto.expandlist(wlist:tlist;rlist:tstringlist);
var j,snum:word;
begin
 //writeln(' _!!!!!!!!',wlist.count);
  for j:=0 to wlist.count-1 do
  begin
    snum:=integer(wlist[j]);
    //writeln(' <li>',snum,' ');
    if snum<19547 then
     generatenom(rlist,snum)
    else
     generateverb(rlist,snum);
  end;
end;
function tsanasto.haenumero(sana:ANSISTRING):word;
var eitaka,eietu:boolean;akon,koko,loppu:ansistring;aresu:tstringlist;onjolista:tlist;
   hits,myhit:word;
begin
akon:='';

voksointu(sana,eietu,eitaka);
koko:=sana;
while pos(sana[1],konsonantit)>0 do begin akon:=sana[1]+akon;   delete(sana,1,1); end;
loppu:=taka(reversestring(sana));

//continue;

//exit;
//resst:=resst+
myhit:=etsiyks(loppu+akon,koko,'',eietu,eitaka,verbit.sijat[0],aresu,onjolista,hits);
if myhit=0 then myhit:=etsiyks (loppu+akon,koko,'',eietu,eitaka,nominit.sijat[0],aresu,onjolista,hits);
//etsiyks (HAKUNEN.loppu+hakunen.akon,hakunen.koko,'',hakunen.eietu,hakunen.eitaka,sika,aresu,onjolist,hits);
     writeln('<li>hit;',sana,'#',myhit);
     result:=myhit;
end;
procedure tsanasto.numeroikaikki;
var instream,hitfs,misfs:tfilestream;
     inf,synf,sanaf,misfile,numfile:textfile;
     sana,prevsana,hakurunko,akon,hakukoko,hitline:ansistring;
     hakueietu,hakueitaka:boolean;
     j,hitnum,ghits,hits:word;
     cc:integer;
     linehits,tries:tlist;
     olisana,ekasana:boolean;
     resus:tstringlist;
     muodot:tmuotolista;
     //sanalista:tst
begin
 writeln('<h1>haenum:</h1>',haenumero('voida'));
 sanoja:=tstringlist.create;       ////  ae ao ea eo ia io oa oe ua ue
 sanoja.loadfromfile('haku.lst');
 //sanoja.commatext:='vaaitsemalla,aatos';//paatti,pataraatti,mataatti,tiilla,tialla,raanulla,haella,haulla,hulla,tulla,puraisulla,sulla,muraisulla,voida,voit,puulla,uulla,ulla,alla,olla,talla,tolla,koivulla,voivulla,vuivulla,xulla,knulla,vuikukulla,vaikulla,vavalla,tavalla,kavavalla,zalla,ella,luulla,kuulla,keinulla,stulla,ktulla,voipivulla,katialla';
 //sanoja.commatext:='aa,xatora,kavatora,kivatora,ravatora,kvora,kora,vora,xora,atora,autora,avora,vatora,katora,hatora,matora,lavatora,kaora,kura';  //isona,ailla,pukisona,isona,risona,asia,iarilla,taioin,sialla,urha,murha,vurha,kukkavurha,kieltolailla,turha,illa,rilla,osasilla,trilla,arilla,aarilla,villa,loilla,vailla,hilla,krilla,tilla,stilla,ztilla,puttosilla,tuolla,maulla,silla,asasilla,soilla,tsilla,pussilla,risasilla,isasilla,haalla,ahilla';
 //sanoja.commatext:='xaa,jakoon,sorrettakoon, purettakoon, pingottakoon, neuvottakoon, kuivuttakoon';
 // writeln(sanoja.text);//:='ampua';
 //for j:=0 to sanoja.count-1 do begin writeln('<li>',sanoja[j],':');teenoodi(reversestring(sanoja[j])); end; exit;

 tries:=tlist.create;
 resus:=tstringlist.create;
 {
 for j:=0 to sanoja.count-1 do tries.add(pointer(haenumero(sanoja[j])));
//sanoja.loadfromfile('testisanat.ansi');
writeln('<h1>expand</h1>',sanoja.text);

FOR j:=0 TO TRIES.COUNT-1 DO writeln(integer(tries[j]));
expandlist(tries,resus);
}
//resus.commatext:='allup,allu,allum,allumaa,all,allus,allubusin,ilut,ilus,iluah,iluviah,iluv';
//writeln('<h3>sanoja</h3>',sanoja.text);
resus.duplicates:=dupIgnore;
resus.sorted:=true;
 for j:=0 to 20 do //sanoja.count-1
   resus.add(trim(reversestring(ansilowercase(sanoja[j]))));//+'al');
resus.sort;
//writeln('<h1>expanded</h1>',resus.text);

//FOR j:=0 TO resus.COUNT-1 DO writeln(reversestring(resus[j]));

//for j:=0 to 0 do tries.add(pointer(19538+random(5500)));
//for j:=0 to 0 do tries.add(pointer(random(19538)));
//writeln('<h3>expand:</h3>');
//for j:=0 to resus.count-1 do writeln(reversestring(resus[j]));
muodot:=tmuotolista.create;
writeln('<h3>taulut',resus.count,'</h3>');

muodot.teetaulu(resus);
try
writeln('<h3>Tehtytaulut',resus.count,'</h3>');

muodot.riimit(resus);
except writeln('eionnaa');end;
exit;
{for j:=52 to 78 do //26000 do
begin generateverb(resus,lks[j-1].vikasana+1);
generateverb(resus,lks[j].vikasana);end;
for j:=1 to 49 do //26000 do
begin
   //generatenom(lks[j-1].vikasana-1);
   generatenom(resus,lks[j].vikasana-1);
end;
 exit;
 }
 concor;exit;
 linehits:=tlist.create;
//inf:=tfilestream.create('wikithe.txt',fmopenread);  //synonyymit/liittyv‰t sanat
//assign(inf,'gutsanat.iso');  //synonyymit/liittyv‰t sanat
//assign(inf,'sense.nums');  //synonyymit/liittyv‰t sanat
//assign(inf,'wikithe.ansi');  //synonyymit/liittyv‰t sanat
assign(inf,'syn_allx.ansi');  //synonyymit/liittyv‰t sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(inf);
assign(synf,'syn_ok.ansi');  //synonyymit/liittyv‰t sanat
rewrite(synf);
assign(sanaf,'sanat_ok.ansi');  //synonyymit/liittyv‰t sanat
rewrite(sanaf);
assign(misfile,'testimiss.the');  //synonyymit/liittyv‰t sanat
assign(numfile,'syn_ok.num');  //synonyymit/liittyv‰t sanat
rewrite(misfile);
rewrite(numfile);

fillchar(sanataulu,sizeof(sanataulu),0);
  cc:=0;
  hitcount:=0;eitaivu.hitcount:=0;
  writeln('<li>xxx');
  //hitfs:=tfilestream.create('wikithe.txt',fmcreate);  //numerolista
  //misfs:=tfilestream.create('wikithe.txt',fmcreate);  //tunnistamattomat pohditaviksi
  try


    while //(cc<1000000) and
   (not eof(inf))  do
    begin
     try
     cc:=cc+1;
      if cc>212388 then break;
      //if cc>10000 then break;
     readln(inf,sana);
     if sana='' then
     begin
         //writeln('<hr>');
         if olisana and (ghits>1)then
         begin
          //writeln(' //',prevsana,integer(linehits[0]));
          sanataulu[integer(linehits[0])]:=copy(prevsana,1,20);
           writeln(synf,hitline);
           for j:=0 to linehits.count-1 do write(numfile,inttostr(integer(linehits[j]))+',');
           if (linehits.Count>0) then  writeln(numfile,'') else writeln(numfile);
           end;// else  writeln(reversestring(sana));
           ghits:=0;hitline:='';
         linehits.clear; olisana:=false;ekasana:=true;continue;
     end;
     //if sana<>'tyt‰r' then continue;
     sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
     sana:=stringreplace((sana),'-','',[rfReplaceAll]);

     if ekasana then prevsana:=sana;
     sana:=reversestring(sana);
     akon:='';
     //if sana='' then begin writeln(outf,'*****');continue;end else
     voksointu(sana,hakueietu,hakueitaka);
     if hakueitaka and hakueietu then   continue;   //autorit‰‰risten harmiksi
     hakurunko:=taka((sana));
     hakukoko:=sana;
     hits:=0;
     hitnum:=etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,nominit.sijat[0],nil,nil,hits);
     if hakurunko[1]='a' then
     //res:=res+
     if hitnum=0 then hitnum:= etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,
     verbit.sijat[0],nil,nil,hits); //verb permuo p‰‰ttyy "a"
     if hitnum=0 then begin hitnum:=eitaivu.sexact(sana,eitaivu.sanalista);if hitnum<>0 then hitnum:=26000+hitnum;end;
     //if hits>0 then writeln('!!!',hitlist[hitcount],sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon);//<li>H: ',sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon,'#',hitlist[hitcount]);
     if hits=0 then if hitnum>0 then hits:=hits+1;// else writeln('<li>;:',reversestring(sana),'</li>');
     if ekasana then if hits>0 then olisana:=true;
     //if ekasana then writeln('<li>',reversestring(sana),hitnum);
     ekasana:=false;
     //if hits>1 then writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
     //if hitnum>>0 then writeln(misfile,hitnum,',',string(sana));
     //writeln('<li>',reversestring(sana),'/ekako:',eka,' /sanako:',olisana,hitnum,' ',hits);
     //if hits=0 then writeln(misfile,sana)   else //
     if hits>0 then
      begin
        //hitline:=hitline+^j+reversestring(sana);ghits:=ghits+1;
        hitline:=hitline+reversestring(sana)+',';ghits:=ghits+1;
        linehits.add(pointer(hitnum));
        //writeln('<li style="color:green">',reversestring(sana),'</li>')
        //if (hits mod 10<>0) then
        //writeln('+');//<li>',akon,sana,'=',trim(res),' ',cc,'!',hits);
//        writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);
          // else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
          ;//else  writeln('<li><b>y:',akon,sana,'=',trim(res),' ',cc,'</b>',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
       end;
     except   writeln('<li>EiEtsi',sana,sana='','!');end;
     //if cc>20000 then break;
     //writeln('<li>',sana,res,hits);
   end;
    writeln('<li>didit');
  finally
    close(inf);
    close(synf);
    close(misfile);
    close(numfile);
  //hitfs.free;misfs.free;
  end;
  for cc:=0 to 30000 do  writeln(sanaf,resus[cc]);
  closefile(sanaf);
end;

constructor tsanasto.create;
var i:word;h:thakunen;slist:tstringlist;
begin
{writeln(' <style type="text/css">div div div{ font-size:1px;border:1px solid green;margin-left:1em} ');
//+^m+' div div div{ font-size:0.5em} '+^m);
writeln('div div:hover div { display:block;font-size:1em;background:#ddd}');
writeln('xdiv div div:hover div div{ display:block;font-size:0.5em;background:#ff9}</style>');
writeln('<div> x<div> y<div> z</div></div></div>');
//exit;0}
//do99;exit;
luesanat('sanatuus.csv');
verbit:=tverbit.create('sanatuus.csv','vmids.csv','vsijat.csv');
nominit:=tnominit.create('nomsall.csv','nmids.csv');
eitaivu:=tmuotolista.create;
slist:=tstringlist.Create;
slist.Delimiter:=' ';slist.StrictDelimiter:=true;
//yy.LoadFromFile('sanatall.ansi');
slist.LoadFromFile('eitaivu.lst');
//FOR I:=10000 TO 15000 DO  WRITELN(YY[I]);  EXIT;
slist.sort;
slist.Insert(0,'');
eitaivu.teetaulu(slist);
writeln('<h3>Numeroi:</h3>');

//do99;exit;
numeroikaikki;
writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<hr>');
//verbit.listaasijat;//exit;
exit;
writeln('ccccccccccccccc',verbit.lmmids[15,0],'!');
//nominit.sanat:=sans^;
//nominit.listaa;
 //nominit.siivoosijat;
 haemuodot;
end;

procedure tsanasto.haemuodot;
var i:word;
begin
   luohaku('haku.lst');
    for i:=0 to hakulista.count-1 do
    begin
        etsimuodot(thakunen(hakulista.objects[i]),nil,nil);
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
      avs[cav].takia:=0;  //takavokaalisten m‰‰r‰  .. ei k‰ytet‰ viel‰
      avs[cav].v:=sl[2];
      avs[cav].h:=sl[3];
      if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"_" k‰ytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
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
  // t‰mmˆnenkin toimii:  for i in vahvatverbiluokat+vahvatnominiluokat do  writeln(i);
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
    if differ=3  then differ:=2;      // av-heikot erosivat mutta vahva oli sama. yhdistet‰‰n - AV ylip‰‰t‰‰n oli eri
    if (differ<1) then uusluokka;
    if (differ<2) then  uussis;
    if (differ<4) then uusav;
     alko:=false;
         //if sl[4]='0' then avs[cav].takia:=csan+1; //pit‰is olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen
      csan:=csan+1;

    sans[csan].san:=(sl[5]);
    sans[csan].takavok:=sl[4]='0';
    sans[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten m‰‰r‰‰ av-luokassa hakujen tehostamiseksi
    //csan:=csan+1;
    alko:=false;
    prevsl.commatext:=sana;  //t‰h‰n taas seuraavaa sanaa verrataan
    prlim:=prlim+1;  //just for debug to make managable listings .. not used
    except writeln('failav');end;
   end;
    writeln('<h1>LKS:',CLKa,' /sis:',csis,' /av:',cav,' /w:',csan,'</h1>');
    for i:=0999 to clka do
    begin
       writeln('<li>',i, '>',lks[i].vikasana,'<ul>');
       for j:=lks[i].ekasis to lks[i].vikasis  do
       begin
          writeln('<li>',j,'si:<b>',siss[j].sis, '</b> >',siss[j].vikasana,'<ul>');
          for k:=siss[j].ekaav to siss[j].vikaav  do
          begin
             writeln('<li>',k,':av<b>',avs[k].av,avs[k].v,avs[k].h, '</b>>',avs[k].vikasana,'<ul>');
             writeln('<li>',avs[k].ekasana,reversestring(sans[avs[k].ekasana].san+sans[avs[k].ekasana].akon),' ',avs[k].vikasana,reversestring(sans[avs[k].vikasana].san+sans[avs[k].vikasana].akon));

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

function listsija(sika:tsija):string;
begin
   with sika do  result:=' [['+inttostr(num)+' '+ name+' ('+esim+') '+inttostr(vparad)+' '+inttostr(hparad)+'):<b>'+ending+'</b>]] ';
end;

function tsanasto.etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):word;
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi:string;
    curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;
    resunum:word;//mysika:tsija;
    //cutvok,cutav:integer;
    //cut_si,cut_av,cut_lka,cut_san,i,j:integer;
    tc,hakutc:integer;
    luokka:word;//xskipped:string;
     d,heikkomuoto:boolean;
     //hakuakon:string;
     //siat,sikanum,lu:integer;sika:tsija;
     resst:string;
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
      var kokosana,myskip:string;
      begin
        try

        KOKOsana:=reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sana+sans[sa].akon);
        if not (sans[sa].takavok) then kokosana:=etu(kokosana);
       resst:=kokosana;//('<b style="color:green" title="'+inttostr(curlka.kot)+'#'+inttostr(sika.num)+'##'+inttostr(sa)+' '+inttostr(sa)+'">'+KOKOSANA +'</b> ');
       if d=d then writeln('hitti:'+resst);
       hitcount:=hitcount+1;
       hits:=hits+1;
        hitlist[hitcount]:=sa;
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
           tc:=1;//pit‰is olla tavurajalla, eli tavu on aloitettu.. ei ei: saa uurtaa   -> RUU   aie he > ia   kapusta  ja -> SUPA
           olivok:=''; //
           for i:=1 to length(sana) do
           begin
             if pos(sana[i],vokaalit)<1 then //konsonantti
             begin
              if olivok<>'' then begin tc:=tc+1;olivok:='';end  //konsonanti vokaalin edell‰
              else //kaksoiskonsonantti .. ei mit‰‰n
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

      function sana_f(san:integer;koita,skipped:string):boolean;
      var i,j:word;hakujatko,sana,kokosana:string;yhtlen,slen,hlen:word;//osataka,osaetu:boolean;
      begin
      try
       try
      //if skipped<>'' then write
      cursan:=sans[san];
      sana:=cursan.san;
      //if san=24567 then
       if d then writeln('<li>',luokka, blue(sana+cursan.akon),'/',red(koita+hakuakon),(skipped+sana+cursan.akon=koita+hakuakon),'/ ',kondbl,konvex,' ',hakusana,(skipped+sana+cursan.akon)<>(koita+hakuakon),'/',san
       ,cursan.takavok,hakueitaka,(cursan.takavok) and (hakueitaka),skipped);

      if konvex then if curlka.kot=60 then  delete(sana,1,1);  //vain "l‰hte‰" monikot l‰ksin
      result:=false;
       if d then writeln('/S:',red(koita),blue(sana+'.'+cursan.akon+'/'),skipped);
      //if xvok<>'' then if length(sana)>0 then delete(sana,1,1);//sana[1]:=xvok[1];
      //if xvok<>'' then writeln('<li>[**',xvok,'/',sana,']');
      //if sana=koita then //if cursan.akon=hakunen.akon then
      if sana+cursan.akon=koita+'' then //if cursan.akon=hakuakon then
      begin
         //fullhit(sana,koita,san);
         hits:=hits+1;
          if d=d then writeln(' <em style="color:green">',reversestring(lkasopi+''+sissopi+''+avsopi+''+sana+cursan.akon) ,'</em> ');
          hitcount:=hitcount+1;
          hits:=hits+1;
           hitlist[hitcount]:=san;
           resunum:=san;
         //resst:=' ';
         //writeln('HIT,exiting for now');
         result:=true;
         exit;
      end;
      //else if (sana='') or (pos(sana,koita)=1) then shorthit(sana,koita,san)
      //else if (koita='') or (pos(koita,sana)=1) then longhit(sana,koita,san)
      //if resst<>'' then exit;
      if (skipped+sana+cursan.akon=koita+hakuakon) // then exit;
      or (skipped+sana+cursan.akon='') or // (sana='') and          uull  amdma
       ((pos(skipped+sana+cursan.akon,koita+hakuakon)=1) ) then
      begin          //sikasopi+''+ lkasopi+'' +sissopi+''+avsopi+''+sans[sa].san+sans[sa].akon
          kokosana:=lkasopi+''+sissopi+''+avsopi+''+sana+cursan.akon;
          //resst:=string(' !!'+sikasopi+'.'+lkasopi+'_'+sissopi+'.'+avsopi+''+'+'+koita+hakuakon+' '+inttostr(san));

          //if (skipped+sana+cursan.akon<>koita+hakuakon)  then
          begin
            if ((cursan.takavok) and (hakueitaka)) or (not(cursan.takavok) and (hakueietu)) then
            begin  ///etutakah‰ss‰kk‰:kiirastorstai/t/                                                   eit:FALSE         /eie:TRUE         /t:FALSE kiirastorstai=torstai 1593!2
             if d then writeln('<li>ET:'+reversestring(hakusana),'/',reversestring(sana),cursan.akon,'/eit:',hakueitaka,'/eie:',hakueietu,'/t:',cursan.takavok
             , ' <b>'+reversestring(skipped+sana+cursan.akon)+'!='+reversestring(koita+'.'+hakuakon),'\</b>',san,kokosana,'???',hakukoko );
              if cursan.takavok then for i:=1 to length(kokosana) do if pos(hakukoko[i+length(kokosana)],'‰ˆy')>0 then exit;
              if (cursan.takavok) then for i:=0 to length(kokosana)-1 do if pos(hakukoko[length(hakukoko)-i],'‰ˆy')>0 then exit;// else write(length(hakukoko)-i,hakukoko[length(hakukoko)-i]);
              if not(cursan.takavok) then for i:=0 to length(kokosana)-1 do if pos(hakukoko[length(hakukoko)-i],'aou')>0 then exit;// else write(length(hakukoko)-i,hakukoko[length(hakukoko)-i]);
               if d then        writeln('***</li>')
            end;// else hits:=hits+1;
            if (skipped+sana+cursan.akon<>koita+hakuakon)  then
             hits:=hits+0 //
            else hits:=hits+0;
          end;// else hits:=hits+1;
          if hits>0 then resst:=resst+' '+reversestring(kokosana)+sikasopi;//+'"/'+copy(hakusana+hakuakon,length(kokosana)+1)+'/s:'+inttostr(san)+' '+inttostr(luokka)+'#'+inttostr(sika.num)+'['+skipped+']';
      end;
      if (koita='') or (pos(koita,sana)=1) then if d then writeln('<li>longhit '+reversestring(hakusana),'/',reversestring(skipped+'-'+sana+cursan.akon));
      //else if cursan.san='' then}
      //writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
      //reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);
       except writeln('!failsana');  end;
       finally //writeln('/sana:', result);
       END;
      end;

      function av_f(av:integer;koita,skipped:string):boolean;
      var san,i,j:integer;myav:string;
      begin
        //if skipped<>'' then writeln('<li>skipav:',skipped);
        result:=false;;
        curav:=avs[av];
        myav:=ifs(heikkomuoto,curav.h,curav.v);
        if d then
         writeln('<li>{',blue(myav),'}',curav.v,'/',curav.h,curlka.kot,curlka.vahva,konvex,red('try:'+koita));//+xvok),blue(myav),' :',curav.v,curav.h,'/',curav.ekasana,'-',curav.vikasana);
        //if d then writeln('<li>(',myav,'=',curav.v+'/',curav.h,'\',konvex,')',red(koita),blue(myav),'/hm:',heikkomuoto,'/ver:',isverb,'/vah:',curlka.vahva);
        if konvex then if myav<>'' then begin delete(myav,1,1);end;
        if koita='' then begin avsopi:='';skipped:=skipped+myav;avjatko:='';if d then writeln('<li>AVX:',red(koita),blue(myav)) end else
        begin
          if (myav='') or (pos(myav,koita)=1)  then //result:=true
          else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
                end;
          avjatko:=copy(koita,length(myav)+1,99);//xvok;
          avsopi:=copy(koita,1,length(myav));//xvok;
        end;
        //avsopi:=myav;

          if d then writeln('/AV:',red(avjatko),blue(avsopi),' ',curav.ekasana,'..',curav.vikasana,heikkomuoto,'<ul>');
          try
          //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
           writeln('?',result);
          for san:=curav.ekasana to curav.vikasana do //!!!
                if sana_f(san,avjatko,skipped) then begin write('gotsana');result:=true;exit;end;
           if d then writeln('...',result,'</ul>');
        except writeln('faILAV!!!');end;
      end;

      function sis_f(sis:integer;koita,skipped:string):boolean;
      var av,i,j:integer;mysis:string;
      begin
        //  if skipped<>'' then writeln('<li>skipsis:',skipped);
        result:=false;
        cursis:=siss[sis];
        mysis:=cursis.sis;
         if kondbl then if curlka.kot=67 then mysis:=MYSIS[1]+MYSIS;

        if vokdbl then if mysis='' then mysis:='ii' else MYSIS:=MYSIS[1]+MYSIS;  //loppuii vierasp sanoissa lka 5
        if d then writeln('<li>sisu:',red(koita),'/',blue(mysis+'!'),vokvex,'/',cursis.ekaav,'-',cursis.vikaav,vokdbl,'2x:',kondbl);
        //writeln('<li> ', curlka.kot,' ',sis,cursis.sis,'#',cursis.ekaav,'-',cursis.vikaav);
        if koita='' then BEGIN sisjatko:='';skipped:=skipped+mysis; sissopi:='';END     //what the fuck?
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

          if (mysis='') or (pos(mysis,koita)=1) then //result:=true
          else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
          end;
          sisjatko:=copy(koita,length(mysis)+1,99);
          sissopi:=copy(koita,1,length(mysis));
          //writeln(red(koita),'qqq');
          //sissopi:=mysis;
        END;
         if d then writeln('<li>SisHit:',red(koita),'/',blue(mysis+'!'),vokvex);
         if  d then   write('<b>/sovita:',sisjatko,'|sopi:',sissopi,'\</b>');
          //if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
          if d then writeln('<ul>');
        for av:=cursis.ekaav to cursis.vikaav do
         if av_f(av,sisjatko,skipped) then begin writeln('+++');result:=true;exit;end;
          if d then writeln('</ul>');

      end;
      function lka_f(lka,sija:integer;koita,skipped:string):boolean;  //vain verbille
      var sisus,i,j:integer;mid:string;repeats:integer;
      begin
       //if skipped<>'' then writeln('<li>lka:',skipped);
      luokka:=lka;
        //if lka<>5 then exit;
        curlka:=lks[lka];
        isverb:=lka>51;
        repeats:=1;
        result:=false;
        //if curlka.kot<>62 then exit;
        if isverb then
        begin
          if luokka=68 then repeats:=2;  //kaikilla 68'illa on kaksi taivutustapaa
          if (luokka in [55,57,60]) then if sika.vparad=6 then repeats:=2;
          if (luokka in [76]) then if sika.vparad=5 then repeats:=2;
          if (luokka in [74,75]) then if sika.vparad=9 then repeats:=2;
        end;
       repeat
        if isverb then
          mid:=verbit.lmmids[lka-52,sija] else
          mid:=nominit.lmmids[lka,sija];
         if mid='!' then exit;
        //dbl:=false;    eatkon:=false;

        vokvex:=false;vokdbl:=false;konvex:=false;kondbl:=false;
        //if curlka.vahva then para:=sika.vparad else para:=mysika.hparad ;
        if d then writeln('<li>TRY:',lka,'#',sija,' <b>[',repeats,blue(mid),'/',red(koita), '] </b>');//,curlka.kot,'!',isverb,verbit.lmmids[15,0]);
        if (luokka=71) then { if ((sika.hparad=2) and  (sija>10)) then     //ifs(isverb,verbit.lmmids[lka-52,sija],nominit.lmmids[lka,sija])
        begin IF D THEN writeln('<li>!!!???');//mid:='k'
        end else    }
          if  (sija in [23,28]) then begin IF D THEN writeln('!!!');mid:='k'; end;
        //aint it pretty?
        if isverb then
        begin
        if luokka=68 then if repeats=2 then begin mid:=verbit.lmmids[10,sija];end;
        if repeats=2 then if luokka=55 then if sika.vparad=6 then  begin mid:='';end; //soutaa sousi
        if repeats=2 then if luokka=57 then if sika.vparad=6 then  begin mid:='o';end; //kaatoi kaasi
        if repeats=2 then if luokka=60 then if sika.vparad=6 then  begin mid:='sk';konvex:=true;end; //huom vain luokan 60  - vain "l‰ksin l‰ksit"
        if repeats=2 then if luokka=76 then if sika.vparad=5 then  begin mid:='*nn';;end;  //tiennen, tainnen
        if repeats=2 then if luokka in [74,75] then if sika.vparad=9 then  begin mid:='';end; //katketa nimet‰ katkeisi/katkeaisi
        end;
        //if lu=71 then if (sija in [23,28]) then mid:='-k';
        repeats:=repeats-1;
        result:=false;
        //cutav:=0;cutvok:=0;xvok:='';
       // if mid<>'' then
       // case mid[1] of
       //  '*': dbl
        if (mid<>'') and (mid[1]='*') then
           if luokka=67 then begin delete(koita,1,0);delete(mid,1,1);kondbl:=true;end
           else begin delete(mid,1,1);konvex:=true;end;

        if (mid<>'') and (mid[1]='_') then begin if d then write('????',mid);vokdbl:=true;delete(mid,1,1);end;
        if (mid<>'') and (length(koita)>0) and (mid[1]='-') then
         begin vokvex:=true;delete(mid,1,1);delete(koita,1,0);; end;
         //av-konsonanttia ei vaadita kun on joku vakkari (s) tilalla
        if d then writeln('<li>DOTRY:',vokvex,lka,curlka.esim,' #',sija,'<b>(mid:',blue(mid),')/',//lmmids[lka,sija],
          '/</b>'    ,ifs(curlka.vahva,'v:'+inttostr(sika.vparad),'h'+inttostr(sika.vparad)),'=',' koita:',red(koita),' / ', blue(mid),vokvex,vokdbl,konvex,kondbl,'///',curlka.ekasis,'-',curlka.vikasis,'::',repeats,'</li>');
        //exit;
        if (mid='') OR (pos(mid,koita)=1) then //result:=true
        else
        begin
           // kum+ajaa s+aa   //62naida a / -12-12:: /ei:a-
           if  (koita='') or (pos(koita,mid)=1) then
            begin  if d then writeln('//EOW:',koita,mid);
               skipped:=skipped+copy(mid,length(koita)+1);
               koita:='';
            end else
            begin  if d then write('<li>/ei:',blue(koita),red(mid));
           continue;
           end;
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
         if sis_f(sisus,lkajatko,skipped) then begin result:=true;exit;end;
        if d then writeln('</ul>');
       until repeats<=0;
      end;
// tsanasto.etsiyks(
var i,j,lu:word;
begin
 try
try
d:=false;
resunum:=0;
//d:=true;
sikaloppu:= copy(hakusana,length(sika.ending)+1);
sikasopi:= sika.ending;
resst:='';
//for i:=1 to 58 do writeln(lks[i].kot,lks[i].vahva);
if d then writeln('<li>etsiyksi:',hakusana,'-->',sikaloppu,'+',sika.ending,sika.onverbi);
if sika.onverbi then
 begin for lu:=52 to 78 do if lka_f(lu,sika.num,sikaloppu,'') then begin writeln('HIOT',resunum);result:=resunum;break;end;
end
else for lu:=1 to 50 do if lka_f(lu,sika.num,sikaloppu,'') then begin result:=resunum;break;end; // skipped vois olls <> ''
//if eitaivu.sexact(hakusana) then writeln('!%%%');
//if resst='' then writeln(' --',reversestring(hakusana+hakuakon));
//if hits>1 then
//result:=resst;
//hitlist[9]:=1;
except writeln('<li>failetsi');end;
  finally result:=resunum;//writeln('<li>res:',resunum);
  end;
end; //etsi


procedure tsanasto.etsimuodot(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
type psika=^tsija;
var sikalauma:tstringlist;passed:string;
     lu,siat,i,j,hits:word;
     sikap:psika;d:boolean;
     sika:tsija;
     sikaloppu,sikasopi,resst:string;
     hakueitaka,hakueietu:boolean;
begin
try
    //vhitlist.clear;
     d:=false;
  //   d:=true;
     sikalauma:=tstringlist.create;

     try
     sikalauma.clear;
     //if isverb then verbit.haesijat(hakunen.loppu,sikalauma)
     //else


     nominit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan
     verbit.haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p‰‰te m‰ts‰‰ hakusanaan

     //if d then     for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),nominit.sijat[ptrint(sikalauma.objects[siat])].ending);
     //if d then   writeln('<li>hae:',hakunen.akon,'|<b>',string(hakunen.koko),'</b>:',sikalauma.count);//,'<ul></li>');
     except writeln('faildosiat');end;
     //resst:='';
     hits:=0;
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
        //sika:=(sikalauma.objects[siat]^);
        //sikap:=psika(sikalauma.objects[siat]);
        sika:=psika(sikalauma.objects[siat])^;
        //sikanum:=sika.num;
        //sikanum:=ptrint(sikalauma.objects[siat]);
        //if sikanum<>0 then continue;
        //if hakunen.isverb then sika:=verbit.sijat[sikanum] else     sika:=nominit.sijat[sikanum];
        sikaloppu:= copy(hakunen.loppu,length(sikalauma[siat])+1);
        if sikaloppu='' then begin continue;passed:=copy(sika.ending,1,length(hakunen.loppu));
           sikasopi:=copy(sika.ending,length(hakunen.loppu),999);writeln('<li>HAKLO:',passed,'/',hakunen.loppu,'/',sikasopi);end
        ;//else continue;
        //sikasopi:=sika.ending;//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        sikasopi:=sikalauma[siat];//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        //writeln('<li>ss:',sikasopi);
//        hakutc:=tavucount(hakunen.koko);
        //if d then
        //writeln('<li>muoto:',reversestring(sikaloppu),'|',reversestring(sikasopi),' //<b>',reversestring(sika.ending),'#</b>',sika.num,'! ',hakunen.koko,hakutc);
//        hakutc:=hakutc mod 2;
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        if d then writeln('<li>HAKUNEN:',hakunen.lk,'#',sika.num,'><b>',hakunen.akon,reversestring(sika.ending+'.'+sikaloppu),'</b> {',listsija(sika),'} ');
        //continue;
        if d then writeln('<ul>');

        //exit;
        //resst:=resst+
        etsiyks (HAKUNEN.loppu+hakunen.akon,hakunen.koko,'',hakunen.eietu,hakunen.eitaka,sika,aresu,onjolist,hits);
        //if sika.onverbi then begin for lu:=52 to 78 do lka_f(lu,sikanum,sikaloppu,passed);end
        //else begin for lu:=1 to 50 do lka_f(lu,sikanum,sikaloppu,passed);end;
//4 do
         //???? if (hakunen.lk=0) or (hakunen.lk=lu) then
         //if lu=48 then
          //lka_f(lu,sikanum,sikaloppu,passed);

        if d then writeln('</ul>');
     end;
     if hits>1 then
       writeln('<li>resst::',hakunen.koko,' :',resst,'</li>');//,hakunen.lk,' #',sika.num,'><b>',listsija(sika),'</b> ',sikaloppu,'/ea:',hakueitaka,'/e‰',hakueietu,'</li>');
     if d then writeln('</ul>');

except writeln('<li>failetsi');end;

end; //etsimuodot

end.

