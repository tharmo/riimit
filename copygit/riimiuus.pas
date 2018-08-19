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
type tav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lis‰‰ viek‰ .takia - se josta etuvokaalit alkavat
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
 procedure numeroikaikki;
 //0-pohjasia, mutta data alkaa 1:st‰
 procedure luesanat(fn:string);
 procedure listaa;
 procedure hae;
 function luohaku(fn:string):tstringlist;
 function etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):string;
 procedure etsimuodot(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
 constructor create;
 end;

implementation
uses riimitys,math;
procedure do99;
type tnod=record rlen,yhted,jump,ed,lev,len:word;etu,tie:boolean;letter:ansichar;end;
type txnod=record ch:ansichar;jump,ed,lev,olisana:word;taka:boolean;end;
type tlet=record c:ansichar;w:word;end;
var
     kirs,adss,cc:integer;
     inf,outf,misfile:textfile;
     len,edlen,maxlen,curlev:word;
     yy,eds:tstringlist;
      d:boolean;
     lets:array[0..23] of tlet;
     //jumps,palalen:array[1..2068] of word;
     nodes:array[0..28088] of tnod;
     //xnodes:array[0..12000] of txnod;
     xnn:word;
     a:word;
     lres,sres:tstringlist;
   function ww(www:string):string;begin result:=copy(www,1,length(www)-2);
   end;

   function sexact(haku:ansistring):boolean;  //kutsutaan kun haku on edellyt ekaan (k‰‰nt) vokaaliin
    var ww,epoint,cp,hlen,cc:word;d:boolean;
   begin
   d:=false;
   //d:=true;
      ww:=1;
     epoint:=30000;hlen:=length(haku);
     cp:=1;cc:=0;
     if d then writeln('.<li>@',ww,'..',reversestring(haku),' ',cp,'<ul>');
     while ww<=epoint do
     begin
        //writeln('#',ww,'<b>!',nodes[ww].letter,'</b>');
        cc:=cc+1;if cc>30000 then break;
        if nodes[ww].letter=haku[cp] then
        begin
           if (nodes[ww].len=hlen) and (pos(haku,yy[ww])=1) then begin writeln('found:<b>',reversestring(yy[ww]),'</b>');exit; end; //fullhit
           if not nodes[ww].tie then
            begin cp:=cp+1;
            if nodes[ww].jump>0 then epoint:=nodes[ww].jump;  //
            end;

           if d then writeln('<li>+',nodes[ww].letter,reversestring(yy[ww]),' ',reversestring(copy(yy[ww],cp,length(yy[ww])-3-cp))
             ,'|<b>',reversestring(copy(yy[ww],1,cp)),'</b>_',nodes[ww].letter,epoint,' /next:',haku[cp],'<ul>');
           ww:=ww+1;
        end //ei, koklaa seuraavaa
        else
        begin
          if d then writeln('-<b>',nodes[ww].letter,'</b>','',reversestring(yy[ww]),epoint);
          ww:=nodes[ww].jump;
          if ww=0 then begin writeln('<li>haku:', reversestring(haku),'<b> not found</b>');exit;end;

        end;
        if ww>epoint then writeln('nomorego');
    end;
   end;

   function shorthits(san:ansistring;w,slen,sfar:word):tstringlist; //etsi sanat joissa vain konsonantti tietyn kohdan edell‰
   var i,j,epoint:integer;  //ei huomio tuplakons viel‰
   begin
     epoint:=nodes[w].jump;
     try
     if d then writeln('<li>tryshort@',w,'..',epoint,' ',reversestring(yy[w]),' ',san,'/L:',slen,'/F:',sfar);
     w:=w+1;
     while w<=epoint do
     begin
       if d then writeln('<li>SHORT',sfar,slen
       ,'(',w,reversestring(yy[w]),' |',YY[w][SFAR],' |',SAN[SFAR],'<b>',copy(yy[w],1,sfar),'</b>');
       if   yy[w][sfar]=SAN[sfAR] THEN
       begin
         if d then writeln('???',w,reversestring(COPY(yy[w],SFAR)+'/'+SAN),'!');
         //if length(yy[w])=sfar then writeln('hihithithithit!');

         w:=w+1;sfar:=sfar+1;
         if sfar+1=slen then
         begin
           writeln('<li>?????????',reversestring(yy[w]),'...',reversestring(yy[nodes[w].jump]));
           j:=w+1;epoint:=nodes[w].jump;
           while j<epoint do
           begin
             if j=0 then break;
             if d then  writeln('<li>--',reversestring(yy[j]),'+',yy[j][slen+1],'/',nodes[w].jump, '#',length(yy[j]),slen);
             if (length(yy[j])-3=slen) and (pos(yy[j][slen+1],konsonantit)>0) then
              sres.add(reversestring(yy[j]));//writeln('*************');
             j:=nodes[j].jump;
           end;
           break;
         end;
         continue;
       end;
       if yy[w][sfar]<SAN[sfAR] then w:=w+1 else  w:=nodes[w].jump;
       if w=0 then exit;
     end;
     except writeln('nono sex act');end;
   end;

   function tavuraja(a,b:ansichar):boolean;  //huom k‰‰nteinen suunta
    begin  //
       result:=false;
       if pos(a,vokaalit)>0 then //a on normaalij‰rjesyksess‰ seuraava kirjain
       begin  // vailla -> av
         if pos(b,konsonantit)>0 then result:=true
         else if not (isdifto(b,a)) then begin result:=true;;end;
        end;
        //writeln('<b>',b,a,'</b>',result);
    end;
    function testaajatkot(w:word;haku:ansistring;cp:word):boolean;

        function getword(ww,tc,cutp:word):boolean;
        var i,j,uto,muntavut,muntavutb:word;a,b:char;
        begin
           uto:=max(nodes[ww].jump,ww+1);
           if d then writeln('<li>GW:',ww, '//',uto,copy(reversestring(yy[ww]),3),'//',cutp,cp,'/',tc,'<ul>');

           //if ww=635 then writeln('<li>MIKƒMƒTTƒƒ? ',nodes[ww].jump,'.',uto,'/',ww,yy[ww]);
           //if prevvok then if pos(yy[ww][cutp],konsonantit)>0 then tc:=tc+1;
           while (ww<uto) do // and (ww<>0) do  //k‰y l‰pi suorat lapset
           begin
             muntavut:=0;//tc;
             muntavutb:=0;
             for i:=cutp to length(yy[ww]) do if tavuraja(yy[ww][i-1],yy[ww][i]) then muntavut:=muntavut+1;
             //if muntavut<4 then
            if d then  writeln('<li><tt>',reversestring(copy(yy[ww],cutp)),'...  </tt>',muntavut mod 2=1,' ',yy[ww]);
            try
            if muntavut mod 2=1 then lres.add(reversestring(yy[ww]));
             //writeln('////');
             ww:=ww+1;//nodes[ww].jump;
             //break;
             except writeln('<hr>NOGW',muntavut,'/',w);raise; end;
           end;
           if d then writeln('</ul>');

        end;

    var i,j,upto:word;hk:ansistring;
    begin
    d:=true;
    //d:=false;
     try
      upto:=nodes[w].jump;
        hk:=copy(haku,cp+1);  //haun mahdollinen alkukonsonantti
        if d then writeln('<li>trying to find "',reversestring(hk),'" before <b>',reversestring(copy(yy[w],1,cp)),'</b>',cp, ' ',w,'..',nodes[w].jump,yy[w]);
        //if hk='' then writeln('nothin to find... almost anything goes');
        w:=w+1;cp:=cp+1;
        while (w<upto) and (w<>0) do
        begin
           if d then writeln('<li>/test:',yy[w][cp],cp, ' ',reversestring(copy(yy[w],1)),' ',w,'!',yy[w][cp],'!',yy[w][cp-1],isdifto(yy[w][cp],yy[w][cp-1]),'<ul>');
          //if hk='' then if pos(yy[ww]
          //if hk='' then
          //begin
          if (pos(yy[w][cp],konsonantit)<1) and (isdifto(yy[w][cp],yy[w][cp-1])) then
               //writeln('.. diftonki ', yy[w][cp],yy[w][cp-1],' ei kelpaa')
          else getword(w,0,cp);
          if d then writeln('###</ul>');
          w:=nodes[w].jump;
          if w=0 then exit;
        end;  //yhden tason jutut
       except writeln('<hr>jatko'); end;
    end;
    function etsitarkka(haku:ANSISTRING):word;
    var hitle,shitle,upto,xtavut,i,j,w,cc,xshortcut,solong,mores,lenh,checkpoint,hakulen,lensin:integer;
         sofar,san,AKON,SINKON,sinful,resst:ansistring;
         d:boolean;
         ohit:tstringlist;
         lets:array[1..30] of word;
    begin
      lres:=tstringlist.create;
        d:=false;
        d:=true;
        fillchar(lets,sizeof(lets),0);
        resst:='';
        upto:=yy.count-1;
        hitle:=0;shitle:=0;
        lenh:=length(haku);
        lensin:=lenh;
        for i:=lenh downto 1 do if pos(haku[i],vokaalit)>0 then break else lensin:=lensin-1;
        //ohit:=tstringlist.create;
        try try
        w:=1;solong:=0;cc:=0;checkpoint:=1;
        if d then writeln('<li>HAKU:',reversestring(haku),lensin,'/');except writeln('mit‰vittuu');end;

        while true do
        begin
          if w>=upto then begin resst:=resst+('!!!!!');break;end;//<li>not found',w,'/',upto);break;end;
          cc:=cc+1;
          if cc>3000 then exit;
          //if checkpoint>length(san) then breaK;
          try
          san:=copy(yy[w],1,length(yy[w])-2);
          except writeln('zzzzzzzzzz');break;end;
          if san[checkpoint]=haku[checkpoint]  then  //m‰ts‰‰ vertailukohtaan asti
          begin
            if nodes[w].jump>0 then upto:=nodes[w].jump;
            if lensin=checkpoint then begin writeln('xxx<hr/>');testaajatkot(w,haku,checkpoint);end;
            lets[checkpoint]:=w;
            shitle:=checkpoint;
            if san=haku then begin hitle:=checkpoint;resst:=resst+'<b style="color:blue">'+inttostr(w)+' '+reversestring(yy[w])+'</b> ';end;//break; end;
            //if san=haku then begin lres.add(reversestring(san));break; end;
            if d then writeln('<li><b>',san[checkpoint],'</b>!',w,reversestring(san),'/',checkpoint,'/',nodes[w].yhted,copy(san,1,checkpoint),'<b>',copy(san,checkpoint+1),'</b>?','}UPTO',w,'/',upto);

            w:=w+1;checkpoint:=checkpoint+1;
            if d then writeln(' /next',w,'@',checkpoint,' <b>',upto,'</b><ul>');
          end else
          begin
            ///8:104 4 3 kuoliaana aina ->117 3/anaailouk 1
            if d then writeln('<li>--<b style="color:red">',san[checkpoint],'</b>!',w,'/',checkpoint,reversestring(san),'// ',nodes[w].yhted,'; ',yy[w],'/?:',haku,
             '/:<b>',checkpoint,reversestring(copy(san,1,nodes[w].yhted)),'</b>:-->',copy(haku,1,nodes[w].yhted),nodes[w].jump
             , ' /cp:',checkpoint,'/lenh:',lenh,'/sink:',sinkon,'_',copy(san,1,checkpoint),'/torlen:',copy(san,1,nodes[w].rlen),'!',';');
            //,pos(copy(san,1,checkpoint),sinkon);
            if nodes[w].jump=0 then begin //writeln('<li>NOGO#',reversestring(yy[w]),checkpoint,'<b style="color:red">',san[checkpoint],'</b>!',haku[checkpoint]);
              //writeln('<pre>',yy[w],^j,haku,^j,'123456789012345</pre>');
              break;end else //w:=w+1 else
            w:=nodes[w].jump;
    //           if checkpoint<length(sinkon) then if haku[nodes[w].yhted+1]<san[nodes[w].yhted+1] then begin writeln('EndOL',haku[nodes[w].yhted+1],san[nodes[w].yhted+1]);exit;end;
          end;

        //if copyhaku, then  begin writeln('<li>MISS',haku,node);exit;end;

        end;
        finally //for i:=1 to mores do writeln('</ul>');
        //writeln('</ul></ul></ul></ul></ul></ul></ul></ul></ul></ul><div style="border:2px solid black">',lres.text,' ',haku,'</div>');
         if shitle<>hitle then
         begin
         if resst<>'' then writeln('<li>',resst,hitle,shitle) else writeln('<li>notfound:',haku);
         //for i:=1 to 20 do writeln(lets[i]);
         for i:=1 to 20 do  if lets[i]<>0 then writeln(i,reversestring(copy(yy[lets[i]],i+1,length(yy[lets[i]])-i-1)),'<b>',reversestring(copy(yy[lets[i]],1,i)),'</b>');
        //lres.Free;
         end;
        end;
        for i:=1 to 20 do  if lets[i]<>0 then
        begin
         writeln(i,reversestring(copy(yy[lets[i]],i+1,length(yy[lets[i]])-i-1)),'<b>',reversestring(copy(yy[lets[i]],1,i)),'</b>');
        end;
    end;

   function etsi(haku:ANSISTRING;shortcut:word):word;
   var xtavut,i,j,w,c,xshortcut,solong,mores,lenh,checkpoint,hakulen:integer;
        sofar,san,AKON,SINKON,sinful:ansistring;
   begin
     //haku:='aar';
       //d:=false;
       d:=true;
   lres:=tstringlist.create;
   sres:=tstringlist.create;
       try
       w:=1;solong:=0;cc:=0;
       //writeln('<li>tavuta:',hyphenfi(haku,tavut));
       //writeln('<li>tavutaattu:',tavut.commatext);
       mores:=0;
       sinkon:='';//
       sinful:='';//

       for i:=length(haku) downto 1 do if pos(haku[i],vokaalit)<1 then akon:=akon+haku[i] else begin sinful:=copy(haku,1,i);break;end;
       if shortcut=0 then begin sinkon:=sinful;sinful:='';end else
       for i:=shortcut downto  1 do  if pos(haku[i],vokaalit)<1 then akon:=akon+haku[i] else begin sinkon:=copy(haku,1,i);break;end;
       //sinkon:=sinful;
       //sinful:='';
       writeln('<li>HAKU:',reversestring(haku),'-->', sinkon,'+',akon,shortcut,' /',sinful,'/');
       lenh:=length(sinkon);
       //try
       while true do
       begin
         cc:=cc+1;
         if cc>3000 then exit;
         san:=ww(yy[w]);
         checkpoint:=nodes[w].yhted;
         //if checkpoint=shortcut then shorthits(w,shortcut);
         for i:=mores downto checkpoint-1 do begin mores:=mores-1;writeln('</ul>');end;
         //if (pos(sinkon,san)=1) or (lenh<checkpoint) or (pos(copy(san,1,checkpoint),sinkon)=1) then if sinful<>'' then begin shorthits(sinkon,w,shortcut,checkpoint);sinkon:=sinful;sinful:='';end;
         if (lenh<checkpoint) //sanat ovat pidempi‰ kuin hakusana  - kaikki k‰y kunhan ei tule tavurajaa v‰‰r‰‰n paikkaan...
         or (pos(copy(san,1,checkpoint),sinkon)=1)  then  //m‰ts‰‰ vertailukohtaan asti
         //if 1=2 then
         begin
           if d then writeln('<li>!!?',w,reversestring(san),'/',sinkon,'!',checkpoint,'/',lenh,'<b>',copy(san,checkpoint),'</b>?');
           //if (pos(sinkon,san)=1)  //pitk‰ sana joks sis‰t‰‰ koko halusanan (-allkkon)
           //or (pos(san,sinkon)=1) then  //lyhyt sana  sis‰ltyy hakuun .. alkukonsonantin ei tarttis sis‰lty‰
           //baana/anaa!2/4naab
           //if pos(sinkon,copy(san,1,nodes[w].rlen))=1 then
           //if lenh=checkpoint then begin writeln('xxx<hr/>');testaajatkot(w,haku,checkpoint);end;
           if pos(sinkon,copy(san,1,nodes[w].rlen))=1 then   //konsonantittomat versiot
            //  if tavuraja(san[checkpoint],san[checkpoint+1]) then
            if tavuraja(san[length(sinkon)],san[length(sinkon)+1]) then
           begin
            xtavut:=0;
            for i:=length(sinkon)+1 to length(yy[w]) do if tavuraja(yy[w][i-1],yy[w][i]) then xtavut:=xtavut+1;
             if d then writeln('//lasketavut:'+copy(san,length(sinkon)+1),xtavut);
             if sinful<>'' then begin shorthits(sinkon,w,shortcut,checkpoint);sinkon:=sinful;sinful:='';lenh:=length(sinkon);if d then writeln('<li>LYHYTLOPPU:',sinkon,lenh);end
             else begin
             if d then writeln('<li>match:',(xtavut mod 2)=1,w,' ',yy[w],' /looking:',reversestring(sinkon),'/',reversestring(san)); //pannaan vain muistiin, jatketaan kuten muutenkin vertailusan sopiessa
             //if length(sinkon)<nodes[i].rlen then
             //for j:=length(sinkon) to length(san) do if pos(san[j],konsonantit)<0 then if pos(san[j-1],konsonantit)>0 then writeln('XXX');
             //kakka|mainen  n-_   e  n  i a m
              //writeln('??tavuraja? ');
              //lres.add(reversestring(copy(san,length(sinkon)+1))+'!');
              if (xtavut mod 2)=1 then
              lres.add(reversestring(san+'!'));
             end;
           end;
           mores:=mores+1; //turha?
           if d then writeln('<li>>>> ',checkpoint,'/',w,reversestring(copy(san,nodes[w].yhted+1)),' <b  style="color:red">'
            ,reversestring(copy(san,1,nodes[w].yhted))
             ,' </b>[',haku[nodes[w].yhted+1],nodes[w].yhted+1,']{',san[nodes[w].yhted+1],'__',length(sinkon),'/',nodes[w].rlen,'}<ul>');
           if checkpoint=length(sinkon) then begin writeln('<hr>zzz'); testaajatkot(w,haku,checkpoint);exit;break;end;
           w:=w+1;
         end else
         begin
           ///8:104 4 3 kuoliaana aina ->117 3/anaailouk 1
           if d then writeln('<li> --',w,'/',checkpoint,reversestring(san),'// ',nodes[w].yhted,'; ',yy[w],'/?:',haku,
            '/:<b>',checkpoint,reversestring(copy(san,1,nodes[w].yhted)),'</b>:-->',copy(haku,1,nodes[w].yhted),nodes[w].jump
            , ' /cp:',checkpoint,'/lenh:',lenh,'/sink:',sinkon,'_',copy(san,1,checkpoint),'/torlen:',copy(san,1,nodes[w].rlen),'!',';');
           //,pos(copy(san,1,checkpoint),sinkon);
           if d then writeln(lenh<checkpoint,'pos(',copy(san,1,checkpoint),',',sinkon,')=1:',pos(copy(san,1,checkpoint),sinkon)=1,pos(sinkon,copy(san,1,nodes[w].rlen))=1,san);
           if nodes[w].jump=0 then begin writeln('<li>NOGO@',reversestring(yy[w]));exit;end else //w:=w+1 else
           if haku[nodes[w].yhted]<san[nodes[w].yhted] then begin writeln('EOL');exit;end;
           w:=nodes[w].jump;
//           if checkpoint<length(sinkon) then if haku[nodes[w].yhted+1]<san[nodes[w].yhted+1] then begin writeln('EndOL',haku[nodes[w].yhted+1],san[nodes[w].yhted+1]);exit;end;
         end;

       //if copyhaku, then  begin writeln('<li>MISS',haku,node);exit;end;

       end;
       finally for i:=1 to mores do writeln('</ul>');
       writeln('<div style="border:2px solid black">',lres.text,'<hr>',sres.text,'</div>');
       end;
   end;
   procedure haepa(st:string);
   var s:string;i,j,lopunalku:word;tavut,haut:tstringlist;
   begin
   writeln('<li>etsi--');
      tavut:=tstringlist.Create;
   haut:=tstringlist.Create;
   haut.loadfromfile('haku.lst');
   for i:=0 to 20 do //haut.Count-1 do
   begin
     if haut[i]='###' then break;
    //s:=copy(st,1,length(st)-2);
    s:=reversestring(haut[i]);

    hyphenfirev(s,tavut);
    lopunalku:=0;
    if tavut.count>4 then
    begin
     for j:=3 to tavut.count-1 do
      lopunalku:=lopunalku+length(tavut[j]);
      //for j:=1 to length(tavut[3]) do if pos(tavut[3][j],konsonantit)>0 THEN lopunalku:=lopunalku-1 else break;

     writeln('<li>',haut[i],'/TAVUT:',tavut.commatext,lopunalku);
     etsi((s),lopunalku-1);
    end else     etsi((s),0);

    end;
   end;
  procedure nollaa(alku:integer); var ii:integer; begin  for ii:=alku to 23 do begin lets[ii].c:=#0;lets[ii].w:=0;end;  end;
  procedure markme(sana:string;alku:integer);
  var ii:integer;
  begin
  for ii:=alku to length(sana) do
   begin lets[ii].c:=#0;lets[ii].w:=11111;
   end;
  end;
var i,j,sn:integer;edsana,lyh,sana:ansistring;
begin
yy:=tstringlist.Create;
yy.Delimiter:=' ';yy.StrictDelimiter:=true;
//eds:=tstringlist.Create;
//eds.commatext:=('itsaemuk 0,itsaemu 0');eds.sort;writeln(eds.commatext);
{yy.LoadFromFile('sanatuus.csv');
for i:=0 to yy.count-1 do
 yy[i]:=reversestring(yy[i]);
yy.sort;
writeln('<li>loaded ',yy.count, ' words<pre>',yy.text);

exit;
yy.LoadFromFile('sanat99.ansi');
}
yy.LoadFromFile('sanatall.ansi');
//writeln('<pre>',yy.text);
yy.sort;
yy.Insert(0,'');
//writeln('<hr>',yy.text);
edsana:=yy[0];edlen:=length(edsana);
fillchar(lets,sizeof(lets),0);
//fillchar(xnodes,sizeof(xnodes),0);
for i:=1 to 23 do begin lets[i].c:=#0;lets[i].w:=0;end;
//for i:=1 to length(yy[0]) do begin lets[i].c:=yy[0][i];lets[i].w:=0;end;
mAXLEN:=0;curlev:=01;
writeln(' gogogogog<style type="text/css">div { border:1px solid red;margin-left:1em}</style>');
nodes[0].lev:=1;
curlev:=0;
xnn:=0;
d:=false;
{for i:=1 to yy.count-1 do  //jos tekis yhden mittasii noodeja.. aivo solmussa, jos ei sittenk‰‰n...
begin
   sana:=w(yy[i]);
   writeln('<li>',reversestring(sana));
   for a:=1 to length(sana) do
   begin
      if (lets[a].c=#0) then  //ed loppui.. sana suoraa jatkoa edelliselle
      begin

      end else
      if (lets[a].c<>sana[a]) then  //osin sama
      begin
       break;
      end else
      if (lets[a].c=sana[a]) then  //sopii,jatketaan vain
      begin end;
      if (a=length(sana)) then  //loppui, kaikki oli samoja: ylˆs ulos
      begin end;

   end;
   //IF MAXLEN<LENGTH(YY[I]) THEN MAXLEN:=LENGTH(YY[I]);
 1  }
   nodes[0].yhted:=1;
 nollaa(curlev+1);
 for i:=1 to yy.count-1 do
 begin
  try
  //if (i>1876) and (i<=1879) then d:=true else d:=false;
  sana:=ww(yy[i]);
  //if length(sana)>20 then continue;
  //if length(sana)>18 then
  if d then writeln('<li>:', i,' @',curlev,'::',reversestring(sana), ' ');
  //
  //continue;
  nodes[i].tie:=false;
  nodes[i].jump:=0;
  nodes[i].rlen:=length(sana);for j:=length(sana) downto length(sana)-3  do if pos(yy[i][j],vokaalit)>0 then break else nodes[i].rlen:=nodes[i].rlen-1;
  nodes[i].len:=length(sana);
  nodes[i].etu:=yy[i][length(yy[i])]='0';
  except writeln('???',i,sana);raise;end;
  for a:=1 to curlev+1 do //length(sana)+1 do
  begin
      if d then write('_',sana[a]);
     //writeln(a,sana[a],lets[a].c,lets[a].w);
     if a>length(sana) then //.. //ravakasti r‰v‰k‰sti  .. loppuun asti
     begin
         if d then writeln('<li>koko::',reversestring(yy[i]),'/',reversestring(yy[i-1]),curlev) ;
         nodes[i].ed:=i-1;
         nodes[i-1].jump:=i;
         nodes[i-1].tie:=true;
         nodes[i].yhted:=nodes[i-1].yhted+1;
         nodes[i].lev:=min(a,nodes[i-1].lev);
         nodes[i].letter:=sana[curlev];
         lets[curlev].w:=i;
         //lets[nodes[i].lev-1].w:=i;
         //writeln('<li>samasana:',sana,a);
         //for j:=1 to 12 do  writeln(' *',lets[j].c,sana[j]);
         break;
     end;

     if (lets[a].c=#0) //and (a<=curlev)
     then  //sana suoraa jatkoa edelliselle  .. ei tarpeen?
     begin
      try
       if d then writeln('//');
      //if pos('itsaep',sana)>0  then  begin writeln(' *<li>voivoi;',a,' ',reversestring(sana), ' -',yy[i-1],'/+',yy[i+1]);
      //writeln('<li>',a,'/jatko',a,reversestring(yy[i]),'/',reversestring(yy[i-1]));     // for j:=1 to length(sana) do writeln(lets[j].w);
      nodes[i].yhted:=min(a,nodes[i-1].yhted+1);
      nodes[i].lev:=nodes[i-1].lev+1;
      nodes[i].letter:=sana[curlev+1];

      //for j:=curlev to length(sana) do begin lets[j].c:=sana[j];lets[j].w:=i;end;
      //for j:=nodes[i].yhted to length(sana) do begin writeln('*',j,sana[j]);end;
      nollaa(curlev+1);
      //nollaa(length(sana)+1);
      if i=634 then begin writeln('<hr>');for j:=1 to length(sana) do writeln(copy(yy[lets[j].w],1,j)+'|',copy(yy[lets[j].w],j+1));end;
      nodes[i].ed:=i-1;
      if lets[a].w<>i then if nodes[lets[a].w].yhted>=nodes[i].yhted then  nodes[lets[a].w].jump:=i;
      //nodes[i-1].jump:=i;
      //yy[i]:=yy[i]+'XXX';
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
       //if i=9622 then
        curlev:=a;//nodes[i].lev;
        if nodes[lets[a].w].yhted>=nodes[i].yhted then  nodes[lets[a].w].jump:=i;
        //for j:=nodes[i].yhted to length(sana) do begin lets[j].c:=sana[j];lets[j].w:=i;end;
        lets[a].c:=sana[a];lets[a].w:=i;
        nodes[i].lev:=a;//nodes[nodes[i].ed].lev+1;
        nodes[i].letter:=sana[curlev];
       break;
       except writeln('<li>',i,' ',curlev,'?????pieleenmen',a,reversestring(yy[lets[curlev-1].w]));break;end;
     end
     else  begin  //keep going
       if d then writeln('.'); nodes[i].yhted:=a;end;
   end;
   if d then  writeln('',i,' <b>',curlev,copy(yy[i],1,curlev),'</b> !!!',a,reversestring(yy[lets[curlev-1].w]),' ',lets[a].w,':');
   if d then  for j:=1 to curlev+1 do writeln(lets[j].c,j);
  end;
 try
   writeln('zxc');
   sexact(reversestring('hallinnoida'));
   for i:=1 to 5000 do //5000 do //50000 do
   begin
   sn:=random(20066)+1;
   sana:=ww(yy[sn]);
   writeln('<li>etsi;',sana,sn);
   //try etsitarkka(sana);except writeln('<li>failetsi;',sana,sn);end;
   try sexact(sana);except writeln('<li>failetsi;',sana,sn);end;

   end;
//   haepa('');
  //for i:=1 to 50 do etsi(ww(yy[random(2068)]));
  except writeln('eietsi<hr>');end;
  writeln('</ul></ul></ul></ul></ul></ul></ul></ul></ul></ul>LISTAA<div>');
  curlev:=01;
  //exit;
  for i:=1 to yy.count-1 do
  begin
  try
    sana:=ww(yy[i]);
    if nodes[i].etu then
     sana:=etu(sana);
   for j:=curlev downto nodes[i].lev do writeln('</div>');
   except writeln('___');writeln('<li>########',j,'#i:',i,'/nodlev:',' /curlev:',curlev);end;
   try
   //writeln('<div>',reversestring(copy(yy[i],nodes[i].yhted))+'<b>', reversestring(copy(yy[i],1,nodes[i].yhted-1)),'</b> ',nodes[i].lev,' ',reversestring(yy[nodes[i].jump]));
   writeln('<div>',i,';',nodes[i].lev,nodes[i].letter,'!',i,' ',nodes[i].lev,' :',nodes[i].yhted,' ',reversestring(copy(sana,nodes[i].yhted+1))
     +'<b style="color:blue">',reversestring(copy(sana,1,nodes[i].yhted)),'</b> ',copy(reversestring(yy[nodes[i].jump]),3),'  ->',nodes[i].jump,' ',nodes[i].yhted,'/',yy[i],nodes[i].tie);
   except writeln('___');writeln('<li>zzz',j,'#i:',i,'/nodlev:',nodes[i].jump,' /curlev:',curlev);raise;end;
   try
   curlev:=nodes[i].lev;
    //writeln('<b>', copy(yy[i],1,nodes[i].yhted-1),'</b>+',
    //copy(yy[i],nodes[i].yhted),'    //',
    //copy(yy[nodes[i].ed],1,nodes[i].yhted-1),'<em>'
    // ,copy(yy[nodes[i].ed],nodes[i].yhted),'</em>',nodes[i].ed-i);
   except WRITELN('<li>XXXX',i);end;
  end;

exit;
assign(inf,'sanat99.ansi');  //synonyymit/liittyv‰t sanat
reset(inf);
//assign(outf,'testi.the');  //synonyymit/liittyv‰t sanat
//rewrite(outf);
writeln('<pre>');
edsaNA:='';
cc:=0;
curlev:=01;
while (not eof(inf))  do
begin
 readln(inf,sana);
 lyh:=sana;
 cc:=cc+1;
 for i:=1 to min(length(lyh),length(edsana)) do
   if sana[i]=edsana[i] then
    lyh[i]:=' ' else begin break;end;
   writeln(lyh,'    ',cc);
 edsana:=sana;
 end;
 close(inf)
end;
procedure tsanasto.numeroikaikki;
var instream,hitfs,misfs:tfilestream;
     inf,outf,misfile:textfile;
     sana,hakurunko,akon,res,hakukoko:ansistring;
     hakueietu,hakueitaka:boolean;
     hits,cc:word;
begin
//inf:=tfilestream.create('wikithe.txt',fmopenread);  //synonyymit/liittyv‰t sanat
assign(inf,'wikithe.ansi');  //synonyymit/liittyv‰t sanat
reset(inf);
assign(outf,'testi.the');  //synonyymit/liittyv‰t sanat
rewrite(outf);
assign(misfile,'testimiss.the');  //synonyymit/liittyv‰t sanat
rewrite(misfile);
  cc:=0;
  writeln('<li>xxx');
  //hitfs:=tfilestream.create('wikithe.txt',fmcreate);  //numerolista
  //misfs:=tfilestream.create('wikithe.txt',fmcreate);  //tunnistamattomat pohditaviksi
  try

    //if cc>10 then break;

    while //(cc<1000000) and
   (not eof(inf))  do
    begin
     try
     cc:=cc+1;
     readln(inf,sana);
     sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
     // if pos('kymmenen', sana)<1 then continue;
     //sana:='v‰ri';
     akon:='';
     //if sana='' then begin writeln(outf,'*****');continue;end else
     voksointu(sana,hakueietu,hakueitaka);
     //writeln('<li>',sana,hakueietu,hakueitaka);
//      while (sana<>'') and (pos(sana[1],konsonantit)>0) do begin akon:=sana[1]+akon;  delete(sana,1,1); end;
     if sana='' then continue; //pelk kons
     hakurunko:=taka(reversestring(sana));
     hakukoko:=sana;
     res:='';
     //writeln('<li>bum:',sana,'!!!',hakurunko,'//',akon,hakueietu,hakueitaka,cc);
     hits:=0;
     res:=res+etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,nominit.sijat[0],nil,nil,hits);  //nomineilla ei perusmuodolla p‰‰tett‰
     if hakurunko[1]='a' then
     res:=res+etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,verbit.sijat[0],nil,nil,hits); //verb permuo p‰‰ttyy "a"
     if hits>1 then writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
     if hits=0 then writeln(misfile,sana);
     if hits>1 then
      begin
        if (hits mod 2=0) then
          writeln('<li>',akon,sana,'=',trim(res),' ',cc,'!',hits)// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
          ;//else  writeln('<li><b>y:',akon,sana,'=',trim(res),' ',cc,'</b>',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
       end;
     except   writeln('<li>xxx',sana,sana='','!');end;
     if cc>20000 then break;
     //writeln('<li>',sana,res,hits);
   end;
    writeln('<li>did');
  finally
    close(inf);
    close(outf);
    close(misfile);
  //hitfs.free;misfs.free;
  end;
end;

constructor tsanasto.create;
var i:word;h:thakunen;
begin
{writeln(' <style type="text/css">div div div{ font-size:1px;border:1px solid green;margin-left:1em} ');
//+^m+' div div div{ font-size:0.5em} '+^m);
writeln('div div:hover div { display:block;font-size:1em;background:#ddd}');
writeln('xdiv div div:hover div div{ display:block;font-size:0.5em;background:#ff9}</style>');
writeln('<div> x<div> y<div> z</div></div></div>');
//exit;0}
do99;exit;
luesanat('sanatuus.csv');
verbit:=tverbit.create('sanatuus.csv','vmids.csv','vsijat.csv');
nominit:=tnominit.create('nomsall.csv','nmids.csv');
//do99;exit;
numeroikaikki;
//verbit.listaasijat;//exit;
exit;
writeln('ccccccccccccccc',verbit.lmmids[15,0],'!');
//nominit.sanat:=sans^;
//nominit.listaa;
 //nominit.siivoosijat;
 hae;
end;

procedure tsanasto.hae;
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

function listsija(sika:tsija):string;
begin
   with sika do  result:=' [['+inttostr(num)+' '+ name+' ('+esim+') '+inttostr(vparad)+' '+inttostr(hparad)+'):<b>'+ending+'</b>]] ';
end;

function tsanasto.etsiyks(hakusana,hakuakon,hakukoko:string;hakueietu,hakueitaka:boolean;sika:tsija;aresu:tstringlist;onjolist:tlist;var hits:word):string;
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi:string;
    curlka:tlka;cursis:tsis;curav:tav;cursan:tsan;//mysika:tsija;
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
       if d then writeln('hit:'+resst);
       hits:=hits+1;
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
      if sana+cursan.akon=koita+'xxx' then //if cursan.akon=hakuakon then
      begin
         //fullhit(sana,koita,san);
         //writeln('+++++');
         //resst:=' ';
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
            if (skipped+sana+cursan.akon<>koita+hakuakon)  then hits:=hits+2 else hits:=hits+1;
          end;// else hits:=hits+1;
          resst:=resst+' '+reversestring(kokosana)+sikasopi;//+'"/'+copy(hakusana+hakuakon,length(kokosana)+1)+'/s:'+inttostr(san)+' '+inttostr(luokka)+'#'+inttostr(sika.num)+'['+skipped+']';
          if d then writeln('<li>hit:',sana+cursan.akon,',',koita+'.'+hakuakon,')',skipped,') ',kokosana,hits );
      end;
      if (koita='') or (pos(koita,sana)=1) then if d then writeln('<li>longhit '+reversestring(hakusana),'/',reversestring(skipped+'-'+sana+cursan.akon));
      //else if cursan.san='' then}
      //writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
      //reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);
       except writeln('!');  end;
      end;

      function av_f(av:integer;koita,skipped:string):boolean;
      var san,i,j:integer;myav:string;
      begin
        //if skipped<>'' then writeln('<li>skipav:',skipped);
        curav:=avs[av];
        result:=false;;
        myav:=ifs(heikkomuoto,curav.h,curav.v);

        if d then
         writeln('<li>{',blue(myav),'}',curav.v,curav.h,konvex,red(koita));//+xvok),blue(myav),' :',curav.v,curav.h,'/',curav.ekasana,'-',curav.vikasana);
        //if d then writeln('<li>(',myav,'=',curav.v+'/',curav.h,'\',konvex,')',red(koita),blue(myav),'/hm:',heikkomuoto,'/ver:',isverb,'/vah:',curlka.vahva);
        if konvex then if myav<>'' then begin delete(myav,1,1);end;
        if koita='' then begin result:=true;avsopi:='';skipped:=skipped+myav;avjatko:='';if d then writeln('<li>AVX:',red(koita),blue(myav)) end else
        begin
          if (myav='') or (pos(myav,koita)=1)  then result:=true
          else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
                end;
          avjatko:=copy(koita,length(myav)+1,99);//xvok;
          avsopi:=copy(koita,1,length(myav));//xvok;
        end;
        //avsopi:=myav;

          if d then writeln('/AV:',red(avjatko),blue(avsopi),' ',curav.ekasana,'..',curav.vikasana,'<ul>');
          try
          //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
          for san:=curav.ekasana to curav.vikasana do //!!!
                sana_f(san,avjatko,skipped);
           if d then writeln('</ul>');
        except writeln('faILAV!!!');end;
      end;

      function sis_f(sis:integer;koita,skipped:string):boolean;
      var av,i,j:integer;mysis:string;
      begin
        //  if skipped<>'' then writeln('<li>skipsis:',skipped);
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

          result:=false;;
          if (mysis='') or (pos(mysis,koita)=1) then result:=true
          else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
          end;
          sisjatko:=copy(koita,length(mysis)+1,99);
          sissopi:=copy(koita,1,length(mysis));
          //sissopi:=mysis;
        END;
         if d then writeln('<li>Sisu:',red(koita),'/',blue(mysis+'!'),vokvex);
         if  d then   write('<b>/sovita:',sisjatko,'|sopi:',sissopi,'\</b>');
          //if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
          if d then writeln('<ul>');
        for av:=cursis.ekaav to cursis.vikaav do
         av_f(av,sisjatko,skipped);
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
        if (mid='') OR (pos(mid,koita)=1) then result:=true
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
         sis_f(sisus,lkajatko,skipped);
        if d then writeln('</ul>');
       until repeats<=0;
      end;
// tsanasto.etsiyks(
var i,j,lu:word;
begin
try
d:=false;
//d:=true;
sikaloppu:= copy(hakusana,length(sika.ending)+1);
sikasopi:= sika.ending;
resst:='';
if d then writeln('<li>hae:',hakusana,'-->',sikaloppu,'+',sika.ending,sika.onverbi);
if sika.onverbi then for lu:=52 to 78 do lka_f(lu,sika.num,sikaloppu,'')
else for lu:=1 to 50 do lka_f(lu,sika.num,sikaloppu,''); // skipped vois olls <> ''
//if resst='' then writeln(' --',reversestring(hakusana+hakuakon));
//if hits>1 then
result:=resst;
except writeln('<li>failetsi');end;

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
    // d:=true;
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
        resst:=resst+etsiyks (HAKUNEN.loppu+hakunen.akon,hakunen.koko,'',hakunen.eietu,hakunen.eitaka,sika,aresu,onjolist,hits);
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

