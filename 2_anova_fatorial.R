

## Estat�stica avan�ada
## Anova Fatorial

names(exercicio2)
dados=data.frame(exercicio2)
attach(dados)
colnames(dados)=c("r�plica", "per�odo", "mata_ciliar", "Diversidade")
names(dados)

# Exemplo em aula para fatorial
fat2.dic(per�odo, mata_ciliar, Diversidade)
interaction.plot(mata_ciliar,per�odo, Diversidade)
boxplot(Diversidade~per�odo)
boxplot(Diversidade~mata_ciliar)


fat2.dic(per�odo, mata_ciliar, Diversidade,quali=c(T,T),mcomp="tukey",fac.names=c("Grupos","Aplica��o"),
         sigT=0.05, sigF=0.05)

interaction.plot(per�odo, mata_ciliar, Diversidade)

aplic1=data.frame(ddply(dados,~per�odo*mata_ciliar,summarise,mean=mean(Diversidade),sd=(sd(Diversidade))))
aplic1

pd <- position_dodge(.3)
per�odo=factor(dados$per�odo)
mata=factor(dados$mata_ciliar)

ggplot(aplic1,aes(x=per�odo,y=mean, colour=mata_ciliar, group=mata_ciliar))+
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width =.2, size=0.25,
                colour="black", position= pd)+geom_line(position=pd)+
  geom_point(position=pd, size=1)+ylab("ganho de peso por gramas/dia")

## Outro exercicio
dados2=data.frame(exerc2_arranjo_fatorial)
names(dados2)

logbiomassa=log10(dados2$Biomassa)
logbiomassa
dados3=data.frame(dados2, logbiomassa)
names(dados3)
attach(dados3)

aplic2=data.frame(ddply(dados3,~per�odo*mata_ciliar,summarise,mean2=mean(logbiomassa),sd2=(sd(logbiomassa))))
aplic2

ggplot(aplic2,aes(x=mata_ciliar,y=mean2, colour=per�odo, group=per�odo))+
  geom_errorbar(aes(ymin=mean2-sd2, ymax=mean2+sd2), width =.2, size=0.25,
                colour="black", position= pd)+geom_line(position=pd)+
  geom_point(position=pd, size=1)+ylab("ganho de peso por gramas/dia")


logbiomassa=log10(dados2$Biomassa)
logbiomassa

bartlett.test(dados3$logbiomassa~mata_ciliar) ## ! N�o homocedastico
bartlett.test(dados3$logbiomassa~per�odo)

fat2.dic(per�odo, mata_ciliar, logbiomassa,quali=c(T,T),mcomp="tukey",fac.names=c("Per�odo","Mata ciliar"),
         sigT=0.05, sigF=0.05)

dim(dados3)

bloco=c("A","B","C","D","E","A","B","C","D","E","A","B","C","D","E","A","B","C","D","E","A","B","C","D","E","A","B","C","D","E")
length(bloco)

dados3=data.frame(dados3, bloco)
dados3
colnames(dados3)=c("r�plica", "per�odo", "mata_cilicar", "H", "biomassa", "logbiom","bloco")
names(dados3)
attach(dados3)

fat2.dbc(per�odo, mata_ciliar, bloco, logbiom, quali=c(T,T), mcomp="tukey", fac.names=c("Per�odo","Mata ciliar"))
bartlett.test(logbiom~per�odo)
bartlett.test(logbiom~mata_ciliar)

aplic3=data.frame(ddply(dados3,~per�odo*mata_ciliar+bloco,summarise,mean3=mean(logbiomassa),sd3=(sd(logbiomassa))))
aplic3

## -- ANOVA PARA MEDIDAS REPETIDAS -- ##
## Como medida repetita!
## O per�odo seria uma medida repetida - mesma unidade em duas esta��es
## o fator sera a mata ciliar

names(dados3)

anovarepetidas<- aov(logbiom ~ mata_ciliar * per�odo * Error(r�plica/logbiom)) 
summary(anovarepetidas)

l=lme(logbiom ~ mata_ciliar*per�odo,random=~1|r�plica/logbiom) 
summary(l)
