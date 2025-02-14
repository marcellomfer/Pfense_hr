#!/bin/sh
#######################################################################
# SHELL SCRIPT DE HARDWARE REPORT PARA pfSense
# DESENVOLVIDO POR MARCELLO MANHAES FERNANDES - marcellomfer@gmail.com
#######################################################################
#
# VERSÃO 0.0 ULTIMA ATUALIZAÇÃO 14/02/2025
#
#######################################################################
# VERSÃO 0.0 -> CRIAÇÃO DO SCRIPT. Data 14/02/2025.
#######################################################################
# Configuração do Telegram
BOT_TOKEN="O_ID_DO_BOOT"
CHAT_ID="ID_DO_SEU_CANAL"
THREAD_ID="ID_DO_TOPICO"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
# Função para enviar mensagens
send_telegram() {
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "message_thread_id=$THREAD_ID" -d "text=$REPORT" -d parse_mode="markdown" > /dev/null
}
# Função para calcular o uso da memória RAM
mem_usage() {
    totalMem=$(sysctl -n hw.physmem)
    freeMem=$(sysctl -n vm.stats.vm.v_free_count)
    cachedMem=$(sysctl -n vm.stats.vm.v_cache_count)
    inactiveMem=$(sysctl -n vm.stats.vm.v_inactive_count)
    bufferMem=$(sysctl -n vfs.bufspace)
    wiredMem=$(sysctl -n vm.stats.vm.v_wire_count)
    pageSize=$(sysctl -n hw.pagesize)
    freeMemBytes=$((freeMem * pageSize))
    cachedMemBytes=$((cachedMem * pageSize))
    inactiveMemBytes=$((inactiveMem * pageSize))
    wiredMemBytes=$((wiredMem * pageSize))
    bufferMemBytes=$((bufferMem))
    adjustedUsedMem=$((totalMem - freeMemBytes - cachedMemBytes - inactiveMemBytes - bufferMemBytes - wiredMemBytes + (wiredMemBytes * 2 / 5) + (bufferMemBytes * 2 / 5)))
    memUsage=$(echo "scale=2; ($adjustedUsedMem * 100) / $totalMem" | bc)
    echo "$memUsage"
}
# Criar relatório
REPORT="🚀 *Hardware Report - pfSense Server* 🚀
🖥 *Sistema:*
-------------------
*Hostname:* $(hostname)
*Versão do pfSense:* $(cat /etc/version)
*Tempo de atividade:* $(uptime | awk -F'( |,|:)+' '{print $5" dias, "$7" horas, "$8" minutos"}')
⚙ *CPU:*
-------------------
$(sysctl -n hw.model)
*Núcleos:* $(sysctl -n hw.ncpu)https://github.com/marcellomfer/Pfense_hr/blob/main/Hardware_Report.sh
*Frequência:* $(dmesg | grep -m 1 'CPU:' | grep -oE '[0-9]+\.[0-9]+-MHz' | sed 's/-MHz/ MHz/')
🧠 *Memória RAM:*
-------------------
*Total:* $(echo "$(sysctl -n hw.physmem) / 1024 / 1024" | bc) MB
*Uso:* $(mem_usage)%
💾 *Discos:*
-------------------
$(df -lh / | awk 'NR==2 {print "*Total:* "$2" | *Usado:* "$3" | *Disponível:* "$4" | *Uso:* "$5}')
*Swap:* $(swapinfo | awk 'NR==2 {print $5}')
🌐 *Status do Gateway:*
-------------------
$(pfSsh.php playback gatewaystatus | awk 'NR>1 {print "*Delay:* "$4" | *Loss:* "$6" | *Substatus:* "$7}')
🌐 *Interfaces de Rede:*
-------------------
$(netstat -ib | awk '
{
    if ($1 == "xn0" || $1 == "xn1" || $1 == "l2tps1") {
        received[$1] += $(NF-4) / 1073741824;
        sent[$1] += $(NF-1) / 1073741824;
    }
}
END {
    for (iface in received) {
        printf "*%s:* TX %.2f GB | RX %.2f GB\n", iface, received[iface], sent[iface];
    }
}')
🛠 *Status dos Serviços:*
-------------------
$(for svc in c-icap clamd dnsmasq dpinger ipsec lightsquid_web ntopng ntpd squid squidGuard sshd syslogd zabbix_agentd; do # Verificar quais serviços estão sendo executados no seu servidor para efetuar o monitoramento
    status=$(/usr/local/sbin/pfSsh.php playback svc status $svc 2>/dev/null | awk 'NR==2' | grep -q "is running" && echo "✅ Ativo" || echo "❌ Inativo")
    if [ "$status" = "❌ Inativo" ]; then
        /usr/local/sbin/pfSsh.php playback svc stop $svc > /dev/null
        /usr/local/sbin/pfSsh.php playback svc start $svc > /dev/null
        status="♻ Reiniciado"
    fi
    echo "*$svc:* $status"
done)
🔥 *Firewall:* $(pfctl -si | grep -q 'Status: Enabled' && echo "✅ Ativo" || echo "❌ Inativo")"
# Enviar relatório pelo Telegram
send_telegram "$REPORT"
