{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my_config.mihomo.enable = lib.mkEnableOption "enable mihomo TUN proxy";

  config = lib.mkIf config.my_config.mihomo.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.unstable.mihomo;
      tunMode = true;
      webui = pkgs.zashboard;
      configFile = config.sops.templates."mihomo-config".path;

    };
    sops.templates.mihomo-config.content = ''
      # 订阅合集
      SubsParam: &SubsParam {type: http, interval: 86400, health-check: {enable: true, url: 'http://cp.cloudflare.com/generate_204', interval: 300}}

      proxy-providers:
        fib:
          # 一次性订阅链接，手动输入
          url: ""
          <<: *SubsParam
          path: "./proxy_provider/fib.yaml"

      port: 7890
      socks-port: 7891
      mixed-port: 7892
      allow-lan: true
      bind-address: "*"
      external-controller: 0.0.0.0:9090
      mode: rule
      log-level: info
      unified-delay: true
      tcp-concurrent: true
      profile:
        store-selected: true
      geo-auto-update: true
      geo-update-interval: 24
      geodata-mode: true
      geox-url:
        geoip: "https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat"
        geosite: "https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat"
        mmdb: "https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb"
        asn: "https://github.com/xishang0128/geoip/releases/download/latest/GeoLite2-ASN.mmdb"
      dns:
        enable: true
        ipv6: true
        prefer-h3: true
        # enhanced-mode: redir-host
        respect-rules: true
        cache-algorithm: arc
        default-nameserver:
          - 119.29.29.29
          - 223.5.5.5
          - system
        proxy-server-nameserver:
          - https://1.1.1.1/dns-query
          - https://dns.google/dns-query
          - https://223.5.5.5/dns-query
          - 119.29.29.29
        direct-nameserver:
          - system
          - dhcp://system
          - https://223.5.5.5/dns-query
          - https://223.6.6.6/dns-query
        nameserver:
          - https://dns.cloudflare.com/dns-query
          - https://doh.opendns.com/dns-query
          - https://doh.pub/dns-query
          - https://dns.alidns.com/dns-query
        fallback:
          - https://8.8.8.8/dns-query#proxy&ecs=1.1.1.1/24&ecs-override=true
          - tls://8.8.4.4
          - tls://1.1.1.1
        fallback-filter:
          geoip: true
          geoip-code: CN
          geosite:
            - gfw
          ipcidr:
            - 240.0.0.0/4
          domain:
            - "+.google.com"
            - "+.facebook.com"
            - "+.youtube.com"
            - "+.jsdelivr.net"

      sniffer:
        enable: true
        force-dns-mapping: true
        parse-pure-ip: true
        sniff:
          HTTP:
            port:
              - "80"
              - "8080-8880"
            override-destination: true
          TLS:
            port:
              - "443"
              - "8443"
            override-destination: true
          QUIC:
            port:
              - "443"
              - "8443"
            override-destination: true
        force-domain:
          - "+.netflix.com"
          - "+.nflxvideo.net"
          - "+.amazonaws.com"
          - "+.media.dssott.com"
        skip-domain:
          - "+.apple.com"
          - Mijia Cloud
          - dlg.io.mi.com
          - "+.oray.com"
          - "+.sunlogin.net"
          - "+.push.apple.com"
      tun:
        enable: true
        stack: system

      # 节点筛选
      # 按地区筛选
      FilterHK: &FilterHK '^(?=.*((?i)🇭🇰|香港|\b(HK|Hong)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterTW: &FilterTW '^(?=.*((?i)🇹🇼|台湾|\b(TW|Tai|Taiwan)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterJP: &FilterJP '^(?=.*((?i)🇯🇵|日本|川日|东京|大阪|泉日|埼玉|\b(JP|Japan)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterKR: &FilterKR '^(?=.*((?i)🇰🇷|韩国|韓|首尔|\b(KR|Korea)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterSG: &FilterSG '^(?=.*((?i)🇸🇬|新加坡|狮|\b(SG|Singapore)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterUS: &FilterUS '^(?=.*((?i)🇺🇸|美国|波特兰|达拉斯|俄勒冈|凤凰城|费利蒙|硅谷|拉斯维加斯|洛杉矶|圣何塞|圣克拉拉|西雅图|芝加哥|\b(US|United States)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterUK: &FilterUK '^(?=.*((?i)🇬🇧|英国|伦敦|\b(UK|United Kingdom)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterFR: &FilterFR '^(?=.*((?i)🇫🇷|法国|\b(FR|France)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterDE: &FilterDE '^(?=.*((?i)🇩🇪|德国|\b(DE|Germany)(\d+)?\b))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|订阅|节点)).*$'
      FilterOthers: &FilterOthers "^(?!.*(🇭🇰|HK|Hong|香港|🇹🇼|TW|Taiwan|Wan|🇯🇵|JP|Japan|日本|🇸🇬|SG|Singapore|狮城|🇺🇸|US|United States|America|美国|🇩🇪|DE|Germany|德国|🇬🇧|UK|United Kingdom|英国|🇰🇷|KR|Korea|韩国|韓|🇫🇷|FR|France|法国)).*$"
      FilterAll: &FilterAll '^(?=.*(.))(?!.*((?i)群|邀请|返利|循环|官网|客服|公告|网站|网址|获取|订阅|流量|到期|机场|下次|版本|官址|备用|过期|已用|联系|邮箱|工单|贩卖|通知|倒卖|防止|国内|地址|频道|无法|说明|使用|提示|特别|访问|支持|教程|关注|更新|作者|加入|(\b(USE|USED|TOTAL|EXPIRE|EMAIL|Panel|Channel|Author)\b|(\d{4}-\d{2}-\d{2}|\d+G)))).*$'
      FilterSpecial: &FilterSpecial '^(?=.*(.))(?!.*((?i)Steam解锁|Steam跨区|特殊|群|邀请|返利|循环|官网|客服|公告|网站|网址|获取|订阅|流量|到期|机场|下次|版本|官址|备用|过期|已用|联系|邮箱|工单|贩卖|通知|倒卖|防止|国内|地址|频道|无法|说明|使用|提示|特别|访问|支持|教程|关注|更新|作者|加入|(\b(USE|USED|TOTAL|EXPIRE|EMAIL|Panel|Channel|Author)\b|\d{4}-\d{2}-\d{2}|\d+G)|((?<![\d.])((([1-9]\d+|[2-9])(\.\d+)?)|1\.\d*[1-9]\d*)倍|(?<![a-zA-Z])[xX]((([1-9]\d+|[2-9])(\.\d+)?)|1\.\d*[1-9]\d*)))).*$'
      FilterNetflix: &FilterNetflix '^(?=.*((?i)流媒体|原生解锁(\d+)?\b|([\u4e00-\u9fa5]{2,4}|\b[A-Z]{2}\b)[- ]?\d+))(?!.*((?i)回国|校园|网站|地址|剩余|过期|时间|有效|网址|禁止|邮箱|发布|客服|公告|订阅|节点)).*$'

      UrlTestParam: &UrlTestParam {url: http://www.gstatic.com/generate_204, interval: 300, tolerance: 50}

      proxy-groups:
        - name: "🚀 节点选择"
          type: select
          proxies:
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "🚀 手动切换"
          type: select
          include-all: true
          filter: *FilterAll
        - name: "♻️ 自动选择"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterSpecial
        - name: "🔯 故障转移"
          type: fallback
          <<: *UrlTestParam
          include-all: true
          filter: *FilterSpecial
        - name: "🔮 负载均衡"
          type: load-balance
          strategy: consistent-hashing
          <<: *UrlTestParam
          include-all: true
          filter: *FilterSpecial
        - name: "🐟 漏网之鱼"
          type: select
          proxies:
            - "🚀 节点选择"
            - DIRECT
        - name: "📲 电报消息"
          type: select
          proxies:
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "狮城节点"
            - "香港节点"
            - "台湾节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "💬 Ai平台"
          type: select
          proxies:
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "狮城节点"
            - "香港节点"
            - "台湾节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "📹 油管视频"
          type: select
          proxies:
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "狮城节点"
            - "香港节点"
            - "台湾节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "🎥 奈飞视频"
          type: select
          proxies:
            - "🎥 奈飞节点"
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "狮城节点"
            - "香港节点"
            - "台湾节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "📺 巴哈姆特"
          type: select
          proxies:
            - "台湾节点"
            - "🚀 节点选择"
            - "🚀 手动切换"
            - DIRECT
        - name: "📺 哔哩哔哩"
          type: select
          proxies:
            - "🎯 全球直连"
            - "台湾节点"
            - "香港节点"
        - name: "🌍 国外媒体"
          type: select
          proxies:
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
            - DIRECT
        - name: "🌏 国内媒体"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "美国节点"
            - "韩国节点"
        - name: "📢 谷歌FCM"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: Ⓜ️ 微软Bing
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: Ⓜ️ 微软云盘
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: Ⓜ️ 微软服务
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: "🍎 苹果服务"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: "🎮 游戏平台"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: "🎶 网易音乐"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
        - name: "🎯 全球直连"
          type: select
          proxies:
            - DIRECT
            - "🚀 节点选择"
        - name: "🛑 广告拦截"
          type: select
          proxies:
            - REJECT
            - DIRECT
        - name: "🍃 应用净化"
          type: select
          proxies:
            - REJECT
            - DIRECT
        - name: "香港节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterHK
        - name: "日本节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterJP
        - name: "美国节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterUS
        - name: "台湾节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterTW
        - name: "狮城节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterSG
        - name: "韩国节点"
          type: url-test
          <<: *UrlTestParam
          include-all: true
          filter: *FilterKR
        - name: "🎥 奈飞节点"
          type: select
          include-all: true
          filter: *FilterNetflix
        - name: EHGallery
          type: select
          proxies:
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - "美国节点"
            - "香港节点"
            - "台湾节点"
            - "狮城节点"
            - "日本节点"
            - "韩国节点"
            - DIRECT
        - name: Gemini
          type: select
          proxies:
            - "💬 Ai平台"
            - "🚀 节点选择"
            - "🚀 手动切换"
            - "♻️ 自动选择"
            - "🔯 故障转移"
            - "🔮 负载均衡"
            - DIRECT
      rule-providers:
        reject:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/reject.txt"
          path: ./ruleset/reject.yaml
          interval: 86400
        icloud:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/icloud.txt"
          path: ./ruleset/icloud.yaml
          interval: 86400
        apple:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/apple.txt"
          path: ./ruleset/apple.yaml
          interval: 86400
        google:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/google.txt"
          path: ./ruleset/google.yaml
          interval: 86400
        proxy:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/proxy.txt"
          path: ./ruleset/proxy.yaml
          interval: 86400
        direct:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/direct.txt"
          path: ./ruleset/direct.yaml
          interval: 86400
        private:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/private.txt"
          path: ./ruleset/private.yaml
          interval: 86400
        gfw:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/gfw.txt"
          path: ./ruleset/gfw.yaml
          interval: 86400
        tld-not-cn:
          type: http
          behavior: domain
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/tld-not-cn.txt"
          path: ./ruleset/tld-not-cn.yaml
          interval: 86400
        telegramcidr:
          type: http
          behavior: ipcidr
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/telegramcidr.txt"
          path: ./ruleset/telegramcidr.yaml
          interval: 86400
        cncidr:
          type: http
          behavior: ipcidr
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/cncidr.txt"
          path: ./ruleset/cncidr.yaml
          interval: 86400
        lancidr:
          type: http
          behavior: ipcidr
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/lancidr.txt"
          path: ./ruleset/lancidr.yaml
          interval: 86400
        applications:
          type: http
          behavior: classical
          url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/applications.txt"
          path: ./ruleset/applications.yaml
          interval: 86400
        EHGallery:
          type: http
          behavior: classical
          path: "./rule_provider/EHGallery.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/EHGallery.yaml
          interval: 86400
        微软服务:
          type: http
          behavior: classical
          path: "./rule_provider/Microsoft.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Microsoft.yaml
          interval: 86400
        LocalAreaNetwork:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvTG9jYWxBcmVhTmV0d29yay5saXN0
          path: "./rule_provider/LocalAreaNetwork.yaml"
          interval: 86400
        UnBan:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvVW5CYW4ubGlzdA
          path: "./rule_provider/UnBan.yaml"
          interval: 86400
        BanAD:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvQmFuQUQubGlzdA
          path: "./rule_provider/BanAD.yaml"
          interval: 86400
        BanProgramAD:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvQmFuUHJvZ3JhbUFELmxpc3Q
          path: "./rule_provider/BanProgramAD.yaml"
          interval: 86400
        GoogleFCM:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9Hb29nbGVGQ00ubGlzdA
          path: "./rule_provider/GoogleFCM.yaml"
          interval: 86400
        GoogleCN:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvR29vZ2xlQ04ubGlzdA
          path: "./rule_provider/GoogleCN.yaml"
          interval: 86400
        SteamCN:
          type: http
          behavior: classical
          path: "./rule_provider/SteamCN.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/SteamCN.yaml
          interval: 86400
        Bing:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvQmluZy5saXN0
          path: "./rule_provider/Bing.yaml"
          interval: 86400
        OneDrive:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvT25lRHJpdmUubGlzdA
          path: "./rule_provider/OneDrive.yaml"
          interval: 86400
        Microsoft:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvTWljcm9zb2Z0Lmxpc3Q
          path: "./rule_provider/Microsoft.yaml"
          interval: 86400
        Apple:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvQXBwbGUubGlzdA
          path: "./rule_provider/Apple.yaml"
          interval: 86400
        Telegram:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvVGVsZWdyYW0ubGlzdA
          path: "./rule_provider/Telegram.yaml"
          interval: 86400
        AI:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9BSS5saXN0
          path: "./rule_provider/AI.yaml"
          interval: 86400
        OpenAi:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9PcGVuQWkubGlzdA
          path: "./rule_provider/OpenAi.yaml"
          interval: 86400
        NetEaseMusic:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9OZXRFYXNlTXVzaWMubGlzdA
          path: "./rule_provider/NetEaseMusic.yaml"
          interval: 86400
        Epic:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9FcGljLmxpc3Q
          path: "./rule_provider/Epic.yaml"
          interval: 86400
        Origin:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9PcmlnaW4ubGlzdA
          path: "./rule_provider/Origin.yaml"
          interval: 86400
        Sony:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9Tb255Lmxpc3Q
          path: "./rule_provider/Sony.yaml"
          interval: 86400
        Steam:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9TdGVhbS5saXN0
          path: "./rule_provider/Steam.yaml"
          interval: 86400
        Steam-社区(Beta):
          type: http
          behavior: ipcidr
          url: https://raw.githubusercontent.com/FQrabbit/SSTap-Rule/refs/heads/master/rules/Steam.rules
          path: "./game_rules/Steam.rules"
          interval: 86400
        Nintendo:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9OaW50ZW5kby5saXN0
          path: "./rule_provider/Nintendo.yaml"
          interval: 86400
        YouTube:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9Zb3VUdWJlLmxpc3Q
          path: "./rule_provider/YouTube.yaml"
          interval: 86400
        Bahamut:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9CYWhhbXV0Lmxpc3Q
          path: "./rule_provider/Bahamut.yaml"
          interval: 86400
        BilibiliHMT:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9CaWxpYmlsaUhNVC5saXN0
          path: "./rule_provider/BilibiliHMT.yaml"
          interval: 86400
        Bilibili:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUnVsZXNldC9CaWxpYmlsaS5saXN0
          path: "./rule_provider/Bilibili.yaml"
          interval: 86400
        ChinaMedia:
          type: http
          behavior: classical
          path: "./rule_provider/ChinaMedia.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/ChinaMedia.yaml
          interval: 86400
        ProxyMedia:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvUHJveHlNZWRpYS5saXN0
          path: "./rule_provider/ProxyMedia.yaml"
          interval: 86400
        ProxyGFWlist:
          type: http
          behavior: classical
          path: "./rule_provider/ProxyGFWlist.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/ProxyGFWlist.yaml
          interval: 86400
        ChinaDomain:
          type: http
          behavior: classical
          path: "./rule_provider/ChinaDomain.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/ChinaDomain.yaml
          interval: 86400
        ChinaCompanyIp:
          type: http
          behavior: ipcidr
          path: "./rule_provider/ChinaCompanyIp.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/ChinaCompanyIp.yaml
          interval: 86400
        Download:
          type: http
          behavior: classical
          url: https://api.dler.io/getruleset?type=6&url=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FDTDRTU1IvQUNMNFNTUi9tYXN0ZXIvQ2xhc2gvRG93bmxvYWQubGlzdA
          path: "./rule_provider/Download.yaml"
          interval: 86400
        国内IP白名单(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/Domestic IPs.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Domestic
            IPs.yaml
          interval: 86400
        放行规则-lhie1:
          type: http
          behavior: classical
          path: "./rule_provider/Special.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Special.yaml
          interval: 86400
        放行规则-ACL4SSR:
          type: http
          behavior: classical
          path: "./rule_provider/UnBan-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/UnBan.yaml
          interval: 86400
        ChinaIp(By ACL4SSR):
          type: http
          behavior: ipcidr
          path: "./rule_provider/ChinaIp-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/ChinaIp.yaml
          interval: 86400
        国内域名白名单(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/Domestic.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Domestic.yaml
          interval: 86400
        OneDrive(By ACL4SSR):
          type: http
          behavior: classical
          path: "./rule_provider/OneDrive-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/OneDrive.yaml
          interval: 86400
        广告规则(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/AdBlock.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/AdBlock.yaml
          interval: 86400
        Bilibili(By ACL4SSR):
          type: http
          behavior: classical
          path: "./rule_provider/Bilibili-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/Bilibili.yaml
          interval: 86400
        YouTube Music:
          type: http
          behavior: classical
          path: "./rule_provider/YouTube Music.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Media/YouTube
            Music.yaml
          interval: 86400
        YouTube(By ACL4SSR):
          type: http
          behavior: classical
          path: "./rule_provider/YouTube-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/YouTube.yaml
          interval: 86400
        YouTube(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/YouTube-lhie1.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Media/YouTube.yaml
          interval: 86400
        Netflix(By ACL4SSR):
          type: http
          behavior: classical
          path: "./rule_provider/Netflix-ACL4SSR.yaml"
          url: https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Providers/Ruleset/Netflix.yaml
          interval: 86400
        Netflix(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/Netflix-lhie1.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Media/Netflix.yaml
          interval: 86400
        Netflix:
          type: http
          behavior: classical
          path: "./rule_provider/Netflix.yaml"
          url: https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/refs/heads/master/rule/Clash/Netflix/Netflix_Classical.yaml
          interval: 86400
        国外常用网站合集(By lhie1):
          type: http
          behavior: classical
          path: "./rule_provider/Proxy.yaml"
          url: https://raw.githubusercontent.com/dler-io/Rules/master/Clash/Provider/Proxy.yaml
          interval: 86400
        direct-applications:
          type: http
          behavior: classical
          path: "./rule_provider/direct-applications.yaml"
          url: https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/applications.txt
          interval: 86400
        Osu!:
          type: http
          behavior: ipcidr
          url: https://raw.githubusercontent.com/FQrabbit/SSTap-Rule/refs/heads/master/rules/Osu!.rules
          path: "./game_rules/Osu!.rules"
          interval: 86400
        ads:
          type: http
          behavior: domain
          path: "./rule_provider/ads.yaml"
          url: https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/reject.txt
          interval: 86400
        my_proxy:
          type: inline
          behavior: classical
          path: "./rule_provider/my_proxy.yaml"
          payload:
            # i2p
            - DOMAIN-SUFFIX,www2.mk16.de
            - DOMAIN-SUFFIX,i2p.ghativega.in
            - DOMAIN-SUFFIX,reseed.memcpy.io
            - DOMAIN-SUFFIX,i2pseed.creativecowpat.net
            - DOMAIN-SUFFIX,reseed2.i2p.net
            # osu
            - DOMAIN-SUFFIX,ppy.sh
            # code
            - DOMAIN-SUFFIX,nixos.org
            # bluesky
            - DOMAIN-SUFFIX,bsky.app
            - DOMAIN-SUFFIX,bsky.network
            - DOMAIN-SUFFIX,bsky.social
            - DOMAIN-SUFFIX,brid.gy
            # fediverse
            - DOMAIN-SUFFIX,mstdn.social
            - DOMAIN-SUFFIX,sushi.ski
            - DOMAIN-SUFFIX,m-i.im
            - DOMAIN-SUFFIX,social.datalabour.com
            - DOMAIN-SUFFIX,bird.makeup
            # common
            - DOMAIN-SUFFIX,cangku.moe
            - DOMAIN-SUFFIX,bewildcard.com
            - DOMAIN-SUFFIX,reimu.net
            - DOMAIN-SUFFIX,dzmm.ai
            - DOMAIN-SUFFIX,novelai.net
            - DOMAIN-SUFFIX,baozhen.jp
            - DOMAIN-SUFFIX,annas-archive.org
            - DOMAIN-SUFFIX,bangumi.moe
            - DOMAIN-SUFFIX,diyibanzhu.me
            - DOMAIN-SUFFIX,simplex.chat
            - DOMAIN-SUFFIX,simplex.im
            - DOMAIN-SUFFIX,briarproject.org
            - DOMAIN-SUFFIX,manus.im
            - DOMAIN-SUFFIX,linux.do
            - DOMAIN-SUFFIX,wezterm.org
            - DOMAIN-SUFFIX,debian.org
            - DOMAIN-SUFFIX,proxmox.com
            - DOMAIN-SUFFIX,okx.com
            - DOMAIN-SUFFIX,ping0.cc
            - DOMAIN-SUFFIX,addons.mozilla.org
            - DOMAIN-SUFFIX,sewer56.moe
            - DOMAIN-SUFFIX,gamebanana.com
            - DOMAIN-SUFFIX,kaopu.news
            - DOMAIN-SUFFIX,v2ex.com
            - DOMAIN-SUFFIX,laborinfocn7.com
            - DOMAIN-SUFFIX,motionmuse.ai
            - DOMAIN-SUFFIX,curseforge.com
            - DOMAIN-SUFFIX,nostr.com
            - DOMAIN-SUFFIX,openrouter.ai
        japan:
          type: inline
          behavior: classical
          path: "./rule_provider/japan.yaml"
          payload:
            - DOMAIN-SUFFIX,dlsite.com
            - DOMAIN-SUFFIX,dmm.co.jp
            # 蓝色协议
            - DOMAIN-SUFFIX,playbpsr.com
            - DOMAIN-SUFFIX,aplusjapan-game.com
            - DOMAIN-SUFFIX,aplus-games.com
        my_direct:
          type: inline
          behavior: classical
          path: "./rule_provider/my_direct.yaml"
          payload:
            - DOMAIN-SUFFIX,feccc.site
            - DOMAIN-SUFFIX,gateway.ai.cloudflare.com
            - DOMAIN-SUFFIX,deepseek.com
        zodgame:
          type: inline
          behavior: classical
          path: "./rule_provider/zodgame.yaml"
          payload:
            - DOMAIN-SUFFIX,zodgame.xyz
        Gemini:
          type: http
          behavior: classical
          path: "./rule_provider/Gemini.yaml"
          url: https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Gemini/Gemini.yaml
          interval: 86400

      rules:
        - RULE-SET,applications,DIRECT
        - DOMAIN,clash.razord.top,DIRECT
        - DOMAIN,yacd.haishan.me,DIRECT
        - RULE-SET,private,DIRECT
        - GEOSITE,private,DIRECT
        - RULE-SET,reject,REJECT
        - RULE-SET,广告规则(By lhie1),REJECT
        - GEOSITE,category-ads-all,REJECT
        - RULE-SET,google,🚀 节点选择
        - RULE-SET,japan,日本节点
        - RULE-SET,EHGallery,EHGallery
        - RULE-SET,微软服务,Ⓜ️ 微软服务
        - RULE-SET,Microsoft,Ⓜ️ 微软服务
        - RULE-SET,Bing,Ⓜ️ 微软Bing
        - RULE-SET,OneDrive,Ⓜ️ 微软云盘
        - RULE-SET,OneDrive(By ACL4SSR),Ⓜ️ 微软服务
        - GEOSITE,onedrive,Ⓜ️ 微软服务
        - RULE-SET,direct-applications,🎯 全球直连
        - RULE-SET,LocalAreaNetwork,🎯 全球直连
        - RULE-SET,UnBan,🎯 全球直连
        - RULE-SET,ads,🛑 广告拦截
        - RULE-SET,BanAD,🛑 广告拦截
        - RULE-SET,BanProgramAD,🍃 应用净化
        - RULE-SET,GoogleFCM,📢 谷歌FCM
        - RULE-SET,GoogleCN,🎯 全球直连
        - RULE-SET,Apple,🍎 苹果服务
        - RULE-SET,icloud,🍎 苹果服务
        - RULE-SET,apple,🍎 苹果服务
        - RULE-SET,Telegram,📲 电报消息
        - RULE-SET,telegramcidr,📲 电报消息
        - RULE-SET,AI,💬 Ai平台
        - RULE-SET,OpenAi,💬 Ai平台
        - RULE-SET,Gemini,Gemini
        - RULE-SET,NetEaseMusic,🎶 网易音乐
        - GEOSITE,category-games@cn,🎯 全球直连
        - RULE-SET,SteamCN,🎯 全球直连
        - RULE-SET,Epic,🎮 游戏平台
        - RULE-SET,Origin,🎮 游戏平台
        - RULE-SET,Sony,🎮 游戏平台
        - RULE-SET,Steam,🎮 游戏平台
        - RULE-SET,Steam-社区(Beta),🚀 节点选择
        - RULE-SET,Nintendo,🎮 游戏平台
        - RULE-SET,Osu!,🚀 节点选择
        - RULE-SET,YouTube Music,📹 油管视频
        - RULE-SET,YouTube(By ACL4SSR),📹 油管视频
        - RULE-SET,YouTube(By lhie1),📹 油管视频
        - RULE-SET,Netflix(By ACL4SSR),🎥 奈飞视频
        - RULE-SET,Netflix(By lhie1),🎥 奈飞视频
        - RULE-SET,Netflix,🎥 奈飞视频
        - RULE-SET,Bahamut,📺 巴哈姆特
        - RULE-SET,Bilibili(By ACL4SSR),📺 哔哩哔哩
        - RULE-SET,BilibiliHMT,📺 哔哩哔哩
        - RULE-SET,Bilibili,📺 哔哩哔哩
        - RULE-SET,ChinaMedia,🌏 国内媒体
        - RULE-SET,ProxyMedia,🌍 国外媒体
        - RULE-SET,ProxyGFWlist,🚀 节点选择
        - RULE-SET,国外常用网站合集(By lhie1),🚀 节点选择
        - RULE-SET,proxy,🚀 节点选择
        - GEOSITE,pixiv,🚀 节点选择
        - RULE-SET,my_proxy,🚀 节点选择
        - RULE-SET,my_direct,🎯 全球直连
        - RULE-SET,zodgame,香港节点
        - RULE-SET,放行规则-lhie1,DIRECT
        - RULE-SET,放行规则-ACL4SSR,DIRECT
        - RULE-SET,ChinaDomain,🎯 全球直连
        - RULE-SET,ChinaCompanyIp,🎯 全球直连
        - RULE-SET,Download,🎯 全球直连
        - RULE-SET,direct,DIRECT
        - RULE-SET,lancidr,DIRECT
        - RULE-SET,cncidr,DIRECT
        - GEOIP,LAN,DIRECT
        - GEOIP,CN,DIRECT
        - MATCH,🐟 漏网之鱼
    '';
  };
}
