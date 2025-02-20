{função EXTENSO
 pP1 valor numérico, pP2 moeda (real, dolar), retorna uma string}
function Extenso(pP1:double):String;
var
   N:double;
   R:string;
   I:integer;
begin
   for I:= 3 downto 0 do
   begin
     if I <> 0 then
        begin
//        N:=StrToFloat(Copy(Right(StrZero(pP1,12,0),3*I),1,3));
          N:=StrToFloat(Copy(Right(Copy(StrZero(pP1,15,2),1,12),3*I),1,3));
        end
     else
      begin
         R:= R+' reais';
         N:=StrToFloat(right(StrZero(pP1,12,2),2));
      end;
     if N <> 0 then
     begin
        R := R+' '+trim(Copy('            '+
                             'cem         '+
                             'duzentos    '+
                             'trezentos   '+
                             'quatrocentos'+
                             'quinhentos  '+
                             'seiscentos  '+
                             'setecentos  '+
                             'oitocentos  '+
                             'novecentos  ',(Trunc(int(N/100)*12)+1),12));
        N := N - int(N/100)*100;
        if N <> 0 then
          begin
           if length(trim(R))<> 0 then
              R:= R+' e ';
           R:= R + trim(Copy('         '+
                             'dez      '+
                             'vinte    '+
                             'trinta   '+
                             'quarenta '+
                             'cinqüenta'+
                             'sessenta '+
                             'setenta  '+
                             'oitenta  '+
                             'noventa  ',Trunc((int(N/10)*9)+1),9));

          end;
        N:= N - int(N/10)*10;
        if N <> 0 then
          begin
           if length(trim(R))<> 0 then
              R:= R+' e ';
           R:= R + trim(Copy('      '+
                             'um    '+
                             'dois  '+
                             'três  '+
                             'quatro'+
                             'cinco '+
                             'seis  '+
                             'sete  '+
                             'oito  '+
                             'nove  ',Trunc((N*6)+1),6));
          end;
        if I <> 0 then
        begin
          R:=R+' '+trim(Copy('        '+
                             'mil,    '+
                             'milhões,'+
                             'bilhões,'+
                             'trilhões',(I-1)*8+1,8));
        end;
        if I = 0 then
           R:=R+' centavos';
     end;
   end;
   R:=StrTran(R,'dez e um',    'onze');
   R:=StrTran(R,'dez e dois',  'doze');
   R:=StrTran(R,'dez e três',  'treze');
   R:=StrTran(R,'dez e quatro','catorze');
   R:=StrTran(R,'dez e cinco', 'quinze');
   R:=StrTran(R,'dez e seis',  'dezesseis');
   R:=StrTran(R,'dez e sete',  'dezessete');
   R:=StrTran(R,'dez e oito',  'dezoito');
   R:=StrTran(R,'dez e nove',  'dezenove');
   R:=StrTran(R,'cem e',       'cento e');
   R:=StrTran(R,'e  e',        'e');
   R:=StrTran(R,'e e',        'e');
   R:=StrTran(R,'ões  e',      'ões');
   R:=StrTran(R,'um milhões',  'um milhão');
   R:=StrTran(R,'um bilhões',  'um bilhão');
   R:=StrTran(R,'um trilhões', 'um trilhão');
   R:=StrTran(R,', reais',     ' reais');
   R:=StrTran(R,',  e',         ' e');
   result:=Alltrim(R);
   if Result='um  reais' then Result:='um real';
   if Copy(Result,1,9)='reais  e ' then Delete(Result,1,9);
   if Result='um centavos' then Result:='um centavo';
   Result:=StrTran(Result,'  ',' ');
end;
