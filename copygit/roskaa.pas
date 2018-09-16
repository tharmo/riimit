unit roskaa;

end.

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
procedure markme(sana:string;alku:integer);
var ii:integer;
begin
for ii:=alku to length(sana) do
begin lets[ii].c:=#0;lets[ii].w:=11111;
end;
end;

function shorthits(san:ansistring;w,slen,sfar:word):tstringlist; //etsi sanat joissa vain konsonantti tietyn kohdan edellä
var i,j,epoint:integer;  //ei huomio tuplakons vielä
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
function tavuraja(a,b:ansichar):boolean;  //huom käänteinen suunta
 begin  //
    result:=false;
    if pos(a,vokaalit)>0 then //a on normaalijärjesyksessä seuraava kirjain
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

        while (ww<uto) do // and (ww<>0) do  //käy läpi suorat lapset
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
assign(inf,'sanat99.ansi');  //synonyymit/liittyvät sanat
reset(inf);
//assign(outf,'testi.the');  //synonyymit/liittyvät sanat
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
      if (lenh<checkpoint) //sanat ovat pidempiä kuin hakusana  - kaikki käy kunhan ei tule tavurajaa väärään paikkaan...
      or (pos(copy(san,1,checkpoint),sinkon)=1)  then  //mätsää vertailukohtaan asti
      //if 1=2 then
      begin
        if d then writeln('<li>!!?',w,reversestring(san),'/',sinkon,'!',checkpoint,'/',lenh,'<b>',copy(san,checkpoint),'</b>?');
        //if (pos(sinkon,san)=1)  //pitkä sana joks sisätää koko halusanan (-allkkon)
        //or (pos(san,sinkon)=1) then  //lyhyt sana  sisältyy hakuun .. alkukonsonantin ei tarttis sisältyä
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


exit;
assign(inf,'sanat99.ansi');  //synonyymit/liittyvät sanat
reset(inf);
//assign(outf,'testi.the');  //synonyymit/liittyvät sanat
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

beg7in
 try
  lev:=nodes[i].lev;
  rsana:=copy(slista[i],1,nodes[i].ru_lyh);
  tm_ero:= (tavus-nodes[i].tavucount);
  if (tm_ero=1) and (max(tavus,nodes[i].tavucount)<5) then begin writeln('EI:',i);continue;end;
 //ss:=lets[i].w;
 //wp:=copy(slista[ss],1,nodes[ss]ru_lyh);
 //if osa=2 then writeln(i,rsana);
 ookoo:=true;
 //if (slen=nodes[i]ru_lyh) or ((osa=1) and ) then
 if ookoo then
 begin
   result:=result+('+'+reversestring(slista[i]));
   writeln(' +++',blue(reversestring(slista[i])),rsana,'.');//,blue(rsana[slen+1]),slen+1);//,'.',rsana,',',sana);//,nodes[ss].reftavs,'<',tavus);
 end
else
writeln(' -',red(reversestring(slista[i])));//,slen+1);//,pit_ero,rsana,'/',sana);//,'.',rsana,',',sana);//,nodes[ss].reftavs,'<',tavus);
 // i-a-ri-a-na        sa-na
 //ap:=reversestring(wp);
 // if dd then writeln('???',slista[ss], '_',sana);
 finally
 try if not (rsana[lev]=sana[lev]) and (nodes[i].jump>i) then i:=nodes[i].jump else
 i:=i+1;
  //writeln('!jumpto:',i);
 except i:=i+1;writeln('????');end;
   //writeln('!:',i,'.',nodes[i].reftavs,'.',nodes[i].jump,'.',tavus);
 //if (nodes[i].reftavs>tavus) and (nodes[i].jump<>0) then i:=nodes[i].jump else
 try  writeln('[',rsana,lev,rsana[lev],sana[lev],']');//,'.',rsana,',',sana)
 except writeln('###',lev,'/',i,rsana,']');end;
 end;
end;
exit;
for i:=nodes[snum].lev-1 downto nodes[snum].ru_lyh-1 do
begin       //etsi ensimmäinen edeltäjä jossa on vähemmän (puunrakent kannalta merkitseviä) tavuja
  ss:=lets[i].w;
  let:=let+1;
  writeln(' ',i,reversestring(slista[ss]));//,ss,'=',copy(slista[ss],1,nodes[ss].ru_lyh)=sana,sana);
  //writeln(sopii(slista[ss],sana,nodes[i].lev,ok));
  if i>nodes[snum].ru_lyh-1 then writeln('+') else writeln('?');
  continue;
  writeln('===',ss,slista[ss],nodes[ss].ru_pit,nodes[ss].ru_lyh);
  //if nodes[ss].reftavs<tavus then
  //if nodes[ss].ru_pit<nodes[snum].ru_lyh then
  //if sana[i],(slista[],1,nos
  begin
     start:=lets[i].w;
     writeln('===',ss,slista[ss],nodes[ss].ru_pit,nodes[ss].ru_lyh);
     lev:=i;
     break;
  end;
end;
//writeln('</ul>');
exit;
//for i:=nodes[snum].lev-1 downto 1 do
i:=start;//ito:=nodes[snum].jump;
cc:=0;
while i<snum do  //
 //result:='!'+result;



-----------
,kavatora

function eds2(sana:ansistring;snum,cp:word):ansistring;
var cc,ss,i,ito,j,tavus,pw,start,slen,tm_ero,xxosa,xxosia:word;wp,ap,lp,rsana:ansistring;dd,ok:boolean;pit_ero:integer;
    tavs:tstringlist; //not good creating and freeing everytime
begin
  tavs:=tstringlist.create;
  result:='#'+inttostr(nodes[snum].tavucount);//('!!'+sana);
  //sana:=reversestring(sana);
  //dd:=sana=reversestring('voipivulla');
  //while sana<>'' do  if pos(sana[length(sana)],vokaalit)>0 then break else delete(sana,length(sana),1);
 //if nodes[snum].tavucount>3 then osia:=2 else osia:=1;
 //for osa:=1 to osia do
 begin
   sana:=copy(sana,1,nodes[snum].ru_lyh);
   slen:=nodes[snum].ru_lyh;
   tavus:=nodes[snum].tavucount; //huom tavut, ei reftavut
   {if osa=2 then begin  //täysin kömpelö ja hidas
       hyphenfirev(sana,tavs);
       sana:='';
       tavus:=tavs.count-3;
       for i:=3 to tavs.count-1  do sana:=reversestring(tavs[i])+sana;
       while pos(sana[length(sana)],konsonantit)>0 do delete(sana,length(sana),1);
       //for i:=
       slen:=length(sana);
       writeln('<b>lyhyt:'+sana+'</b>',slen);
       //writeln('::',sana,'/',nodes[snum].tavucount,' ');
       tavs.free;
   end;}
   for i:=nodes[snum].lev-1 downto 1 do
   begin       //etsi ensimmäinen edeltäjä jossa on vähemmän tavuja
     ss:=lets[i].w;
     if nodes[ss].reftavs<tavus then
     begin
        start:=lets[i].w;
        //writeln((sana),':',reversestring(slista[start]),':::');
        writeln('===',ss,slista[ss]);
        break;
     end;
  end;
   //for i:=nodes[snum].lev-1 downto 1 do
   i:=start;//ito:=nodes[snum].jump;
   while i<snum do  //
     begin
      try
       tm_ero:=abs(tavus-nodes[i].tavucount);
       if (tm_ero=1) and (max(tavus,nodes[i].tavucount)<5) then begin writeln('EI:',i,'>',nodes[i].jump,'|',nodes[i].reftavs,'>',tavus);continue;end;
      //ss:=lets[i].w;
      //wp:=copy(slista[ss],1,nodes[ss]ru_lyh);
      rsana:=copy(slista[i],1,nodes[i].ru_lyh);
      //if osa=2 then writeln(i,rsana);
      cc:=cc+1;
      if cc>300 then break;
      {pit_ero:=slen-nodes[i]ru_lyh;
      //if (rsana=sana) or ((nodes[i].tavucount mod 2 =tavus mod 2 then
        //if (pos(rsana,sana)=1) or (pos(sana,rsana)=1) or
        //if riimaa(rsana,sana) then  //vähän turhaakin laskentaa riimaa-funktiossa kun jo tiedetään jotain yht osasta
         // then  // yhden tavun ero paha .. yli nelitavussissa kyllä poikkeuksia
          ok:=true;
          //if (slen<>nodes[i]ru_lyh) then //ei raakata jos ihan samat
            //and (osa=)  then
           //  if (slen>nodes[i]ru_lyh) then begin if tavuraja(sana[nodes[i]ru_lyh+1],sana[nodes[i]ru_lyh]) then ok:=false end
           //  else if tavuraja(rsana[slen+1],rsana[slen]) then ok:=false;
          if (osa=2) and (sana<>rsana) then ok:=false else
          if (osia=2) and (osa=1) then // ei huomioida mitään lyhempiä, pidemmistä vain ne jotka jatkuu vasta tavunvaihdon jälkeen
          begin
             if (slen>nodes[i]ru_lyh) then ok:=false
             else if pos(rsana[slen+1],vokaalit)>0 then begin if isdifto(rsana[slen+1],rsana[slen]) then ok:=false;end
             else //yhtä pitkät
             if rsana<>sana then ok:=false;

          end
          else if (slen>nodes[i]ru_lyh) then begin if pos(sana[nodes[i]ru_lyh+1],vokaalit)>0 then if isdifto(sana[nodes[i]ru_lyh+1],sana[nodes[i]ru_lyh]) then ok:=false end
          else if pos(rsana[slen+1],vokaalit)>0 then if isdifto(rsana[slen+1],rsana[slen]) then ok:=false;
        }
         ok:=true;
          if ok then

          //if (slen=nodes[i]ru_lyh) or ((osa=1) and ) then
          begin
            result:=result+('++'+reversestring(slista[i]));
            writeln(' +',blue(reversestring(slista[i])));//,blue(rsana[slen+1]),slen+1);//,'.',rsana,',',sana);//,nodes[ss].reftavs,'<',tavus);
          end
         else
         writeln(' -',red(reversestring(slista[i])));//,slen+1);//,pit_ero,rsana,'/',sana);//,'.',rsana,',',sana);//,nodes[ss].reftavs,'<',tavus);
         //writeln(rsana,'/',sana);//,'.',rsana,',',sana)
          // i-a-ri-a-na        sa-na
      //ap:=reversestring(wp);
      // if dd then writeln('???',slista[ss], '_',sana);
      finally
        //writeln('!:',i,'.',nodes[i].reftavs,'.',nodes[i].jump,'.',tavus);
      //if (nodes[i].reftavs>tavus) and (nodes[i].jump<>0) then i:=nodes[i].jump else
      i:=i+1;
       //writeln('!jumpto:',i);
      end;
     end;
    //result:='!'+result;
  end;
end;
function sopii(tsana,ana:ansistring;posi:word;var goon:boolean):boolean;
var i,fitpos:word;
begin
 result:=true;
 writeln(' {<em style="color:red">',tsana,'/',ana,'#',posi,'</em>}');
 goon:=true;//??
 //if len(tsana)>posi then
 for i:=posi+1 to length(ana) do  ////puussa aiemmat joiden jatko voi sopia.. testataan ANA:n loppun asti
    if i>length(tsana) then break else if ana[i]<>tsana[i] then begin result:=false;exit;end;
 for i:=length(ana)+1 to length(tsana) do writeln('!',tsana[i]);
 for i:=length(ana)+1 to length(tsana) do if pos(tsana[i],vokaalit)>0 then begin result:=false;{testaa myös difton} exit;end;

end;
function edeltajat(sana:ansistring;snum,cp:word):ansistring;
var ss,i,j:word;wp,ap,lp:ansistring;dd:boolean;
begin
  //sana:=reversestring(sana);
  //dd:=sana=reversestring('voipivulla');
  //while sana<>'' do  if pos(sana[length(sana)],vokaalit)>0 then break else delete(sana,length(sana),1);
 sana:=copy(sana,1,nodes[snum].ru_lyh);
   result:='';//';'+(sana);
   for i:=1 to nodes[snum].lev-1 do
     begin
      ss:=lets[i].w;
      wp:=copy(slista[ss],1,nodes[ss].ru_lyh);
      //ap:=reversestring(wp);
      // if dd then writeln('???',slista[ss], '_',sana);
      if copy(slista[ss],1,nodes[ss].ru_lyh)=sana then
      begin

      end;
      if riimaa(copy(slista[ss],1,nodes[ss].ru_lyh),sana) then
      //lp:=copy(ap,i+1);ap:=copy(ap,1,i);
      //result:=' <b>'+ap+'</b>'+lp+' '+result;
      result:=reversestring(slista[ss])+' '+result;
     end;
    //result:='!'+result;

end;
function riimaa(rev1,rev2:ansistring):boolean;
var salku,left:ansistring;i,tavs:word;
begin
result:=false;                                             // ina,apina   ani,anipa >ipa  //     tae, e  eat, e  -->eat
//write(' ',rev1);
//write(' ',reversestring(rev1),'/',copy(rev1,length(rev2)),copy(rev2,length(rev1)));
if (pos(rev1,rev2)=1) then   begin write('');left:=copy(rev2,length(rev1));end
 else  if (pos(rev2,rev1)=1)then begin left:=copy(rev1,length(rev2));write('');;end
  else begin writeln('');exit;end;
 if length(left)<2 then begin writeln('');result:=true;exit;end;
 if not tavuraja(left[1],left[2]) then begin exit;writeln(':::',left);exit;end;
 tavs:=0;
 for i:=2 to length(left) do  if tavuraja(left[i],left[i+1]) then tavs:=tavs+1;
 //write(tavs);
 //writeln(' ',reversestring(rev1),'>',reversestring(left),tavs);
 if tavs<>1 then result:=true;
end;



function testaajatkot(w:word;haku:ansistring;cp:word):boolean;  //yhden noodin alanoodit. rekursio?
var i,j,upto:word;hk:ansistring;
begin
d:=true;
//d:=false;
 try
  upto:=nodes[w].jump;
    hk:=copy(haku,cp+1);  //haun mahdollinen alkukonsonantti
   // if d then writeln('<li>trying to find "',reversestring(hk),'" before <b>',reversestring(copy(yy[w],1,cp)),'</b>',cp, ' ',w,'..',nodes[w].jump,yy[w]);
    //if hk='' then writeln('nothin to find... almost anything goes');
    w:=w+1;cp:=cp+1;
    while (w<upto) and (w<>0) do
    begin
       if d then writeln('<li>/test:',slista[w][cp],cp, ' ',reversestring(copy(slista[w],1)),' ',w,'!',slista[w][cp],'!',slista[w][cp-1],isdifto(slista[w][cp],slista[w][cp-1]),'<ul>');
      //if hk='' then if pos(yy[ww]
      //if hk='' then
      //begin
      if (pos(slista[w][cp],konsonantit)<1) and (isdifto(slista[w][cp],slista[w][cp-1])) then
           //writeln('.. diftonki ', yy[w][cp],yy[w][cp-1],' ei kelpaa')
      else getword(w,0,cp);
      if d then writeln('###</ul>');
      w:=nodes[w].jump;
      if w=0 then exit;
    end;  //yhden tason jutut
   except writeln('<hr>jatko'); end;

end;


function getword(ww,tc,cutp:word):boolean;
var i,j,uto,muntavut,muntavutb:word;a,b:char;
begin
       uto:=max(nodes[ww].jump,ww+1);
       if d then writeln('<li>GW:',ww, '//',uto,copy(reversestring(slista[ww]),3),'//',cutp,'/',tc,'<ul>');
       while (ww<uto) do // and (ww<>0) do  //käy läpi suorat lapset
       begin
         muntavut:=0;//tc;
         muntavutb:=0;
         for i:=cutp to length(slista[ww]) do if tavuraja(slista[ww][i-1],slista[ww][i]) then muntavut:=muntavut+1;
         //if muntavut<4 then
        if d then  writeln('<li><tt>',reversestring(copy(slista[ww],cutp)),'...  </tt>',muntavut mod 2=1,' ',slista[ww]);
        try
        if muntavut mod 2=1 then lres.add(reversestring(slista[ww]));
         //writeln('////');
         ww:=ww+1;//nodes[ww].jump;
         //break;
         except writeln('<hr>NOGW',muntavut,'/');raise; end;
       end;
       if d then writeln('</ul>');

    end;
procedure knollaa(alku:integer); var ii:integer; begin  for ii:=alku to 23 do begin lets[ii].c:=#0;lets[ii].w:=0;end;  end;

function shorthits(san:ansistring;w,slen,sfar:word):tstringlist; //etsi sanat joissa vain konsonantti tietyn kohdan edellä
  var i,j,epoint:integer;  //ei huomio tuplakons vielä
  begin
    epoint:=nodes[w].jump;
    try
    if d then writeln('<li>tryshort@',w,'..',epoint,' ',reversestring(slista[w]),' ',san,'/L:',slen,'/F:',sfar);
    w:=w+1;
    while w<=epoint do
    begin
      if d then writeln('<li>SHORT',sfar,slen
      ,'(',w,reversestring(slista[w]),' |',slista[w][SFAR],' |',SAN[SFAR],'<b>',copy(slista[w],1,sfar),'</b>');
      if   slista[w][sfar]=SAN[sfAR] THEN
      begin
        if d then writeln('???',w,reversestring(COPY(slista[w],SFAR)+'/'+SAN),'!');
        //if length(yy[w])=sfar then writeln('hihithithithit!');

        w:=w+1;sfar:=sfar+1;
        if sfar+1=slen then
        begin
          writeln('<li>?????????',reversestring(slista[w]));//,'...',reversestring(slista[nodes[w].jump]));
          j:=w+1;epoint:=nodes[w].jump;
          while j<epoint do
          begin
            if j=0 then break;
            if d then  writeln('<li>--',reversestring(slista[j]),'+',slista[j][slen+1],'/',nodes[w].jump, '#',length(slista[j]),slen);
            if (length(slista[j])-3=slen) and (pos(slista[j][slen+1],konsonantit)>0) then
             sres.add(reversestring(slista[j]));//writeln('*************');
            j:=nodes[j].jump;
          end;
          break;
        end;
        continue;
      end;
      if slista[w][sfar]<SAN[sfAR] then w:=w+1 else  w:=nodes[w].jump;
      if w=0 then exit;
    end;
    except writeln('nono sex act');end;
end;

