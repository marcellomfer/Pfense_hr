Esse script em Shell Script foi desenvolvido para monitorar um servidor pfSense e enviar um relatório detalhado para um grupo ou canal do Telegram. Além disso, se algum serviço crítico estiver inativo, o script tenta reiniciá-lo automaticamente.
🔍 O que esse script faz?

1️⃣ Coleta informações do servidor:
Sistema: Nome do host, versão do pfSense e tempo de atividade.
CPU: Modelo, número de núcleos e frequência.
Memória RAM: Total disponível e percentual de uso.
Disco: Espaço total, usado, disponível e uso da swap.
Gateway: Status da conexão com a internet (delay, perda de pacotes e substatus).
Rede: Monitoramento de tráfego das interfaces.

2️⃣ Verifica o status de serviços importantes, como:
Squid, DNS, VPN, SSH, Syslog, Zabbix, entre outros (você pode personalizar a lista).
Se um serviço estiver inativo, o script tenta reiniciá-lo automaticamente.

3️⃣ Envia o relatório para um grupo ou canal do Telegram, permitindo monitoramento remoto em tempo real.
📩 Como funciona o envio para o Telegram?
O script usa a API do Telegram para enviar mensagens.
Para funcionar, você precisa criar um bot no Telegram e obter:
BOT_TOKEN → Chave do bot criado.
CHAT_ID → ID do grupo/canal onde deseja receber o relatório.
THREAD_ID (se for dentro de um tópico de um supergrupo).
📌 Exemplo de relatório gerado no Telegram:
🚀 Hardware Report - pfSense Server 🚀
🖥 Sistema:
Hostname: firewall01
Versão do pfSense: x.x.x
Tempo de atividade: xx dias, xx horas, xx minutos
⚙ CPU:
Modelo: 
Núcleos: x
Frequência: MHz
🧠 Memória RAM:
Total:  x GB
Uso: x%
💾 Discos:
Total:  xGB | Usado: xGB | Disponível: xGB | Uso: x%
Swap: x%
🌐 Status do Gateway:
Delay: 12ms | Loss: 0% | Substatus: OK
🌐 Interfaces de Rede:
eth0: TX 5.6 GB | RX 7.8 GB
eth1: TX 12.4 GB | RX 20.3 GB
🛠 Status dos Serviços:
✅ Squid: Ativo
✅ DNSMasq: Ativo
♻ Zabbix Agent: Reiniciado
✅ OpenVPN: Ativo
🔥 Firewall: ✅ Ativo

🚀 Benefícios desse script
✅ Monitoramento proativo → Receba status do servidor diretamente no Telegram.
✅ Ação automatizada → Reinicia serviços automaticamente ao detectar falhas.
✅ Fácil personalização → Adapte a lista de serviços monitorados e os dados coletados.
✅ Rápida resposta a incidentes → Reduz downtime de serviços críticos.

Se precisar de alguma adaptação ou explicação adicional, me avise! 🚀
