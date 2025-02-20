# Projeto-Frente-de-Caixa
Projeto Frente de Caixa PDV ECF/NFC-e/SAT/MFE/MEI - Delphi 7

Projeto para emissão de 
- Cupom Fiscal: compatível com todas impressoras fiscais, dos convênios 85/01 e 0909, através de arquvios .DLL dos fabricantes. Existe uma unit para cada .DLL suportada
- NFC-e: utiliza componente da Tecnospeed para realizar todos os eventos envolvendo NFC-e
- SAT/MFE: compatível com todos SAT/MFE do mercado. Utiliza classe nativa em Delphi para comunicação com equipamentos SAT/MFE
- MEI: possibilita empresas optante pelo MEI realizarem a venda sem a emissão de documento fiscal

Melhorias necessárias no código:
- Migrar para Delphi atual, observando com muita atenção a questão de incompatibilidade entre a versão 7 e a atual do Delphi. Será preciso testes minuciosos com ECF depois de migrado para Delphi atual
