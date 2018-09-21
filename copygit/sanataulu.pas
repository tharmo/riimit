unit sanataulu;

{$mode objfpc}{$H+}

interface
//voi olla ettei tästä omaa luokkaa kantsuis tehdä
//tai ehkä luokka pitäis tehdä  sanatauluista, hakutaulu on vain yksi.
//taipumattamattomat sanat ovat toinen. Eli yhdistetään luokkaan teitaivu
 //sanataulujen yks metodi on hakea keskenäiset riimit
uses
  Classes, SysUtils;
type tsan=record san:string[15];akon:string[4];takavok:boolean;end;
type tnod=record ru_lyh,ru_pit,ru_lyly,yhted,jump,ed,lev,len,tavucount:word;reftavs:integer;etu,tie:boolean;letter:ansichar;end;
type tlet=record c:ansichar;w:word;end;

type tstaulu=class(tobject)
   eds:tstringlist;
   lets:array[0..64] of tlet;
   //jumps,palalen:array[1..2068] of word;
   nodes:array[0..28088] of tnod;
   //xnodes:array[0..12000] of txnod;
   //xnn:word;
   lres,sres:tstringlist;
   eithits:array[1..30000] of word;
   hitcount:word;
   slista:tstringlist;
   sanalista:tstringlist;
   procedure listaa;
   //procedure riimit;
   procedure ETSIlista;
   procedure teetaulu;
   function numeroi:tlist;
   procedure riimaa;
    // procedure do99;
   function sexact(haku:ansistring;yy:tstringlist):word;  //kutsutaan kun haku on edellyt ekaan (käänt) vokaaliin
   constructor create(fn:string;sl:tstringlist);
  end;
  ///type triimihaku=class(tobject)
  //  procedure luohaku;
  //end;
implementation
uses strutils,riimiuus,riimiutils,math;

procedure tavutnoodi(VAR node:tnod;san:ansistring);
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
     else  //vokaali vokaalin jälkeen
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
  if tavus>3 then   //ei etsitä yhdeb tavun riimejä. joskus kyllä haluttaisiin
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

constructor tstaulu.create(fn:string;sl:tstringlist);
var  //stmp:tstringlist;
    j:integer;
begin
  writeln('<li>SANATAULU:',fn,sl=nil,'!');
  slista:=tstringlist.Create;
  sliSTa.duplicates:=dupIgnore;
  slista.sorted:=true;
  if sl=nil then
  begin
    sl:=tstringlist.Create;
    //yy.LoadFromFile('sanatall.ansi');
    sl.Delimiter:=' ';sl.StrictDelimiter:=true;
    sl.loadfromfile(fn);
    sl.Insert(0,'');
    for j:=0 to sl.count-1 do
       slista.add(trim(reversestring(ansilowercase(sl[j]))));//+'al');
  end else
  begin
   for j:=0 to sl.count-1 do
      slista.add(trim((ansilowercase(sl[j]))));//+'al');
   //for j:=0 to sTMP.count-1 do   slista.add(trim(string(ansilowercase(stmp[j]))));//+'al');
  end;
//writeln('<li>lista luettu',slista.text);
//writeln(slista.CommaText);
teetaulu;
end;
function tstaulu.numeroi:tlist;
var i:integer;hitlist:tlist;muolist:tstringlist;
begin
hitlist:=tlist.Create;
//muolist:=tstringlist.create;
for i:=1 to slista.count-1 do
 hitlist.add(pointer(sanasto.haenumero(slista[i])));
result:=hitlist;
//for i:=1 to muolist.Count-1 do writeln(reversestring(muolist[i]));
end;

function tstaulu.sexact(haku:ansistring;yy:tstringlist):word;  //kutsutaan kun haku on edellyt ekaan (käänt) vokaaliin

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

 procedure tstaulu.etsilista;
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


procedure tstaulu.riimaa;
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
   var i,rhymecount,rpos,fpos,rivinalku:integer; //huom resmat nollapohjainen
   begin
      if pos('?',slista[r]+slista[c])>0 then exit;

     rpos:=(r-1)*rimis; //nollas arvo on jo löydettyjen määrä, sarakeindeksit ykköspohjaisia
     rhymecount:=resmat[rpos];
     if rhymecount>rimis then begin writeln('Riimirivi  ',r,' on jo täynnä');exit;end;
     resmat[rpos+rhymecount+1]:=c; //arvo talteemn
     resmat[rpos]:=rhymecount+1; //määrä kasvatetaan
    // writeln('<br><b>; ',r,':',rhymecount,'=',rpos+rhymecount+1,'</b> ',rpos,reversestring(slista[r]), ' arvo ',rhymecount+1,'=',c,reversestring(slista[c]),rpos div 64,':<br> ');
     exit;
     for i:=0 to rimis do writeln(resmat[rpos+i]);
     writeln('<b> ',r,reversestring(slista[r]), ' > ',c,reversestring(slista[c]),' ',rpos div rimis,':',rhymecount+1,'</b>');
     writeln('</div>');
   end;

  function sopii(vert,kohde:word;kohrpit,kohrlyh:ansistring;var short:boolean):boolean;
      var nchar:ansistring; mypit,mylyh:ansistring;tavuero:integer;
     begin
       try                 //  k ampe-aisimme  h aisimme
        result:=false;
        try
        mypit:=copy(slista[vert],1,nodes[vert].ru_pit);
        mylyh:=copy(slista[vert],1,nodes[vert].ru_lyh);
        tavuero:=nodes[kohde].tavucount-nodes[vert].tavucount;
        if mypit=kohrpit then result:=true
        else if mypit=kohrlyh then result:=true
        else if mylyh=kohrpit then result:=true
        else
        if tavuero<-2 then
        begin
            if (pos(kohrpit,mypit)=1) then result:=true;  //
            //if result and (pos(kohrlyh[length(slista[vert])+1],vokaalit)>0) then writeln('avotavunpaino!');
        end
        else  if (tavuero)>2 then      //kohteessa enem tavuja
        begin
         if (pos(mylyh,kohrlyh)=1) then result:=true;
         //if result and (pos(slista[kohde],length(slista[kohde]+1],vokaalit)>0) then writeln('avotavunpaino!');
        end;
     exit;
        //if abs(tavuero)>2 then writeln('<hr>,!!',mypit,'|',kohrpit,tavuero);
        //if abs(tavuero) mod 2=1 then if result then writeln('eee');
        //end;
        if abs(tavuero)=1 then begin syy:='eritavut';end;
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
      //if d then writeln('<span style="color:blue">[[',alasana,upto,':');
      while alasana<upto do
      begin
         cc:=cc+1;
         if cc>300000 then break;
         if short then
            ookoo:=(nodes[alasana].ru_pit=nodes[snum].ru_lyh) and (alasana<>snum) and (nodes[snum].ru_lyh=nodes[alasana].ru_lyh)
         else
           ookoo:=(abs(nodes[alasana].tavucount-tavus)<>1) and (alasana<>snum) and (nodes[snum].ru_pit=nodes[alasana].ru_lyh);
         //kun pitkää testaaa, voidaan hyväksyä myös useampitavuiset muodot
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
        //    if d then writeln(']]</span> ');
    end;

  // tmuotolista.riimit
 var d,short:boolean;
  begin
  //res:=tlist.create;
  //resres:=tlist.create;
    result:='';//'#'+inttostr(nodes[snum].tavucount);//('!!'+sana);
   begin
      d:=false;
      //d:=true;
    // lets[1].w:=0;
     cc:=0;
     slen:=nodes[snum].ru_lyh-1;
     tavus:=nodes[snum].tavucount; //huom tavut, ei reftavut
     let:=slen;
     pitr:=copy(sana,1,nodes[snum].ru_pit);
     lyhr:=copy(sana,1,nodes[snum].ru_lyh);
     //writeln('(',sana,nodes[snum].lev,'.',lets[i].c,')');
     for i:=nodes[snum].lev-1 downto 1 do //nodes[snum].ru_lyh-1 do
     begin
        try
         ss:=lets[i].w;
       //jos sana on monitavuinen, loppupätkästyn vrt:n pitää mätsätä täysin. Kokonaisen vrt:n
       //sana lyhyt, vertailtava lyhyt: pitää mätsätä täysin
        //writeln('!',i,':',ss,slista[ss]);
        if d then writeln('<div>');//,'#',i,'_',ss);
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
       begin  //loppupätkä sopii, mutta perussana jatkuu. Vertailtavien alasanojem  pitää matsätä kokonaan
         alasanat(alasana,ss,true);
       end;

        finally prevlev:=ss;end;
     end;
    end;
  end;
   //   procedure tstaulu.riimaa;
 var i,j,sn:integer;edsana,lyh,sana:ansistring;
 begin
   d:=false;
   //d:=true;
    curlev:=01;
    setlength(resmat,slista.count*rimis);
    fillchar(resmat[0],slista.count*rimis,0);
    writeln('<li>resmat:', length(resmat),' ',slista.count,lets[1].w);
    for i:=1 to slista.count-1 do
    begin
    try
    if pos('?',slista[i])>0 then continue;
    if length(slista[i])<3 then continue;
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
      //writeln('<div>',lets[1].w,'>',i,'>',nodes[i].jump,'/',' ',reversestring(copy(slista[i],nodes[i].yhted+1))+'<b>', reversestring(copy(slista[i],1,nodes[i].yhted)),'</b> ',nodes[i].tavucount,' ',red(inttostr(nodes[i].ru_lyh)),nodes[i].ru_pit,nodes[i].ru_lyh,':: ');
      writeln('<div>',nodes[i].lev,'<large style="color:blue;font-size:1.2em"> ',reversestring(copy(slista[i],nodes[i].yhted+1))+'<b>', reversestring(copy(slista[i],1,nodes[i].yhted)),'</b> ',nodes[i].tavucount,' ',red(inttostr(nodes[i].ru_lyh)),nodes[i].ru_pit,nodes[i].ru_lyh,'</large>:: ');
     if d then if nodes[i].ru_pit<>nodes[i].ru_lyh then writeln(reversestring(copy(slista[i],1,nodes[i].ru_lyh)));
     eds3(slista[i],i)
     //writeln(' ',eds3(slista[i],i));//,nodes[i].lev));
     except writeln('___fail');writeln('<li>zzz',j,'#i:',i,'/nodlev:',nodes[i].jump,' /curlev:',curlev);raise;end;
  end;
    writeln('<h3>lista</h3>');
     for i:=1 to slista.count-1 do
     begin
        //writeln('<li>',i,reversestring(slista[i]),': ');//,'#',resmat[64*(i-1)],':::');
      for j:=1 to rimis-1 do
       if (resmat[rimis*(i-1)+j]<i) then if (resmat[rimis*(i-1)+j])>0 then//or (resmat[j,i]) then
         begin
          addres(resmat[rimis*(i-1)+j],i);
          //writeln(resmat[64*(i-1)+j],'/',reversestring(slista[resmat[64*(i-1)+j]]));
         end;
     end;
     //writeln('<hr>',slista.text);
    for i:=1 to slista.count-1 do //slista.count-1 do
    begin
      if resmat[rimis*(i-1)]>0 then
      writeln('>',reversestring(slista[i]));//,': ','#',resmat[rimis*(i-1)],':::');
      for j:=1 to rimis-1 do
       if (resmat[rimis*(i-1)+j])>0 then //or (resmat[j,i]) then
        writeln(' ',reversestring(slista[resmat[rimis*(i-1)+j]]));//,resmat[64*(i-1)+j]);
       //writeln(' ',i+1,'/',resmat[(64*(i-1))+j],reversestring(slista[resmat[64*(i-1)+j]]),': ');
    end;
    writeln('<hr>');
 end;

procedure tstaulu.listaa;
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

procedure tstaulu.teetaulu;//(yy:tstringlist);
var      kirs,adss,cc,reftavs:integer;
    inf,outf,misfile:textfile;
    len,edlen,maxlen,curlev:word;
    a:word;
    d:boolean;
    yy:tstringlist;
  procedure nollaa(alku:integer); var ii:integer; begin  for ii:=alku to 23 do begin lets[ii].c:=#0;lets[ii].w:=0;end;  end;
  function ww(www:string):string;begin result:=copy(www,1,length(www)-2);  end;
var i,j,sn:integer;edsana,lyh,sana:ansistring;
begin
  yy:=slista; //laiskana en jaks muuttaa nimeä kaikkialle
  {yy:=tstringlist.Create;
  yy.Delimiter:=' ';yy.StrictDelimiter:=true;
  //yy.LoadFromFile('sanatall.ansi');
  yy.LoadFromFile('eitaivu.lst');
  //FOR I:=10000 TO 15000 DO  WRITELN(YY[I]);  EXIT;
  yy.sort;
  yy.Insert(0,'');
  }
  //writeln('<li>taulu;',yy.commatext);
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
  writeln('<li>haku:',yy.count,'</li><style type="text/css">div { border:1px solid red;margin-left:1em}</style>');
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
      if a>length(sana) then //.. //ravakasti räväkästi  .. loppuun asti
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
      if lets[a].c<>sana[a] then  //kohta jossa poikkeaa edeltäjästä
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

end.

