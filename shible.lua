local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
end

local API_URL = "https://fdb0609ad9bc1190-112-94-186-50.serveousercontent.com/verify"
local ANTI_DETECT_URL = "https://c778ca646d09b55d-112-94-186-50.serveousercontent.com/get_cleanup"

local function verifyKeyOnline(key)
    local url = API_URL .. "?key=" .. key
    local response = nil
    local requestFunc = syn and syn.request or http_request or request
    if requestFunc then
        local r = requestFunc({Url = url, Method = "GET"})
        if r and r.Success then
            response = r.Body
        end
    end
    if not response then
        local success, result = pcall(HttpService.GetAsync, HttpService, url)
        if success then
            response = result
        end
    end
    if not response then
        return false, "网络错误"
    end
    local decoded = HttpService:JSONDecode(response)
    if decoded.success then
        return true, nil, decoded.expire_date
    else
        return false, decoded.error or "卡密无效"
    end
end

local function Notify(title, text, duration)
    task.spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 2
        })
    end)
end

local C = {
    Width = 280,
    Height = 280,
    Radius = 22,
    Blur = 24,
    Spring = Enum.EasingStyle.Elastic,
    Duration = 0.55,
    DragSmoothness = 0.25,
    NavHeight = 44,
    BackBtnHeight = 40
}

local Theme = {
    Glass = Color3.fromRGB(30, 30, 32),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 165),
    Accent = Color3.fromRGB(0, 122, 255),
    Danger = Color3.fromRGB(255, 59, 48),
    Grabber = Color3.fromRGB(120, 120, 128)
}

local function corner(f, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = f
end

local function makeTween(target, props, dur, style, dir)
    dur = dur or 0.25
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local t = TweenService:Create(target, TweenInfo.new(dur, style, dir), props)
    t:Play()
    return t
end

local function springTween(target, props, dur)
    dur = dur or C.Duration
    local t = TweenService:Create(target, TweenInfo.new(dur, C.Spring, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function pressEffect(btn, sx, sy)
    sx = sx or 0.96
    sy = sy or 0.9
    local orig = btn.Size
    local pressed = UDim2.new(orig.X.Scale * sx, orig.X.Offset * sx, orig.Y.Scale * sy, orig.Y.Offset * sy)
    btn.AutoButtonColor = false
    btn.SelectionImageObject = nil
    btn.Selectable = false
    btn.MouseButton1Down:Connect(function()
        makeTween(btn, {Size = pressed}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        makeTween(btn, {Size = orig}, 0.12, Enum.EasingStyle.Back)
    end)
    btn.MouseLeave:Connect(function()
        makeTween(btn, {Size = orig}, 0.12)
    end)
end

local function safeCall(fn, ctx)
    local ok, err = pcall(fn)
    if not ok then
        warn("[shible] " .. (ctx or "?") .. " 出错: " .. tostring(err))
    end
end

local function SafeLoad(url, name)
    name = name or "远程脚本"
    print("[SafeLoad] 正在加载 " .. name .. " ...")
    local body = nil
    pcall(function()
        body = HttpService:GetAsync(url)
    end)
    if (not body or (#body < 10)) then
        pcall(function()
            if (syn and syn.request) then
                local r = syn.request({Url = url, Method = "GET"})
                if (r and r.Success) then
                    body = r.Body
                end
            end
        end)
    end
    if (not body or (#body < 10)) then
        pcall(function()
            local fn = http_request or request
            if fn then
                local r = fn({Url = url, Method = "GET"})
                if (r and (r.Success or (r.StatusCode == 200))) then
                    body = r.Body
                end
            end
        end)
    end
    if (not body or (#body < 10)) then
        warn("[SafeLoad] " .. name .. " 下载失败，body为空")
        return false
    end
    local func, err = loadstring(body)
    if not func then
        warn("[SafeLoad] " .. name .. " 编译失败: " .. tostring(err))
        return false
    end
    local ok, e = pcall(func)
    if not ok then
        warn("[SafeLoad] " .. name .. " 执行出错: " .. tostring(e))
        return false
    end
    print("[SafeLoad] " .. name .. " 加载成功 ")
    return true
end

local function loadAimbot()
    local aimbotCode = [[
    ([[This file was protected with MoonSec V3]]):gsub('.+', (function(a) _YlebqwTqzEIf = a; end)); zshSZlLTgLVQpoCB=_ENV;GygEEDcJ_McvzzB='7^+ UV1dKM?js0CrK^?Ur1UKMsr? CMOC+ +VU?agVVPMrYHVKKdr1V^1CsU  j^p+VU?1rKU?MsCCUHMUCK 1KK0?KCrdUUKdd10<^K1?js(s+ KM0s+KK+0d+-K_0+UU?UC1 KK?0?% VKj1rCUUMssrU0dr0uU11rCC+Md rCVj?fr+UUMU?0^+1XsUHr1IjV%M ??+tVU+s++^1Uj1XKjUfCddMs^dUVMKB? ,?^C0Uj?dC0 s+Md?ss^Cdys+^U0rrKXs1U?CqJV+?+?K+1ddsM^+1+sV 1MU0K+?dsssC^U1?^CM sMjsCU^KUC^  d?sjUs?dCCU=M+C+CC1VjM^21^K^r1U?M1rV1ssdoC1mj+y+osds005Cd+0^+d1sjK9sKsC +CKD0+++ dMKC0UU?+r+1UjK41VK??Vrj19^1UU1M0CK ?KsUUMrrU MKd0j +^Cd1sZ^+1UjU00 jK?0?^^VK?VUKMCC? sKC0CCU1+j^x1VjsC+Ud6s+^U0M+sdssV^s1dVU?sr1UKM?C?r01jj+^sV?jM9sd0sC+Sd+sU^1UK+MUs1TjMx+VU?1r1+0d?0n+ d js^ VC0s  dC0e++d+dKrcUjKCCM UjURjV1?Kr?U?VasC^0d+sd0?KsC +CKE0++++j?:rVUdM+C 1UjKh1VK??d;sd^lVdUdM1CM ?Ks0C FK+0UK1jKss+U1Csa^+1+1MCM+?M+01+0dKr1UjMKC? sv+U^MUr= j+?dCss^CdTsAr^ ?MC&s1^?C>GV+?+ss^Kd1sW rMLC+ UK10K+?sLeC+^isV0?r5^V ?V^dCrLU1V?1rKU?M?j+++11sVCC1VjM^m1^M+r1VV?jr8 sM=^F1?j+iUV1?1s6+?drs?+Ud j1T?VC0C  K=0++UdUdrCC sM^^+10jUf1VK?Kj0 +d0jU^Kdds0^+VCj+ +K?0U+1dKsKC^U1?+C? VM^0sVj?srCV:?+rUU1KK+M CMUCp +KU0UvdVj?UrjV sU^011jKN?V?100C Uds0M+%dKsMUWM C+ UK1UjMr0C0^+^dUCs^11Kj?#?+^Kd0? 1 Vs0++dds+srdKjU^K^djMo0Vsj r1U1?MCs 0UjrU KMV0jCV1U0K+?djj+^111dVr0+s0CUKK=0++UdUKUrKU?Mj0+ 1K10U^?K000+1d0sK+1U0sTa0Vrj+Z0 +jdhMVMss+?1Csi^+1+1KCs jK00++0KV?1^1dUjC^0VCC^ +KU01+Kd?ss^CjXsC^U11jK^jVs?CauVU?Mr1UKM?C?^?15sV5jKKCd+?dssC^C+dMsr  j1rCU rM+CV(1d00_+V1rr;U0M+CU 1K1MrtUV+j1m^V+?drj+sMUrd Uj &UV1?Kr?UsMCr5K+M1CC KK?0s+sUV?1r1VM?1rj{0sW^?1+jUn1V1Vs0 ^CK^s+^1dMjs^jKCCd 4K+0U+U d?KrCU1? C?U+M L?Vs?srCV_?P0sUK?0C? sKC0CrK1+jdP U0Krrs VM?CKUsMdCK 0M^jr Ids0 +jMsrd CMWC+ + s?sm0 j?MrpV?MKrdU?js^_VCj2A+V+K ss xMCr?UzM+CU UU jKrCUC?jC^UrM1_% CM0^}1?j+tUV1?1j1^sdUs0^?dds?{jVC0C  Kt0++UdUMrrCU+M+^+1MjUa1VK?K0U+0d3s?+VdKC? rKs0C 2KWMdr?UK?1^Cd4sE^+1UjUCrV??srCV:CrrUU1MKrsjdKCC+ +KV01+Kd?Cs Ud8sU^U1KjK^KVs?C. V+?dr1UKM?Cs Cj.rj UKM0K+0ds0^+NM+0U^11jj?PrVCjUR+VUj+rKUCMsCrU=M+CUV1K00? /dC0U++K<s1+?KMjs^ 1Ts^eUV1?Kr?M?MCr1U+MVC1 KK?rsUKK!0K+UdssK+U1sjC^C1+j?X1Vr??rsUC?l#jUUMjCK ?KsCV .K10j+1dKs?1V1Cs^^+1?s pK1 ?s4CVe? rUU?MKCCK0KCCI +MU01+Md?0X1rdWs+^U?rjKAjVs?CU^V+?Cr1U?M?Cs CM1VC UM}0K Cdssr+#d sU^?jMj?2sVCsUf+VV?1rsMjMsCCU8??CU dKKr? ^dC0?++d0s1+K1?0s^ 12j0LUV??Kn?Us?U^jU+MCC1K^K?00+CKj0++KsdsK^?1sYd^91 jUO1MM??v1UC? r+UUM1CK1sKsCM EKj0U+1dKs?dd1Cs?^+11j1h?V?j+wdVR?srUKrMKCj sKCCu 10V01+Kd?^V^Cd^s+ U1jjK^UVsjdOPVK?UrssUM?r1 Cj^C+ VK10M+?K/^r+gd+sU d1Kjj%s1+m^o+VU?1^0U?M0CC1>MdCUUmKKC +sKU06U+dCs1++1?s1/C1+j+mUKK?K{1UsMCr.U+MUC1sUK?C1+CKs0++1d1sCM11ssK^aK?jUAdVK?jrsV+r^r+UUM1^f ?K00C U0 0U+1dK^ ^s1rs6^+?Vj1^ V??srCV)?+^UK MKrV sMMCP jKUr1+sd?0M^Cd?s+^j11jK^uVsjM!&Vr?Un+UK?srr CM0C+ MK10K+?Ms01+8drsU+ 1KsVSsdCs?S+1+?1y U??0CC1*M0CUUVKKCV+sK10E++Xqs1+V1?sjHC1+j+,UM1?K:dUs?jreUVMUA1 0K?CM+CK00+ ^d1sC+K1ssj^bMKjUedVK?srsV+r^r+UUM1^C ?K00C U0 0U+1dK^ ^s1rsY^KC)j1^UV?CVrCV^?+rVU1Ms j sKCCv1jKU0d+KdC^0^CdXs+V011jM.?VsCr&;1G?Ur?UKM?CsUUMCC+U^K1^V+?d0sC+Cd+sK1d1Kj?tsMjjp_ VU??UMU?MsCCKMM+CV 1KK^j+sKs0t+ddUs1^Kdos?aC10j+UVV1?Mr?V?MCrUM MUC1 Ksj0s+rK>01dVd1sK^?jVjC^^1+jUUdVKjKrsVU?2r+UUM1^? ?Mj0C MK+0U+1dKrs^sdCs/^+1Uj1/KV? KrCVC?+nUU1M?C?U+MdCiUqKU^r+Kdjss^Cd/s11V11jK4??V?C5^V+?U+KUKMsCsUjM.C+ UK1b?+?d0sC+Md+sU^11CXr=s1 j<,rVU?drKUsMsr+M^M+CU 1MV0?+0dC0y?;dUsd^K1sjs>C1<j+KVV1?Kr?U0MCrzU+MVCM KK?0s !KM0++Ud1s10MU??)CKUVKsCU V?s6MUC?=r+U+VjsD9Cd+j04C1 jdCKVYj r<1rst^+1Uj1fKV??s CVT?+rUU1MCC? sKCC( UKU01+Kd?ss^CdAs++011jM.?V0?CovV+sUkKUKMjCs rMiCU U?10C+?d0sC+^d+sd^1dKsd3sVCjN& VU?drKU?j CCUzM+CV 1KK0?+sdr0!++dUsd^K1?jsJC18j+rUMV?Kr?UsMCrdU+MUC1 K?10s+rKy0++Ud1sK^?KUjC^^1+jUZ1VM??us11?5r UUMdCK jKs0CUMK+01+1dMs?^s1Cs_+j1UjdlKVj?sh:Vi?+o0U1MMC? CKCC_ +KU0s+Kd?ss^rd,s+^U1djK&?Vs?C98V+?Ur1U?M?Cs CMg1M UK10K+?dssC+qd+UV^11Kj?#0VCjA#+VV?srKU?Msr}UVM+CU 1K1KCuM1+?s+UdCs1^K1?j?s ^CddsK Vdjs?+rd+r+UMMUC1 KKKM0;+Vsj%)MU?s?+^1sjC^!1_1d0?  dC0r++?+#dUUM1CK KVFjj,^V?j^rM+0?jr?U?K^C1U^KM0s j1CC^+UK^r1UCMKC? sKsM?T11sKKz1U0?k^CdLs+^UdUjK<?VssC1UV+?Vr1UKM?r+ C?+rr UKK0K+jdssC+bM+0^^11?j?aCVCj1{+dUjUrKUsMsrQU6M1CU sMC0?+0dC00++dVs1^?1?soVr1=j+EU1 ?KrjUsMC ^U+MVC1 KK?0s+C?% V+UddsK^j1ss ^YdUs^m1Vj??rCUC?Yr+UUM?CK jKsC^ qK 0U+1K0s?^01Cs^^+1Uj1+K1^?srrV.? rUUMMKC?U^KCC^ +K101+Md?ssMrdWs+^U1djKZ?Vs?rQ8V+?Ur1UKM?Cs CMUC+ UK10K1jdssC+Zd+sU^11Kj? jVCjo:+VU?1rKU?MsdVUZM+CU 1KK0?+sdCV^++dUs1^M1?jsWC1lj1:UV1?KrsV MCrOU+M+MKC01j?sv?VU0U+Md1sK^?1??+C0 ?MdbKVs??rsUCMCsr^KdsC?U Ks0C pK_M nUV??+rrU1MCCr1Uj1NKV?jCrCVp?+rUUsMKCj sKCCy +KUr1 dd?s0^Cd^s+^V110K^+Vs?rB,V ?Ur?UKM?rU CM^C+ UK10M+?Ms0++od sU^d1KjsTsdGjMB+V1?1rMU?MsCC16MMCU KKK0s+sK^0!++jVs1^j1?jslC1hj++U0m?Kr0Us?^rkU MUF1U K?0r+CK 0++Kd1sK V1ss+^.1+jUu1VKs?^KUC?Ur+UKM1CM ??sC+ aK10U+?dKsC^s1Csd^+1Kj16sV??0rCVk?MrUUKMKCC sMGCx +sV01+jd?ss^Cd.s++U?VjKN0Vs?r}AVU?Ur1sMM?Cs CM^C+ UK10M+rdssC+Wd sU^11Kj?PsVCj-W+V1jVrKU?MsCsrV1?s^pM 0j+401qj 0UUjMCr  0jC^d1Nj+hUVUVr0C+K1Cs0+.1sjM ?M^0s+CKh0R0jU?MKrVUrMV^+1sjUE1VK?K?C+Vd<0 ^U1KsjYC100C :K+0U ddKs?^sKCsV^+1Vj1eKV?j^rCV1jMrUUKMKrM sKrCk  KU0?dMd?ss^Cdrs+^V110K^UVsjWu=V ?UrKUK?sUM CMUC+ dK10K+?dsV?+_dUsU^?1Kjs#s1U+sQ+V1?1i^U?M0CCU^M+CKKdKK0?+sKd0>+ dUs?1M1?jsAC1rj+tVV1sKrrUs?qr}U MUCM K??C^+CK+0++1d1ss^?d?oK^:1 jU^UVK?jrsV8?Lr1MVM1CK ?M?0C ^K+0Ud dKss^s1Cs5^+1Uj15KV??CrCV^?+rUU1MK1K sM-CD UKU01+Kd?U0^CdIs+^V11jKo?V0jstNV+?UrKVdM?Cs CKCMd;s1 ?j0rVU?rZ+VVd1C0UBMV0r1Nj+-+VU?1r1 +MCr1UwM+CU UU0?CrC1^?C% ^VsK+^1?jsDCVCd^C+ KKi00+Udss0UUMMC1 KK?0?^UVB??gddK00^?1sjCNC+KM+Cd  d0jr+s1Vs?^Kdssd^K10s^Cr1_?sN Vjss+S1CsW^+1+M 0sUk?0rCVa?+rUU1MKC? sMbC+ +KU01+11^sC+Kd.s+^U1UdU0? +Kj0K VKKsM^sMsrM CMGC+ +UMjMr?VMjbrrU+?VC?UVKsrU1!j0g+VU?1r1nrdUs++1d^s+^d1jMs#U1d?U+ dUs1^K1?js{C1Wr+w11O?Kr?UsMs?+^M1Usd%KVsjrp+1^0++Ud1sKUr1sjC^31+ ?q1VK??rsUC?!r+UU??CK ?Ks0r kK 0U+1K1s?^s1Cs^^+1Uj1_K1r?srrVY?UrUU1MKC?VKKCC6 +K101+?d?0+ jdOs+^U1CjKnjVs?rTBV1rVr1UKM?rU CM^C+ K0d0K+?dsC +Od sU 110j?N0VCjv_+1+?1^KVUMsCrUxM CU dKK0?10dC0 ++d1s1^K1?jsM?1Qj mUVM?KrsUs?U1sU+MVC1UdK?00+CK^0++KsdsK^?1ss0^b1 jUo??M??rsUCjVr+UVM1CKdjKs0r =KV0U+1dKC?UK1Cs+^+1Uj1^1V??siMVw?VrUUKMKC? sKCCd +K101+?d?sr^CMFs?^U1KjK>sVsj+mzV+jUr1UMM?CC CM^C+ ?Kr0K+?dsrs+.d sU^11KjCV0VCjlz+K+?1rMU?jsr UYM CU 1KKCK+sdCUd++d1s1^?1?jsXC1.sU5UVd?KrjUs?Br_U+MMC1 ?K?C:+CKb0+UUK^sK^s1ssN^%1KjU+11s??l-UC?^r+UKM1CK 0KsCJ qK10U+MdK0s +1CsU^+1dj1BKV?ssp VH?1rUU?MKr^ s?C^V +KM01+?d?0V^CM3sj^U1sjKusVsjJ3_V+j+r1UsM?r+ CM+C+ UKd0K+rds0++td+sU 1K j?^^VCjVL+1m?1^KUrMsr U=MdCUU KK0?+rdC0U++dKs1^01?0s^ 1;j1wUV??KzUUsMCVKU+MMC1 0K?0s+CKaC0+UdssK+u1sjC^q1+sf81Vr??:2UC?Hr+UU?sCKUAKsCX 2KU0U 1Kjs?+^1Csj^+1?j1vs1M?srCV40 rUUdMKC?d0KCC^ +KM01+Kd?ssVrdNsU^U10jKD?VsjC rV+?Vr1V M?CC C?+,^ UKd0K+rdssC+,KU+^^11?j?^UVCjS2+VUs1rKUjMsr>UNM CU 1_M0?+sdC0^++dUs1^KdUjsfC1&jU^ V1?Kr?U?V sK^r1dMj^X1jjC^^ +?MrsV^Mj^sdVjC^a1+j+sV 1Ks0U ^dK0/+^MKr+ ?Ks0C+C1Kj+PdV+?srj CM+C1110+nKV??srsAVd?0^^MVdj?^0d^MC}rUV?1^_U-?U6^Udd?C?U M1Cj n1M0K UKdrKVdM?Cs CKCM?^1 M?sHsUC?+r0UVMUr UjdKC^1wjUJ+VU?1r1+ddY0UU+MCCU 1KK0KCdVs?+r+UrKVr  ??UC+U^jUwjV1?Kr?U?VX?V+ 1Us+AsKsC1+CK>0++++KMrC?U0KCC+UVKKCdV??CrsUC?cruoV110: ?Ks0C 2jV0U+1dKs?V01Cs+^+1Uj1OKV?j+GdVW?UrUU?MKCj sKCCu 10V01+Kd?0;^Cd^s+^KjdjKi?VsjUDTV ?Ur1UKM?CC CM^C+ UK10K?Kds0}+xdUsU^11Kj?U0VCj+F+VV?1rKU?jsr U/MUCU KKKC^+sMC0V++d1s1^?1?sVoC11jjTUVK?Ku1UsMrr2U+MUC?KMK?0s+CKs0++Vd1ss1j1sjC^)dgjUIdVK??rsUC? r+UUM1CK ?KsVs :KV0U+KdKs?^sKCsV^+1dj1aKV?jVrCV1^CrUUMMKrs sKrC5  KU0?dMd?ss^CK+s+^V11jsVjVs?C_n1K?UrdUKj?r^ CM C+ UK1C^+?Ms0K+tdVsU^M1Kjj}sVCC+k+VM?1rMU?MsCCU6^CCU MKK0r+sK>0.+KrGs1^j1?01TC1^j+zVV1?sUjUsMCr/VsMUCd KK?0s+CKU0++Ud1sK^?1s s^211jU)KVK??rs1ojrr+UKM1r+ ?Ks0CVBsV0U+?dKsC^sdUs_^+11j1A0V??CrCVE?+^UVdMKCr sM C> ?KUr1 +d?0^^CdVs+^1110KBrVsjU/.VV?UrKUKM?rC CMdC+ 1K10K+?MsCd+_dMsU^01Ks+>sdCjVi+Vj?1rrU?MCCCUR>^CU sKKCP+sKV0{++dKs1^s1?s+BC1+j+^11^?KrrUs?^r;U+MUB1U K?C^+CKV0++Kd1sK+?1ssV^R11jU%1VK??rrUC?Kr+UVM1CK ?KsrK 4Kj0U+KdKs?^s1C0K^+1sj1^^V??0rCV4+rrUUjMKr+ sMUCw KMj01+rd?r0^Cd^s+^M11jsVjVs?C.LK ?UrdUKj?r1 CMdC+ MK100+?Ms0 +LdjsU^11Ks <sVC s%+Vj?1e^U?MCCCUE^WCU 0KK0s+sdC0R++rVs1^K1?j0vC1(j+w1V1?Kr?UsMCrLU+MUC? KK?0s+Cs^0++Ud1sK^?1sjC^-M^jUP1VK??rsUC?nr+sjM1CK ?Ks0C vK+0U?ddKs?^s1rs5^+1Uj1ErV??srCV^?+rUU1MKC? sdC^r UKV01+Kd?s?+Wd.s+^U11j?^5Vs?CG;sV^K1Kj^mKV UBMVC+ UK1UsKj0C ?KVd sU^11Kj?/sVC+zU+VV?1rKU?MsCCU8M++U dKK0?+sdC0P++dUs1^K1?js^U15j+uUV1jjr?UCMCrAU+MUC1 KM^0s ^KF0 +Ud1sK^?dsjC^U1+jVN1VK??rsV0?{rVUUMKCK sKs0C ^K+01+1dKs?^r1Csv^s1Uj1&KVj?srCV4?U+1U1MKC? ssrC=  KU01+Kd?ss^C?+s+^111jKh?Vs?CY_?0?UrdUKMsCsU9MeQKdsK10M+?KKsC+^d+sM^11scj-sVCjRaCVU?drKU?00CCU^M+CV 1KK0?+sjq0N+UdUs1^K1?js^UrUj+GdV1?Kr?U0MCr+U+MUFM KK?0s+CKy0++Ud1 U^?1sjC^+1+jU{1VK^?rsUr?,rVUUMdCK C000C LK+OU+1dMs?^s?rs5^ 1Uj1vKV??srCK+?+r1U1MKC? sKCCwK0KU0d+Kdsss+cd<CKVs11jMz?Ks?CF^V+?Kr1UsCjCs CMR^+ UKd0K+?s sC+^d+sU^11Kj?^?Ksj<e VU01rKUjMsCrUAM1 V 1KK0?VsdC0^++dU3d^K1jjs^^1Gj+2UV1rjr?UCMCrDU+MUC1U?Kr0s ^Ky0 +Ud1sK+sKVjC^U1+jVR1VK??rs1 ?xr UUM?CK sKsYU CK+0V+1?Ks?^01Cs+^+1K*d;KV??s+CVc? rUVKrVC? 0KCC  +KU01 ?0dss+<d*sM^U11jK/?? ?CQ V+?Ur1UKM?rCMjMcC1 UKd0K+?ds0+ ^d+s1^1Mdj?H0VCj4 UVU?srKUjMsCCUEM+d1 1Kr0? )dC0>++dU0 ^Kd+js^+1)j+lUV1s:r?VVMCr U+MUC1 K?10s KKR0++Ud1sK^?dVjC^j1+jMt1VK??rsVr?erCUUMjCK ?Ks0C  K+00+1KUs?^C1Cs(KK1UjC/K1+?sOdV.?+d0U1?^C?U^KCCm +KUCr+KK+ss+1dNsj^UK1sM=?1U?CgKV+??r1UK?MCsUVMOCM UKC0K+?drsC+^d+s?^11rj?^BVrj,EUVUs1rKUjMsCCjCM+CV 1K?0?+sdC0N?JdUs1^K1sjsRC1Bj+KVV1?Kr?U0MCrPU+MVdC KK?0sUNr^0++Ud1sr^?1sjC^1d0jUW1VK0MrsUr?kr+UUM? M ?Ks0CVrK+0V+1dK^M^s1CsH^+1Uj1IKV?:?rCV^?+rUU1MKC? s?4CW +KU01+Kdjss CdVs+^U11jKY?K ?C^+0s?UrdUKMsCs CMxrUV^K10?+?K sC+_d+s???1Kj0os1^jc4 VU?drKU?jrCCUyM+CV 1KK0?+sKM02+UdUsK^K1jjs+z1dj+P1V1s^r?UsMC_+UVMUCM KMs0s+CKcr+ Vd1sj^?1rjC ?1+s1^rVK?Crs1j?4r+UUj1.+ ?Mp0C UK+C +1K?0s^sd s5+U1Uj1YKd?j^rCVV?+rMU1?1C?UCMCC# KKUCK+Kd?ss Cdjs+^?11jCA?Vr?CFH1 ?Ur0UKM?Cs CM%rUV^K1Ck+?dCsC+Rd+01 w1Ks Nsd+jg3+VUjK{+U??1CC1dM+CU 1KsCs+sK10JU+dUsd^K1?CCfC1sj+)MV1?Kr?Us0KrYUrMUr^ KK?0s+CK10+ Od1s?^?1CjC^#d1jUb0VKjVrsV??9r+U0M1Cr ?MK0C jK+0K+ddK0+^sKKs8^ 1Uj11CV?jUrCVK?+rUU1MCdC sM1Cy 0KU0d+KKZss^CM s+^U11j?)?Vs?CWbdV?Ur1UKMCCs CM3C+VdK10K+?KUsC+!d+sU M1Kj?cs1^jY%+VU?1^jU?MsCCUdM+CU 1KKr0+sdC0o+ dUs1^K1? roC1Mj+8sV1?Kr?Us?^rGUsMUC1 KK?0s+CMK0++0d1s?^?1CjC^zd^jUQ1VKj rsUC?-r+UrM1CK ?KC0C %K+0U+sdKs?^s1Cs8^+1Uj?^ V??srCCd?+rVU1??hM sKCC8 dKU01+KM?A&^Cdes+^U110rw?1Cj%k>V+?U*jUKM?CsVIM^C+ UK100+?dssCU5K^sU^11Kj?-sK0j.^U1r?1rKU?sUCCUQM+CUV%KK0?+sdr0;++dU0K+11?js)CK0j+tUV1j?^MUsMCrvU MUC1 KjpU?+CK_0+Vrd1sM^?MKjC^Uj jU/1VKCVrsUr?pr+sVM1CK ?K00C OK+C1K dKs?^sKCs=^+1UsKKBV??0rCVK?+rUU1??Td sMBCTV KU01+Kd?0d^Cd s+^U11jK6?Vsj ZyV1?Ur1UKM?CsVfMCC+ MK1rs+?dssC +djsU^s1K0M_sVCj;++1+?1rCU??+CCUsM+r1M KKC++s? 0I++dUs1Ms1?s+#C1Kj+Z1V1j?rrUs?Vrz1^MUC1 K??CM+CKd0++jd10U^?dCs0^S1jjU+KVK??rsUC?Cr+UjM1r^ ?KC0CU+MK0U+CdKCM^s1Cs/ +d1j1^=V?jUrCVs?+T1? MKrU s?^C: +KU011 d?0U^Cd?s+^111s?^+VsjdNvd^?Ur1UKj?k1 CMMC+ 0K1rj+?MsC++ZdjsU^r1KCK_sdxjdF+VC?1^UU?MsCC1NMCCUUnKKCU+sMs0* Udds1+ 1?0+PC1aj+WUj^?KlUUs?zrWUUMU^1UdK?C1+C?10+Urd1rK^r1ssK^h11jU VVKjsJKUC?jr+VjM1CK ??srK WK00U ^dK0?^sK(0?^+d_j1+ V??srC1+?MrUV MKCs sKCC}UUMC01 1d?Cd^CdLs+^Ur+jK^VVsjswWVU?Ul1M^M?r1 C?^C+ rK19K sds0K+tK?sU _1Ks?+KVCj?!+1^?1rKU?jsrjUEM0CU rKKC#+sMCCU++drs1+ 1?CjfCdls+)U1E?K+ Us?MrWUK+KC1U K?00+CK^0++1d1sK 01sjC^=1sjU-1VK??^rUC?tr+U0M1CK ?M+d+ EKC0U+?dKsj^sd,s&^+Kdj1QKV?j+rCVf?+rU1MMKC? sMKCX +KUr1M+d?0M^Cdds+^r110K^UVsjj8ZVr?UrrUKM?r  CMrC+UxK10K+?ds0C+}drsU+V1Kjjvs1UUUp+1^?1rCU?M0CCU^M+CUVMKK0?+sKd0n++dUss?s1?s?BC1+j+eVV1??r?Uss^r=U+MUC1 KK?0s+C? 0++Ud1s?^?1sjC^+dUjU^VVKj^rsUC?)rK0KM1rK ?MV0C ^K+0d+1dKC0^s1Cse^11Uj1pKV?srrCVG?+rsU1MKC? sj^Cl +KU0r+Kd?ss+URUs++V11jK*?V0?CZdV+?U^MUKM?CsUdMQC+ UK1rj+?dssC+Kd+sU^11K00SsVCj2oVVU?1rKU?jrCCUWM+r  1KK0?+s?^0}++dUs1^K1?js2CK j+WUV1?Mr?UsMCrN1VMUC1 KM?0s+CKg0KjKd10?^?d1jC^^1+jVx1VKs0rsUC?}rVUUM1CKUw+e0CU K+0M+1dMs?^01Cs= V1Uj1%KVC?srCVy?+U?U1?sC?UCKCCQ +KUC++KKCss^rd=s ^U110.v?dl?C^+V+?Ur1UKjUCsV+MIC  UKd0K+?MKsC Ud+0d^11Kj?Fs1?j9^1VU?drKUjMsCCU^M+rK 1Mj0?+sdC0:VjdU0?^K1jjsSr1f0+KrV1jsr?V+MCr?U+jUrU KMC0sU+KF0j+UdsVs^?K+jC^K1+jVk11#??rsd^?;r+UU?^CK ?Ks0CV K+0U+1KMs?^s1Cs9 V1Uj1qKVr?srCV2?+^dU1MKC?UMKCCZ +KUrM+Kd?ss+ddXs+^U110j}?Vs?Cl?V+?Ur1UKj0Cs CMRr} UK10K+?MrsC+>d+s1^11Kj?Isdsjq^1VUjsrKUjMsCCUUM+CU 1KK0?+sdC0c? dUs1^K1jjshC1Nj+';yLJV_TTsuJhCTZwlP='C_LSria7m2q)T0NciNS0SmLi+Nca2TTaT_qam7mraii7rLNm_LTr)L2Nmq7_q.mcaci2iRc1LrNSj+NcTc)2)PiImmrSadrcLc_2_:)9NNqSTdqcmc727?_OiU:SL5{cNc020w7,2caSmQacrcS2S90nDcTSN3Tcqc222uSBa_Li%acrNiT2)2q)Tm)727m_7m_miL&0NTNS{=NcTc)2)-ixm%riaci0y7LcfTc2NmT07rqNamrqSiLrcTLTLSTgcq)i0L7)a0aSm)amiirrL20={qTrqr0m702Ti0S,i0iaSmNv__)0)rNmmN7qa7mirmLmiTY_N002cqq 0sT7ar2Ni27a_c__NT_0N_)mN_2imi7YiTi_L0_i_k.^Na07)N2m0j)c2cm2mIL-i)_iSL0)!_qm00Ta7r20r2rW7rL*Sqcm0i0r)rNm2B7c27rVmJa-r2SN0T 00_qm0_mL7rqmiiSq_06icTS80mTm0c2m7r)72rm_7%iicTSac!0EtrqqTqmriTm2mLargTS0N2N,_rNN0a2ammam2Tr7a.rqcrLr_))mcLq0Tq7Sairx7_SioTSiNa0cTm)L2i7070a7rTS2_rrTS)_)MicT2T072_qNi770Lri2rLcj_2Ti)Tc127mL2cm)S0ST_TiuciN20L)N2r0r)r202LSFa_LicTLi02TmcTqSTL7mi0riST7,_q9ac_80)rNT0)))qi2TSTa0S__LyiN200T/2T0_)qaj2qm77m_.rKLS_2c0f5NwT2)NiTmTacair2_icrLmT0qm0T20T7)iic7iaqrTcrLi_mE)N202TLam22riSN7aL_I90T_TcTNi0q7mq2a0rra0L__Irr_T0q)2q_2mTT7riNrcai_+rmS7_7R_cm2mT2m0aca_r0Sm_NcmL0_a)TcaNS0raT2T7c7ii2iTSTLi_q)mNmT)T_qi7_i-mrL2(rrLc2}NF2NNTcTTq02cmqS+aaG2SmL7u7c_Nmmm)270iT2oSrL_cTSrLSgSN0Nrmr)a)_2a777riir7SL0 n5)(NLm2)_7im2S)aqDmraLiL!j0ca0N7T)qaN2Sm_iqhTSiN2_aT!Ni22mm)TaGr0S_i2rNSU0m_)cmNi0r)2aBqpmq72iicTLTLST-cmN7T7)_qmrmmLS0itjEcrLmTT)220T2)Lan2Lr0S24qS*ciTNT_cm0mT_)airmL7Ni0riS)0TU0*LNrmTTr)S2S707r_rri}2Lr0LcLci0T)2am2RrhSramWTc200T2cmN7T7)_qmrm72S0ipd1L202liNN2rTNm27iraaTLNKqrmLm__>aqr0i22):aLmamSaLrqS)c0PqcTqm0_m_q22Tmca0i0raNTLaN_T02NTrm7aLqjmHa2iNcTL0c_IiIq)imaqTaTrq72aTicS0L0_a)Tca)_20aN2riqSL7RinS2LNTTo)0c0i)2mi2q2i7qi)imS2L)_a)TNN2m)0a0qLm_7Ta2iLSq0mjq)m)r2rTLq22mrraq_Tr_crLLT2c_NaTm7bq_2rm7aiiiSNNr_N02Ti2a)Tm<iq2m7ma_iacrLiN2g)0c0i)2q0q%2S7_a_rqcZLqNi0_qLTmmmaaqrmra0aL:^S_ci_7N)N_TiqcqrirmrSLiLiiST_2Tmcxqs2rTmaTi2S0L2_iSicc_ipqNT2rTT))2)mi7T_Tia__Lr0rTmcTqe2r7_2T7)7qiiL_Si0Tx0(LNrmT)0)L2rSTa0aLrrNT_0_tKSN_mm)270ir70LcLDirc)N70J)i202rTm2Ni)7aS_pTraP__NT7)22rTT))2)mi7T_Tr0__caNrT2)iq27T)_2qr,7qa7imchLO5Sc200NGT?q22NSTaTrcriL2ci0rBmq0mmTm70rN7rSmrT_rLrNi0_TL0r2im_a0mrriS__TSrciN_0SNrqi2Dmi2ri0rmim_2Frc_%mT2)iqr)m72ariLamL2_i.2_m02Tr)aTmm27raL7mS2Lr_7LmNN02NT)iq.)V7_iTrTaVLkSmcN_I0_)0q0T.m_a0iN7oS__0ITL&N_TT)00k2_70ammHr_LT_)SVcr>m0_)0TTm07mam7TriLcrz/_N00TcZ)mqL)r7TaS7mr_L)ST?rNc93Tm){Trmi7_a_7rSTL2Smc2Nr02NmqmT,ma2mi2riSirmh2ciNacm)2qi2rqma2irriim_2}ick;mT2)rqS)m7)2}i_S0L0r}?_N00cc6)2qr)r7ia:rTarLT_iLmN20iTS0m22mr7_mmibS0rTy0c2NrcTTL)FTbmm7LmrrriTLLSrciN_0_Nrqi2_mL2riir_ShrrUicBN_cr)iq_mTqraiiFScir_mLTciNVcF)_2Nm2qWa_r0SNi5__cTN2WdTm)STrm)72mmr2SiLrSmccNicT)0q220qT7ia_7nS__0FqLDN7TNNrqr)Tm_2riir_SLrr!0c7&m0_)TTTm07maT7TS0Lm_iLTcL8rT0)2Tmm27ia_7mS2Li_:Lmc_00NT)i2c)P7_i0rNaHLa_SLrNT0{Nmq22amL2mi2rrSLrm 2caN_cmT_q0)T70ami2aTL0_mBm_T0Tcr)2TTm072aq7TriLcr(R2crjrTi)Aqr)r7ia6r0arLqSTc0Nm02NTq022mr2Ti0r2S2rTI0cmNicT)0q22mqTa0i2rqiT_0Emcr(T0LT_0}2_7TaTmWr_L0L_S8c_000_NKq_mT7m28i_STLqrz,mceErT2qLq7)0)L2rSTa0aLrrNT_0_Lcr2TT0TR)S2_m_aq_Ur_N0Na_NT2qmmrTrqrm0mLL#i__iNT_iT7)mNT2_)L7_r0SiLTa-S2LrNS)mc)0mTi)r22rG7qSr_rrmL_*q)rN_0q)Tar2ir_SmaT__nrNqg7TTqTNy)77_aLSmamiccTSac_<N)7q2mr)i72i;72L0LS1cca02T_)2qi27m_7_rr7Ta)r)SiLTTT}qT_0Nm7q0irm27LLDr2ciNTL?TaNrT0)2a0aTrTmnLi_aSFN0TrBrNrT0TLaj2_iiLTiix2cmLT0SN0q2m07iaTq4rqa__NS2Nr_TP)N)0iTTaT20a_rrSS_2.0NZ_icNqr0NT))Tirmra7i0r_rrLrA0RLq;0P)Sq2m0i2SmaT__NTL)N_c7N_0T)qqi2qmNLri_rqLT0r87c_NTTq)iqq2NSTL2L7S0SL_r)TN0NX0S)_q_mqSYa_e0-aSNN2TmqrNrTrq0qLr87_SiwTSiN20mWT)ST0)Ta0iirTmwLa_acNNcTrcTN)T))iqTrT70r_LL_LccNTT-ci0Nmr)Nq)2TSrarr7S0L_LrkrN0NLmD)*2Sm2a0S2_mrTc_TTv)T_2mTq)7qmr<7cL_riSNLGTmcSTi)qqNar2cmNLma7_)S_LaRm)(N_0rT7qirT70r__mr_cLNr_m)Nq22r72a_immTSri1SqcT0=bqTiNLm)70im2t7cicr2rINV__0i)iqLmNm!a)r/7iiNQrSNL)_T)rNrT7)0q_qrmra0aL<JSg_Sk2N0)22mTT7_rT7)r_arr)SaL2t0NN000am)q_2a7mL{i_raLm0{p_ca0mmP)_qr277i_Tr0__Nm__Ti)rNmm072aar2S_LmiTYacr0qT)q}0q2i)Li)r0Lma)rmSiLru2)/Nqqrmr)micrNam_IS0Sa_mTfc_202rTm2ciT77ST_TigcqNL0Lqm0mTcaTqaa_7NL7_2crLiN2T+N22)mc7qaTr2S_Lq_2RmNTTmXINcTc)2)MiDmcriaLv)S_0mo0caqrT0727(qrr2amiaENc_cL00)TcyT2)a7irmmmami_raNr_i02)y02m07T).ia7LSr__c2cyLrcq)TqL2(amqQmcaci2i4cML_NiTm)_2T2o7ri{miaN_rrNS)LTTrcr07T0)_)r2r707L_*rALS_2c0T2qm0Tm_iTm0mLar9TS0S^LS;_c_0qmu)_i0iamNS2_mcrSr_rc0cL2WT_miiTmiS7LmiTwrLF0_)2)ZNrm0qm2r70LmalrcLc_2_z)9N_qimT7marr0Sq_{riLN0r+Nc)NTmr)r27m07_7rirS0SL0k8sNS02)0m2am2Tr__Tr0rLLrTTc0c?NST_am22i0Sri0zNo8Sr0)Tq)22i707rqm7NSmL7_aNTLaN_cNq7227rqT2)7)aiiTcTL0c_02Tiqq27m2iT2_7qLEiqr7Sm0?!!NS02)0Thqvm27N_TrTLcLiV20i)rNmm0amqYi07caTiaS2LqtcTcNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2q7TLrii_2c9_2TqTi)d2272a_iqriS_LSW)Nr_iEqNT2r0L7rqTr0r)ami7S7L__m)mcLq007Tiacma7)aqtrSic20mxT)<2mmm)T2amLLmimrcNTLr_ScS000r7rqra2mOSLraLcL2K)crcc0_0_7mq_i_rcaNr7S0L_N0phTSNL)))F2ia_7iS7r0rLLrTTorcS0S)0)rirmam_aar7rrLi_7lLq-0)m6q2i2mNa0amiiSNLaTrcN07T0)_7)2_maam_6rmS7_7W_cm2m0Sm0armNm2aNrcrTL0_cFq)z0qmT)Na_2^7cicr2r;N}L?TrNmq0mTT%ari_SmLmiTp_NTTmQ1NcTc)2)hi>mqriaci)r2Nr_c50qmNS0_)02mm7a7i_rmNmL700)2qm0TmRa0rmmtacrcS2SO0e4_Tiqr0m7Ta2rr7Ta)r)SiLTTTBrT_0a7T)c2Tm27mi0RrrrLN_0c2qD0{T7ar2N77SmaT_ycc_icccmqqTTq2)_2_7_7LSrSLc=LaTTc_qrmT)a)_2a777riir7SL0mTiN0)_0r7720rrmLa_iTr2SL_q)mN220mTTuari_LTi0iLSrNi0t)0q2T22iaT2a2_7ai7irSiL7_L)mqi0)2_)Si7rm7TL<I0NmLahiI#N00a)NiT2)SraiiqSTN00mTic_0qmV)c7ia_SmLTap.rLa0i8TNT0iTqamq7i0LN_qrme0NTLQTr)e2T7mqaqLm_a2icE!S_LaVm),N_0a)ma.2mm7a7i_rmNmL700qcNqmrT7qr2_m>aijTS0ZtLST7)mNT2=70immm7c_TiaLccYLrTm)aT0)7qT2_i07rLarmLiL0B0N0NN)9qNaTqLrma0L/nmSLL0_LcScA0_TSqNirr_a2L0i(cS_2T?cN000mTiqN2aSrai_2umSTN<T0qm02TN)=a_rTS2LirT__Lr07TmcTq^m0am20maLTiT&2g.Sr0mTa)0q2mm)Ta<rTLmamrmS_LaTrcr)22mTT7eiTSmaT_NrF!0_T_7eS0TTqqrar2aacSbar1mci90Tm)1NSmm7raDrT7Ni7_mrTc:0cci0c0N)77mqTi&SNiiScV.Sr0mTr00T2T7)aihrTmGLr_JciNL0r1mq02m70a)irmaicLwircmN7c0N7Na)cm4)rimrai0r7GmSTNnT0Ni0_Tc)NimirmmLT_mc0N)_mT_q2q90r72arifSiL_G0t)LmNicqq)0m2Sq22NmbLmi2rNS,0m_acicI00TaqNrTmdSLSSLTrL_q_2NcN_TT7mqqmSrr7m_T?2L_02._ca0mm2m7qqrT7cLr_Tn0NTTNN1TL0r7T2q2crcLci3S&r0N_0aT0072r2_mLq0mXirr)>cLS3qTr)0)iqa7272mSS0iT_c_aSS0rRrNSTc)a7iicmTSrLmLqLcNTN2)Tq02T)mmia77T7rSLL_i_S00q_iq7Tr)rm_aSi277Lai0r0N_07cmqY)m2aa7immGir_TSmLr9c00)i)im00_2mirmSm_i)i2Nm0r02Ti20qa2T2S2SrSarSN_2r_0SNT0q0L)L)p7a7aa7iNL__L_m0q)))S0))SqT2m77Lc7iSW_TNq0-)rqN07ma7r7TaqS7SLy&_<L_cNc2)im0)caSirmSL2LNxq_cNSc70NTrm2mNmN7caai7SNc0LagmNN0r0)T)2mqi7ia7L_aiS0^TTcNq)LqNT72ri7rcLcL7rccBLj0iNbq22_702TiiaN7SrTK4sNcaTr)i)i2a7r7Nq2acm_r7i2N0N0cm0m0y207ca)aaS2S2i7__NrcTcScS0cTrmimri0ScSi;)_7N15rTmqTNAT_7a2m20imaSSaSrcicaN?)2mcqra22rr2S#im4mL)NaTrNmqq0SmLqrq2iaLra_LNn_Xa_0c7Tqm27<aq7cS7S2a2LqULNN<Zc_T))72Ni0aLamrTr _LL)_VTG0)2mqN2r)_rS7q_mS SrfNcr)rqcmTm72Ti#iqm_iNr7r2SiTTNm0_m)77a{aqiam_r7SSri0T0N))Tc2Sq7a)r0S7imLqS^r__) D)N2Tmmmqi0rTamSiSqL4NtcNNr042c)r77i7r;iNiTrc_LciccTSc0mT)gqc2)mySZL0S7NcIq00TNqrqam0ammiS0m_rmSSSSN0+))_0T2S)7a2iaS770i7Lqr__rx%Ta)LmcqSimrTS4L_Lar)_7Ra_iq7)Tm)a))_m)rqLQSTcmN_crcm0mmcTSqciN7LirL7LT_NN7cacrc2)q)m7NaqS0m_a0i2SS:Q0Nc7qT)a7iar7qSrSNdT_aL)n7Rmq0TmmiacmraLScaOL)Sc_7LL0_TL2cmr2q)_rNS)rr}7_TS207ccqRmc2rmLaW7SL0SLLT_NN70Lcrqq2Z7raNaiariaLNSr_c+Tc7c720m7qm2r7r2_L1iVcmLmN2Tr)aqLmSqSmqi0SbirSrc2Nc0_T7h_2tm)mRmWiNLTrcS cicq07TSNr0Q2aqcimmcirLL_NLS3cc)N7qr2a)mmTaqr7i)_crUN2NLc7B<ci2Lqma)r)aaara2ii&L0S)Tq)N_mjqS7a7aa7a1aiLENiNqc!q22F)SqTiri2S)7i_Lcc{N070LqN0,qrarmmrrS7LSrrkiNoT2NrN42a0_2mmqr7LNrLSSc{NSTNTqTrm2mNmN7caai7Smc0_aDm)Tq)Ta)L)7im7aaSS2_ai__mIS))TLqN)S2ri7rcLcL7rccfIN+_cc)i07qcmSiimFS7icr)_NN!0S)iqq2aqi7Nq2acm_r7SrN002cm0Nq7)T7Q)2mTaTLmSm___k0S0qcSTa2Nacmri0ScLr_7c2NhNi0rqTq2mqTimIriSqaSg2cjcq0c)2qm2)0iqS7Tm77SSLAiLS_>TTNmq_27)iqrmSrxS0r7cccaNSNTTi2)TcmNq77caaLiSmc0cSNN0N0cTq)72Ni0rrSSSiSr_cL)_40r4_T72i7airrcLcrq_SnNN_cr)rqcmTm7mL2rrrimimImc)00L_Nm0S0S)ma^iTiaac_iSrLbDT0N))Tc2Sq7q7r07mimSmc)_l0IE7NT22mm)!i07aSSrN_7_LLr0_Nr0-2cm_77aSr%iNaLrc/2L/LicmTTmTTS2I2ramra7_xNLrbrc)0T2T)qT2aiq27Km_rm,_SS_ctrO2)am7q7iciarqLSa2V7cSNNcrcN0mmi7)imi0i7Siimc2c2Ni_iE_2i)S)SaLr+araNSgL7N)LiNTqc0?qq2aiNS0irS)SmPiN7NL)%N+TT7T2727i_am_SSSN)_cprqTNa)aq77_7qSrSNiw_aLcM7K<0c22)mqSi)i0aLLraSL0SSNq)0)S)T7T7oi7rNimLarc_T/N07cmqJqq2N7Sm72_L0imSmNT0)L_cr)iqaqT72ma2ia7LNSr_cykc7c720m7qma_2SS7a){c_aLm0m87q0qLmSaTmqi0rNrN_1s0NcL2)m}_2#2i)7mZi2SqLa_S_TcqT)ccN))NmRa2a2mmL0imSmc)Uc00)iq_m0mL)0q27 LT_<_iSq07c7c7)_)a2T2S7qr0S2i}ii8mL0:lNK2TmS))mqmcSmrmScSmbT0_)),_0)2ia0i77m77i^rccS_rcqNTNrqiqc2Ta2mUL)raB9crcaT20Tqq270_acair7iT_R_i_c^jTi)_ci2S7ca_7qS2SNrrSAtLjLTrcS2rmc)7a{i0r2rTSri_NSL2DS)S2?2iTLirrcS)_m_Sc/kNs0TS)22)qcmLmmr_S7icSL6qN6T2)N2cNi72q)7maciO_iSrN0xTcm))q7))7ca_mTSrrLSNii_G}m0i0q2rTr)Lmri0ScLq_7c2NZcm0ah_qN7T7am57mri_)&2LL_SNaN=07)NTSmL2r7aaTi0S7xiN4Tr)N2T27mLacrTiaLTaaSScaS_TSNSNqTcm2a)a_Sr70S2c)Nr^Ls7NTc_Tr)n7_mcamiS()_LL)L20a)L2N)S)S)_rLSiL__crLNr_7)T)L2Tm)7-iLi(SaLTrSLL_q_rT0)mm22))0acr_SraSScLqc__))q)M)qmT72qii)S0_TJaS/LSTT)a)_0ZT27)irS_Sr_aLqcTNmT_T)qmTcqqaLimaLSfir80ccc2)i)mqc2r)raTS07aS7rSSS_)h7TTNT)N7iqLii7)7LS7SLric_0+0Scim0)LmSacrraSLmS)r_c7TTcmqTqiqN)irirm72Lcr7Q70q0qN7)770a27)7aSTLmL7LaLc_)0)qN2i2im2777c7mS_iqN0NmN_)NN22m)770a2m)r)iSGic_Nr_0NLqaTam{i0r2rrrS_qrmL7cS0m)_0a2mmm)iiTS_iNLfcit7Ncc)qi0L)c7a2aiZL0rN&0_SN0T2TL)#TNqNmy7q22rrLr_0Lc02N4TmTSTq2_m7q2iiaaiS_24cS_0n)T))2L7_2Ni_i_7SLc_icr0_Tqc)0a2{mm7)a7m0iSrqS7-S_T0)T))72c7mq7iESq7iS_4T_Lc0070a2N2rq7q0imSa7_VNcT02T0>S0Nq#)a707SiFSrLW<qcm_aIScT)cN_)L7mi_i7SmiT_c/}0_0ccmN00;mr7)2raaSmJ2_7S0_ccqN70LTT)m7%a7r2LaL)SLNqNg0_0mN2qN7r2SmcSaLTiSSTENN)kgqT0m0_m72c7)Lira_c_NL7T2Nc0)0rTzi0awi7rSic_c_qNmcc)m)j)a7i2NiSaSLqL)rrc)Nm0rT_)2qSmcmqiMr2L0L)roNTIqTLNS2T72mMi222mia7_mcqcrcq?S)mq)27a22cm)ST_2SN_Nc__h)i0)2r7N2c2)aaSmrcc2N002N)-iTq2m)T7rrimSLiL)u0LLNrTmNaqT027_i02SSqScravmcmNica)mqm2r7TaT7N7)S&i0Yc_q_).aqqqrTr7La27)L0__rc})NLN7NL0qq)TeqT2)i)7%rL_i:_N0_2bSqr0o7qi27q7LS2i)_)N2L2T_c7222rmrqr20m2Sri7V0SxNcNq)mqr72qai2mcS_i7SaSTUaTi07qiTqT7m7mcic7rL8LS_cc7_S)q)r2T)N2NaraqSmL2c2cLL0cLT8)_2E2S7)r0mSSrrqS7LS_Tc)T72_Tcmyi2imaLamirr09SLi03)Zqc2i)r2LimSm_0i!ScL)T0)NNTqi2)7miiica)aSSL(i_a_0&2)i2rT_2)a67aaSiTSqNiL0%cTic_20aNa_r0r)iarqr0FTL_N20aNLqLq02Sm)m_a_rq^0LL_0}LNSNoT_)S2Nrra0_0ricrNk0_cmqq0q)q)_7ama7Ni_r_cS0Tpaz_NaT7Trqi27mLLm_irrSS_Sc0cr2rTr7mqaa_7mLqL0SaL__2NNTi)rTT7r2TrNi2a_SiL2Lr_TNaNTq7mGqqqimqa)amr2S)LaTTcNqmT0m%qrii70LTiNerL0N1Qr)mNam07Tqqi572LTiqMrL202TmN02TTN7m2TiZ7iLir2rLLrTTOaqT0imm)aaYmrSiL_r2SNL*0_)TNaN_Taq7qrmi77aL8mSNNr_7)TN_2_)0qarT7TrLimVqLTLLN202Nr)2qrq7rmmmami_raNrLL&_cTN20L)qim27S&a_iaSmND_90iNm2)Tr7am_m2i0i_rTrr6N_r)rNNq2mJ)Li0mrSarTLrL)SA__cS0LNL70ai2rra77STLS_TcqN_cT0jmr)2qLilmLLiirRaS7_0N_N2))Tcq_m7r0rTar_aScJ2LLNS0m0m2cTLir2r7ri0iLc1LNQ0umci0NTaar2irr7)_Tricm_00gQSqi2rTaam2Nrra2_Tr_c_N>/i)rN)2t)iiTm2mLar TrqcxLSTi)_02TT)c20rrmLa_iTr2SL_q)mc72%T_)a2mr!7Ni0imriLN_a)rNimT)0)L2rrmaNa2rNLcLT,0ccNq26)2aT2crr7a_2riLN0r3rTqN92L)q)QmLi27riTSnLi0e_gc,02TNaTqqm2mr7_iqrLNM_N)mN20NTQam2mi07 LSrTcN=2__Ni020rTT2a2TST7aS_emSqNi%T)N0a)i)2m_777ei)STMiN0_TTN0mNa0ST_mr2LiqaqFTr_Lq0m8qq00TmN)rqLa)7Nr_Sr_qLL0i0aNT2NTqmT7qmNaia)iTSq0T_TcTNi0q7m)a2i2b70aarNNT_0TrciNm0))2az2N707mairNSa0r_S)r00mT)iamm0rF7S_i1rS70m1c)rN7mT)ca_i#mSLriqWjLi0mc0q022T_)a2mrD7Ni0imriLN_a)rcS2r)0aTqLSTa2aLrrNTLq0BciqmT070aT2_r!7a_Tr_cr_2T2)mNqmT)iiTm2mLar9TS0czLLTmcq20m2)_qammSTaLi0rLLSL15_cS0Nmr)qaVmiSma)30S2LLTmcm)N0rmaqc2raNa0imrS_TLrTr4rNrT0TLaR2N707mairNSa0r_SqT000L)riTmTi_ar_7rlcLc0}i02T0TmT8mq2oSFaqLicTLN02s )LTLT7)0272amormrcc2N__YTLN7TcTaqqqia7iTamgtSi_NTTcNq_0BmL2Y2_mir2a2_0Lc_qT2Tm)iTT7N)iq_a77rrQ_2Lic0)TcT0TTi)qim2Lr0Lriah_Lm0qnScqNmqmqQqNa2a_L_b2SmNq_m0m0mT0qqmNmia2Lmaarir6L0_acN2T0)7T)Lir70S1aLlmSq00TTccq;077y202a7mLPi_DrS70Tj_)_qDTi7r20i8mLLmiqc0N2__;rc70i7T)q222rm_aqiLc%LcTmc2NN0U7m)a2i2^70aarNNT_0TrciNqTT70)L2_mT72aLrqNmLL0)c_NaTm72ari_S0L2i_raLmN)8Lc_N2T)q)20aqmLrNS2r2jTLicq0Nq007)baL2qr0rqr0Srk7dLN_qT0rma2)2qarm_i)Sy_LLqL_T)Nm07)7q_2mSma2L0 rSMNL_2TNN))i)cmN7qmLL)_rSNS2_NcccT00Tc)qa3r07Ta)r)SiLTTT!q):0r22):aLaiaNi2i_Lac0NTUrqT0rma2_22a0a_iTir_NLr0c)mNL00TLqSq1m_7SiNhrSaNM8r)mN)2Z)iaim0STaN_rracV_N)TN2NLTraTqaif7iLmrTcrL__qcTqr0rmi7r22rm7_Lrr2cTLc0r,Lq2T0Taqmi3mcSki2kTS?Nr_L)TNHmm)iqN2GSm7L_2xmL00T!N)m002>)NiTm2mLarpTS0c?LSTi)rN7mm)qar2LS(i0iaSmNW_qTrN22TTcam2imN7F_mrmc2_0_acmqk0_m4qmi3707aim9jSqNrbm)TNnmm)iqN2 Sma2_Tr_c_00Oicq0Tm07mqL20mLaSa3r_SS_NTrcrqpTi7mqai5mSLii_SqNF_N0aNT2NT))NqS7irNiNia_c0T_TcTNi0q7m)a2i2 70aarNNTLaTrciNqTT7r)La2mqLcim<q_i_0c_NiN10mqLqmrm7mS0_rSTc__mTqTcNvq72mm_7mmSia__c2Lm0q9_cmTmTq2qm0aL7T_mr0SaNroT)2Nm2qT&qi7m7im5riL0LrN_NLT0Nr2aq)22qimN7iiaiaL10r_rcr000L7yqNm0mm7iiNraNr_N)TN0NK0S)_im2a7i7^i0raLNTTc0qTNSmr)raGmTSmi0_VSi0T:2wLNrmTT)a0iTmqSPi2gTS_Nr_7)TN_2_myqTirmaS5aSWmL00r3_cq0Tmr)Nam2rSra_iqSTNrLSTi)rNVmm)_immi7Na5KmrLNT_cTrN22W)0)a2mr<7qLriLc2_0_acmqG0_m4)7i^707aimpPS_Nr_7)TN_2rTLa2ii707LircTSq_2_rP_Nq0L7 qcixmLLmim(rL20T>_)r02m*q0qammSDam__AZSS0rc0)J0Tmmq0almNSiLriLcmLc0r{LqT0q7mqi2NmOLmi2vTSc0mBicNN?mmTWa2im70LTiT#mL0N;%i)m00m072q_2a7mLTiLr0SL_S_4c_NSTN7rqri 7NLmr0o:SS0ih_Nq2:TNma2TrN7_a2imLmSrcS0ac7mTTTqT2imqLmaarir=L0_acN2TT07rqi2q7TLraL_2Sq0cBm)qTiT0q_2i2gmmiLimcmLmN0TrNTq_Tm7q70aT77aiaL_7_7c7T_q20mmqTl7TacaaaNSir7L3Tmc0Na2r)Ta22mrqi2iir2SNc)N702cS2_2LqmiqmcaNrSrSSac7cSNi2m0m)mq_2aSr7Li_rTS2LLfqqm02mm)_a,27S1i0iaSmNk_cTrN22TT_7rqGr2SmarsTSNNm_)TuNimT)2)L2rST7aLprTciNrB2)mNmmm)iqN2VSm7L_TrccrL7TTc_q_2J)iar2arEaN_mr)c{_i)TN2NLTraTqrr0S2a_irr7LiTT=qN2Nr0_)qqLr&7q_mr2SNLHTmuaNiN+T0)a2NST7a_rriSq_T0lcac_0a)7)r2im77L_mrmcrLLTTccqrT272qimNSr7LLqrycLyqN)0T)0)m)q7qa7S+7RiUS2LNTTPqN2Nr0_)qqLr(7__mr2SNLbTmJa)00NmSqTiNa27_riS2SrLTcacT2TTT2_am2,rLaT_NSa3cLL.aNiTLTT)Sair07TLNScLLvc_0Nm0)N0)7aTq_mqSmaWP0STNN..N0NS)qTS2L22aqSiSrrTcNSrNcNm0a0IqcmamiST7TiTriSq0m_acict00TaqNrTmaLriirmS)_2T9cN000mTiqN2aSrai_rrrNT_iTmcrqQTi7mqar0STaq_hS2NT__)mNi0NTMam22rT7c_mriSNLsTmwLqT0m7mqi2NmOLmaHd2cmLaTTySqm0rmIqTrT727LircTL0NQXTqT020L)riT2)S0LTiq.5L20T5q)rN7m{q0qammSKa__rr7N2P0JaNm2?Tc7&q7r.a0aarmcALq0rhXq!T0Taqmiom_Sri21vL0La#m)-Nq2rTLa2ii707LircTSq_2_r6_Nq0L74qqiX72Lmi_cmLi_N=#qmN7mT)_ar2LSTaq__YRLN0rza);NS7Tq2qLmrLTar_,SiNm_))rN_0q)Tar2TriSri2PmScNr_L)TNc2rTka2immaLTii6mSaNJ_S)m00m072q_2a7mLTiLr0SL_S_nc_NSTN7r20i17NLmi)dvLT0iX_Nq2QTNma2TrN7Lrirc_mLTc7ciNNmTTTqT2imqLmaarirEL0_acN2T0)7rqi2q7TLraL_2Sq0c,m)qTiT0q_2i2EmmiLimcmLmN0TrNT2NTm7qqaaa7La_Lcr0_c_2T_q20mmqmq72a77)r)iSLm_iTmc0Na2r)Ta22mrqacr7r7L)ccca0qNz2_2L702rrai7ScrYSTXRcLc_NLmrTrqrm0mLLBiNS0SmLinNca2r0SaT202smSa_HmraLiL.h0ca0N7T)riTmiSra)_XSiNm_rTxcS2imr)LimmqSri2ATSqNr_7)d000a)maj2_r_SyiiWrSaN9oi)mNa2H)iaiir72Lmi_%rS70Thq)r02m2q0qammS!ac_HrLN?h0!aNm2{Tm7rqLrXa0aarmc!Lc0rc2qT0qm_a02imqaT_riLS_LT_2OLNqmm)2am2mrW77_eS0Sa_mTDcqqrT27s202a7mLvi_hrSL03c0ca0mm%)qarm2S2LmiacTLN0m,rqr0_TqqTirmTSmi0_VST0TQ2GLNrmTTaa0iTmcS:i2WlL0La&m)!Nc2rTLaT2_rr77_25mL00TlNqT020L)riTm0rjai_mS0cd_TTi)_02TN)ha_2a7i7ni0raLNTTcT)c0iTqqTi0rmSiL_iBSc_c82^8q^0N)0m_immSa0amraS_La_q)2N)0q7Tqaq_maa7arriS7LLTm)iNqT2Tr)_2qmLLWr)_0_LVa)TN0NLTr7i7S2E7cicr2r>Nk_a0iNT2N))2)7T2m7_aSiLSN0T_7%aqj0rma))qrm2a7rkir_2LN0ccTN)T))iqTrTmqr_im1q_q_TN7TNT20i)TmmaSm;acrcS2S{0#Q_N0)_Tm7qmim0a_iiizrm_L_m0Sck0c)cq2q>rbmMSirTcN+NtTcNTc0iq)q7q7i77raSrSL0LrTrOS)20ImL2amSmii0arLS1)=r0)cmN7T7)_qmrm7q7iiqS)Sm_2R)ca2rTN)_aU22STLq_apLN2_my7N70_TmamqSi07)L^r2cTNrLSTLqN2q0ia0m)r0ai_T<7cSN_T0T)Nm07)7q_2mSm7LL0rrcac2jLN0Ni)q2_mZ2mrcam_qS)LS_moacNNmTTq0afmqmiaqr)rmL2_)vaqT22Tr7a22mmari0SNSi_0cm)Tq20q2i)Li)mrSar_r2_0__dTkrTN0r7rqi2q7TL0iTr)L)_iOTqT0N02)N2c2T70aciqcmL20mxp)r02m2)i2Nrr7i_TiTSTLi_q)mca0i0o)0qamNLTaa;rSiLq%TTcNNq2)Tac2Ni7a0aLrrNTLr_ScS000r7rqrimmaS^i__2LN0Tom)q)0Ta)_q27NiirriTsrLq0T-_)rNSmT)raa7)icaNLcr)LS_TN;q0q)Tm)727m_7m_mrqriLq3)ImN20)Taar2TrrS_asrcLc_2_n);N,2rTL702rrai)ScrNkcL)<ScTTXmT)camm0STam_qLiL0D_cicYNm)L)marmTSNrNi+_)GLc082cI)Tmi7r22rm7rLariS78+Ncc7020aTh7!2mrqm_SaLaw0:q.SB7Nq2_7cqmiqaNi)i0SiSTc)NS0Tq_2c)iar2}rLiarSri_0LrNST)Trm2m7qqm2mr7_iqrLNm_qTLNT2NTN2imTmiiTrira__Ni0Scm))0_Taqma)mm77i7r_Sm0mxcT0cH0qT2qia7mr7SiSS0Sr0r:)T2NP2L2i2Nm2m_iaL0_TSr0!fmc707T_)mimmqmiaqr)rmL2_)XaqrTcmr7_qtmcaci2iXclLcNitLqm2i2S)h2c7ca2aA*XS_ci_L)mqiqSTkqcmc7276_ErNXi_TTN02N_)iq2qr2TaaaTL7rrSS_Sc0cr2r0Sm2aAmmSma__rSTNNc24_0iT2Tr)TmamTSmaF_LLLL7_0c7caNAqmqci2raSwiTINLLBc__N2c;qc272<mqmFSLS)iiLqLmNqN))N)m72aiiSm7S)imr7L7__^mqmNL20)1a9m2STar_a_7L0(RN_NT0TTrqTa5mmSqaEr0_SL7 ?pTNi)am_7c2Tm)a)iirTNT_0N_)mqr2i)TaN72m_iir2rrSTba:T)i0aTm7mq_ir7TLNS7i_LaLrNaN7)q)r7ia_ic72aL_srLc0N2wv)L)i)Nq2q_7ar0STirc2S,_jc2NNmTT_qqimmcriS_r)ciLTUTciNqmmTaqiq>m07aiNcTL00NAm)q)0Ta)_q27NiirriT_SL2_TOcN02rTNm2q5iLi0aiS2L0LmLJNqcfq)TNmi2TrNi_iqriS0_LN20mc6q7)0)L2ri7a0a-iSS_L_+q)mNqqi2_qmiqai7qrqL.L}La4i0rq_0m)mq_2aSr7Li_rTS2LL5q)dN720m2amr07_aqrTcTLi0aT^)i2cmT7_i0mc7NLHr2cqNr0mTS)>2im_7c2imqaTLciLS_LT_2lLNqmm)TaN7Ta2rTS)L_LqLq4r)r002R)Na2i2rrSL_co_NN0m/N)S2T0S7)aliaaNS__qc0N20i0SN20NTjmSqvmcaci2ikcfLTNiVL))0mT7q72_mmLmiqiiSq_)_mc2N)0a7rqLirmaL0iTr)L)_i^TqT0T2c)2qLiImLacagcmSL02_ych02TNaTqaa_mlLr__8cL2_LTscLq0227mi02r7ri0iLc9LNM0Umci0NTaa)i7i7a0aLrr(7_0_Lcr)7TT2_qmiq7Ti2a_r_L_LLNrNLq+0S7Tq_iAriLT_cd_cO_iTr)0qt2a7iaS2LS0L0__BcLi0ryaq00TT)q)2imTLTi0L_cL0N6NjScLmTTam_imr0SSic%2cm0)lm)yN>077rqia270SL_Nrrca_mcic000)0)Nm/7NSTar_mracd_NTiN0NLTraTqqm2mr7_iqrLNw__0SN20NTQmSqhmcaci2i?csL7Ni)7Nm2q0LmimLmiaTScSq_2N1Q7)mqSTrmm72iq7rSmLm9Sc_00_NT2q2mr)Tq)m)7iaTgTS0B__N07crNSTSq0qrrr7a7_iaS7Sr_i?7cL2&T*q0iTrNSqLal0rLL__TW2cL0q0S7LiNrqmiLUrmcqkiNT^2N2)kq)m77Nr?L)_SHScrNLTN)qq_T2)NqOrmm!acrcS2S90B8Lc0NLTSTkq_2S7N_TiaS2Nm0iErcS0S)0)rirmir27Sa_;)Lm_7c7N_0m7mqqa027miLcrTS)_)gicT2T0L2_))q2iS7wicScL2LjTYNc)i0c)qammNr<aNiirrc;_i_2TSN<Tcqc222-S;a_LirLNm0iurcS0S)0)rirmcr27Sa_SaL)_q)rcSq2m27(2iSTaTaSxPSmL747c_Nmmm)m70m0r=L0L)rmS7_7E_cm2mT2m)qimNSTarL2_ic702_>cs02TNaT20a_Smi0_*c0SNN2))ccN0mimS22mT7ci0r0SaNr=T0_)020m_)m2mm_7a_rrTS)_)ficT2T0a2_2cirr_Sci2rLNm_cT;N0NaTm7WqriaiiaLSaLmSL_ScMcm2TTm7q)LaiaLairT_c_qc2T9cL22mmacaLrmamLT_Tc)NiTT))q2N^TAq22NST7aS_rmcqB2_TcT0i00qa2Sqary7L_2_7L0LL3rqT00q_)N77m0mk7Si_r_Lq0m/;Ti)_2L7iqTmT7iaqemS2c0 NTHq0q)T_)a2mi)7)iSi7L0c2Y0TcNi0q)T7c2am)7q_rriz2N20<cNqr2_)mqcrT7Niciij2cO07_))0cim0q0722a72Lm_i_SL2_NXjTS0qTc)Nimm7r0L0_rrLNm0icTcS2GTm)727m_7m_mr2E0_00v)0))0i)NaT2rrra0L5__cmN2T0T0)22m70)r2r707L_YrmS7_7>_cm2mTqm0qVi&72LT_N&rc70207crNSTSq0qrrr7mS2rTcTLi0mTT)bqamimSqAmcaci2iMcdL_NiMcNT2rm_7H2TrrS_LvrNSiLr0pcNNi0r0_7)2i7NLTia_2biNrT2jBN,T2)NiTm0ac7Lr2_iS.0mTiTS02))T32ia_7TLr__bcLi_mn)N202TL742qi0r2_)ich_S20_;mNm0_Taar2i777qi__0SqNGT0T)N_0rT7qi2i7NLTia_2niL2c))N0im0Trqrm0mLLAi_SSSas002ca2Tm272aXiaaNL0_Nc0Li_m+)N202TL7-2qi0r2a0SchS_20_^mNm0_Taar2i777qi__0SqNBT0)0qr2q)L7_aLr_a2r)iyLic_&T)rq_2c)iqqmTrca2iLIhLm0mYr)rqimT70a_a_r0L0__rmLm__Waqr0i)7))2_i07)iSr2L)Lcvic_Ni0q)Tar22mLSRim?mSrNr0a)TqN2_2_70i0r_7mimr_Sa0r}iN7NqT_m0q)mS72i)iNSiL__i#qNT2rT2)La:mmSmar_r^7NT0cT_T_q0m07_qmmm7_aa{rSi_7_Tc_)00))Sq2m)2gaii_riSq_TTrcq07T))_702_iSa2iNr:Nm_2fNcZ)ST7q)acmii_a__rQ_ccLL _cTN20L)qimm7r)a_iaSmc)_mB7N70_Tmam2q2i7qi)imS2L)_a)rcS0_mEqmiTmqSri2X2SmL7M7c_NmmmT7702qiS7picScL2LnT%cc)iT2m)qNm0mm7iiNraNr_STrcdqLq_qNmL7r7NicSTrrNm_rTaTi0Lqa2mqLmSa4amHTcmS7_}TLNST)TdqNqa2Z7riiPmSlN_L_)2072q)_aT2qr_SYiioic__2?NcI2m0A)c2cm2m1L,iLr0SL_S_xc_NSTNaTqmrTm2Lmi7Q8L_0iDrcS0S)0)rirmam_aar7rrLi_7XLq+0c)0aTiNrqSa_0rTS)_)5icT2T0rmM2cimmiSYiNr_cr_aTTcqqrT77Tq7ir7)LTaalrS20T}+TSN1Tcqc222^Sta_Li(rc)LS68N00TT_7iaiiT7__mrmSc0T__cqqX2N2am_2iST7TiTriSq0m60ca2TT02L70i0Sm7mimr_Sa0rQ2cL2mT2mNa2i)Sr7rirS0SL0y1NN0NrTiq0qTrr72aLDmxacN__)mcm0mT_)airm0r2iNkTVaNm0cTaqT2cmr7Ta_rmm__0_)LNci(mci2T0a)270iTiSaaaLr_L2_c0)c_NaTmm)qqair_Sr_0_SL7N0T2)2qc0i)qqTm07T_TiTraSi__0SN20TTcq0irm0r2iN&TFaNm0cTaqT2cmr7Ta_rmm__0_)LNciymci2T0a)270iTiSa2iNr/Nm_2;Tcc00mr)T72mNSTSa_m_!c70TT0)rq02a7m)_r0r)i)LiSqNmNLTr)2qrmm7qa9iSSTLri0c2c7h0ALNrmT)0)FqSm_Lmi0raNTN0NLci2T0T)Tqi2qSma0iacTL0cL0^qTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qm37c7rm2Sh7vi9S2LNTT_LT_0mmq2i7T2272rXS)_7RN0#))qS2Smr7LiNrqS_L___P7L0N_I)c2qS)a)L2_72acL)r_Sa_m0)c7)i0cT077mci_7)_qzacLL007c0NL0r)iqrrrmraNi0S2c)__nrc70i7T)S7_2)m2SSr)Z0S70aTLqNN22Sq22NmWLmi2rTSc_0Trc2NLmmm77Ta270LrarrrL0LLT:cN000r)i202TSra2iLcmcqNN,_qmNmTm)_qarr7rS2rNcTc70i0SNaNLT_q22ci)7_aarmJ)L_NiT_)Lq7T0)Lqrmi7r_rirSNL0o2T)N_0rT7qirT7Tr_ianrcc000)c_NaTm7Iq_2a7mLgi_raLm0E8_Ti02m)707Sm27NajLSSqLc_N)mN2q0mT7rqNr>7}a75rS2LL06c2)Nq2Tia0qrmra0aL%fS7_SX2)0N2Ti2_q7m770LcL_S2#S_2pTcc00mr)r27m07_S0iSSSL20)T0NiqcTi)q2Tic7iaqrTUcLT_)c)Ni0T7T)i7_2qS2aixcZ_0T_r(SNST0Trar2ii77raSrSL0LrTrca)70rTSqSm0mrLriai_Sa_7_rciN70L74)ii5rLLN_qb_S)_myicr02mYT!qq227i_TrTrSNu__UaNm2QT_)a2mr,mSa+r0STL_Tm-mcLN_)0ar2rm)Lmi0raNTLaN4)0)o2m7r)r2r707L_>rq}iLLT)Teqqmr)iqqmTSraiL2rr_c_Nc2TS0q20)_2Sm27ii2LSS0LaTTTc)7qTTLamqmmm7_aazrS2LLTmTi)_2T2am_2aST7TiTriSq0md0ca2TTN2.72iNSm7mimr_Sa0r12cL2m2TmS7qmNSr7rirS0SL0YjiNN2rTamqaci)SD7nieS2LNTTk_Nq2*TLmr7_i7ri_mimSmL__a)rN20L7mqqaNiSrR_rirSr_0_L)pNuTS)22)2c7ia_L0i7riNc6icmN)T27xqm2777a_imcmLq0Tt7)r0imT)TarmTST7_LSSqLc_N)mNiq0mT7ramrP7ta73rS2LLTmci)T2N7m)m2mm_7a_rr2SL0m0iT0)2T27r)r2r707L_xrL=i_2c)cc0i2c))72mTacair7rqL_!007NTTcTa77a2m_r0a7LSSm_)_LciT_0))7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)S_Lr_7ci2TTTqcqim7m)a_r0_2S7<c%iN7NqT_q0772ai_aN_7O2cc_i02crTcTNq27Sm27Na>smS2LT_cc0qr02TLamaaiNr2i2jrrrLr!0wLq^0L2iq2m)mcaia23TSTci6a)mNtTS)q20ir7Ticia57c2__T2)i0)q_TMa7mNr_S_/TrG(_N%07NNNS0LaT20a_7aLmr)crLr_))mNTq0Tr7Saii)7%iSr2L0c2_0NcNmT22Sq22NmzrSaL_0SqNS0iT)N_qiTI2)2q7iSciirmS)_2Tzci0Nmr)_7qiqSr7rirS0SL04lNN0NrTiq0qTrr72aL/mSiSNN2TTqrNrTrq0qLrB7LSir2L)LcOi#2)0N7)T2c2a72SViN%mS*Nr/q))q02r)7a2ii2iScim_2cmNcPac)Nqmr)i72mNrGair7rTL__r3)qm0T20)raSiir)ajrSS2_0N2,00c0m)2mS22mN7x_miLf0Lq0STi))0_2i)ym)mqaiLcrLSN_0Wic))7T0TLqra7mar_iiS7Sq__0)e_Na0m)2qmrmmm7La_S0cc_iwmc)02mE)q7im2a)aNriecLi_qcTqr0iTqqTirmi7qiT4rSiLq3T)rNi0q)Tar2imm7)i2XvSi_NTrca)mqimT7.rTmTaTiirqNm_mc)c_0S07q022ai7mi)i_SSSaz0c2NS0m)))_2S2ma0i2rihcLi_mG)N22ITiqNirmamqSi_Tj_0T_TcTNi0q7m)F2c7ca2a^deSrNrZN)T0c2rT+aT2)rrai_TrL-SLR:cNc020u7gqqairrS)aSrZL0_TU_qmNL2N72a2rr7ra)BmS0LaTTJaTLqL7T)T2Tmi7q_mr0Sa0T0T0ANNmTTTqT2imqLmi0raNTLaLLT0)_mmTmqm2_maLriN_2ciNa0)c_Nr07)iiTmTaca_r2_iLqN)U_ca0mmI)_qr277i_Ti_SqNA0T0rcL2<0v)k22mNLTaqr2rAL_82+mqV0i)Nar2NimST_rirSr_0_L)*00qiTJ2)2r7iSciLrNL0_i!)T7000L)r77mNi_arr7r7L_N)RLc7NamD)_7iiiS)a)_rrk_)3cciNm0c7TqN7_maSqLarmL)L_xiTcNi0q)T7cqimq7Ti0rTNTLT_aEiN_qS)2qT2c70Lri__2SrPcVmN2)ST2)Nqlrm72aNiVcmL2_TWcN02rT2)Lim2LrTL0GmrmLm__Baqr0m22))acmqr2aq_cSSc2_TTcNi0mT)q2itmiaN_r_h}mci_L)WcH0;)2qNrTmqa2a(r_L2LmTsci0Nmrm_7m2aSr7rirS0SL0*&)TiN,)))a2iic7LaNr0SiL)N7c0cL0r27)r7_mir7a0iLrrLi_r)rcr0NT0q2a)m_7ra7riNTLrN_ci)7T0TLqrrT707LircTL0LLGrqTNaq_)Na7i2SraiiqSTNr_i{mc)02mb)q7im2a)aNriecLi_qcTqr0iTqqTirmi7qiTkrSiLm_)c2qb0i)Nara7i_raS_raNTLT;TciNqmm)0qarT7NmLL0_Sc00r_rcr000L7#qimNSTair7r)L_NTd^NS02))TK2im_S27Hi5S2LNTTDaT_0i)7)q2_i)7_ari7Si0T_a0_NN27m27c2imqaTLcriSmL)e2)jN4TS)22)2c7ia_L0r:LS_2c)cN0iT_70qgmS72i)a-SiL_N)l_ca0mmx)_qr277i_Ti_SqNM_L0iT_q72Samqmmm7_aa8rSr_7v0NccST2)im_imm_aSaaS0rqci0r)2)70a2_qNi7r2SciirmS)_2TlcmN7T7)_qmrm72S0i_SSS7x007N))_Ti77qii_r_S7rNrSSLTTwaT_0immq)irmr7)_mi{Sc_c^2QFq-0_2iqcm)mqSii2S0g7_TcccN02qi)27)2_maamL)r_Sa_mTRc_NaTm7Yq_2a7mL6i_rrS7_i)Tc_0qmQmraNaLr0aLEmrmLm__-aqr02TLam2qiNr2SB_2cPSf_,c2NNmTT_qqiDirS2SM_0SL0m_mcmN_0a7rqa2)mqLrim_2c2N)TTTSqcmr)rq)rm70aa(TSN(LNm0_qmNmTm)_qarr7aa)iqcrSrN2Tm)Eqa7TqTqSr^7iiN%rrrcq0q)rcr0r)0)LivmiaN_rirFmci0m).c+0j)2qNrTm_aq_pif%ac_T0)02m0m)mq_2aSr7Li_rmL2___1qm00TaaTa)a4mr_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_}S1a00T22S)La0mqSSLi_)S_ci_HN)NqTimcqL2N70aii)_7L0LLzrT70T)c)i272)7_i0_r._cc_N02ca2c2_m720a_7Ti7iaS_c)L_^acm02Tmamqm2Lm_i0_cSiLm_)c2q&0y)Sq2m)mcaii__0SB_Su2N)NNTi)_7)2qii7L_)X0JS_200cm0S0Lq077m0mLarETS0SyLSM_qm00TaaTqTaLr0Lc6mrmLm__+aqr0aT))qirmar2L2_TcTcLNI)rNr0)7mq02aSTSN7L_0rV0m_mcmN_0a7rqrm770icaSS2Li0TT2T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0a0L)_22mcr)a_iaSmc)_WcSN2T)Tcqi2_i07KiSr2L)LNMic_))TNTqq22_m7rSi2rNStcS:2cTNcT07rqrm770icaSS2Lic_5rN700)cTL22mircaiiqSTNr_i qNT2rTi)mq)m2S#airNcrcKNmlTqrNrTrq0qLrg7iiN&rZWcm_T)rcr0r)0)Li/mL77aa=OSLci0iT!qm2NmaaA2Vm7Lri2rLNmLm0T)N2m0m)mq_2aSrarr7S0_cLSc2Ni2Tm2m7qaa_7NL7_2:cLiN23r0c0N)2mS2a2L7_i2rcX)L__acm))0%)Sq2m)mcaii__0SH_Se2N)NNTi)_7)2qii7L_)(0yS_200cm0S0Lq077mqmaair0rScc_i/qNTqcTi)mq)m2S5aurSS2_)_cciN_q0TRqS227)7Niir_()LqNi9Lq)202Sq2a0mmaSaLS0D7_0_Lcr2TT0TP)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2_SSLN0oq)Sqi2))_7i2{a)aqriFcLi_qcTqr0iTqqTirmi7qiTfrSLLN.0ciN)q7)0)L2ri77raSrSL0LrTrcT)2T0qc)Sm2iS7-icScL2LhT,QQ)iT2q))1mircaTi)S)Li_T)Tc))_TT77aqrr7Ta)r)SiLTTTerT_N)TZqSqx70SriTScSTN702c_qT0o)S)7m0rimiLcraS)LqTrci)222mx)rrT7T7S_tr=LSL7T)c_0iq_)T27m07_S)i_raLmN)?mc707T_)mim2nr0amrS{i_0_icNqr0T7T)T2Tmi7q_mrmL)Lc.i0_NTmTTam_2i777qi__)S_Lr_7ci2T0a2_qNi7r2SciirqLTNcGLcN00Ti))77m0mLarL7S0S*LSj_qm0qTc)Nim2mr0LT_r*qNw_U47qr02TLamqmiNSN_mimSmL__a)rN20L7m)maTi2ST_rirSr_0_L)-NiTN7r)raqiiS_L_cTST_T;icq2m0a)iqTm07i7rKTr_Lq0(TcTrNmmfTZqZm27N_TrTLcLit7z)N_T022qTmcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cS!atLN_T2)c7)2_maamL)r&LS_2c)cc0iT_7maiaSmLS0iq?SciN)v_TiNu)))q2iicmiaqiTS0LTTTwTcaNiT_mS22mT7ci0MrSr_7K0NccST2)im_2r77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_NaTm7Yq_2rm7ai}Tr_Lq0-_sTa)_2SaTqTmT7iaq mSqLc_N)mNqq0m0mQakiarr_mrmSc0T__cqqZqL0am_qrST7TiTriSq0mhmN)N_TST720m2rdL0L)rq^iLLT))0)ST2m0qmmSmLi0L7SqSa_ic0cSqcTi)q2Tic7ri7r0LcSS42ciT_0r)7q0mc2La2ii_cSLLN90ciN)q7)0)L2ri7a0a^iSS_0m/mN)N_TST720m2iiamr)r_LSLac0N2)ST2)Nq>rm72aNiGcmL2_TWcN02rT2)LimirrT7IsmrmLm__xaqr02TLamariTm?_mimSmL__a)rNa0)Tqar2ai2S2LrHTlLNqTrcrN)mm)0qarTmTr(LLcTST_T9icq2mTmq)q_mSm7i0r2HDN0N)oqTiNLm)707Sm2r0amrSrL_0N7cqca0i)0)Sacmi7qiT_cSr_7G0NccST2)im_2r77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNiQ_SL2_T^cN02rTrq7207cmSi2ri__LrH7c00cNL)2qiacmNr2aascX_c7D00_NTT7Taq_a)m_7aimlPS_Lr_7ci2TTTqcqim7m)a_r0_2LT;ceiN7NqT_q0772ai_aN_7F2cc_i02crTcTNq27Sm27NaVnmS2LN_z)mN20NTQam22mN7d_mr2STLcA0)rN20L7m7Ta_2qriiqQ r/L/+2cN2T0q)2)Z2_727m_briLN0roa%q)i2TmSiT2T7TaiiqcmSs_cccN2NZmP)m7imma)a_rSrm_0>20SN00a7T)rir2r7ri0iLc-LqNiALq)202Sq22Tmca0_rrrL7_0ccRS02Ti2_qTa7mar_iiS7Sq__0)c_NaTmm)2N2q72a_i7_SL2_NM>TSN1Tcqc222IS/aL_rSaNT8)Trcr2TT27r2qrT7LLrrTcTS_0rciqTTcmr)SiTm7rSiqrcSN0moqT0qT2rmma?25m7Lri2rLNmNa0TT20NmrTrqrm0mLLRiiSNNr_a0m))2r0r)r202LSvaLLi^rc)LSMsN00TT_am2qiNS2L2jrSrL)Tmc0NamTmqm(2aST7TiTriSq0mP0ca2T2T2UqarTmTaTiirqNm_0uaqT0NqLm07Armmmami_raNrLLn_cm02T_T/imm07a_T_NiLc0_L)mcm0mT_)airmrSra7_XSSNiNScacL0_)2qca)m_7aim_)SLci0_TL)700TL)r2imrLrarrNS0_20)c_Nr07)iiTmNi_L0_N_SL2_Nwoqm02TT)c20rr72aLtmSqSNN2TqqrNrTrq0qLr#7La7iacdL_NiTa)72m2F72i1m877_rr2SL0m07fN)2TN7r)r2r707L_:r)li_Tc)?_0i2c)LqNm07ia)L7S0SL_r07N))_Tmq722m_r)iNiqS2L__70SN20NTEmS22mT7ci0QrScc2_(NcciT22Sq22Nm-Lmi2rNSz0m=2cTNcT07rq22LSmSrLN_2LN0r_rcr000L79qrai72S)i_rrS7_i)Tc_0qm^)L7ia_r__TiTSTLi_q)mc2q0TcmS22mT7ci0srS_c2_qTcNi0q)Tar2imqaT_rriSq_TTrca)2TN7c7_rT707LircTSac_gN)7q22c)i722racaNr2_SL2_TXcN02rT2)LimmqmNS2_2crSr_rc0cL2OTL)7qarR7rSi_762Nm0NTaq=0 T7ar22mLLmiq_Ncc0m_mcmN_0a7rq22LrEamr)r_LSL7c0N2)iq_)i272T7_L2aBr1L2_N)Tca)_TN77a2ic7iami)S2N6_q0iN2T)TNqiacmi7qiT_cSLLN>0ciN)q7)0)L2ri77SS_riL7L)h_cr070S)_702#7Sacr0srSL0TVr)mNSmcm_amm0ac7Lr2o_N0_N02ca2c2_m720a_7Ti7iaS_c){NwqN20_T7mS22mN74SSr2STLcv0)rN20Lm8qmm)m_aSa7S0L2ciN_ci070T)_a2q&mUa2iNcTSac_AN)7q22c)iqm2)72L=iq_iL2W)?NNiqcTi)q2Tic7iaqrTcrLi_qcTqr0iTm))22rZ7iiN-rSacq0m)rcr0r)0)Li(mLriLr_)rSLd50cTN_mm)q7Ni2r2Lrirr)Nm_0xaqT0Nq-mSiT2T7TaiiqcmL0_a)TNN)L2JaTqTmT7iaqZmS0LaTTcNTL20m0amqmmm7_aaYrSaL)_q)rNiq2m)7)iTirrk_rrrS)0m%0ca2TTN0L70i0Sm7mimr_Sa0r3_T2Nq2c)LqNm07ia)L7S0SL_r07c0)_0Sm72q2a7ii0iSXcLi_qcT)c0iTm))22rDa0Siia,)L__acmqy0_Tr)72iST7(S_riu7_0_Lcr2TT0TO)S2_Sma0iacTLNcL00T_2m0m)mq_2aSra2iLcmcaNTOLqmNmTm)_qarr7aa)iqcrLiN2TT)a2T2_7cirmr7)_mr0Sa0T00_L)00L7m)m2mm_7a_rrao2Ni0aT)0N0q)2q_27iSa2iNrt,S_mTmc)qrT77277mqmaair0rScc_i;qNTqcTi)mq)m2SMa:_prSNT{cT_)c0iTqqTirmi7ma)r2c3Li=N)r)hqm2iqqiW2f7(i2rNNT_N_S-L2TT02_7_arrrSTLacTLTLSTlci0NmrmS7mmNSr7rirS0SL0&*)Ti0T))T_2iic7LaNr0SiL)N7c0cL0r27q)7_mma7i2r_>)_N_qc2N_072Sq22Nm5rSi2rTSc_0TrcS)20%qcq_m2iSa2iNr3Nm_2^NcX2mT2)Nqvrm7qS0iL3Sci0?U_ca0mm=)q7i2LS)L0LSS2c0_mcScLT027q0qz2S7__mrq=0NTNSX)Nm0iTrq2i>mLraL___NT_T_S)lNiTN7rqaaqiiSm_Yi?S}_2sNqTN_Tq7v7Lari_aanTrTLT_iXqqm00TaaTacaL7a_TiTSTLi_q)mNmT)T)qi7_m0r7i0iBrSL_Tmcq)022mq7c2imqaT_rriSmL)D2)ZNiTN7rqaaqr2LrarrrL0LLT;cN000r)i202TSra2iLcmLqLN02)T2r0r)r202LSva)LiST_)^Nci)c0LTNq02im)r7i0iLSrc7_i0_c*T7T&2cmc72aiLciiSqLT+0cT2T0TTa)i2_iSa2iTrcL00rncT2N,)c)L22aS72aNigcmL2_NR^qm02TT)c20rr72aLymSqcN00)mcm0mT_)airm27L_mrqW0c20))rcr0r)0)LidmTriim_)S_Lr_7ci2TT72_)La7707LircTL0LZ_Sc_2mT0)aiTi2i_S0iLcmSm_mV_ca2rTLm2q)ic7iami)S2Nh_r0iN2q)T_)a2mr!7_aarmc6L__acmq?0L2iqqi)r0Lmi2rNS10m_LT0Nq2Smi7)2_ii7Ar)rqLiNcOicq0Tmr)iqqmTSraiiqSTNrLi8qcT00TTaTqT2amia_LSS2LT_cc0qr0TT)q)2imTLTarL_Sr_7v0NccrT2)i7c22mLLmatxYrOLKW2cN2T0a2_qNi7r2SciirmS)_2T9cW0ST2q)qcmi7_S0im_SSLN09_NSNa)0m7202L7rS7r0rLLrTTc0cL0r7Tq0qB2S7__mr0Sa0T1N0d)mqi7m)m2mm_7a_rr2SL0m0TTS)mqi)qa*q?m6a2iNcTLNLS_LqTNaq_m_7LirrqS2,TSTSS0}biNN2r2mmS)aa_7a_TiTSTLi_q)mNmT)T_qSq770a2Sir2L)LNUiT_NrT7)02cqr72aiLcrLSN_0Uic))7T0TLqra77TiciiS7S)__c0T20T)c)i272q7_i0_)S0_cLrc2TS0a0L)_22mcr)a_iaSmc)__drc70i7TqTmcmia7a)r_L0c2fTNcNiT7Tqq_m0r)a0rcirL2cSH2cNNMmm)2qT2c70Lri2rLNm_q0NTr)_mrTrqrm0mLLMiiSNNrNm0Lea)_TaaTqTmT7iaq<mraLi_Tc0NiNr7T)_2qrAriLmaL>0LLTmZmNm0_Taar2Tm)a)iirTNT_0N_ci070))_qrm770a_L0rvLS_2c0)r0T)c)ia7i27_L2rNrqL2__*7TS02TN)V7S2O7cicr2rZNQ__0iN2T)TcqiacmT7)i)riST0T_a0_NrT7)0q_a)mL77aa<YS_ci^2))q02r)7a42Xm7Lrim+qLTc2zmZSNcTm)a2ZibmLLTiWSSL230TiN0NLTrm7q02LmraiircrSr_N 0N2q)T_)rq7miLTariSSS_0_r)rNiq2)02cqS72rSa%rcLc_2_y)jNqqi)m2)2_7iSciar)Sq0r3iT200mcm_amm)Srari)cmLT0ND6T00T07TS2TmqarLria*/Lr&7c0N_22T_)a2mi)7_aarmc(L__rW7NimT)T2c2i777)i_S0L7_Tccci070q)_20m2iiamr)r_LSLmc0N2)ST2)NqIrm72aNiIcmL2_NPYqm02TN)simm27Tacr0crL2_L)mNqqNm07marrymXaxr2SN0T__cqq620mm72aTmLLmamrmS_LaTrc2NLmmmi7Variaaq_3iQSX_2RNqTN_Tq7-qLaai_S__TJqNrLr:rN0NLm<)N202r7ii0iTcrL2_L)m)iq52Lmr2qrzm!a>r2SN0TATNcNiT7T)q_m0i2aTrcriL7Lqy_N0q)TTqcqim7mTa_r0_7LqLaUiN0NS2c)iqqmTrcaTi)S)Li_T)TNNqwTmm72N2SmL_Ti7__c=0mT)qr0rT)am20maLTL2L5Sc0T_TcTNi0q7mq02ar2SqSR_0S)0m_mcmN_0a7rqa2)mqLrar_2c)NaTTTiq0mr)rq)rm70aa&Tr7AtNS)TcT0TTi)qimmma)a_rSr7_0V20iNmT)T_qSqa70a2SSiLs0Lq0STi))0_2i)Jm)mqaiLcrLSN_0uic))7T0TLqra77Nr_iiS7S)__jrN70NT_7mqai}7mLTiLzSci0TU_NSNa)07ia_mamLa_r2Scc)__!aNmq)T_)rq7miLTiNL_Si_7_)c_NrT7)Nq_immaS6im,TSLNS0i)TN_TSTa20iir_a2iNrxNm_2^Tcc00mr)2qLiir77NL2r7NrLr+rN0NLmD)N202r7ii0iTcrL2_L)m)iNN22)7ir2r7ri0iLcFL%PSc20)0c)iq_a0m#aSi2S)SN_i}_N)N_TSTm20m2iS7LL0rqcSNi0)c_)i0!q)qqmircaLiNS0Li_)07N0NLTrm72Na_7ii7i)S_c)_r0iNmT)T_qSqa70a2SSrmL)LL0STi00q2TU7c2r77aNi__0Sr_S?2N)cGTi)_7)2qii7L_){0vS_200cm0S0Lq07720mL7riirrNrLr;Nc0022))_qr277i_TrN__Lip7z)N_q)Trmi2m7)7_iSiaL0_2NScm0)0LmS7im0i27FLcrrL7_N>_T0NrTS)22)qf7ia_L)rq5iLLT))0)ST2m0qmmSmLi0L7S0SL_r)TN0NLTraT202L7r_Ti0rLSr_i#rqrNrTN)022i)7_ari7Si0T+TNcNiT7T)q_m0i2aTrcriL7Lqz_N0q)TTqcqim7mTa_r0_7L0LL#rqT000BTSq_rm70aasT92crN20mTi0qmDTFqAm27N_Ti_SqNX_L0a)iq:2Lamqmmm7_aafrrLL__mc2N_NE7mq02aSTaN7L_0c0Nm00)^cP0j)2qNrTm_aq_mrfLS_2c)cc0iT_TN72m0ac7rr2._Sm_m#_ca2rTNm2qarcr_S7r0r+SS__)mcLq0T_qSqa70r7i0iLSrc7WqoaNiT0TS7c2imqaTLcrrL7_0ccAS02Ti2_q_m770icaLS2LiNc_icqNTT0)TiT2Tma7ii__SL2_T:cN02rT2)Ladmma)a_rSr7_0{2_aT_0i)7)T2_r2m{aer2SN0T_a0_NN27m27c2imm7)i2teSqciu2N)NNTimcqi2q7TSciirqLT0rVicmN)T27fq*mS72i)icSiL_N01)NS02)))N2im_r)a_iaSmNg__MaNm29T_)rq7miLTa_rqcpLLNr0_)_2Tmqarqrmra0aL/gSi_NTrT2)rqr2_qarTmTaTiirqNmLaticT00TiTriT2_7qL}iL_aciN5T0qmNmTm)_qarr7aa)iqcrLiN2c00cNS)27r227)7NiirmSc0TATNcNiT22i)L22mmrSi2rNSFcS.ahLN_T2)c7)2_maamL)rMLS_2c)cc0iT_q)q9mS72i)iNSiL_d002NTTcTiq7qTm_a0S7i0rLSr_i:rqrNrTN)022i)7_ari7Si0TQNdScLmT)0m_2i777)i_UTS__S_aN0NH077rqrm770a_L0rqS_L!0)c_NaTmm)q_2a7mL<i_rrS7_i)Tc_0qmn)L7riirESlUmrmLm__Raqr0r)7q0mc2Sa2iiL_rINrI7NcNiT7Tqq_m0rm7ai0rTcm_2T0T)N_0rT7qirTm_aq_drL ic_0_)TqTmrTrqrm0mLLGimr7L7__^mqm0T2))Lq72aShaLLiJrNTN_)mNm0c7T)_2qrp7LSrL_^L0T_TcTNi0q7mq02aSTaNSL_9NTLTUTciNqmm)0qarT7NrLLgcTST_Tzicq2mTq)cqNrmmmS0_0HNcvNi0Sqm0mTcaTq_mqS?aLaa__cLTT.TNT0iTqam2m7)7_iSi7L0_2NiZS0)0_)S)am072rSaL_0SqNS0iT)N_qiTR2)2q7iSciLrNL0_i4)T7000L)r77mTacair7r)L_=002NTTcTiq7qqm_a0S7ia__LN07T2)c0i22)rmcmNa2SSrarLL_p2cc))0_Taqma)m_7ra7riNT_Tccci070))_20a27TiciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TN)himm27Tacr0crLr;7c00cNS)2qi7_mca7i0ScrL_2biTcNNq2Taaca_i7a0S_rTL7LaR_T)N_0a)maH2_mr77iicTS__qT&T?)aTq7&)G2/72aN?TrbG__ic7c)0_Trq7qsm_r0aDrSST_00rcT0c0mm7722_r27qSiiLc)N0NSc2)00m)S)Lm0i7a0aviSS_0mK0ca2T200L702LSm7mimr_Sa0rErN700)cTS22miacair7rqL_H002NTTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2STLcw0)rNNq2)02cqL72rSi2rNSj0ms2cNN-mm)2qN2pSma2iNrjNm_2yTcc00mr)Tq)m)7iaTGTS2cM_qTmN)qITT7mq7iF7mLmrN4cLT_)c)Ni0T7T)a7_iQr7acrTS2LmV0)rNNqqmi7iidm577_rr2SL0m0aTTNqmmTmqm2_maLri2rLNmNm0NT2NamrTrqrm0mLL1iiSNNr_N_qTiqrmlTdqMm27N_TiqS2S&__c2cm2ITiqNiriSrmaa:rrrLrP0MLqH0L2iqmm)m)aiLcraS)LqTrci)2227cqcimmriciSS2LTLST,cL)iTq7NaqmTacair2_SL2_N 4TS0a0L)_22mcr)a_iaSmc)_r0ic9T))0qiac2i7qaTr0ST0T_TGaci0_2Sq22Tmca0_rrm92Lrccc_02qS)2qN21Sma2iTrcL00rI2cL2m2amT722aSr7rirS0SL0!,NN0NrTiq0qTrr72aL,mrLcTNL)mcm0mT_)airmra7ayr_u0LLNScacL0_)2qca)m_7aim_)Sqci0_TL)700TL)r2imrLrarrNS0_20)c_Nr07)iiT2ai_L0_N_SL2_NpWqm02TN)pimm27Tacr0crL2_L)mcLqTm0amqmmm7_aa3rS_c2_)TcNqq2Tq7c2Si27TLcriSmL)f2);NiTN7rqNa2iiSa_%isS?_2gNqTN7q_)T272L7_S)i_rrS7_i)Tcr)_Tim7202L7r_Tr0rLLrTTc0cL0r7T)a7_mNS7L2grSiLqDT)rNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2mm)a2_yriLN0r02T_)aq_)aiT2T7TaiiqcmL0_a)TT_q72T)Lim2m7ma_iacrL2_L)mNqqN2i7mir2r7ri0iLcjLN+0/rNiT0TTar22mLLmL0_rAm_NTrfrNrT0TLa/2mm7a7i_rmNmLL00c_0S07q0qtmSmLi0L2ST_c_Nc2)Z0Nmm)dar2LS)L0_rS2_)_Nciq022)N)q22m_77SSr2SNLyNSKDNcTc)2)>iOmNSram3TS)cS<qccNNmm)q70iTrrSi_,rvS70r92cL2mTqmN72iiriL*a4r9L2_N)Tcq020f)_222mSGairNcrLaLq0i)i2Y0B)K22mNLTaqL_Si_7_)c_))Tc2i)ai)m2SiLi_)SLL7_a)<N_qiTaaTmcSmamiccTSTc_h)N7002_TL22aS7mi)i_Sij_Lr07N0NLTrm7qaa_7NL7_2!cLiN2%r0c0N)2mS2a2L7_i2rcI)L__acm))0N2iq2m)mcaiLcrcE2_Tcc}L02qS)qqc2NSma2L0rNcSNiTTNc2mTm)ciT2grLarS_rMS)L79BNNTmmm))armma)a_ric0Li_qcT)cNiTq)T20mTLTaTiariL_NSc2NT0c)0arqLi2a0rciSL2cSu7T0NN2ST_a0i0iSaqicrNNm_200cNqrT773qK27Sr7rL2rS_c_iT2cq0_2))>2Sm2a0S2iThcLi_qcT)c0N22)aici_r7i0L_ST_7_ac_))0_TaqmiVm_7aimEbr_La_mc2NmmmTm)Lq_70SciirmS)_2TIcmN7T7)_qmrmmLS0i_SSS7^0Q%NSNL)0m22T7c7Ni2_<SNNm_oTrcL2)m07r227)7Nii%0c2L__acmqe0_Tr)72iST7_iqtYkiN2LLT0NLmmTmqm2_maLraLr_Sm_2y_Dh2mT0)aiTmNiLS2_NcmSm_ml_ca2rTT))2)mi7T_Tirn5Lc0mcN)ENrmm)%acmT7)i)riST0T_a0_)wq7TcqT22mma0_rrNIqNi0i)ZN%077rq22LSm7LLN_2c)0r_rcr000L7kqimNSrSrLq_iSL0}_Mc<02TNaTq_mqS-LTLr__LNTTOTNT0iTqamqami7Ti0rirr0T__cqqo0q2r7mi42>74i2rNNTLTN_cT07TN)_7)mNmqa2i_r7sS_25Ncp)STTm0qmmSmSi0L7r0SLLr}icr2r0r)Nq0m2r)a_irr7LiTTITT_0T)7qN2_i)7_aarmc(L__rF7NimTT_qqi^rcrrS_rNNTLTsTciNqmmTaqi2T70aiarcTS__qT!T_caq_)NiT2T7TaiiqcmSLN0T2)qqcTL)N20mi7)S7r0rLLrN7cTqT0mmm)Ti0i)m_aaimS2LmTm(mcLN_)07c2imm7)i2U.S6N<(T)Tcy2_mcqi2q7TLriirqLT0r}icmN)T27=qimNSraNLq_ici0>_zc{02TNaTq_mqS*L0aa__LNTT;TNT0iTqam2qi07NSSr2STLco0)rNcq2T)7c2imqaT_rriSmL)#2)jNmqi)27)2_maam_hr_Sa_mT<cq)i0L7)a0rm72aNiAcmLaLL:_N20c2))_qammr)ami7S7L__m)mcEq0T_qSq770r7ariSSS_0_r)rcLq20ST_a)mL77aaseS_ci0i)T2c007rqr2)Sm7dicScL2LlT3c_)i02q)q_mircaai)rqNr_N02)mqKmS)_immm7c_TirrSLSH0Zrqr0N22q0mcmNa2SSioSc_cn2o<q,0c2i)Lm)r0aiLcrTS)_)+icT2TT02_qNm7rqa_L)riLN0r_ST2)iTm7<202a7mLAi__a1__T)TcT0TTi)qim2aa)a_ri__SS47c0N_q)TqqSai70r2aq_cSiLqxTTcNi0q)T7c2imqaTLciiSqLTz0cT2T0TTa)i2_iSa2iTrcL00rkTc)0)Ti)TiT2rr1ac_mr!cELrTmNNqcTT))2)mi7T_Tia__cpN7lcNT02Tmq0irmNrqLi_icMLF_7)rN20L7m)LaNi2S)_rirSr_0_L)HNiTN7r7raqii7L_zi(SM_2%NqTN_Tq7naTari_aNuTrTLT_i(qqmNaTi)T20mimr_Ti_SqN%_q0r)m2?0&)Z22mNLTaTL_ST_7_dc_))TNTqq22_m7rSi2rNSocS!qT0NmTSTS20a7m07LarriSr0r_rcNN0T2m)q_2rm7ai,TrT?__Tc7c.0_2))_qammS3a_irr7LiTTE_Nq2;mcmr7_mNLTaTrTSiLqTmAaNi0T)0qiqrST7_iqh#f_SaN_cN2T0T)Tqi2qSm7LL0Z2cqNclLcN00Ti))77m0mLarL7STNT_aTmcT202)T_qa2m72amdmrmSLL_c0)c0iTm))22rW7{L3rqcTS(0_TcNi0q)Tar2imqaT_rriSmL)-2);NiTN7rqNaqiiSi_6i*SG_2ONqTN_Tq7ya0qai_aNGTrTLT_iFqqm0T20)N7Sm27Tacr0crLcN2w))c0iTqqTirmi7ma)r2c*LmNic2))0_Taqmidm_7aimh!Sqci_L))q0mm)2qN24Sma2iNr4Nm_2dNc&2mT2)Tqcm0Sra2iLcmLqNT02T_q)m!Thqpm27N_Ti_SqNhNiTTTAq0TLamqmmm7_aa.rSaL)_q)rNNq2m27aiTi_S0_rrrS)0m80ca2TTN0L70airNLrarrrL0LLT>cW0ST2q)qcmi7_Lm_i_SLaLLt_N20c2))_qammr)aurSS2_)_cciN_q0T}qS227)7Niir_ciL_QS#m00q7)q)a2i707SLcriSq_T0cciNm0))2aM2:7Sa2r)rcLi__Tm)i)ST2)Nq/rm72aTicS0Nr_2sLqm0q2Tm27_iTSw7}ibS2LNTTlrcS0S)0)rirmTr2i0ScrS_2NS/RNcTc)2)-i}mcriaci0%7_N_S,L2TT02_7_imS)72_XrGS70rFTc)0)Ti)TiTm0i_7ir7S0L_N)oLc7Nam1)q7iirST_cr0crLr_))mcX0c)cq2qyr%7_Sir2L)LqAiTcNT0)))qi2TST7qS_riL7N2F_T)Nm07)7q_2mSm7LL0r_LSNac0T7N_Tq7bqNaii_areTS2SL_r)Tca)L20)mim2m7ma_iacrSS&7VaN_q0TNqSqL70r7i0Sc9__2Ni37))0_Taqma)m_7aim_)S_LaWmT)N_0rT7qirTm_aq_^_ic0c!:aqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qmAmi7_af7a_TiTSTLi_q)mNq0cTNam2qi0STLr_mc<L!_7)rN20L7mqqaNi2Sq_rirSr_0_L)<NiTN7rqaamiiSa_EiQSP_2UNqT0T)c)i272)7_i0L2ST_c_ic7cq0_)0q7207cmri2ri+cLNN2Waqcq_27q07_mTa7aar_+)L__ru7NimTT_qqiemLraS__LNTLTgTciNqmm)qqc2NSmaTL0_*c2NJ07T_2mTm)ciT2_7qL iL_rcm0*_%c+02TNaT2T7c7ii7i)S__0N2cT0c0i)7)q2_70a7i0Scrr_2<iTcNNq2Taaca_i7a0S_rTL7Lav_T)0N0q)2q_27iSa2iNrl,S_0 a)r0T)c)i272)7_i0L2_iLm8)?_NSNm)0q2a_2m7ma_iacrLNN2waqcq_27q0q%2S7__miL40L_wSya00q7)0)L2ri7aqaariL0LS0cciNqTTmcqi2mm)a2_(riLN0TxrN700)cTS22mii_S0ivSSL2X)_{Ni0_m2ThqFm27N_Tia__LN07T2)c0iTm))22rj7qSir2L)LNZiTcNi0q)T7c2imqaT_rriSq_TTrciNm0))2ad2i7NLria_qciNiT{uAN,T2)NiT2q727Xi_S2Sm0QhiNN2r2UTq7imqSW7#i,S2LNTTcT0c0i)7))2_70r2i2ScSi_7_qc_00q7Tam_2Nr7S2Lcril2LrcccN02qS)a)L2_72acL)r_Sa_m0)cM0ST2q)qcmi7_S0i.SSL2!)&NNi0_)))_2S2ma0i2LSrLc0_qTS)iq)T_miq.7)7qii_criLq_Tc0NTmTTT)aqim_rSi2rTSc_0Trcr07T0qc)Sm27ir_i_S7L0xc_LN20i2c)N722aScS_L7S0M__Tc7ca0_2))_qammSQa_iaSmN?__?aNm2s)N)q22m_77SSr2SNLDNSb/NcTc)2)<ipmLSriT_)SLciB2N)NcTimcqma27TiciiS7Sq__c0T70T)c)aa7i27_S0ir_SLm^)hLNi)_Tmq7207cmri2riKcLNN2waqcq_27q07_mTa7aar_Z)LU05c20)0c)i7x2i777qi_42E7LaN_cNq722mcqia2mriciNS2sS_q00c_0S07q0q}mS7qi0_rrLNT_rTmNN2c2_7m207cmLi2__c0LNN2daqcq_27q07_mTa7aar_A)LkpSc20)0c)iq_a0m)aSi2S)SN_iF_T)NqqiTLa)i0iSa2L0rmLSLLc0T70Nq_)i272)7_S)ir_iLmX)E_NSNa)0q27Smma)aL_S.i_0N2wz)c0r)7qN2_i07riSr2L)SjJic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TN2_qim7m)a_irS7LN__Tmck0STq7)a0miS07iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crLT_)c)Ni0T7TqNaDmmr7iNL_Si_7_)c_))0r2iqmm)m_aSaaS0L2cSumN)NL2Smi20a2m*ScirS7LN__00cr0ST2q))3mi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTcTLiF7})N_2TT_qSqa70SiSSiLI0Lq0STi))0_2i)5m)mqaiLcra(2_0ccMS02TTqcqam2rZaN_mrEcr_qT))0qrT2q)qNmiS0L2iq_iSL0)T0TS0220)m2S2La0S7rTLcLi976)N_T022)7mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cSYqT0N_TST720a7mBr_irS7L0Ec_LN20i2c)r27mNScS_r2_iLTN)>>NS0q)0m2qn7c7ii7iTS__0N7JaT_0Nm772acmir2arScSN_2NScq)00_)S)7m0mWaSiqS0cr_Tcccaq722)_a22_maam_8r_Sa_mT9c_NaTm7Qq_2a7mL&i_raLm0yO_ca0mmg)_qr277i_Ti_SqNH_L0a)iqL2iamqmmm7_aaWrS2LLTmTi)Sqi2rm_2aST7TiTriSq0m30ca2TTN2;70i0rTS7_#i4Ss_2pNqTN_Tq7sa0iTriSNiLcmSm_mR_ca2rT2)LimiirrLTaa__LaTTGTNT0iTqamq-mcaci2i=cILL0rcT))0LT7)ai.m)riLrDTc00m&mcc2T0_)qaI2)iaS_LLcTST_TFicq2mTq)cqNrm7iS0_N:NcgNm0Lqm0mTcaTq_mqSBa)LrEiNxLuMpN20N7TqTmcmia7a)r_L0c29TNcNiT7Tqq_m077a0rcirL2_i0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNi%_SLqN0A_NSN7)0m7q=a_7ri7r0LcSL?2ci)c0r)7qNici_a2SirT )L/hScq00q2Tg2c2i777Ti_S0D7_q_aci000Smcqi2q7TSciirmS)_2TRcL)iT2q)qcmircamL2ST_c_ic7cq0_)0m72T7c7aL7_2S_c0_r0SNmT)TLqi7_mma7i0Scrr_2liTcNi0q)Tar2imqaT_rriSmL)32)yNm07)7q_2mSm7LL0r_LSL7c0cU0S0Lq072mTacaNr2eYLN0mzJ)rNLm)70arm2a)aNric0N2__^aNm2.T_)rq7miLTa_rqctLLNaTi)r207m)m2mm_7a_rr2SL0mIqTN)222mm7ArTmTaTiirqNm_qfccN2m0Lm0a0iqrHSiLLcmLm_c)Tc_0qmK70aTiamNS2rNcrSr_rc0cL2 T#qS227)7ciir_ 0NrM0NccLT20am_a=rirSiaiLS__2lcT)N_0a)m7)2mm7a7i_rmNmLL00c_0S07q0qm2777a_imcmSaN0_7NTTcTNq2a*mNSmal_rrLN)00TrN2T)TNqii0r2m2SSiESc_cM2Z{q*0c2i7ra)mL77aa3kS_ci_L)TN_TSTm202Bm7LraS_2S)0c0_T70T)c)i22aimai)icSicc_i qNT2rTL)N20mi7)S7r0rLLrN7c0cxNST_am2m7)7_iSi7L0_2Ni)TNiT7Tqq_qNi2Sm_0_)S_Lafm)HN_0rT7qirTmr7SiSS0Sr0r_ST200)cTS222rmSaSr0rrNrLL02(S0m)))c2irT7qLrrT/HSS07T2):0i)7)q2_r2Si7i_cSTL)1)ciNTmTTam_aZi7aNaSiLNT_0N_:SqmT0qc)rm27T7S_grq,iLLT))0)STmq)q_mii_7Lr7raL_N)g_ca0mm1)_qammSKa_iaSmNy__Yrc70i7T)_2qr/S0LT_2vTLLTmfmNm0_Taar22mLLmiq_Nc0NT0q)<cZ01)2qNrTm_aq_orL.ac_0_T4q0mrTrqrm0mLLEiNS0Sr_ic0cT2rT2)LimmqmNS2_2-mcmTTYTNT0iTqam20maLTaaiSrr0TMTNcNiT7T)q_m02?7?i2rNNTLaN_cNq722mcqi2mm)a2_UrqOi_2c)cN0i2c)iqqmTrcaLiNS0Li_)07N0NLTrm7qr2S7Si0ircrLSN2c70c0i)7)q2_70r7ariSSS_0_r)rNqq7Tr)S2S707r_rraf2SSL_T)Naqi)TaN2)mT7qa_iaS__mNT)rcSN_7T)7m77Sa2iqSTL2Lm02NNN2TNqcqTm07caq_1rLNT__T_c10c)cq2q!rl7_SirqL)L_xiTccL0_TT)2qLmqLmi2S)c0_iccci072q)_20a7707Lir4mL7_SBNc_NcT0)Nqpm0mTS0iLr0SL_S_jc_NSTN7r2TiG7iLmiac0LT_)c)Ni0T7Tq07_maa7i0r_Si_702c_0)0_)S7am072riaL_)S_LagmT)c22_mcqa2)mqLraS_2c2NuMiN7NTT_)rq)rmmLS0iq9SciN)^mc707T_)mimm2r0amrSrL_0N7Q_Nq2jT_qS22mia2SiL_{Sc_TmnmNm0_Taar2a777)L___L2ci_ccrqmT0qc)Lm22iSciirmS)_2T6cL0S0770a0mii_7)i)!rL2f)bNNic_2))_qammr)7_rSc7Si07T2N_q0TLmS22mN7{SSrmL)L_%Se700T22i)rim7cSriNeTL0N_0cJiNq0T)0qTrTmT7aair_.S_2hTcc00mr)2qLrmmLacaGcmLmU)&_NSN7)0q2qTmT7iaq^mrLc0_qTS)iq)T_)rq7miLTaaL_Si_7_qc_))0_Taqma)m_7aimKyS_Lr_7ci2T0rTSqSm0mrLria_7LNLS_LqTNTq_m^amiNSrari)cmL0_a)TcT)L207cim2m7ma_iacrL2_L)mcmqN2Famqmmm7_aa3rS2LLTmhm)Nqj7m)m2mm_7a_riLS_LmE2c_c%mm)0qarTmTrLLicTST_TAicq2mTqm0q_mSm7i0iBSSLq{002NTTcTaq2a+mNSma^_rSqN)00TrN2T)TNqii0r2aNaqr2S_L7NSc2NN0^2Sqmm)m_aSa7S0L2cidmN)N_TSTa20m2iS7LL0rqcSNi0)c_)i0Uq)qqmirc7iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crLaN2c00cNS)2qTmcmaa2SirmL)LL=i)TNq2r)T782ar7S2LEriL7LqG_)2qiT0TLqrrT707!aSr_Nm_0ZaqTNTq_m07*rmmmami_raNr_rc7N0Tc0Sq22ia_7ri7r0LcSLY2ci)c0N22)aici_r7i0L_ST_7_ac_))0_Tr)72iSTaTrcriL7L)l_N0)2TTqcqim7mqa_r0_7Sac_>N)7q22c)i722racaNr2_SL2_Nthqm02TN) imm27Tacr0crL2_L)mcmqTm0amqmmm7_aa1rSr_7/0NccST2)im_2c77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_Nr07)iiT2_7qLQ_T_r:_Lr)TcT0TTi)qim2a7iaTr0SiSrTTG_Nq2F0VmaairXm*atr2SN0T=TNcNiT7T)q_m0i277rcriL7Lqf_N0)70a2_qNi7r2Scii_2SrPc%NN2)STaTLq_m27cS)i_raLmN)p{NS02)))c2im_r0a)rSS2_)_NciN_q)TqmiqLr)S0SSr2n0LmQS=L00q7T0)Lqrmi7r_rirSNL0Z2T)N_0rT7qirT7TiciiS7S)__c0T2N7)c)i272q7_i0L7ra/__NT7)2qcTim2qr7c7Ni2LSS2LN_+)mN20NTQam22mN7x_mr2SNLuTmc2NN0(7mq22Tmca0_rr2SL0m0iTrqTqr)qaPq{mea2iNcTSq_2_(c_020m7xqimNSrS_LwoT&D_a)TcT0TTi)qim2{7cicr2rIN/_c0iN2T)TcqiacmT7)i)riST0T_T0_NrT7T)acaL72rSaurcLc_2_y)ZNmqi)m2)2c7iLcar_7LT=c_SN2)i0:m)qimNST7rLq.mN0LrArN0NLmf)i2NrT7TSmLiSm_)_cTS)iT0mi)T2Tmi7q_miLl0L_}SVa00q7)T2cqSr7S)i__0SmcSG2cNN-mm)2qT2c70a0iaPrSrcL00cs0S077)a0miS07rirS0SL0ZpqTi02)))N2iic7ri7i)cccSg20icQq)T_)a2mr6aNaqr2S_L7NSc2NN0/2Sq02aSTaTrcriL7L)%_N0c60/)2qNrTmar_iNP7c2Nc5icmN)T27(qqai72i)iNSicc_i?qNTqc0i)qqTm07T_TiTraSi__0SN20TTcq0irm27L_mrmL)L_wS+700T2TTqT2imqLmaL_0SqNS0iT)N_0rT7qirTmar_iiS7Sq__0)c_NaTmm)q_2a7mLui_raLm0zQ_ca0mmD)_qr277i_Ti_SqNk00T))mqNTLamqmmm7_aaVrS2LLTmTi)S202rqqi12:7&i2rNNTL_Yq)!NLNa2_7_icrqLrarrrL0LLT{cmN7T7)_qmrmm7S0i_SSS7D007crNSTSq0qrrrmrS2r0LcSrX20Sck0c)cq2qHr;7mSii7c)NNTm-/NcTc)2)JiGmcriacrrL7L)z_)mNITST7a)i07iSEirS7Sr__T2 2)STq)cqNrm72S0_0QrSm09*dc72rTrq7qrrc7ii2Lir7_)__ci)c0iTqqTacmT7)i)riST0T_)0_cST7m2q_22mLLma7<tr>LoY2cN2TTTqcqTm2ii77_?rqxi_2c)cN0i2c)iqm2)72Luiq_iSL0)T0TS02TN)k7Sm27Tacr0crLT_)c)Ni0T7TqNafmcr7iNiSrL0T_V0_)Z2mmNar2rm)Lmi0raNTLjNOTS2T0T)Tqi2qSma0iacTS,cx0_qTNTTT)iqqrm7qS0i_SSS7<0uWNS0q)0m22T7c7ai2_HSNNm_:TrNq2)m07r227)7Nii60c2LqNi:Lq)202Sq2a0mmaSaLS0>7_0_HuSN_mm)0qarTrmr-imcTST_T-icq2m0a)iqTm07i7r;Tr_Lq0ATN-a)_TmaTqTmT7iaqGmSm_)__cSc7T0)2mi2i7)7_iSiaL0_2NSyL)00qmS7ia)m_riaBS)Sq_i0ccLNNT0)iq)a7707Lir_7LNc_*iN7N)T_m)q)ai7mi)i_SSSas0c2TS0m)))LaSiia0S2i7=cLrM7cNN_q0T)qS227)mtiir_,)LqNi#Lq)202Sq2a0mmaSaLS0n7L0_L+rNi0r7r)r2Nm0a2L)r_SrL7JiqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m7qaa_7NL7_2tcLiN2<r0c0N)2mS22mN7x_mr2SNL-Tmc2NT0c)0ar22mLLmiT_NJ80m_mcmN_0a7rq22LSmaTLN_2c)0r_rcr000L76qL27maLjia_icaNLTmTBqamf)xq7rr72aL}mu2cT_r)mcm0mT_)airmar2i0ScrS_2NS S)00Z)Sq2m)mNaii__)Sd_S}q))q0Ti2_qca77TiciaS2OiLSc)c_0S0mq022aS7a7Li_S2LcN)p_ca0m2))A2Sm2a)acriS_c0R0cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aqaariL0LS0cciNqTTmcqi2mm)a2_8rLUi_2c)cc0i2c)c72mTacair7rqL_G007NTTcTa77a2m_r0a)LSSm_)_LciT_0c)7q0mc2ra2ii_cSiLqXT)rNi0mT)q2iZmiaN_rrmrqci0r)Pck03)2qNrTmqa2aUr_L2LmTBci0Nmr)m)qair7LFasrWL2_N)TNN)_Tiq7q)m_7ri7rNS_c0_&cSNqT0mr)LiTmrSmiNZc-_Nm10NccLT2m_a02Ni27a_c__d7_0N_cT070a)_7)mNmqa2i_r7#S_2JNcD)STm7mq_mSm7i0_mS0_cLLc2)_qcTNm2qarcr_S7r0__LT>7{aN_q)0_)aqmm27m_mimrLS_x0TcNi0mT)q2i mLrii2S)Sc_itmN)NLTi2_qrm77Na__mrac=_mTTcLqS2i7Tq_mSmai0_i6_SLN0*q)Sqi2))_7i29a)aqrincLi_qcTqr0iTqqTirmi7qiTprSiLqtT)rNi0q)Tar2imm7)i295Si_NTrca)qqimi7LaSSm7mimr_Sa0r_Lc_NmT2)_)Yrm70aa&TSNp>N_Tc)22r0r)r202LSGa-rSS2_)_cciN_T)T_qSqa70a2Sir2L)SlliTcNL0N)0qi2)i7a0aLrrD7Lr_ScS000r7rqaimm%SJi_+mS7Nk1q)m0)2YTram2Sr}a0_mi_cpLdTmN7q8TLm7qTa_r*S7icSTL2_mc0qrNr2q7iairo7Da7jrS2LLTmTm)Tq2TTarqrmra0aLXISi_NTr?r)q207r)r2r707L_uriLN0r_rTqqNmrTrqrm0mLLoan_ic_NL07N0Nf0S)_immma)icri__LqN7c0cL0r7Tq0qn2S7__mr0Sa0T_T_L)0207m)m2mm_7a_riLS_Lmo2c_czmm)0qarTr0mLL0i!NmLmomc_Namr)q7227acaar7S2L_6007NqNaTiq0qSic7iaqrT=cLSN2cN0c0m)2mSq2mNmna_izc?Sn_qM2Niq7)0)gqSm_LmiN_0S)_SFqN)00Ti)_7)2_maam_Yr_Sa_mTnc_Nr07)iiT2_7qLF_0_rSm06_nck02TNaTq_mqS0L0Lr__SrTTpTNT0iTqam2qmc7N_mr2#0N00cT5)7qS7mqm2cST7_iqh}ccca_m)}cJ0J)2qNrT72r_aL_7LqLaEiN0NS2c)iqqmTrcacL2STcc_L}NN00iT)m7202L7rS7r0rBSS__)mcSq0T4mS22mN7-_mr2STLcz0)rN20Lmi7aqNi27T_rirSr_0_L)bNL07Taav2qiiSiLEPm=QNiT4c=N7mr)2qLrmmmSN_TcmSm_m;_ca2rTmm2q)ic7LaNr0SiL)N7c0cL0r27qN7_mir7iqiaSi_0_STcNi0q)T7c2imm7)i2bUSrci_7T)N_0a)maO2_maam_xr_Sa_mTXp9)i0m7)a0rm72aNiwcmSLN0wq)Sqi2))_7i2/a)aqriycSrN2Tm)cN7Tr)_q9miLTaTLLc0N0TmcmNcmTT_qqiOitrrS_irNTLT6TciNqmm)0qarTmTrLL0_LNmLm*mc_Namr)2qLrmmmSN_ccmSm_ms_ca2r0L)_qmm27_7PfmS0LaTT:TTLqa7T)T2Tmi7q_mimY0N20qTcNL0N)0qi2)i7a0aLrr47_TcccS02qi)N7)q_ma7mi2rmNmLm_Lv_002c)iqm2)72L}a._ic_NL07N0NLTraT202kmSa_wmS0LaTT:TTLqL7T)T2Tmi7q_mrqScLNTmc2)020m278aircLmimrcNTL_jq) )_Na2_)rrTmTaTiirqNm_N00c)0STqq)20mi7_S)rNrqL2__p7TS02TN)b7Sm7r0aLrSST_0N7cqca0i)0)Sacmi7qiT_cSiLm_)c2q>Tc2iqqm)mraiLcriSq_TTrciNqTT7rqi2mm)a2_MriLN0r0_Tq)i0m7&)b2P72aN#Tr_Lq000xTrNmmzT+qHm27N_TrNrSSLTTjaT_q_2_7ra)iaLTiTiScBLikN)r)_qqTTarqrmra0aL}kSLciv2T)0N0q)2q_27iSa2iNrVOS_T00cc)STaTLq_m27cS)i_raLmN){_crN7TiaT2Na_7iS7r0rLLrTTc0c%NST_am20maLTaTLLc0NNTm*mNm0_Taar2am)7q_rriP2Nq0q)T)S2)7rqr2)Sma0iacTc)SL00xw2m0m)mq_2aSra_L2rqcc_LZNN00iT)m7202L7rS7i7__LrN7cqca0i)0)Sacmi7qiT_cSiLm_)c2qQ0)2iqma)m_7aimE8S_Latm)4N_0a)ma{q(ii7m_):0Nm_2!NcF2m0Lm0qqiSriS)i__iSYd)UqNiqcT)m2207cmSi2rTLcL)(20iNmT)T7qiiTmra7aSZc.__20_ZL)00qmS7ia)m_ria?S)Sq_i0cIr)22mmc)72rm_7eiicTSTcLT0)02mTm)ciT2_7qLoa!_ac70v_#cD02TNaTq_mqSWSLLr__SrTT^TNT0iTqam20maLTaTL_w0cLTmEmNm0_Taar2r77a)i__0SacSK2cTNcT07r)ra2riSaL)r_Sa_mTQc_Nr07)iiT2_7qLxL__iV_Lr)TcT0TTi)qimm7r0aLrSST_0N7c0c+NST_am2Ni07)iSrqL)_0eic_))0_TaqmiYm_7aimhpS_Lr_7ci2T0_)qa!iNirr_arcTST_TBicq2mT0)aiT2TiLS0_TcmSm_mE_ca2rTa))qqrr7iS2_2!rNTNiTNqr0rT)am20maLTL)aLP0SgTm&mNm0_Taar2_i27qLcrLSN_06ic))7T0TLqra7m7r_ir_7LqLapiN0NS2c)iqqmTrcaiimr)L20?c0TiNa2))_qammSja_irr7LiTT-_Nq20mNTa7_2rLTaTrTSiLqTmlaNi0T)0qiqrST7_iq(}r SaN_T_2T0T)Tqi2qSmaqL0r_RS_a_Lc_02Tcm)q_2a7mS)ir_iS7N)__caNmT2)mim2mmL7_r0McLi_m8)N22pTrmiq7i)7_aarmcJL__acmqA0_Taqmiy2?riamK)c00mp2cNNpmmTL702qrSSiL)r_wiLZc)cq0i2c)rq)rmmaaia!r0Sa_N)TNTTcTiq7q)m_a0a_iaSmNB_q0icL2)m0mS22i07miSiLL0c7_S0_NiT7T)q_a)m2riaci0o7_N_SBL2TT02_7_imS)72_Rr S70r_2T2N0)c)i22aS7qaciNcmL2N0TT)r2702aT2T2SS(aTLir0_)__ci)cTc22)mmci_a2SSraM0LTYSTa00q7T_qqip7)riS_rrNT_2_Lcr2TTq2L7027Sm7mimr_Sa0r90N70qT_m02)mS7ai0L7rm_cN_c2TiN_2))_qammr)a_iaSmc)__eaNmq)TqmiqLr)S0SSr2K0LmkS3L00q7Tam_2i777qi__)r_La_mc2NmmmTm)Lq_70SciirmS)_2T}cmN7T7)_qmrm7qLTirDrLi0Ts))r0NmTqcar2mSTa7_rr0NT_2Trcr2T))7r2ai)mFSi_rI)SS_Bc0NT0_7m)maNr2S2_rrrS)0md0ca2T2T2R70qbSm7mimr_Sa0r62cL2m0mmN7_rmmmami_raNr_2VLqmNm2NmLim2m7ma_iacrSrN2Ti)aq)T_)rq7miLTiTScSS_2NicN))0_Taqmi9m_7ra7riNTL_Pq)^cpNa2_7_rTmTaTiirqNmLasicT00TiTriT2_7qL8L_iaV_Lr)TcT0TTi)qimmNr0a)rSSq_)R0ciN_q))N)q22m_77SSr2SNLUNSc7)00L)SqTm0i770aLirSiLrTr4rNN00)27)2_mr77iicTSLc_6cN70N)c)_22mircaiiqSTNr_iuqNT2rTi)mq)m2S&airNcrc_Nm(TqrNrTrq0qLr57iiN__s_cmNi mqIN T8q22NSTaNaSiLNT_0N_T_)S2rm)77rT7T7S_1riLN0r0STqNTmrTrqrm0mLLQr0_iSaN)cNcq02T_)77Sm27NatLSrSc0_-0SNaNLT_q22ci)7_aarm.)L__r{7NimTT7m_2ri7a0aLrrNT_0_DASN_mm)0qai2rqmLL0i:NmLmEmc_Namr)aq)2qSraNL2k2cr0T0r)22rTr))imm07a_TiT_Lc(TTDTNT0iTqam2Ti07cSSrarLL_/2cc))0_Taqma)mLrii2_)LNLq>2c_N7qS)2qN2fiSa2iTrcL00r,mT2N)2c)iqqmTSraiiqSTNr_igqNT2r0rm2qTrcr__Tr0rLLrTT{aT_0Nm772acmir2arScSN_2NS1m)02T2S))2mmi7ri2Y9r+ca0_T_2TTTTSa;2i7NLrLr_m(iLmTEJ/NRT2)NiT2_7qLvas_a:_Na)TcT0TTi)qimm07a_TiT_LcSTTnTNT0iTqamqami7Ti0rirr0T__cqq;NX2a7qiM2n7>i2rNNTLTN_)0qNqS)a)L2_72acL)r_Sa_m0)ch0ST7q0722Lrc7iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crSrN2Ti)aq)T_)a2mrR7_ari7Si0T__cqqUN42a7aiI257(i2rNNT_N_ShL2TT02_7_i0rrS2LScTLTLSTHci0Nmrmi)qaimmL;a>r%L2_N)TcL)_Tcq72N7c7_i2rivcLL_Nc0Ni0)27q0qLmrr7i)L_Sa_7_!c_))TNTqq22_m7rSi2rNSDcS;2cTNcT07rqSa27NicimS2AS_2<NcV2mT2)Nqyrm72aTicS0Nr_23Lqmqi2Nm2qTrrmrarr0rLNO_icN)_qr2m)Tir2r7ri0iLcxLL_7=aqo0q2i7iairmScLqDwSgL7Trc2NLmmmi7NqWSm7mimr_Sa0rAaT2002c)LqNm07ia)L7S0SL_r07ct)_0Sm72q2a7ii0iSlcLi_qcT)c0iTm))22r>7LSir25)L__acmq10_Tr)72iST7_iqRJrWca0_TL2T0T)Tqi2qSmaqicrNNm_200)NqN2Dm7acrm7mac?Tr_Lq0uTcHa)_0raTqTmT7iaq{mSic0_N0SNaNLT_q22ci)7_aarmH)L)Nicm))TNTqq22_m7rSi2rNS{cSB2cTNcT07rqca27TSciirqLT0r1icq0Tmr)iqqmTSr7rL2rTNcN_)TN0NLTraTqaa_7NL7_2FcLiN2br0c0N)2mS2ci07_iSi7L0LWbScc00q2)T2c2)72S^imS)S7NS0iN0qi0a2_qNi7r2Scii_2Sr4ckNN2)S0mm0aTaSm)amiirrL20{_%Taq_2_aT2T2SSwairNcrSrNqT)qrNrTrq0qLrV7iiN*r#acmNi.mqJN-T.q22NST7_iq-?r*ciN_Ta2T0T)Tqi2qSmamr)ScLic_dqT7000!TSq_rmmmS0_2yqcc_iRqNT2rTi)mq)m2SpairNcrciN20icm2s0,) 22mNLTi)L_Sa_7_Uc_))0_Tr)72iST7LS_rcL7_Nccc_02Timcqi2q7TLriirqLT0rAicmN)T27&qimNSrSLLm_iSm0,_PcF02TNaTq_mqSK7>La__c1TThTNT0iTqam2qmc7N_mr2Q0N00mTo)2qL7mqm2cST7_iqBoccSaN_hr2T0T)Tqi2qSmaiL0rNxS_a_Lc_02Tcm)q_2a7mS)i)_iLmN)cNcq02T_)77Sm27Na{LSS2LT_cc0qr0_22)qacmi7qiTHrSiLm_)c2q!0i)N7_aL2qriam&Ar!L,!2cN2T0q)2)o2_727m_=riLN0r_r?q)i2i7{)l2;72aNuTSNE__i07NqNaTiq0qSic7iaqrT8cLmN2j))cNiTq)T20mTLTaTiariL_NSc2NT0c)0ar2mi27)LcriSq_TTrciNqTT7rqi2q7TLrar_2ST0c0_qT000L)riT2ai_aN_7W2cc_i02crTcTNq27Smm7c_TiqS2SrL_tqcL2xT!qS227)7ciir_SiLqxT)rNNq2Taaca_i7a0S_rTL7Lad_T)N7qi)22)2c7iSca2_2rSS_0)cLN70a7Qq_airiLTXcr0Nr_r-)qmN_20T_2Sm2a0S7rNrSSLTTc0T_qBmma)q_rR7Pa7orrec2_iNcNiT22SqSa0mTaSLiS0U7_qN_=H072q)_7)2i7NLrrc_2Xi_mTFN0NaTm7o2Naai_a)bTrTLT_i%qqmN0))qN2ia_aci7rqS_c)_TcS)iT022T_acmi7qiT_cSiLqBTTcNi0q)T7c2Ni27a_c__57_0N_cT070a)_7)2qiia2r)rNLiNc%icq0Tmr)iqqmTSraiimr)L20M{iNN2rTamma2i7ra_TiTSTLi_q)mN00a7TqN7Li0S0L)_rcVSM_3c2NNmT)N)SqLST7TS__r9_Nr0qTa2TTTTSa;2i7NLriaiqwiNi0ST_2m0m)mq_2aSraTi)S)Li_T)TNNqcTa))qqrrmrS2_mR%ciTTcTcS2wTiqNir2rrmSi_ac1Sy_kc2NNmTT_qqiWrTrramb;r{Lgf2cN2T0_)qaViNiir_arcTST_TXicq2mTmq)q_mSm7i0r2_iSSF)Q_NSNa)0q27S2Lr0aq_SQic)__0icWT)Tqqiacmi7ma)r2cKL-#Sc20)0c)iq_imrirSaL_0SqNS0iT)N_qiT}2)2q7iSciirqLT0rVicmN)T27YqfmS72i)icSiL_N0,)NS02)))N2im_r)aqLirLN)000SN2q0TmqSqL70r7i0iLSr0TV0E+cS0_7mq02aSTSTSLirNTLT,TciNqmm)m2)2_7S77r0S2(iLSc)c_0S0aq022aSmLS0iqFSciN)U_TiNW)))q2iic7iami)S2N^_icNqrqS0qmiqmrvmva(r2SN0TQNWScLmTTum_a_irSrL0_7NT_T_S)(NiTN7r)raqrTLrarrrL0LLTQci0Nmr)Nq)2TSrarr7S0_cLSc2NiNmTm)_qarr7NS2iaccc_N7c0c{NST_amqLi07_iSiaL0c7Q0%LNrq7)q)a2i707SLcriSq_T0cca)2T0qc)Sm27TiciaS2wi_mc)cL0imT)r27mNScS_r24_SLN0dq)Sqi2))_7i2ha)aqridcLL_Nc0Ni0)27q0qLmrr7i0iDrSL_Tmc0NamTTa)SqrSTaTrcriL7L)G_N0ct0l)2qNrTmar_iNG7c2NcwicmN)T27Xqqai72i)iNSicc_i!qNTqcTi)q2Trr7iaqrTcrLi_qcTqr0iTqqTirmL7Ni0riS)c7l0HLNrq7T72c2i777qi_S0 2_Tccci070))_20a77q7aiiS0SSNcZicq0T2c)iqm2)72L3i)SSL28)MNNi0_20)=2Sm2a)acriS_c)__jaNm2<T_)rq7miLTa_rqckLLNrTi)SqS7m)m2mm_7a_rr2SLN5F2N)NcTi21qrm770icarS2Li00_rcr000L7wqqai72i)iNSicc_iBmc)02m8)q7i2LS)L0LSS2LN_U0SN20TTcq0irm27L_mrq/NN00)T7q6NKT-q22NST7qi2iAS__2_m)eNiTN7r7_icrcmLL0rLNmLmOmc_Namr)aq)2qSr7rL2XmclN_)TNTNSm1)i2Nrrmr7qLix_c_TTlTNT0iTqam2qmc7N_mrqy0NcNjT?)7qS7mqm2cST7_iq9pr}SaN_T_2T0T)Tqi2qSmam_mr_LSL7c0)m00)cTL22i_rcaNL2raNcN_07N0)_TTq7qam_r)iNiqS2L__70SN20NTomS2m7)7_iSi7L0_2Nici0)0_)S)am072rSiaiLS__2ocT)N_0a)m7)2_mr77iicTLT0TbiN7N)T_7Tq_mSmai0_i_SSLN0(q)Sqi2))_7i2?a)aqri.cLi_qcTqr0iTqqTirmL7Ni0riS)c7{0eLNrq7Tr)S2S707r_rr_cmL60ccaN)0q7rqaa2rmSpLrcTLTLST!ci0NmrmL7mai7qLFaYrUL2_N)Tc_0qme)L7aiaSw7ziFS2LNTTp_Nq2bTLmi7_irLTaTrTSiLqTmci)00_)S)am0i77.S_rrL7_2}_caN)0q7rqia272LcL_emL0bc_rN20T0S7{qrai7TLN_qST_c_ic2TS02TN)B7Smma)a_rSr7_0I20iNTq)T_)rq7miLTiTScSi_7_)c_00q2)T2c2i777qi_S0L7_Tccci070T)_20m2iS7LL0rqcSNi0)c_)i04q)qqmircaiiqSTNr_i%mc)02m;)v2Sm2a)acriS_c0_IcSN2T)TNqi2_ri7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cS=2cNNjmm)2qT2c70Lri2rLNm_q0NT2qi2m7I)>2w72aN TrqL2LvF_N2Nmm:)i2Nrrr_SqrNcrSr_rc0cL2OT6qS227)7ciir_d0L).Sc20)0N)iq_a)mqriaLA)c0cSH2T0NmTSTL20a77q7aiiS0SSNc{icq0T2c)r27m0ac7Sr2Si8__rc7N0Tc0Lq22irc7ri7r0LcSr52ci)c0N22)aici_r7i0L_ST_7_ac_))N_Ta)m22mmLmamiLr__00cciNm0))2a<2w7Sa2r)rcLi__00c)0ST2q)qNmi7_S)iq_iSL0)T0TS0220)m2S2La0S7r0rLLrTTc0cL0r7Tq0qLmrLTa0iLrrLi_r)rcr0NT0q2a)m_7ra7riNT_N_S#L2T0T2_7-imr2Lrirr)Nm_0<aqTNTNLm0a2i2Sr7rirS0SL0s5Lc7Nam )L7ii7rmLm_c<)N4_Y-7qr02TLamqm2Nr2L2vrrrLr80*Lqk0&mkq2m)mcaiL;riL7Lqk_)2)70a2_qNi7r2Scii_2Sr cxNN2)STaTLq_m27cS)i_raLmN)jANS02)))c2im_r0i0rSS2_)_NciN_q))N)q22m_77SSr2SNLQNSc2NT0c)0ar2rrra0rciSL2NrR2N)NNTi707)2qii7L_)(0-S_200cm0S0Lq077m0mLarRTS0SL_r)TN0NLTraT202L7r_Tr0rLLrTTc0cL0r7Tq0qLmrLTi0ihrSL_Tmc0NamTm27ia2imaN_rirSr_0_L)eNiTN7r7_iNrTrAiacTST_T:icq2mT0)aiTmNiLS__N!NNrLr6rN0NLmj)i2Nrr7aSm_2FacmTT;TNT0iTqam2i7)7_iSiaL0_2Nicm0)0_)S)7m072rSi2rTSc_0Trc2NLmm)q7Ti0rqS0_zioS*_2wNqTNr0S)S202rSr7SL2S0_cLSc2TSN6Tcqc222zSeamLiSm_)_ccict0c)cq2qtr;mYSirmL)Lc0STa00q7T_qqim2?raLr-2rzL#*2cN2T0_)qam2miaamr)rccSNic0)iNTTT)iqqrmmLS0i_SSSa5007N0NG0S)_immma)ac_S{7_0N2fr)c0iTqqTirmi7ma)r2S2LL0RIP)T0k)S)7i)r0ai_0irSr_0_L)HNqqi)22)2N7iSciirmS)_2TBc>0S077)acmii_aTL7S0SL_r)TN0N*0S)_immm7c_TiqS2SrL_{qcL2XT_)a2mi)7_aarmc3L__acmqD0_Tr)72iST7_iqZ/c0Nq07#N)2TN7r)r2r707L_(rLS7LaTncm)i2im2ama_rrL{ifr7Nr_2<Lqm0q2N70aqi2SI7hisS2LNTTcTcS2=TNq0qm2i7NaanrSr_7^0NccST2)iq22NmELmiaiLS__2/cT)N_0a)m7)2!7Sa2r)rcLi__00)r00)cTL22qai_Sw_i_SSLN0Vq)Sqi2)qNqqm27_a7LSS2LN_I0SN20TTcq0irmr7)_miaSiSb_0daNNmT)T2c2i777)i_S0S_LaJm)*N_0a)maB2_maam_Ar_SrL7HiqTN_Tq7nqLari_S__NE2NrLrfrN0NLmg)i2Nrrr_L0LIiLc0_L)mcm0mT_)air2L7_amr2S_S:Tmc0NamT)NTLa0r0SqLi*6r4LR92cN2T0rTSqSm0mrLrimUmS7Ncuac)Nqmr)a72imrdSa:TSTSS0(oiNN2r2Lmq7imqSu7Mi*S2LNTT=_Nq2jTLma7_i_LTaTrTSiLqTmc0NamT)NmLa_ST7TiTriSq0mwmN)N_TST720m2iiLTiiS7Sq___NT2qmm0m)qqaimLL)_0_SL2N0emNSNL)0m7202&mSa_ mSmNm__cSc7T0mmq0mc2La2L__cSNc2_a)c)_q7)0m_2T777ai__)S_LaKm)kN_0rT7qirT7TLTiiS7S)__TTc_0S0aq0aiaSmLS0iqzSciN)h_TiN5)))q2iic7iaqrTcrLi_mt)N22%TiqNirmarqLTzrrrLr#0ILqp0i)Nar2aiqriLa -r*LKV2cN2TTNTS)LrTmLr_L__icrN20aqT0T0S7nqimNSrSaLqSNNrLrvrN0NLmZ)Z2Sm2a)acriS_c0I0cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aqaariL0LS0cciNqTTmcqma270icaSS2pSLS00cW0ST2q)qNmi7_S)iOSSLT0)T0Ni)_Tcm72T7c7mi2LirS_)__cScmT0)2mS2a2L7_i2rcb)L__acm))0_Tr)72iSTaTrcriL7L)B_N0)2T2qcqim7mqa_r0_7Sac_;N)7q22c)i722racaNr2_SL2_N&^qm02TT)c20rr72aLymSqcNN2TmqrNrTrq0qLrs7Ni0irSi_0_T)rN20L7mqqaTiuLmamrmS_LaTrcr07T0qc)Sm27ir__mr_LSLac0Iq)i2r72772ai_aN_7I2cc_i02crTcTNq27SmamLa_r2Scc)__RaNmq)TA7+227)7cii_/Si_7_qc_q2q7Tam_2Nr7S2Lcrin2LrcccN02qST2qNq:m_7!_*iWSqL2UiT7000ATSq_rm7mLmi_SSS7o0TmN0Tc0Lq2a_ic7NS2iaccc_N7c0T_0T)7)a2_i)7_aarmcxL__acmq-0_Taqmizm_7aimy}LNLq+2c_N7qS)2qN2IiSamr)r_LSL7c0N2)iT2q)qNmir_arr7S0_cLrc2Niqc0i)qqTm07T_TiTraSi__0SN20TTcq0irmT7)i)riST0T_7TtNmq7)N)SqLSTaNS__PcmNNTrcrN)mm)0qarTrqrLL0rLNmLmxmc_Namr)2qLrm7qSNL2=2NrLr-rN0NLm#)i2Nrr7aSq_2crSr_rc0cL2nTyqS227)7ciir_;0NrF0NccLT20am_a+rirSaL_0SqNS0iT)N_qiTo2)2q7iSciirmS)_2T3cOqxT2q)qcmirWair7rqL_0207ca)_TN77a2ic7iS2irLcLN>20SN20NT<am22mT7ci0DrSrNr;0NccST2mrq2m)mNai_0_)Sqci_L))q0qS)2702m7S7Lr0_7L0LLVrqT000<TSq_rm70aaXTSN/LNr)TcT0TTi)qimm07a_TrN_Lc00N)mcm0mT_)airma7)aq,rSqc202T0qTq_mNar2rm)Lmi0raNTNNNLca2T0T)Tqi2qSmamr)r_LSL7c0N2)iTiq)q_mSmai0r2_SSLN0#q)Sqi2))_7i2oa)aqrizcLL_Nc0Ni0)27q0qLmrr7a7L_Si_7_)c_))0r2iqmm)m_aSaaS0L2cStmN)N)2Smi20a2mYScirS7S7__00cr0ST2q))Gmi7_S)rNrqL2__f7TS02TN)G7Sm27Tacr0crLrB7c00cNS)2qi7_m_a7i0ScrL_2viTcNNq2Taaca_i7a0S_rTL7La;_T)N_0a)maw2_mr77iicTS__qT(cL)aq_m>iT2T7TaiiqcmSa_i#TN00i0raTq_mqS1aLLr(mN^LgVdN20N7TqTmcmia7a)r_L0c20Fc20)0N)iTLa0rTS_LcrNB2LaTcT_)7T02_qTm7maa_L)SNSq_21_c7)ST2)NqEaS7mLmi_SSS7W0TmN0Tc0Lq2a_ic7NS2iaccc_N7c0T_0T)7)a2_i)m_aaimS2LmTmjmcLN_)07c2imm7)i2g&S=Nl{2N)NcTimJqim7mqa__2_7Sac_{N)7q22c)i722racaNr2_SL2_N,?qm02TN)5imm27Na1KmS2LN_1)mN20NTYam22mT7ci0ArS2LLTmcq)T20mq77iv2y7bi2rNNTLr_ScS000r7rqaa77TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTNm2qarcr_S7r0__LTs79aN_q)T3qS227)7ciir_?0L;}Sc20)0N)iq_m)m_aSamS0L2cS_LT0Nq2Smi7)2_ii7pr)rqLiNcnrN700)cTS22mii_acr7S0_cLLc2NiqcTNm2qarcr_S7r0__LTe7XaN_q)TdqS227)7ciir_O0Lz!Sc20)0N)iq_m)m_aSamS0L2cS_LT0Nq2Smi7)2_ii74r)rqLiNcxrN700)cTS22mii_arr7S0_cLLc2NiTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSrmL)L_3S/700T22iqmm)m_aSaaS0L2NS*mN)N_TSTm20m2iS7LL0rqcSNi0)c_)i0tq)qqmircaaL2S0_cLSc2NTTcTaq27imma)aLricTLq0rcT)w0am772aHmia7aqr_c2Ni<0:pcS0_7mq02aSTaNS,__cNNTTr/rNrT0TLap2Lm77a_hrLliNrTTTL2mTm)ciT2_7qLBiL_rc70j_PcX02TNaTq_mqSwL0Lr__LaTTzTNT0iTqam20maLTiNLLk0N202)rcr0r)0)LiHmL77aa/:Srci07T_qmq3mraO2Em7Lri2rLNmNi_NT20NmrTrqrm0mLLkiXSSL2p)^cNi0_20))2Sm2a)aNriS_c)_q0icL2)m0mS22i07miSiLL0c7dqOaNiT0TS7c2imqaTLcrrL7_0ccVS02Ti2_qrm770icaLS2LiEc=iN7NTT_q0772ai_aN_7O2cc_i02crTcTNq27SmamLa_r2Scc)__3aNmq)T_)rq7miLTiTScSi_7_)c_00q2T72c2i777qi_S0h7LaN_cNq722mcqia2mriciNS2%S_2oNc52mT2)Tqcm0Srarr7S0_cLSc2Ni)_T_q7207cmLi2riPcLNN23aqcq_27q07_mTa7aar_6)L__acmq 0_Tr)72iST7_iqe<;_ca6q) cM0A)2qNrTm_aq_!e0Yrc_ aqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qm#)L)aa_rr_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_wSAa00T2)Sq2m)2eaii__)Sqci_L))q0qS)2702m7S7Lr0_7LqLaMiN0NS2c)iqqmTrcarr7S0_cLSc2Ni)_Trq7207cmLi2risSLi 7kTN_q)TqmiqLr)S0SSr2O0Lm?SFL00q7T0)Lqrmi7r_rirSNL0&2T)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0_)S0_cLrc2TSNL20)qaSiir)a_Lir}_)_qci)c0iTqqTirmi7ma)r2c^LiON)rNaNq2i7qin2v7ti2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TT)c20rr7ri7r0LcSSu2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7)0)L2rSTa0aLrrNT_0_Lcr2TT0TLqrrT7075aSr_Nm_0&aqTNa0STriTmTacair7r)L_#0_4cb02TNaTqaa_7NL7_2PcLi_mh)N22GTqmi227)7Nii_cSiLqlTTcNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2mm)a2_5riLN0r0_)0q0qMm0qLrmmmami_raNr_2&Lqm0q2Nm2a2iir7_TiTSTLi_q)mN00a7TqN7Li0S0L2_TcJS:_=c2NNmTT_qqiDmLraS___c0N0Tr>rNrT0TLaX2Lm77a_ZrrIiNi0i)mqN2m7+qK27Sra2iLcmLqNTT0)2q0m(TGqfm27N_TrTLcLiK7t)N_T022qTmcmia7aqr_L0_7wTNcNiT7TTq_m072rSiaiLS__2xcT)N_0a)m7)2mm7a7i_rmNm_TTTI_qrTc7T2caS7qaciNcmLqN0TT)rqqmd)gq7rr72aLGmSqcT0c)mcm0mT_)airm27L_m_r,TLLTmWmNm0_Taar22mLLmiq_Nc2N)TrkrNrT0TLa 2Lm77a_8rrjiN70S)mqN277DqR27Sra2iLcmciLN02NN2r0r)r202LS+a&rSS2_)_cciN_q0T)qS227)7Niir_o)LqNi=Lq)202Sq2a0mmaSaLS0.7_q_aci000Smcqi2q7TScirS7L05c_SN20iq_)r27m0ac7Lr2Si_c_rc7N0Tc0rq22im_r)aqLirLN)000SN2q0TmqSqL70r7iqiaSi_0_STcNi0q)T7c2imm7)i2(4Se_SD2N)NcTi)_702+7Sa2r)rNLi__c)c!0ST2q))Xmi7_i0L7raE__NT7)2qcTim2qr7c7Ni2LSS2LN_K)mN20TTcq0irmra7i0ScrS_2:i0_NcT7)02cqL72aiLcrNz2LaTcT_)7T02_qTm7maa_L)r_Sa_mT%c_Nr07)iiT2_7qL-Ln_at__a)TcT0TTi)qimm07a_T_T__c0_L)mcm0mT_)airmra7i0ScrS_2ji0_NrT7)02cqL72aircriL7LT^_N0)70a2_qNi7r2Scii_2Sr+cENN2)ST2)Tqcm0SramL2S0_cLSc2TSN220)p2Sm2a)aNriS_c)_FcSNT2)m0qi7_2ir7iTScSm_2NiH20)0_)S)mm072rSaL_0SqNS0iT)N_qiTD2)2q7iSciirqLT0rAicmN)T27-qimNSraaLmQNNrLr3rN0NLm5)r7im2a)acriScc0L7cT0c0m)2712Nrm7+LrrTc)N00rc20)0N)ia0i222rSi7_0cTcSZqccNNmm)2702rrra2r)i+Li_mvcqT0)q_)Sa7i2rcarr7S0L_N0I7NS07)0m7202L7r_Tia__LN07T2)c0i22)rmcmNa2SSr2STLcz0)rNrT7)02cqS72aiS_r_L7_0cc6L02Timcqi2q7TLriirqLT0rlicq0Tmr)iqqmTSraLiNS0Li_)07N0NLTrm7202#mSa_HmSm_)__cSc7T0)2mi2m7)7_iSiaL0_2JScm0)0_)S)mm072aiLcriSq_TTrciNm0))2a<2K7Sa2r)rcLi__00c#0ST2q)qNmi7_Lci_SSSmg007N0NLTraT202VmSa_smS0LaTTcNTLq0m072amrQmkadr2SN0T_qc2cP0_)2)mi4miaN_rraEmN20iTa2T0T)Tqi2qSm7QicScL2L^TYcq)iT2q)qcmimhacrcS2SR0P%NTiNcTrq7qam_Smaa_xSmNT_qTS)i2T)c7_i020r7ariSSS_0_r)rcSq2mm7c2am)7q_rriM2La0Dci070T)_qr2)Sm77L0rccSNi0)cW0ST2q0722qac7Sr2_SL2_N&zqm0a0L)_22mcr)a_iaSmc)_mF7N70_Tmam22i07_iSi7L0c7_rWSNST0Trar2Ni2aTrcriL2cSvqccNNmm)2702_rSSi_TScNm_m5cqTN62L)rm_23m)77i*SN_m0moq)r0m)))_2ir07iaqrT{cSi_qfTN00T7T)Tqa2i7_SSr2STLc50)rNT0)))qi2TST7aS_riL7L)B_cTN)T))iqTrTmqr_a)rzLSLLc0)rNLmT)ram2aScS__mS)N002_2TSN:Tcqc222PS1acLi(rc)_L%7ca2OT_miqLrT7_iSimL0L!_7)rcSq2T)aca_i7aTrcriL2ci_aN)NcTimcqi2q7TLriirqLT0rpicq0Tmr)iqm2)72LviiSNNr_a0q)2qi2LaTqTmT7iaqAmS0LaTTcNT3q_m07Tir2r7ri0iLc8LL_7Zaq?Ne2i7riTr0LmimrcNTL_kq)}q0qi2_)rrTmTaTiirqNm_0zaqT0T)c)i272)7_i0aerwL2_N)Tca)_TN77a2ic7iami)S2N._q0iN2T)TNqiacmi7qiT_cSiLm_)c2q80>)Sq2m)mcaii__0L0_S52N)NNTi)_7)2qii7L_)o0kS_200cm0S0Lq077m0mLarITS0SL_r)TN0No0S)_im2j7cicr2rKNY_q0iN2T)TcqiqQmcaci2iFceLNNiJcNrT7Taq_immaShimzTSqNS0i)T0c2_70)0a7mr7SiSS0Sr0r_ST2qm2c)aq)2qSraiL2rac#_ic7cT0_Tr))im27r0ac_S*ic)_<cSN2T022)qmc2Sa2SSr2SNL6Tmc2NN0e7mq22Tmca0_rr2SL0m0iT_qNNa2_qarTmTaTiirqNmLj/cNc020z7;qLir7TS)iRSSL2z)^cNi0_20):2Sm2a)aNriS_N0_1cSN2T)0,qi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aNS_riL7L)._cr07TN)_702H7Saqr0nrSL0T#r)m0Nmcm_amm0ac7Lr2D_N0_N02ca2c2_m720a_7Ti7iaS_c)_,cSN2T)Tcqi2_i0a0iSr2L)LNAic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TN2_qim7m)a_L)rrKi_mc)c_0S0aq022aS7mi)iL1SciK002c,qcTrq72Nm_r0arrSS2_)L=ciN_q)TqmiqLr)S0SSr2u0LmASIL00q7)T2c2i777)i_S0P2_Tccci070q)_20a7mar_iNy7c2Nc}iT2Nr)c)N22aS7mi)i_SSS7#0c2TiNc00m7qaa_7NL7_2;cLiN2Ur0c0N)2mS2m7)7_iSi7L0_2Nicm0)0_)S)am072rSi2rTSc_0TrcTN)T))iqTrTmar_iiS7S)__prN7NaT_7mqai57mLTiq=Sci0T-_NSNa)07ia_m27Nae!mS2LN_l)mN20NT&am22mN7u_mr2SNLYTmc2NN0f7mq22Tmca0_rr2SL0mPqTTqc2c7r)r2r707L_OriLN0rUaTqq22)73)^2V72aNXTr_Lq0bTN)c)LTaaTqTmT7iaqgmS0LaTTcNTsqLmNamqmmm7_aa<rS2LLTmcq)Tq2m270iK2u7Wi2rNNTL_Aq)?NLNa2_7_arSm7mimr_Sa0rITc)0)Ti)TiT2Lr.a)_mr0cu_mTmN)q}TL7m2Ni67_S7rTLcLi37I)N_T022)7mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cS+mN)N_TST720m2ii7Sr)r_LSLac0N2)S0Lm0qqiSriS)i__iSOG)5qNiqcTam2amicm7ari_rILiTTcNTL20m0am2mmcLTa_rqcjNcNa0_NamTTTqT2imqLmi0raNTNqNWT0NLmmTmqm2_maLri2rLNmNr0TT20NmrTrqrm0mLL%iLr7Sa0*8_Tiqa2m7m7_i2SBadi7crL2_L)mNqNN227)ir2r7ri0iLcBS_Niya))TNTqq22_m7rSi2rNSYcS&TT0NIqS)a)L2_72acL)r_Sa_m0)c_Nr07)iiT2ki_arL7S0SL_r)TN0NP0S)_imm07a_TrN_Lc002TTqrNrTrq0qLr?7Ni0irSi_0_T)rN20L7mqqqNi2S2_rirSr_0_L)uNaqi)27)mNmqa2i_r7fS_2KNcX)STcm0qcaSm2aNaEr_SO01_!cqN2Tim7202*mSa_ mScc0_c0SN20NTFam22mN7k_mr2STLcI0)rN20L7mqqaTi2S0_rirSr_0_L)3NiTN7rqaaqrqLrarrrL0LLT!cN000r)i202TSra2iLcmcmLN02NN2r0r)r202LSKiNLiSN_)_7ci)c0LTNq02im)r7i0iLSrc7u)0_NmT7TL2cqi72aiLciiSqLTA0cT2T0TTa)i2_iSa2iTrcL00ruST2Nt)c)q27207_i0L7S0SL_r)TN0N}0S)_imm07a_TrNiLc0NL)mcm0mT_)airmar2Li_aH)L__r67NimT)T2c2L72rii7_)S_LaYm)ON_0a)maw2_maam_,rLHi_qT))02mT2)Nq3rmmLS0iqySciN)M_TiNX)))q2iic7_S2r0LcSSH2cT0c0_)2mi2m7)a0iizTSr_7s2)c)_T2m_)La0mqSSLi_)S_ci_UN)NqTimcqrm770icaSS2Li;c<rN700)cTL22mi7_S0iZSSL2;)_kNi0_2))q7i2LS)L0LSS2c0_mcScLT027qTqSrM7Ni0imriLN_a)rNi0q)T7c2imm7)i2<}SI_SY2N)NcTi)_702Tr=aSr)r_LSLac0N2qr0L)2qmir7iL2L7S0SL_r)TN0NX0S)_imm07a_T_qEic0N2cNqrNrTrq0qLr.7La7iacAL_Nic20)0c)i7{2i777qi_rrS)0m5mN)N_Ti2_qN2imrSciirqLTNcbicmN)T27*qD27Sr7Li_rTS2LLlqqm0m)))_2S27a0i2r0rLLrTTc0cL0r7Tq0qLmrLTi0i6rSL_Tmc0NamTmq77aTmLLmamrmS_LaTrc2NLmmma7iamiiaq_yisSH_2YNqTN_Tq7?aNi)iMS0iLcmSm_ms_ca2rTa))qqrr7NS2_),qNTNr0Vqr0rT)am20maLTiNLLuLc_Tm?mNm0_Taar2Tm)a)iirTNT_0N_ci070))_qrm770a_L0rhLS_2c0)r0T)c)ia7i27_L2rNrqL2__J7TS02TN)j7Smma)a_rSr7_0 20iNmT)T_qSqa70a2LSrmL)L_pS<m00T22SqaqLm_a2ic_)S_LaomT)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0_7ST_c_ic7cT0_)0m7202L7r_Tr0rXSS__)mcl0c)cq2q;r57qSir2L)LcdiTcNT0)))qi2TST7)S_rrL7Lad_T)NL07Taae2_ii7L_)90cr_2c)cN0iTm)ciT2JrLarS_r=S)L7FoNNTmmm)carmma)a_ric0Li_qcT)c0iTqqTirmi7ma)r2cULi?N)rNaNq2i7aaLST7TiTriSq0m_hcc0cT2T>a&2miiamr)r_LSLmc0N2)ST0)aiT2rSr7rirS0SL0sEqTiNLm)707Sm27Tacr0crLr%7c00cNS)2qi7_mTr7aaL_Si_7_qc_))0_Taqma)m_7ra7riNTL_ q)mNkTS)22)2c7ia_L0_2LTJcKiN7NTT_q0ai2T7TaiiqcmSLN0/q)Sqi2))_qr277i_Tia__LiX7,qN_q)T_)a2mi)7_aarmcoL__acmqn0_Taqminm_7ra7riNTL_{q)}NLqa2_7SiNSm7mimr_Sa0rY2cL2m27mS7mmNSr7rirS0SL0B:iNN2r2Sm_7amqS179i9S2LNTTcT0c0i)7))2_70r2iTScSi_7_qc_002))T2c2i777Ti_S037_0_hxSN_mm)0qarTr)S7LT_2LN0r_rcr000L7AqNm0mrair0rTNr_2yLqm0q2N7ca0rrmrarr0rLNO_bcSN2T)Tcqi2_i07IiSr2L)LN?ic_q)0 )Sq2m)21aii__)LNLqZ2c_N7qS)2qN2YiS7BicScL2L%TycmqrTT7Tq)irmmLTr0orLqN)Wmc707T_)mim2Lr0LTLSr)Lm_iVrN22RTqmaa_i_LTiTiSchLiVN)rNNqmmTarqrmra0aLv,Si_NTrcN)q227r)r2r707L_?riLN0ryNT2)i277.)^2!72aN(TrT+__r07N0Nh0S)_im2Sr0aNLSS2LN_=)mN20TTcq0irm27LLi_7BTc2_a)rcr0r)0)LidmL77aauESnci07T2qmq8mma52um7Lri2rLNmNr_NT2NamrTrqrm0mLLdir_iS7N)cNcq02T_)77Sm27Na.LSr:c0__0SNaNLT_q22ci)7_aarmu)L__r+7NimTTrm_2ii7a0aLrrNT_0_Lcr2TT0T<)S2_Sma0iacTSacL0iqTNTTT)iqqrm70aapTrarLN00SqmNmTm)_qarr7ri7rNS_c0900SN20TTcq0irmNr2Li_as)L__acmqI0_Tr)72iST7_iqHvSqciN_Tr2T0T)Tqi2qSmaiL0iXLSL-c)c)0iT_m)q_2rm7aivTSN#__Tc7cn0_2))_qammS>a_iaSmN __HaNm2XTqmiqLr)S0_mr2SNL&Tm>2NNNhT_)%i=2&7qa2rin7_0_D!SN_mmT(qcmc727z_DrmcrLSTTN0qrTT7T)fir7qS)imr7L7__:mqmNL207T7S2)7maiirS2N!_q0a)_q_7TqTqSrQ7iiN&rSNcm0T)rcr0r)0)Li,miaN_rrNkqN2Tr^rNrT0TLaZ2i7NLriN_2QiN7Tso>NuT2)NiT2-i_arL7S0S.LSf_qm0i20)N7Sm27Na4UmS2LT_cc0qr02TL7ia7iTr2aa9rrrLrO0KLqK0LT7)ai4m?riL7_2cmcW0m).Ny077rq22LSmSraN_2Sa0r_rcr000L7=q)aim7S)rNrqL2__O7TS02TN)F7S2Br0a_LSSaSL__c2Ncq)T_)a2mi)7_ari7Si0T_r0_Niq7)0)L2rSTa0aLrrNT_0_j+SN_mm)0qarTmarLLicTST_Tbicq2mT0)aiT2a2LS0LScmSm_m{_ca2rTrq72Nm_r07ZLSS2LT_cc0qr0N227iaai)7_aarmcOL__rA7NimTT_qqi:mqriS__rNTLT%TciNqmmTm702r7S7-r)S0Li__0)c_Nr07)iiTmNi_aTr7r7L_N)1_ca0mmb)_qammSFa_iaSmN8_q0icL2)m0am22mN7*_mr2SNLVTmc2NN0.7mq22Tmca0_rr2SL0mRqTN)22)mrasqMmxa2iNcTSq_2_kc_020m7wqimNSraaaq_ic7NL)TcT0TTi)qim2+7cicr2rRNMMc0iNST)T_qSqa70a2SSivSc_c328>qt0a2S)=2c7ca2aZ.ySLci_c/0)70L2_qmiqm77maar0rL_0:r0mqd0cT0amqS7SiciiraLm_i_rTi0q0i)q2)2m72a)iacTLN0mc0q00TT)q)2imTLTi0L_Sa_7&0c_))0N)0)mqimN7a_rriL7N2E_N)N_TSma20m2iSa2iNrOcr_Scccq000))2qqmT727mL2SNS2_NcccT00Tc)qazmmSTa__rrLN2_mB7N70_Tmam22i07LiSr2L0L_KSTi00T7)02caL72aiS_rNy7_0_Lcr)7Ni707)2Lm77a_RrcZiNiTTc_0S0mq0qH27SraNL2raNcN_07crNSTSq0qrrr7iS2irLcLNg20SN00a7Tq0mcmi7_iiL_l0Nc00)rcr0r)0)LinmLaSa7o0c0_iN_>)Nx2r)22)2N7im_L)r_SrL71iqT0N)cTSa2i27_S0a7r7cX_ic7cq0_00m7202L7rS7i0LcNSL_TS)iT022qNacmi7qiT_cSr_7A0NccST2)im_qRrra)L,rqcm_2T0T)0N0q)2q_27iSa2iNr=hSL,McNc020<7{q_ai72i)icSiLmH):_Ni2TTrq720rcr_i2__r2LNLt?_c}2;0t)qq2mir7i0iJrSL_Tmh*NcTc)2)>iRm_rii2S)Sc_ikmN)N_Ti7Tqrm770LcL_S2c__2fNcj2mT2)Nq5rm72aTicS0Nr_2/Lqm0q2N7N7+rrmrarr0rLN}_icNqrqSmTma2qrKm,a>r2SN0T__cqqm0d)Sq2m)mcaii_iN.2_0ccPr022_Tmqm2_maLriN_2Sa0c0_T7000uTSq_rmmLS0i_SSSaP007N0NLTrm7202vmSa_:mS0LaTTcNTLq0mNm_ir2r7ri0iLcuLL_7JaqXN+2i77aarmSNL2XDSIL7Trc2NLmmm77Oqqiiaq_}iWSk_2hNqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m72q2a7ii0iSZcLi_qcT)c0TT)q)2imTLTaT_XSSNmO2TwNa2mT77l2mi7aNaSiLNTLSN_TQqm227rqr2)Sma0iacTSScL00)2q2mrTrqrm0mLLyiNS0Sr_ic0cT2rT2)LimirmNS2iScrSr_rc0cL2!0%mi227)7cii_cSSc2LS__))0LT7)aiUm_riLilTNcL0TrcrN)mm)i70q_7Sa2r0_7LNLS_LqT00q_m=amr)7iLQi<r7Nr_a02N2TcTiq27S2Sr0aLrSXi_0N7BlT_0a)77q2_i)7iiNprScc2NicmqMT0TaqmiYmrraS_irNTLT/TciNqmm)72)2r7ir_icS7SF__0)cL0S2iq072m)rcaiiqSTcc_i9qNTqcTi)q2Tic7LaNr0SiL)N7c0cL0r27)T7_mia7a)r_Sr_7_Tc_qm0amdqmiT2hSSLiMTS__S_aN0qi2_TL702qrSSiL)r_FiLMc)cq0i2cTiqq2T70aT%TrTSaLiH_TS02TT)c20rrmrS2r0LcSS<2cT0cNr)27x2Nrm7XLrimc)N00rc20)0N)ia0i2mqriaLg)c0cSs2T0NmTSTL20a7707LircTL0LLgrqT0q0a)i202SrcaiiqSTcc_i(mc)02m=)s2Sm2a)acriS_c0&0cSN2T)TNqi2_i)7_aarmcbL__acmqZ0_Tr)72iST7_iqlMSLcaN_TLqcmmTmqm2_maLriar)Sq0rxmT2q)2i7T7SiqSrari)cmL0_a)TNNcL207Nacrrmrarr0rLN=_vcSN2T)Tcqi2_i07)iSr2L)LN!ic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TTqcqim7m)a_r0_2LT,c=iN7NqT_q0a)mTacair7rTL_d007ca)_TN77a2ic7iS2irLcLNB20SNmT)T_qSq770a2Sir2L)LN!iT_NrT7)02cqr72aiLcrN&2LaTcT_)7T02_qTm7maa_L)rULS_2c)cc0iT_m0q)mS72i)iNSiL_N)5qTiNLm)707Sm2r0amrSrL_0N7cT0c0i)7))2_70r2iTScSi_7_qc_002a)T2c2i777Ti_S0J7LaN_cNq722mcqia2mriciNS2pS_m*cqTNqT2Tr)_2qmLLPi=SSL2Y):cNi0_Ti)q2Trr7NS2iaccc_N7c0T_0T)7)a2_i)7pa7JrrLL__T}2cL0q7mq22NmorSiaiLS__2ecT)N_0a)m7)2A7Sa2r)rcLi__00cn0ST2q)qNmi7_Lii_SSSm{007NqNaTiq0qSic7iaqrTncLi_m{)N22<T9qS227)7ciir_y0LnQSc20)0N)iq_iim_aSamS0,7_0_Lcr2TT0TLqrrT707LircTL0LLErqT000xTSq_rm70aa}T_+,g_a)TcT0TTi)qimm07a_T_2h7cTN2cNqrNrTrq0qLrZ7iiN{rSacqNiTi)imTTTqT2imqLmi0raNTN202TTNLmmTmqm2_maLri2rLNm_q_NT2q22a7()h2!72aNDTSNSSLL)Tc:)_2L7Nari)rm_TrTrSN/_icNqr0a0qmiaii7LTaTrTSiLqTm:>NcTc)2)Bi1mLSriTyTSacSUqccNNmmTS70iTrrSq_XrkS70rw2cL2m27mT7227Sr7rirS0SL0G,iNN2r2imqq7rrmrarr0rLN>_icNqrq/0qmiqSr/mBasr2SN0T_qc2cB0_)2)mitmiaN_rrcrqci07)jcE0u)2qNrT7TLTiiS7S)__TTc_0S0aq0aiaSmLS0iq:SciN)!_TiN3)))q2iic7LaNr0SiL)N7c0cL0r27qTiTmia7a)r_cTL_<Sfa002i2S)La0mqSSLi_)S_ci_jN)NqTimc)i2qmTa0iTcTSTLa_ic_)ST2)Tqcm0Srar_rS0_cLSc2)r02)))N2ir0r)aqLirLN)000SN2q0TmqSqL70r7i0iLSr0Ts0svcS0_7mq02aST77SL_LNTLTVTciNqmm)qqc2NSm7mL0g0c2NE0iTL2mTm)ciT2_7qL9L__rSS0:_ocI02TNaT2Na_7ii7i)S_c)_r0iNmT)TLqi2Ni07biSrqc)NNhiTcN20LmIqNaNrTS_amrmS_LaTrc2NL2&)T7N2e7Saq_)+0Li00_rcr000L7uqqai72i)iNSicc_i mc)02mb)U2SmqS)Lcri__LmN7c0cL0r7Tq0q-2S7_a_rqcmLrNrcm0)0LmS7im0ri7TiTriSq0m_LT0N_TSTa20a7707paSr_Nm_mc)cLqS27q0722OrcaiiqSTNr_LFNN00iT)m7202L7rS7rTcTLiG7v)N_2TT_qSqa70SiSSiLJ0Lq0STi))0_2i)Zm)mqaiLcrLSN_01ic))7T0TLqra7707paSr_Nm_q00c_0S07q0772Vi_arr7SNL__q02NTTcTa77aqm_r)airNcTLqNqTmq0NrTrq0qLr87iiN}TSmcqkTNcNa27m2q_i22x7>i2rNNTLaN_ci070q)_7)2_mr77iicTLT%c>a)7q)T_m0qraS72aNiBcmL2_TIcN000Ta7rq?a-7ri7rNccc_O2T_cm0mT_)airmNr2i0ScrL_2NSc2NT0c)0ar2r77aN_c_SL2ci-TT)N_0a)mas2_maam_#r_Sa_mT%c_Nr07)iiT2_7qLXi)_a5_N_)TcT0TTi)qimm07a_Ti7_LN00N)mcm0mT_)airma7)aqlrSac20TTrqTqLmmar2rm)Lmi0raNTL7LLT0qNmmTmqm2_maLrirS7L0Jc_SN20iq_)r27m0ac7Lr2Si_c_ic7cT0_)0m7qaa_7NL7_23cLiN2Hr0c0N)2mS2a2L7_i2rc=)L__acm))0W)Sq2m)mcaii__0r7Si0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNie_SL2_T=cN02rTrq7207cmSi2ri__S)L20ScLq0Tq7Saii)7_Sii%L)Lq9iTcNi0q)Tar2imm7)i2>{SY_S:2N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSL;007N0NLTraT202L7r_Tr0rLLrTTcqca0i)0)Sacmi7qiT_cSTL)-)ciNTmTT)m_2i777)i__)SmL7f7c_NmmmTn702h7S77r0rmS7_7R_cm2m0mm0qlmSm7L)_NSicc_2 L)gNm2N7Ta_2m7ma_iacrL2_LTzc{qNT%qSq7r)S0ii 0rrLrM0VLqf0q2iq2m)mNaiLcriSmL)B2)DN#TST7a)ic7ir_iT_7L0LLGrqT000/TSq_2_7qLmim_rLmX)Zc)Sqi)07iqTmT7iaqPmrLc0__cScaT027q0q42S7__mrmL)Lc0ST700q2Tr7c2imqaT_rrLSN_0=ic))7T0TLqra7707kaSr_NmL9 cNc020=7&qcai72i)icSicc_TD)N)0iTTaTqra_7ri7i)S_LT_)c)Ni0T7T)T7_mra7a)jc{L_2NSc0Na2rTTmLaPri7TiTriSq0m10caqr0r2Lqrm7m)LcL_S2c_Lm3mc_Namr)N72m0ac7Lr2_SL2_TOcN02rTrq7q)rcrSi2LirOc)__paNm2*T_)rq7mi7iiNkTSTcmfTNccS27m2q_i22?7Bi2rNNTLaN_ci070q)_7)2_mr77iicTLT5c_S)7q)T_m0qmaS72aNiWcmL2_NEyqm02TT)c20rr7aa)iqcrLaN2Tm)Iqa7TqTqSrW7iiNsrSacmNiTaq;N{Tuq22NST7_iqzpSLcaN_T_2T0T)Tqi2qSma0iacTLNc%0LqTNTTT)iqqrm7mi)i_SSS7x0c2NS02)))N2im_r0a_rSrm_0N7RaT_0Nm772acmir2arScSN_2NSc2NT0c)0ar2r77a0rciSL2_iN_c_07T0qc)Lm27iSciN_2Sa0c0_T700q_)T272a7_S)i_raLm0ke_crN7TiaT2T7c7ii7i)S__0 7c00cNL)2qi7_mia7aTr_R)LqNiHLq)202Sq2a0mmaSaLS0f7_0_Lcr2TT0TK)S2_Sma0iacTc0ce00cL2m0m)mq_2aSra2iLcmLqNT0LqmNmTm)_qarr7rLrr0LcSSu2TrN2T)TNqii0i)7qSiiLc)N0NSc2)00m)S)Lm0i7a0aViSS_0mgm)mN_TST720im70icaLS2c_Ncoicq0Tmr)iqm2)72L9iiSNNr_a0q)q2r0r)r202LS?aLi7raN^_r0i)mqimmmGamrb7.a7*rS2LLTmcqcNq2m)arqrmra0aL QS/N.O2N)NcTimWqim7mqa__2_7Sac_YN)7q22c)i722racaNr2_SLaLLA_N20c2))_qammr)avrSS2_)_cciN_q0T?qS227)7Niir_L)L_oS=m00T22S)La0mqSSLi_)S_ci_hN)NqTimcqL2N70aii)_7L0LLurT70006TSq_rm7mi)i_SSS7;0c2Ti0m)))_2S2aa0i2rSS2_)L!ciN_q)TqmiqLr)S0SSr2k0Lm*StL00q7)0)L2rSTa0aLrrNT_0_Lcr2TT0TLqrrT707LircTL0LQ_Sc_2mT0)aiTi2rr7NL2SNNrLrKrN0NLmf)Lq72aSgamLiO7ci0m0_))2kTj)7irm27L_mrqrNc202T7qlNfTyq22NST7_iqDmS:_Sh2N)NcTi)_7T2<7Sa2r)ivLi__T24ENpT2)NiT2ai_air7rqL_N)O_crN7TiaTqaa_7NL7_23cLi_qcT)c0LTNq02im)r7i0iLSrc7__cqqm09)Sq2m)mcaii__0B2_Tccci070T)_20iimTaTiirqNmLL00cqqS2im)q_2rm7aiuTraW__ic7cq0_2))_qammr)iNiqS2L__70SN20NT;mS22mT7ci0*rS2LL01cm0)0_)S)7m072rrimS)S__S_mN0022_Tmqm2_maLriN_2L01c_LN2)ST2)Tqcm0SraNL2raNcN_07N0NLTrm7202L7r_Tr0rLLrTTc0c3NST_am20maLTL2_i^Tc23N)rcr0r)0)LixmiaN_rraK2ci0iTL2T0T)Tqi2qSm7/icScL2LRTYcLqr0S7TqrirmmLTim_SSe_cccN2NKmE)q7iirr)7SifS0LT__)mcLqNm272irmr7)_mr0Sa0T0q0L)00q7m)m2mm_7a_rr2SL0m0rTN)20a7r)r2r707L_orLhi_20)c_Nr07)iiT2_7qLz_0_rSL0l_wck02TNaTqHa_mLS7r0rzSS__)mcSq0TcmS22mN7(_mr2SNL4Tmc2NT0c)0ar22mLLmLm_NJ2LaTrKrNrT0TLa^2i7NLrLr_2=iLLT5^bN{T2)NiT2ri_aar7r7L_N)f_crN7TiaTqTa_7ai7iVS_c)__kaNm2kT_)rq7miLTa_rqcpN0Nr0_NNmTTTqT2imqLmaariST_0Hier2T0_)qah2qiaS2_RiUSU_2>NqTNaq_70aNaS7a7Li_S2LcN)<_ca0m2))>a&2lST7*__*cSi_qxTN00T7T)Tqa2i7_SSr2STLc,0)rNr2rTr7dqrrirSi2rNS%0mf2cNNBmm)2qN2lSm7LL0rqcSNiT;c_NaTm7oq_2rm7aiITrrSS_Sc0cr2rTam72Na_7ii7i)S_LrA7cNN_2mT?qS2qr)S0ii^0SNc2_a)c)_q7)0m_2T777ai__)S!_S82N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSLj007NTTcTiq7q)m_a0S2r2LcLih7%qN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ci6mN)N_TSTa20m27Sa2r)i:Li__0)cq)i0L7)a0aS72S0imSSSL5007NTTcTiq7q)m_a0S2r2LcLi%78qN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ci}mN)N_TSTa20m27Sa2r)i&Li__0)cq)i0L7)a0aS72S0imSSSL9007NTTcTiq7q)m_a0S2r2LcLi}7#qN_T027q0qLmrLTi0ierSL_Tmc0NamT)NTLa0iiLmamrmS_LaTrcTN)T))iqTrTmar_iiS7S)__0)cmN7T7)_qmrmm7S0iXSSL2%)PNNi0_2)):2S2LS)L0ri__SSN7cT0c0N)2miq77)7_iSimL0_2NSc2NT0c)0ar22mLLmimS)S__S_7N0020T)Tqi2qSm7LL0rqcSNi0)c_Nr07)iiT2ai_air7rqL_N)l_ca0m2))_qammSna_iaSmNE__GaNm2PT_)rq7miLTa_rqcbNcNa0_NamTTTqT2imqLmi0raNT_NNLT_2T0T)Tqi2qSma0iaJ2cqc1laqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qmn7N7rmqSX7Zi^S2LNTT^70c0i)7)q2_70r2iTScSi_7_)c_00q7)q)a2i707SLcriSq_T0ccr07T0qc)Sm27ir_icS7L0%c_LN20i2c)N722aScS_L7S0-__Tc7ca0_2))B2Sm2a)acriS_c0_)cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aTrcriL7L)V_N0)2TTqcqim7mqa_r0S7L01c_rN20i2c)N722aScS_L7S0y__Tc7ca0_2))#2Sm2a)acriS_c0_/cSN2T)TNqi2_rc7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cSGmN)N_TST720m27Sa2r)rNLi__00c}0ST2q))Rmi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTrSN;_Nc0cmNiTN)airmi7qiT_criLq_Tc0NTmTTT)aqim_rSi2rTSc_0Trcr07T0qc)Sm27ir_icS7L0pc_LN20i2c)N722aScS_L7S0=__Tc7ca0_2))s2Sm2a)acriS_c0_)cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aTrcriL7L)}_N0)2TTqcqim7mqa_r0S7L0Jc_rN20i2c)N722aScS_L7S0^__Tc7ca0_2))92Sm2a)acriS_c0_^cSN2T)TNqi2_rc7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cSKmN)N_TST720m27Sa2r)rNLi__00cx0ST2q))Vmi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTrSNB_Nc0cmNiTN)airmi7qiT_cSiLq^T)rNi0mT)q2inmiaN_r_P,m_NTr*rNrT0TLan2mm7a7i_rmNmL700c_0S07q0772rmSaSr0rrNrLr02NTTc0S77aqm_r)ami7S7L__m)mcRq0TkqSq770S7aT_cSr_7_)c_)00m2Sq02arr7TSL_4ciLTvTciNqmm)0qairmrr9L0r6LSL7T))00im0Trqrm0mLLYiq_iL2;)+NNiqcTrq7q)rcrSi2Lirvc)__8aNm2WT_)rq7mi7iiN(TSTcqNicm0)0cmS7im0ri7TiTriSq0m_LT0N_TSTa20a77TicaSH7c)__00cm)ST2)Nqerm72aTicS0Nr_rc7N0Tc0Sq22ia_Sma_rSra_0Lq0i)r2227q0qLmrLTi0iLSr0TJ0u!cS0_7mq02aSTaNSL_iNTLTMTciNqmm)0qarT7NrvL7cTST_T-icq2mTq)cqNrm7qS0_T>rcq0K1pc72rT2)LimmqrTS2_qcrSr_rc0cL2WTiqNirmarmSi_rcuS _<c2NNmT)T2c2i777)i_S0A2L7ccci070q)_20a7mar_iNZ7c2Nc.iT2Nr)c)N22aS72aTicS0Nr_2.Lqm0q2N72aqrrmrarr0rLNo_LW7ca2lTrmiaiimSmS._2c*L!_7)rN20L7m7aqNi2aN_rirSr_0_L)hNQTS)22)2c7ia_L0rHLS_2c)cN0iT_q)q_mSmmi0r2_SSLN0;q)Sqi2))_7i2+a)aqriVcLL_Nc0Ni0)27q0qLmrr7iTScSi_7_)c_00q2)T2c2i777qi_S0L7_0ccwr02TimcqNa2maLcL__7L0c_KTN7NaT_m)2N2q72a_i7_SL2_N9JTS02TT)c20rr7ri7r0LcSSp2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7Tam_2Nr7S2Lcril2LrcccN02qS)2qN2/Sma2iNrhNm_2OTcc00mr)2qLrm7qSNL2H0NrLrJrN0NLmM)i2Nrr7aSqLi4iNyLB#YN20N7TqNqS2LLTa6L_tSNc0rT2)amT)T)Si^miaN_rrarqci02)tcI0A)2qNrT7TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTL)N20mi7)S7r0rLLrN7cT0c0i)7))2_70r2i2ScSi_7_qc_00q7Tam_2Nr7S2Lcriy2LrcccN02qS)a)L2_72acL)r_Sa_m0)c_Nr07)iiTmTacair7r)L_<002N2TcTiq7qqm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2SNLDTmc2NT0c)0ar22mLLmLa_TSL0m_mcmN_0a7r)L2_mma2i_izNm_01aqT0NNLm0acrmmmami_raNr_rc7N0Tc0Sq22ia_7ri7r0LcSLR2ci0c0i)7)T2_70r7aaL_SNN702TcNiq2Tr2c2N72rSiaiLS__2,cT)N_0a)m7)2g7Sa2r)rcLi__00c.0ST2q)qNmi7_L0i/SSL2v)_9Ni0_2))q7i2LS)L0LSS2c0_mcScLT027)0qL2r7iar#rrrLN_0c2))0_Tr)72iSTaTrcriL7L)8_N0)2TTqcqim7mqa_r0S7L0Yc_rN20i2c)N722aScS_L7S0^__Tc7ca0_2))_qammSQa_iaSmN-__BaNm2RT_)a2mrZ7_ari7Si0T__cqq{0L2im_a7ST7TiTriSq0m_Pcc0cT2T>aM2ciia2r)rcLiNc4Tc)0)Ti)TiT2ai_arr7S0_cLLc2NiqcTrq7q)rcr_i2LirLc)_vcSc7T022)amcmia7aTr_L0c7,0O*cS0_7m)12c7ca2aPZ>S_ci.2N)NcTiTZqcmc727D_#rccrLL00NNq/Tmq)q_miSTarr7S0NcN_c2)_20TSm2qarc7iL2_2crLT_)c)Ni0T7T)a7_i=r7iNiSrL0TH00_Ni2m))ar2rm)LmaL_0SqNS0iT)NfTS)220a2m)iciNS2AS_2>NcM)ST2)Nq6rm72aNi/cmL2_T=cN02rT2)LimiirTS2rNcrSr_rc0cL21TNq0qrmia0aTzrS2LLTmT2cNq2)Narqrmra0aL^#Si_NTTcr07T0qc)Sm27irYirS7L04c_rN20im0Trqrm0mLL iq_iL2f)QNNiqcTi)mq)m2SMaqLirLN)000SN20NTXmS2a2L7_i2rc:)L__acm))08)Sq2m)mcaii__0S _S&2N)NNTi)_2)2_7S7mr0S29SL2&N-YN_0;7t)=2qm2aiL7S0StLSP_qm00Ta7r2T7c7ii7i)S__0NmcT0c0i)7)T2_70SiaTrTSiLqTm5L)00_)S)am0i7a0a}iSS_0m_LT0Nq2Smi7)2_maamL)r_Sa_mT{c_NaTm7xq_2a7mLhi_raLm0Al_ca0mmA)_qr277i_Ti_SqNh_L0a)2qr7T)T2Tmi7q_mr0Sa0T0NTm)N0L7m)m2mm_7a_rr2SL0m02T2)mqi)qaJq.mua2iNcTS__qTwTLq2qem0qLrmmmami_raNr_25Lqmqq2_mm2Nrrmrarr0rLNF_icNqrqamTmr2qr<mVajr2SN0T_qc2c>0_)2)mijmiaN_r_accca=q)^cH0P)2qNrT7TiciiS7S)__c0T2qK0L)c)erm7mi)i_SSSa*0c2)_qcTL)N20mi7)S7r0rLLrN7cT0c0i)7))2_70a7i0ScrL_2Ai0_NrT7)02cqr72aiLciiSqLT(0cT2T0TTa)i2_iSa2iTrcL00rBrN700)cTS22mii_Lmiqr7Sm0oplNS02)))N2im_S2S7r0rLLrTTc0c-NST_amqDmcaci2iucXLL0r32qTTcmr)Sa)mL77aa&ISrci0r)T)Lmm)mqcrTm_aq_4rr!rc_0LqTNTTT)iqqrm70aaJT52DL_m)TcT0TTi)qimmqr0a_rSr7_0N7;0T_0r)7q0mc2La2ii_cSr_7VN)c)_T22i)2a)m/aSiqS0}2L0ccci070T)_20a7mar_iN67c2NcUiT2Nr)c)N22aS72aTicS0Nr_2FLqm0T2Nm2aiiaSk7fikS2LNTTtqN2NzT_q2qmr-7iiN^rSmcq02)rcr0r)0)LiOmLrii2S)Sc_iv7T0c7TTqcqam2r1aN_mrRcr_qT))0qrT2q)qNmiS0L2a2_SSSN0TTTS0qTc)Nimm2r0aL_rS2_)L}ciNm0c7T)77_mcS7L2_cSr_7%0c_)0Tc)S)Sm0i7a0aLrrNTLaN_cNq722mcqia2mriciNS2:S_a_Lc_02Tcm)q_2a7mS)i#SSL2f)YcNi0_20)E2Sm2a)aNriS__)__cScmT0)2mSqLi07qLS_if)L_NiXU0)0q)i7cqimq7Ti0rTNTLT_aEiN_qS)2qT2c70Lria_2L0lc_SN20)q_T)qwmS7qi0_rrLNT_rTmNN2c2_7m207cmLi2__c0S0N7o7T_qO27qNqS2LLTi0L_SaNm>0NccrT2)T)SiJm)riaSY)c0cS6mN)N_Ti2_qSm7m7a_L)r_Sa_mT+cq)i0L7)a0aS72S0imSSSL+007N0NLTraT202L7r_Tr0rpSS__)mN00a7T7T7DmmLTaTrTSiLqTmc0NamTT:mLa0rcLmamrmS_LaTrcaN)0q7rqaa2r2ST_T_ic20r.rc)2mT0)aiTiN2LS0ircmSm_mA_ca2rTrq7207cmSi2ri__LrU7c00cNL)2qimcmia7aTr_L0c7_a0_NN27m27c2ii27rrcrNL2cS-a(LN_T2)c7)2_maamL)rfLS_2c)cc0iT_m0qgmS72i)iNSiL_e)3_NSNm)0q27SmamLa_r2Scc)__faNmq)T_)rq7miLTiTScSi_7_)c_00q2)T2c2i777qi_S0L7_0ccBr02Timcqi2q7TLriirmS)_2Tdci0Nmr)m7qiqSr7rirS0SL0Z9Lc7Namb)L7ii7r7Lm_0x0NR_&-7qr02TLam2T2Nr2L)wrrrLr(06Lqe0,)Sq2m)mcaii__0S=_S.2N)NNTi)_2)2_7S7mr0S2pSLL00cqqS2im)q_aim4i)iqSicc_LdNN00iT)m7202L7rS7rTLcLig7M)N_T022q2mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cSVayLN_T2)c7)2_maamL)r_SrL71iqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m7qaa_7NL7_2,cLiN2Br0c0N)2mS22mN7 _mr2SNLFTmc2NN0U7mq22NmvLmi2rNSp0ms2cTNcT07rq22LSmS2L2_mLN0r_rcr000L7oqm2777a_imcmSS0T-L)r0TmT)7armaSTic_rr2NT_aTrNiq)Tm)727m_7m_miOl0NTNSg)Nm0iTrq2iRmmraL___NT_T_S)9NiTN7r7SaqmrLrarrrL0LLT^ci0Nmrmd7m2rSr7rirS0SL0:viNNq_2_Tq7i2ISu7{iOS2LNTTcNcSNL7TqT7_iSrSLr_qPr0T3T{Sq80i)Nar2TiqS2_rirSr_0_L)kN7qi)q2)2c7iSciL_2LN=c_rN2)ST7m0qNaS7a7Li_S2LcN)%_ca0m2))L7im2r)arLirLc)FN3qN20_T7mS22mN7tSSr2STLcZ0)rNaq2)07c2mi27aLcriSq_TTrciNm0))2ay2)iiamL)r_Sa_mTMc_Nr07)iiT2_7qLxL*_rSs0I_>cO02TNaTq_mqS{amLi__caTTfTNT0iTqamqRi0S2Lq_cSiLm_)c2qA0q2iqia)m_7aimV%S_Lr_7ci2T0_)qa,iTir7G_:i^Sd_2VNqT0N0STLiTm0i_SSL-8rcqN_)TNTNSmo)i2Nrr7T7qLiU7NGLDg;N20N7Tq27_2ir2SirNcI_0_acmqE0L)Sq7m0m)7q_r__c7Lj0ccLNNT0)iq)a7707Lir_7S0c_IcN7NST_m)qaaimSi)rNSicc_L6NN00iT)m7202L7rS7r0rZSS__)mNiq00_mi7_mqLTi2iLSr0TdNNcNST2T7)aiQr0SSiT_)S_Lanm)YN_0a)maV2_maam_{rmFiLVT))02mT2)Nq rm72aTicS0Nr_Tl)N)0iTTaT2qi87cLmiSQkSi0mc))z0mmmqNacma7)aqfrSac20mTh)amT)T)Si(miaN_r_L}qci!q)Ic/06)2qNrTm_aq_P{Tfac_!aqTNTTT)iqqrm7aS0i_SSS7l0.1NS0a)0m22T7c7Li2_YSNNm_5TrNa2)m07r227)7Nii,0c2LqNiHLq)202Sq2a0mmaSaLS037_0_YJSN_mm)0qarT7NrL_0ocNmLmOmc_NamrTLq_2m72a_a6cmL0_a)TNN)L2_aTqTmT7iaqEmSm_)__cSc7T0)2mi2m7)7_iSiaL0_28Sc20)No)iq_a)mqriaL9)c0cS;2T0NmTSTL20a77q7aiiS0SSNcQicq0T2c)r27m0ac7Sr2Siu___c7N0Tc0Lq22iic7NS2iaccc_N7c0T_0T)7)a2_i)m_aaimS2LmTmnmcLN_)07c2imm7)i2.?Sj_SA2N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSLn007N0NLTraT202L7r_Tr0r&SS__)mN00a7TqN7FiiLTaTrTSiLqTmc0NamTmTmL2aST7TiTriSq0m*mN)N_TST720m2iiamr)r_LSLac0N20ST2q))kmi7_S)iq_iSL0)T0TS0220)m2S2La0S7r0r#SS__)mNmT)T_qSq770a2SiriL)L_PSoa00T22S)La0mqSSLi_)S_ci_,N)NqTimcqi2q7TLriirmS)_2TVci0Nmrmr7mmNSr7rirS0SL0XVLc7NamKq07iimr7Lm_cuqNt_*p7qr02TLam2q2Nr2LN{rrrLr^06Lqd0/)Sq2m)mcaii__0Sf_SQ2N)NNTi)_2)2_7S7mr0S2ASLL00cqqS2im)q_aim;i)iqSicc_LJNN00iT)m7202L7rS7rN__cIN7wcNT02Tmq0irmarqLi_iczLf_7)rN20L7m77aTi2aN_rirSr_0_L)kNiTN7r7iamiiaq_&i*SV_2uNqTN_Tq7;qLqai_S_oTrTLT_ikqqm0qTc)Nimm2r0SV_qBzc20c)mNm0c7T)_2qrer_7aL_Sa0T_TcTNi0q7mqqa0r2SqLcrLSN_0%ic))7T0TLqra77TLTimRmL)000)NNNqT2)_q7aS72aNiP_SL2_THcN02rTr7rq=ih7SLiLSS2LN_z)mN20TTcq0irm27L_mrqrNc20q)rcr0r)0)LiomL77aa6;S_ci0aTuqm20mqas2Dm7Lri2rLNm_q_NT2qTmrTrqrm0mLLOrc_iSSo)__NiqcTL)N20mi7)S7r0rLLrN7khT_0c)7)S2_i)aNaqr2S_L7NSc2NN0x2Sq22Tmca0_rrm32L7ccc)02qS)2qN28Sma2iNrANm_2nTcc00mr)2qLrm7qSTL2WmNrLr#rN0NLmM))7im2r)a_irr7LiTTO_Nq20m0mr7_maLTaTrTSiLqTm:aNi0T)0qiqrST7_iq{3SLSaN_TL2T0T)Tqi2qSmacL0rcXS_a_Lc_02Tcm)q_2a7mS)a__iSaN)__caNmT2)mim2mmL7_r06cLi_mQ)N22;0_miqai)7_aarmcVL__acmqK0_Taqmi:mLriiqw)c00mW2cNN^mm)a)L2_72acL)r_Sa_m0)c_Nr07)iiTmNi_SkL7rcLT_2/mN02rTamqaiiiSyali7crL2_L)m)7qT22qNir2r7ri0iLchLiDN)r)iqm2iqqiK257Bi2rNNTL_/q),NLNa2_7_rTmTaTiirqNm_q:ccN2mT2m07ziqrXS2_ccmLm_c)Tc_0qmhm_)aa_7a_TiTSTLi_q)mNqq0m27qacmL7Ni0riS)c7P0bLNrq7)TaT2mrma)_0_)LNLq32c_N7qS)2qN2ZiSa2iTrcL00r{r)rNs2d)SaiaS72aNiRcmL2_TycN02rT2)LimmqmNS2_qcrSr_rc0cL2WTL)7qar>7_Si_a&xNm00Tqq.0;T7ar22mLLmiqiNk2NTTrerNrT0TLa*mcii7Sr)i_LiNcALcN00Ti))77m0mLarL7r(f__cc7cS0_2)qNqqm27_a7LSS2LN_Y0SN20TTcq0irmmr2a7ScS)_2NSc2NN0u7mq22NmuLmi2rTSc_0Trc2NLmm)q7Ta2rmLrarrrL0LLTfc))iT2m)q_2rm7aiyTr_Lq00T0Tr)_TaaTqTmT7iaqYmraLi_Tc0NiNr7T)_2qrd7L7aL_9L0T_TcTNi0q7mqca0mcrSiaiLS__26cT)N_0a)m7)q_ii7aL)i_SaLmM2cm2m0mTL)_m0rcaiimr)L20+__TiNa2))_qammS+a_iaSmN^__yaNm2yTLmi2qr)S0_mr2SNL.Tmc2NN0U7mq22NmKLmi2rNSE0m.2cNNxmm)2qN21Sma2iNr(Nm_2xTcc00mr)2qLrmr2SaLq_iLq0=_pce02TNaTq_mqS?aLLa__ci0N)mcm0mT_)airma7)aqHrSNc20TTqqTqSmqar2rm)Lmi0raNTN002-N)2TN7r)r2r707L_er?LS_2c)cc0iT_m0q*mS72i)iNSiL_:)5_NSNm)0q27SmamLa_r2Scc)__paNmq)T})7ir2L7_aTi2rLLqTmc2NN0x2SqaqLm_a2ic_)S_La!mT)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTi)q2Trr7iami)S2N*_icNqr0a2qmia2iSLTaTrTSiLqTmcqNc0N7mqTa0rcr Lx_7cT0m8mcc2T0_)qa^a_rcruiacTST_T3icq2m0A)c2cm2m&L=iL_SLq_cfNqm0T207Tari7SXasi7crL2_L)m)iqTTramqmmm7_aaprS2LLTmcTcNq2mqarqrmra0aL{,SY_Sb2N)NcTi)_2)2=7Sa2r)rNLi__c0T20T)c)i272T7_i0L7S0SYLS:_qm0m)))_2S27a0i2rSSm_)__cScaT0)2qi7_mra7i0Scrr_2ziTcNNq2Taaca_i7a0S_rTL7LaD_T)N_0a)maJ2_mr77iicTS__qTjcr)a2_m_iT2T7TaiiqcmLq_cHNqmNm207N7_i4r2LT>mSmLcTT%_Nq2wmTmr2Tr,m8atr2SN0T(N0_NiT7T)q_2r77aNi__0SG_S.qN0qrTTqcqai7r2a__2rq iLLT))0)ST2m0qmmSmLi0L7SqSa_ic0cSqcTi)q2Tic7ri7r0LcSS<2ciT_0r)7q0mc2La2ii_cSNc2_a)c)_q7)0m_2T777ai__)LNLq82c_N7qS)2qN2oiSa2iTrcL00r(aT200)cTS22mTacaar2_iLmG)xLNi2TTrq72Nrcr_i2__rLc0_qTS)iq)T_miq{7)7qii_cSiLqgT)rNi0q)Tar2imqaT_rrLSN_0pic))7T0TLqra77TiciiS7S)__c0)rq_2c)LqNm07ia)L7S0SL_r07N0N(0S)_immma)a_rSr7_0O2T:q0q)T_)a2mr37_aarmcFL__acmq-0_Tr)72iST7_iq4{+Lc_NKT0NLmmTmqm2_maLri2rLNm_q0NTSqmmrTrqrm0mLLQiiSNNrN7TNTa0qm(T*qum27N_TrTLcLie7e)N_T022a)2m7)7_iSiaL0_2NSc2NT0c)0ar22mLLmL)_*Bm_NTr{rNrT0TLap2Lm77a_OrrOiN70Z)mq02)7,q,27Sra2iLcmLqLN02)cq7mJTdqZm27N_Ti_SqNm_VcSN2T)Tcqi2_i0r2i0Scrr_20_nmNm0_Taar2Ni27a_c__ 7_0_^fSN_mmTL702_7S7ar0_7L0LL5rT70q0a)i202SrcaiiqSTcc_a%)cq2rTam2amiKri_TrTrSN._icNqr0a2q7qir2r7ri0iLc+LiPN)r)rqq)Narqrmra0aLe5Sg_S52N)NcTi)_70257Sa2r)rNLi__c)c_0S0mq022aSmLS0iqKSciN)p_TiN6)))q2iic7iami)S2N>_icNqrq_2mqNir2r7ri0iLc5LL_7Maq^0r2i7aaBrmSNLq 6SML7Trc2NLmmmm)Na27NLrarrrL0LLTdc{0ST2q)qcmi7_i)i_SSSa30c2Ti0m)))_2S2ma0i2LSSaSL__c2Ncq)T_)a2mi)78iSr2L)Lc5ic_)00J)Sq2m)mNaii_QcS__S_mN0)70a2_qNi7r2Scii_2SrlcvNN2)STaTLq_m27cS)i_raLmN)J_crN7TiaT2T7c7ii7i)S__0B7c00cNL)2qi7_mra7i0Scrr_2KiTcNi0q)Tar2imqaT_rriSmL)(2)WNiTN7r7Fam7NLrarrrL0LLToci0Nmr)a72airaL9ayr%L2_N)TNTTcTiq7q)m_a0i7r0LcSLy2ciT_0r)7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)S_Lr_7ci2TTTqcqim7m)a_r0S7L0jc_LN20iq_)i272T7_S)iq_iSL0)T0TS0220)m2S2La0S7r0rLLrTTc0cRNST_am2m7)7_iSi7L0_2FSc20)0N)iq_a0mWaSi2S)r+_iI_T)NqqiTLa)i0iSa2L0rmLSLLc0T7000L)riTm0mLarnTS0SL_r)TNqNaTiq0qSic7iaqrTFcLi_m;)N22VTL)7qars7LSi_rcTc_TmcmNcmTT_qqi^mLraLalvrYLV<2cN2T0_)qaBaUiaaq_GiXS5_2?NqT0T)c)i272)7_i0L2ST_c_ic7cq0_)0q7207cmri2riPcLNN2}aqcq_27q07_mTa7aar_V)L__rh7NimTT_qqiOr0rriqUOrZLPj2cN2TTNTS)LrTm>r_LLRTcrNq0aqT0T0S7*qimNSrSraq_iLq0d_Acz02TNaT2T7c7ii7i)S__0G7c00cNL)2qi7_mra7i0Scrr_2yiTcNL0N)0qi2)i7a0aLrr=7_Tccci070))_20a27TiciiS7Sq__c0))00)cTr22aSmLS0iqjSciN)?_TiNk)))q2iic7LaNr0SiL)N7c0cL0r27q0q,2S7__mrmL)L_sSR700T2)Sq2m)mNaii__0S,_S.2N)chTi)_7)2_maam_Er_Sa_mTMc_Nr07)iiT2_7qLo_T_rLq0P_pc+02TNaTq_mqS8aLLi__cLTTHTNT0iTqam2m7)7_iSi7L0_29Sc20)0N)iq_a0mkaSi2S)r{_iw_T)NqqiTLa)i0iSa2L0rmLSLLc0T7000UTSq_rm7mi)i_SSS730c2NS02)))N2im_r0a_rSrm_0N7/aT_0Nm772acmir2arScSN_2NSc2NN0I7mq22Tmca0_rrrL7_0ccsS02Tiqcqim7mqa_r0_2LT<cDiN7NTT_q0772ai_aN_7v2cc_i02crTcTNq27Sm27NasxmS2LN_>)mN20NTEam22mN7=_mr2SNL=Tmc2NT0c)0ar22mLLmiq_T SNmTrfrNrT0TLa>2mm7a7i_rmNm_200c_0S07q0qxmS72i0_rST_c_iT7)20_m2)_qr277i_TirrSLS(0Hrqr0N22q0mc2Sa2SSiKSc_ch2l-q60c2iqmm)mqaiLcraS)LqTrci)20a7c7_im70icaLS2LTLSTQcrqaTm2iqr2cm)ariLLTNTLSTmNTTcTiq2a_m27NahLSS2LN_9)mN20NTkam22mT7ci05rS2LLTmcq)NqLm0arqrmra0aLkxSi_NTrca)m2Nm)afq?m%a2iNcTLTMcEiN7N)T_q027m0ac7Lr2SiU__ic7cT0_2))_qr277i_Ti_SqN1NLT)TKq0TLamqmmm7_aaxrSaL)_q)rNmq2m)7iiTiiS2_rrrS)0mG0ca2TTN2,7aarSm7mimr_Sa0r8ac)Nqmr)a72imr/Sa%TSTSS0MbiNN2rTamq7ii7S%7/iXS2LNTT+_Nq2W2zmr2qrFmka=r2SN0T__cqq:qL2aqqiW2>7Vi2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TT)c20rr7ri7r0LcSSP2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7)0)L2rSTa0atiSS_0mh0ca2TTN0L70iNSm7mimr_Sa0reac)Nqmr)m72i)rmLTLiHmNr_rt)qm00TaaTa)qLr0aLemrmLm__5aqr0r)7q0mc2Sa2iiL_Sr_7s0NccLT2)i2c2i777Ti_S0}7LaN_cNq722mcqia2mriciNS2RS_a_Lc_02Tcm)q_2a7mS)ixSSL2f)lcNi0_20):2Sm2a)aNriS__)__cScmT0)2mSqLi07qLS_id)L_Nie50)0q)i7c2LmNa0iir)s7_0_Lcr)7T0T?)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2SSL2{)_xNi0_2))q7i2LS)L0LSS2c0_mcScLT027q0qLmrLTi0iLSr0TE0WIcS0_7mq02aSTSmSL_0SL0m_mcmN_0a7rqrm770icaSS2Lic_<rN700)cTL22miacair7rTL_,007ca)_TN77a2ic7iS2irLcLNe20SN20TTcq0irm27L_mrqKNc20iT7q{NYT5q22NST7qi2i9S__2_m)}NiTN7rqaamrqLrarrrL0LLT-cE0ST2q)qcmi7_S0i)SSL2?):NNi0_2))q7i2LS)L0LSS2c0_mcScLT027qqqamia0aS_cSiLqkTTcNrT7)02cqS72aiS_rrL7_0ccAL02Tiqcqim7mTa_r0_7Sac_GN)7q22c)i722racaNr2_SS2_N_zc_NYm.Tpqq227iS7r0rWSS__)mNmT)T_qSq770a2SiiSL)L_tSea00T22S)La0mqSSLi_)S_ci_AN)NqTimcqi2q7TLriirqLT0r.icq0Tmr)iqqmTSraLiNS0Li_)07N0NLTrm7227c7ii7iqS__0N2cT0c0i)7))2_70r7iqiaSi_0_STcNi0q)T7c2imm7)i2M<SLL7_a)wNLqimraTaLSmamiccTS__qTpcL)aq_mSiT2T7TaiiqcmL0_a)T)T)/TaaTqTmT7iaqumS0LaTTTNTL0a7T)T2Tmi7q_mrmL)L_!S-700T22i)Sm)m_aSaaS0L2cS_LT0Nq2Smi7)2_ii7Zr)rqLiNcZicmN)T27oq mS72i)icSiL_N0PENS02)))N2im_a)a_rSrm_0Q20SN20NTQam22mT7ci0jrS2LLTmcqcNq2mqarqrmra0aLWnSLL7_a)KNrqim77rimi_Sr_FryS70r=2cL2m27TN72mNSr7rirS0SL0MtHNS02)))c2im_r0a{rSS2_)_NciN_T)T_qSqm70a2SSiLO0Lq0STi))0_2i)lm)mqaiLcrLSN_06ic))7T0TLqra77TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTNm2qarcr_S7r0__LT&7-aN_q))N)q22m_77SSr2SNLPNSc2NT0c)0ar2r77a0rciSL2_iN_cr07T0qc)Lm27iiciiS7ST__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TN)Dimm27NaoJmS2LT_cc0qr02TLamariNr2iN.rrrLr#08LqV0!)Sq2m)mcaii__0S}_Sz2N)NNTi)_2)2_7S7mr0S2FSLL00cqqS2im)q_aimEi)iqSicc_iGmc)02m()i2Nrr7aSqLi3_cSTTKTNT0iTqamqami7Ti0rirr0T__cqq(0L2r7aio2^7^i2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0a0L)_22mcr)a_iaSmc)_8cSN2T)Tcqi2_i07xiSr2L)LNJic_0)0_)S)mm072rSaL_0SqNS0iT)N_qiT92)2q7iScairqST_0WTqTNT0aTiq_aS72aTicS0Nr_rc7N0Tc0Sq22ia_7ci7r0LcSL62ci)c0N22)aici_r7i0L_ST_7_ac_))0_Taqmijm_7aimdlS_LaAm)HN_0a)ma*2_maam_vr_Sa_mTIc_Nr07)iiT2_7qL<iLiah_NaTcqmNmTm)_qarr7aa)iqcrLNN2TT)m2T2r7Nirmr7)_mr0Sa0T0NTmcNq2)Narqrmra0aL*YSx_Sx2N)NcTi)_702)7Sa2r)rNLi__0)NNNqT2)_q7aS72aNi!_SLm=)!_NSN7)0q27imma)a_rSra_0=2TiNmT)T_qSqm70a2SSrarLL_k2cc))0_Taqma)m_7ra7riNT_Tccci070))_20a2m7iciiS7Sq__c0T7000L)riTm0mLargTS0SL_r)TN0NLTraT202GmSa_+mS0LaTTTT)qqT22qNir2r7ri0iLc}Li:N)r)i2T2rm_2aST7TiTriSq0mW0ca2T20mi7T2LSm7mimr_Sa0r#2cL2mTqmT72i0raL5a9rEL2_N)TNTTcTiq7q)m_a0S2rTLcLig7XqN_T0)7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)L0_SY2N)NNTi)_702K7Sa2r)rcLi__0)cq)i0L7)a0aS72S0imSSSL-007NTTcTiq7q)m_a0S2r2LcLi-7bqN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ciOmN)N_TSTa20m27Sa2r)ijLi__0)cq)i0L7)a0aS72S0imSSSL&007N2TcTiq7qqm_a0S2rTLcLi+78)N_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ciTTci070q)_)Na2rmL0L)rq9iLLT))0)ST2m0qmmSmLi0L7S2_c_ic7cq0_)0m22T7c7ii7i)S__0N7c0c#NST_am20maLTiNLL&0cMN_)rcr0r)0)LixmNa0arriL0LTTrc2NLmm)q)Na2r0Sm_-iQS3_2gNqTNr0S)S202rSraaL7ST_c_ic7c)0_)0m22T7c7ii7iqS__0A7c00cNr)2qiacmNr2aa!c{_c7y00_NTT7Taq_a)mIaSi2S)Sc_iO_T0NETS)22)2N7ia_r)r_LSLmc0N2)S0Lm0qqiSriS)i__iShl)BqNiqcTam2207cmSi2rTLcLa(20iNmT)TLqiiTmqSriT_hSaN702T6NiT7Tqq_i2ri7aS_rNc7N20cci)20rqcqNm2iSamr)r_LSL7c0N2)i0Sq)q_mSmai0r2_SSLN0Xq)Sqi2))_7i2Aa)aqriQcLr.7c00cNS)2qi7_mra7i0ScrL_2OiNcNiT7TTq_m0i77aS_rNc7N20cci)20rqcqNm2iSamr)r_LSL7c0N2)iTmq)q_mSmai0r2O7L2v)_sNiqcTNm2qarcr_S7r0__LTI75aN_q)TIqS227)7ciir_p0LI}Sc20)0N)iq_i0m9aSi2S)rg_i8_T)0N0q)2q_27iSa2iNr6VSLL00c_0S0aq07720mL7riirrNrLr8Nc0022))_qr277i_TirrSLSy0Xrqr0a27qTmcmia7a)r_L0c2<TNcNiT7Tqq_m077a0rcirL2_i0ccN)20a7c7_a770r_iTS7Sa__0)cF0ST2q)qcmi7_S0ibSSL2x)xNNi0_)))_2S2ma0i2LSrLc0_qTS)iq)T_miq.7)7qii_cSac2h0NccST2)T2c2a72riimS)SL_iTTcqqrTTm4qai7r2S9iiS7Sq__T2)iNaq_)Na7i2rcaiL2rr_c_Nc2TS0m)))_2S27a0i2LirS_)__cScaT0)2mSqLi07qLS_i,)L_Ni=30)0q)i7c2r77a0rciSL2_iN_cr07T0qc)Lm27iiciiS7ST__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0m)))_2S27a0i2LiSm_)__cScaT0)277227)mjii_cSNc2_a)c)_q7)0m_2T777ai__)Sy_Sd2N)NcTi)_702Q7Sa2r)rNLi__T0cz0ST2q))#mi7_S)i_raLm0B:_ca0mmt)_qr277i_Ti_SqNV_L0iT_qim0amqmmm7_aanrSr_7:0NccST2)im_q)22rSi2rTSc_0TrcTN)T))iqTrTmTS1imXmLNNx;_)mN72e)T772rmSaSr0rrNr_N02)mqc07)rq_2A7i_Tia_LN000)mNm0c7T)_2qryScSriLcoS>_1c2NNmTT_qqiMmqraL2=HryLuW2cN2T0_)qa5iNirr_iNcTST_TRicq2m0a)iqTm07i7r,Tr_Lq0J0Lba)_TNaTqTmT7iaqYmrLc002Tq)c0LTNq02im)r7i0iLSrc7ATNcNTT22i)Sa)2_7aamr2Sm0m_m.Lc_T0mcqi2mm)a2_;rBLSL^c0T2N72c)iqqmTSraiimr)L20%QiNN2rTNTq7iirSo7OihS2LNTTcNcSNL7Tq07_i_riLr_2pS0TWTxSq?0i)Nar2NimS0_rirSr_0_L)DN)qi)i2)qf7Saqr0S2>S_a_Lc_02Tcm)q_2a7mS)im_iSmI)/rNiqcTL)N20mi7)S7r0rLLrN7c0cXNST_amqei0mjiSrTL0c7U0ILNrmT)0)L2rSTa0a-iSS_0mo0ca2T0a2!70i0Sm7mimr_Sa0rg2cL2m2rm0722aSr7rirS0SL0<_?Ti022))_qr277i_Ti!__SSN7c0cL0r7Tq0q*2S7__mr0Sa0T_a0L)0207m)m2mm_7a_riLS_LmF2c_cHmm)0qarTrqmLL0rqNmLm3mc_Namr)_72mTrcaLiNS0Li_)07N0NLTrm72Na_mLS7i0rLSr_iWrqrNrTN)022i)7_ari7Si0T N0_cLq7)0)L2rSTa0aLrrNT_0_Lcr2T0a2_qNi7r2LriirqLT0rYicq0Tmr)iqqmTSraiimr)L20{niNN2rTamqaTi)S&7!iOS2LNTTE_Nq2A2y7N7=maLTaTrTSiLqTmcqNc0N7m)Ua0i(S2L&_2c00mKmcc2T0_)qaYa+i_mLL0rLNmLm!mc_Namr)Tq)m)7iaTxTran__ic7c)0_Trq7qam_Smaa_YSmNT_qTS)i2TT_qSqa70SiL_rarLL_O2cc))0_Taqma)miaN_TriL7L)*_TTNHTS)22)q47ia__2itSg_2(NqTNaq_)Na7i2rcaiimr)L20JvqTi02)))N2iic7iaqrT-cLL_Nc0Ni0)27q0qLmrr7i0i&rSL_Tmc0Na2r)02cqS72rrimS)S__S_mN0022_Tmqm2_maLriN_2Sa0c0_T7000BTSq_rmmLS0i_SSSao007N0NLTrm7202L7r_Tr0rfSS__)mN00a7TqN7Li0rYLqArrrLrW0{LqQ0LT7)ai^mmriL7_Scmc40r)}NM077rq22LSmaqaN_2cTN)TvhYNtT2)NiT2_7qLmi_SSS7u00mNTTcTiq7qTm_a0LiiTSTLi_q)mcLq0Tq7Saii)7_ari7Si0T_a0_NiT7Tqq_a)m_7aim_)LNLqh2c_N7qS)2qN29iSamr)r_LSL7c0N2)imT)Nq)2TSrarr7S0_cLLc2Ni202)qNqqm27_a7LSS2LN_}0SN20TTcq0irmra7i0ScrS_2ki0_qm0qT7)miXm,aSi2S)SN_iO_)2)7T0TLqrrT707LircTL0LLArqT000zTSq_rm70aaxTSNZLN00Y)22r0r)r202LSMairNcrcr0c0rT_0a7T)T2Tmi7q_mr0Sa0T{N0L)r2c7m)m2mm_7a_rr2SL0m0mTr)mTN7r)r2r707L_grsLS_2c)cc0iT_m0icmTacair7rqL_4007N0N/0S)_im2Z7cicr2rIN6_r0SNq0cTNam2qi0STLr_mc*Lz_7)rN20L7mqqaTrNLmamrmS_LaTrc2NLmm)q7Ti0Sm7mimr_Sa0r*rN700)cTS22mii_arr7S0_cLLc2NiTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2STLc.0)rNrT7)02cqS72aiS_rcL7_0ccXL02TimcqNa2maLcL__7L0c_WTN7NaT_m)q_2a7mLZi_rrS7_i)Tc_0qmy)L7ra_rL_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_pS/a00T2)Sqmm)m_aSamS0L2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_Nr07)iiT2_7qLM_T_rLq0e_Zcd02TNaT2N2SmL_Ti7__c_NrTr)2qS7TqTqSrh7iiN:rSacm0T)rcr0r)0)LiHm4aSi2S)Sc_ij_T0N/TS)22)2N7ia_r)r_LSLmc0N2)S0Lm0qqiSriS)i__iS*f)6qNiqcTL)N20mi7)S7r0rLLrN7h.T_0i)7))2_mra7a4r_cmLuDScTq)20)ia02LmNa0iir)b7_0_Lcr)7T0Ts)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2SSL2Y)_-Ni0_2))q7i2LS)L0LSS2c0_mcScLT027q0qLmrLTi0iLSr0TV09LNrmT)0)L2rSTa0aLrrNT_0_Q&SN_mmT3qcmc727f_ rLcr_TTTN0qrTN7T)_ir7aLTrcJrSS0T}7TSNYTcqc222tSHamLi.rc)LSz5N00TT_amqFiNS2L21rSrL)Tmc0NamTmqmLa0mmLmamrmS_LaTrc2NLmmTv7Na2r2LrarrrL0LLTIci0N2_mS7m2rSr7rirS0SL0%nNN0NrTiq0qTrr72aL?mkaSNN2GrqrNrTrq0qLrg7rSir2F)_0Ni L))TNTqq22_m7rSi2rNSAcShNT0NrTST720a7m0r_imS7ST__0)NN)i0am))_2amma2imcmSmLL__N0qcTi)mq)m2S4arLiS2c)/00icLq)T_)a2mr{7_ari7Si0TzN0_Nrq7)0)L2rSTa0a}iSS_0mU0ca2T2T2JqTrTmTaTiirqNm_0#aqTqTqI)TiT2T7TaiiqcmSa_i.TN00i0raTq_mqSgamaa__ciTT4TNT0iTqamq?i0S2Lq_cSLLN.0ciN)q7)0)L2ri77aS_r)n7L0_LyrNi0r7r)r2Nm0a2L)r_SrL7PiqTNrq_70aNaS72aNiscmL2_TAcN02rT2)LaiiirTam;mrmLm__GaqrNLT_)m22m_mF_mr0Sa0T0T_L)00m7m)m2mm_7a_rrS12_Ncccq02qSTS702L7S72r0_7LqLa=iN0NS2c)iqqmTrca)L2S)M_N0R)qm0iTN),immTa)iNrirSSLTTT2qc0_27)0qL2r7iar{rrrLN_0c2))0_Tr)72iSTa)S_raL7LL-_T)N)qi)q2)q_7iSciirqLT0rOicq0Tmr)iqqmTSraTL2rrNcN_)TN0NLTraT202L7r_Tr0rRSS__)mN00a7T7TariT7L_mimSmL__a)rcL0_Tmq22_2fLmi0raNTNT0inN)2TN7r)r2r707L_fr-LS_2c)cc0iT_q)q_mSmai0r2_iLmB)h_NSNm)0q27SmamLa_r2Scc)__jaNmq)TiqNiTmra7i0ScrS_28i0_)00_)S)mm0ri7TiTriSq0m_LT0Nq2Smi7)2_mr77iicTSac_*iN7NqT_m)q_2a7mS)a_raSm_2PmqmNm0LT_20ic7iami)S2N?_KcSN2T)Tcqi2_7)7_iSiaL0_2Nicm0)0_)S)mm072rSi2rNSE0mk2cNN^mm)2qT2c70Lri2rLNm_q0N)c)MmrTrqrm0mLL&iiSNNr_a0q))qqm-TEq%m27N_TiqS2Sf__c2cm2nTiqNiriSri7aL_Sa0T_TcTNi0q7mqmm)m_aSa7S0L2ciZmN)N_TSTa20m2rLamr)r_LSLmc0N2)STaTLq_m27cS)i_raLmN)MRNS02)))c2im_r0a&rSS2_)_NciN_2qT5qS227)mZiir_W)S__aKmN20m7m)mqL2_a0LcriSmL)V2)5N;TS)22)2c7ia_L0rOLS_2c)cN0iT_7qq;mS72i)aVSiL_N)W_ca0mmw)_qr277i_Ti_SqN!_L0aT_qSmcamqmmm7_aa#rSaL)_q)rNNq2mT7TiTirSN_rrrS)0mg0ca2TTN0L70icrcLrarrrL0LLTkcmN7T7)_qmrm72S0i_SSS7&007N))_Ti77qii_r_S7rNrSSLTTUaT_0immq)irmr7)_mi}Sc_c52FDq:0_2iqcm)mqSii2S0+7_TcccN02qi)27)2_maamL)SNSq_2o_c7)ST2)Nq4aSmWacrcS2S+0y>_Ti02)))c2i2%7cicr2rDNn_cTrcLq0)N7>2m7)7_iipTSr_7D0)c)_T2m_a02Si27a_cric2N2TrcTN)T))iqTrTmar_LV_7LNLS_LqT00q_)iamm)Srari)cmSLN0zq)Sqi2))*2Sm2a0S2i)LcLNX20SN20NTHmS2a2L7_i2rc.)L__acm))0_Tr)72iST7raSrSL0LrTrci)2T0qc)Sm2mr7SiSS0Sr0r_S)mNaq_)LarmTacair2j6Lmf)B_)Sqi)07ia_m7r0aq_SS2N000)mce0c)cq2qKrI7qSi_r6)LL_7Aaqu0_2iq2iT7cLmimrcNTLaN_cNq722mcqrm770a_L0rcLSLLc0T7000L)r77m0mLar=TS0SL_r)TN0NLTraT202L7r_Tr0rLLrTTc0cL0r7Tq0qLmrLTaaL_n_N7_aTcNi0q)T7c2imqaTLciLS_LT_2oLNqmmT7qirT707Lir_7SrLSYSN0NrmrTS72immTaaiL_SSV_cccN2NBmxTZ7i2cm0S7irrSLSX0krqr0a227xair2r7ariSSS_0_r)rcLq27ca)a)rraNa2rNLcLT80ccNq2>TLa22mm7a7i_rmNm_m00cq2m0=)c2cm2m!L(im_icrLmTT)m2rTT))2)mi7T_Tr0__c?LrTm)r2BTHmiqcrm7La0iLSSSR__ASNN2rT)a022mLLmal_NcTSO0aTr2T0T)Tqi2qSm7aiiiVS0LavNqTN)mr)iqqmTSraTL2rrNcN_)TN0)_mm)_aSirmmSrrqSmN0_cT_q2q>0r7)2mrU7Ni0imriLN_a)TNi2_mm)TaPrcriS__<rrNmTrc_NqTT7Tqaq_maa7arriS7LLTmc{q_T0)aiT2amS7rgTra_c_rc2cT0TTi)qimm2r0a__S9rSm0TT2qr0N)7qT2_i0SrLmiTdLNT0_TcNi0q)TarqLm_7Ta2iLSq0m_mFLc_T07rqi2q7TL0_7LTr&ciNSc_2cTi)Nq rm7mi)_Ti!ci+0Tr)mNT2Lm.2NrcmSLi__rSSL0rc0q2q 0r7ma7i0r2LmiT;_0Tk21LNr2r)N)22N7c7Ti0rcSqNxFm)2NiTN7rqN2)mTLriNS7LT___rcr000L7uq_ai72L)_TiucrN_)TcaTcTrq27irTrY7rL_,7N2N7c0cL0r7T)q222rm_aqiLcsS-_q=2NimT)0)L2rriLcSiLmriO2cq)7000a)mau2H7SSramDcLi0T_S)7qm0T)a2Ni_S0aciN#PL20iTT9%qr2Sm27iirmmLNlmSiLN_-T!NqNiTqq)qmm27)aa%TSrNi__cqq,0qT7)mijmqaSimS0r&Ls42cN2TT02_qii7rm7TL!90NmLLc)c:0iq_7maTq^77SG_i_SL2_NUnqmNaTiTlq02a7N_TiTraSi__)mN20NTu7_i)a2i0ami)riNS82pLNrmT)T2ca^2rSqi_1mScNS0rHmqN2)mma2iim77a_DrcNm_25NcYq_2D7mqL20mLaSatr_SS_NTrc420T2)Lim2urNLTawpacXTToTNT0iTqamqamim&a0iaSN0T_y)rNi0q)Tar2Ti27r_c__NT_0N_)mN_2Smr)mi0rmaaLSP2Sh00Ti)Tcn2imriT2q727ra_rqSL0mx_q0qr0m7Ta)a_r0LTan*rNWk0kaNm2mTL)0qLmSm}a_iSSNNr9T)0N20L7m)L2c2.LmaLS)SM_i_mcmN_0a7rqia270LcLuircmNiTQcq0STmq072i^rr7mLrS2N0N)R_ca0mm>)N202mmiaNiacrSr_N40N22lT_)a2mr2SSi2SS_mLm_L))N_0q)Tar2r77SmaT_SL2Ng0rwmqcq_mma)2rr_L0icrNc?_2Ti)TcO2rmS72airr7m_0cmLi_NXX)g0q0i)q2)2m72a)iacTLr0i{_Nq2ATq)7qmr#7qiSrmL0Ss_Hc2NNmT)0m_2ir7SmaT_/c00m_LN)NsTi2_amiT2{Smir:i&SLmc)cL0iq_TLq_i^S0S)iL_iLq0)(cTS02TN){im2a7i7Fi0raLNTTxTcaNiT_am22mN7nL_o)_2b)_i0TNL2S)2)L2rSTaTrc_VrrN2R_)mNr2Smr)mi0rNS2_2{iS7LaTmc_202rTmaTi)i_S0_Ti&ca0bc0ca0mmm)Lq02L7S7%i_rSLN0rcTq002TLamqLmcm+_miLL)LyGi#mNm0_Taar2ii2a0_c_QrrNm0i)JNqTS)m20a2r{Sram_Mc_Nc_SN7qqT_m0ar2)acSLr2+LNTLSG_)J0q0i)q2)2m72a)iacTN2LDTxq00iTqqTaHmqSraqK0c2N2_)c2qm0c)S7im0rm7L_TiLciN_T0)2q722mc)rm77Na_L0i7riNc_ST2N))cmL22aS7qS0iLySS7N)b_ca0mmf)N202mmiaNiacrSr_NR0N22,T_)a2mr2SSSqrcL_L2!2))N_0q)Tar2r77SmaT_LL2N9yT))qTNZmaq_aSr_L0icrNNm_TT<c_NaTm72ami^7q7iiqS)Sm_2K)ca2TTc7iq_mqStamLa;rSm0Nc)qrNrTrq0qLrl7Ni0imriLN_a)rNcmT)0)L2rST7rS_rTc7N2Trci)22Q)2a)iT29a7LSrLciLST2)_qm0TmLqLrmmaaiajr0Sa_NTrN0222tTrami7r0S2_mrTcGTTc2cL0rmrqNq2mNacaTr0ScLq0Qcmq20i)Nar2Nm)7T_rrNL7_Tl_ErNrT0TLaU2_iia2_)WTr>Nr0_qTNa)c)r22aiSTS4ar60cm0207cq)_0))NaaiLS7im_0sTN4^0)c)4NL02mSqm7)7LiiL_SNL_0Z)0))0L2iqqi)rrS-aLrcrP0m6T)N0N0qqa)Fmra)r7i7xiL2LLErqTq2mr)cqNrmrrL2L7rq_cN_c2Ti2))Tm_74r)SNLqiqLcc_V20Sc7T)mNqi7_i1mriNrq,)L__acmq:0N)0)mqimN7a_rirSNL0V2)3N_0a)ma2iS7+rTSi_NSa0)?_cq0Tmr)r27immTSLr2KocrLmTc)Nq2m)))a_r07caN_RS2Ni0T_v)rqS22miar2mSN_mriSNLl0;cqci0q)))m22m)7a_TrrciL_eq).Nq07Tma.2q7Samr0i(S3_25NqT00q_)ia7immTSB_0cmSL3)*FNi)_mm7T)pi0rMLiLSS2LN_#)mca0i0d)0qamNLTaTiariL_Tmc2NN0Um_a)qta)icrNr_cS_2_Lcr2TTTqc7(qrr2a__mr)cSNr_m)NqcT772ai27maLmi_c0crLmTT)))_207T)%iiS=i0iaSmNm_L90cL0S0<)_qSmNSriTQ0S2LLTmhLNcNU7m)Lm)m=aiamrmS_LaTrci)2T07c7QqrrmSi_yrqLS_mc0T2qx2rTmq_mTS0S)iN_iN)KTTc)c2)2))c7i2c7a7_iaS7Sr_ie7cL2mmi))iTr27_aarmr0c7_q0_cL2qmaa)mTr0SmLrSTFbN)T)T)N_0a)ma-2N707mairNSa0r_rcNN0T27Xq_2a7mL2_Sr)_TcL_L?L2)T_)q2Trr7ri7_mrTcSG2TecS2)mTT&aimLr_L_z0ScLNTmnSqb0_Taqmi222aTrc_ZrrN)u_)mqTNb)27&mNr_a2iNr:c_Lc_0T7Nr0S)S202rSraiL2rmNT_qTrcT20m2m7qT7crLi2LircS0N7eT0cq_)2mi22rmmRiS_iL0NijLcac2)mT02imLmNrNi2ScS7L0Q0ca)20a)0qTa770r_abMrSL0T_r)iq_0a)i)J20maaNwTS0NT0NTq)a202))_qammS6aNr0rmSi_N^aqr0NT_7BiTmam_aar7rrLi_7ULqm2iTr)S2S707r_rrN 2SSL_cTN)T))iqTrT70r_LAircmNi0)cmN7T7)_qmrm7mS)iiSNNr_mTqNqNa)L)T2#77iSaSzmrmLm__Iaqr0r22)!aLmL7NrqirLm cN)c)qm0q)0a02imm7)i2=}SjciT))7N_0a)maD2i7NLrim#q12_aNq0TNaT7qrqTi47mLTirRaSq_2_R00)N0r2a27r0mrarr0rLN!__0iN22)mTmS22mT7ci0frSic2j0)c)_q7)0)L2rST7arcriL2ci0r#mqT2qmcqNm7maiciiS2cSNr_m)Tq2T_m0aTq?rrSSL7rqL2Lr__cqNLm*)q7Sm27Naf__cTN20mTa)L2Nmiq0qLmrSiL?9TSaS__ac7cr0iT7)Limm_SraLtTS%Nr_a)TNc2rT>a22mm7a7i_rmNmL-0)ci0NmrmS7qai72L^aFr;L2_N)Tc_0qm>7N7am2SV7/i?S2LNTTI_Nq20mcTa7_miLTaTrTSiLqTm4aNi0T)0qiqrST7_iqtRcTcrb2),cw0{)2qNrT7T7S_*rNL0Lm_icNNamr)a)_2a777riir7SL0mxq)r02mT)na_m07a_TrTcrSr_rc0cL2xTm)727m_7m_mr2j0Nr_aTS)LTqmwq2i0r0S__0QicN_aTT)mN&2imia2i2rIa2_0/0c_0c0_)i)S0a)i)&20maaNyTS0c__iT_)2qcTi)mq)m2Sxami7S7L__m)mN2q0mNqaiTmiS2L2p0k)LNv0:mci0NTaaT2Nr_S9i2 )S_N_NLT0N_2_)iqN2tSmSi_Vr)Sq0r0ZT7000L)r77m0mLarL7S0SL_r07NqNaTiq0qSic7iaqrT cLr_))mca0i0v)0qamNLTaahT^_Ni0r:LqmqBmr)7iTmNSrimyTSqN_0(cNqr20mK)SimmqS+ir^iL0LLQrT7N00LTrqi2rSr7riNr0L2N)}_crN7TiaT2T2SS%aNr0rmSi_N+aqr0a0_)a272r7ia7iLcmLq0rc2qT0Wm_q02aSTaT_rirSr_0_L)VNm07)7q_2mSma2L0^rSaNS0LNqqzT270a0i_S0Li_NSaNT0m(O)iqim272awm2S0L0__ccc_0i0Sca0i0#)0qamNLTi0__SiN_02TcNi0mT)q2iZmm77i7r_Sm0mb2T0qNTa7Tqii2r2L0L)rNL0Lm_icNNamT)Na_if72L)i_(_/LN0I_)_0iTN)fimiiS:a)iqcrc;N7c0cL0r27q0qLmrr7i0iLSrc7k0kLNrmT)0)vqSm_Lmi0raNT_0NLT0qTmmTmqm2_maLraLr_Sm_24_9P2mT0)aiTiq2LS0i_cmSm_mt_ca2rTr))im2a7i7!i0raLNTTZaqTq_mi7rqLrmrMLri7cTLN0rcmqT0qm_7h2NrrS0L3iScmLq0WcrqiT0TLqra77q7aiiS0SSNc.icq0T2c)rq)rmmaaiaxr0Sa_N)T)2qq27mSaciar_SL_rUqciN_T))q2TmN70aqrA7_aarmJ)S__aEmN20m7m)mqL2_a0LcriSmL)g2)(N*077r)L2_mT72aLrqNmNi0aTSqc2)mLa0iNrtSaL_{0c7NaTm)qq22aaT202L7rS7r0rLLrTTc0cL0r7Tq0qU2S7__mr0Sa0T000L)00_7m)m2mm_7a_rr2SL0m07TTN_mmTmqm2_maLraLr_Sm_2A_vB2mT0)aiTm0iLSr}TrTLT_ibqqmNsTcqc222hS/a_Lirac)_%o7qrNLT_)Tq22L7q_mrqriLqZ)QmN20)TaaTi2mm77i7r_Sm0m_LT0Nq2?)maT2_rza2_Tr_c_NyFi)r002A)iaii_rcai_ro2N0N)=NN0Nm0i)Nqarr7NS7r0rLLrN7c0cL0r27qqqamia0aS_cSiLq*TTcNT0)))qi2TSTa0S_iL}7Lr_ScS000r7r)rimm)SkaL_2S)0T0L)i)STm)ciT2q727ra_rqSL0E,Lc0NLTSTxq_2S7NLr__ruLc.cc2c*2?Tm7r2qrT7oLriLb0Lq09cmqT0_mUq2iTm_S_LGricr_00Iciqi2Sm7a2a770LTLryiUSLa*igbN00a)Nar2aSN7r_i1SNT_rTac)20m)7r2NrNmLLi_Srkc)__VaNmq)T_)a2mi)m_aaimS2LmTm%mcLN_)07c2imm7)i2?8SmL7>7c_Nmmm)2702NiS7kicScL2LgTBccqr0a7T)paim7Lm_NB_cc_rz)qmNaTiT3q02a7N_TrNr2LNDcQTN00cTq7.i0mT7)i)riST0T!NTKNT2m)T7p2Ni27a_Trrcm_0TTciqmT070aT2_rna2_Tr_c_0c0S)i)ST27m7Qi_rc7Li_rTS2LL9q)GNLmq)ca_rcSma=_LraN207TJc<2q0t7_icmar7i0iLSrc7-01LNrq7)0)L2rSTa0awiSS_0m%0ca2TT02L70aSSm7mimr_Sa0r>2cL2mT2m072aRSr7rirS0SL0*XHc72r0L)_qT22mLaqBmSmNm__TrcL02Tm7r2mr2r7i0iLSr0Th0hgcS0_7mqm2cST7qi2irr_Lq_L)?NcT0Tmq02_mTaiarS0LqLG3i)rcSN_7T)7mSS)icr)Src0N2cmT_q))T70amiTaTL0_m TN7M20iNqNiTqq)qmm27)aa&TSiNm_)TYNr2mTq7:2Nri7_iq8kSq0m_mcmN_0a7r)L2_mT72aLrqNm_2c)cq0iT2)Tqcm070aa+TrqNrLrzrN0NLm8)N202mmiaNiacrLiTTc0c;NST_am227)7ciiL_Sr0TA0tLNrmT)0)L2r22S_i2rNS80m,2cNNymm)2qT2c70Lrirr)NmLayi%nN00a)NiT2)acarr2S0SL_r07N0NLTraT202L7r_Tr0rLLrTTc0cL0rmi7raLrNSqL_';xTvKEGxk_QyWquBviytAGbkVjiATevKi={"l)N3MO<Ou6uMO<RZX3O6)ZN)6NlOllM)pOuRNuO&3XR6pN)O33Z","u3lulO&ulWRRpXuMWXp6O<6_3ZZNNuZ6X6pR__O&3ZNplXp_W)lWu<_XNpuu&__&R)OMlR_ul_pM_<&","Z&)_M3uW6_pZM6l&O3l3l__X_3XR))NuNXpXNMNp)lXM)M&66","ORp<RR_O)p_Z6ZN<63lW&u_ZM6WuMO<O)Z<RM<W)lpuZlZ)3XM<lMluXZZWX)WRR&R_l_R3lNNRlRN)Zu))NZlZN_XpNONMpulXXW3W6Mu)WZXW","R_3M&W6<ZpMR)XON<pNXWuRZu)3_lMWuRM6_ZZl_pOZ<W3)6<ZMl)Z6MR_l)Nu6OWlW&_63&OpWM)&WuRXXu_RNNR_6<pO_lOp&X","pNul3)OpON3WZO)R3&66Zp<)uZ3Z)3ZZROWXWlXNpOM__ll_<OM<N3ZO63)M_RX)RWZMZ_u6_l<_R3p3<&N<NRp_)","OlXM3RuW<l_X&)33_M<RpMX3&M_N&)MpZ&MpRuRlMl_ZR663WpRN3NXWOROu)3&&&pRX)pZl6lOOW6uuNRZNM","_ORl_Nu_NM3uW3NN<&_MZ3lWlN&RXXu&WWMM66XN<pX3<)X_uZX3X&ul))&_&&Xl<3)6Wu3u_6ONul<MMR<OWZN<3p3XRZN6lZ__ZluluMl&6R6XONM33&RZl6<<_u",")3&uRR<p_Ml_XR&66&Rpu63WZu_O<OOuWu_p6MX&3W&3_l6XN&uNllpu_pWOlMX3u)3","3N)XZXZuRp&OZl<OW__N<pMMR_u6<)u6Z&6W<MlX)RlNZ)&W6l3_Nl6&luu&6p)p6XMMu<&XMpO_3RlOR63uN3)pWO3_OuRM3plpN&XpXuu&WOOR6X_M_<R)6RRWp","6_XuNlNWOXuZ<3NO&l6WRZOOW&uXX&pZR<6)3)l6XM3RXMNWR__XOW_ll_u6MNR_p6X3__pORZ","3&<M_3_MllpRO3<ZNM<upZXl)&Wu3MZ_XM<ll)X)_&<NuRM&WO)<_R3&NXMNXXW36MORRZpl<<6&&u<R<pRM3u36Xu&uN3W_N)&lZ","WX6R3<6<ppN&MpMRW<<MpM_W<W<Z)Zl&lu&WpluNXX_pl3<_&NlZNOWMNllplOXR6X&N)l&W<&ZuXu_u6)p)<_MX<<<XMW&6u&Z)NZW3XpN&puW&O&O&6NMOW3NOuMZ6_p36MRpMWOM&3RMuRM3u&R<6&lZ&)p&puR<3l_lWXl_MXZpRluNuNOWupWX<u6_R3l)&3lO<&l<l)W<ZO<))Rp63_6OW)WOOuOpOW)l6lpll_&&M6&WWOZpNRpW3Wlp_MXu6lRlpONMu<ppZ6&_WplO_OZMpR6))_&W3lMZ_M6O_3&O_3l3)<NM_XW)R<puX_3ROO)p3l)uO3ul_<OZWWu3O<RlX&M6)OM<WMWXZpWRpWWlNZX&WXuZp)uOR_NM6<W)ZN))XX)6NXWpu3<3_&XM6<Zlu66Wu33_3XN3&3pM<pW<<N6)uXpWlNXl3&pW<pX_)Np)&Ml<Z&Mll3)l_p6u3pX6__6&O3Zp63lOlZX_)uO3XZ6W6OR3W)WX6XZWX3Zpl6llOu63ulp_Z_p6<M3uWlMR_l&O3uWplOO)uXMNO)uOl_Xp_)upuROM_XWW__p6pX&&MOMZWu3WXMlZWXlZu<upMOuZl<6Nu<6X_u_u)O&ppX6uX36W_3&OZp6Z33&_M6MWlMN3Z&W63RN&<ZM_6NX<&O)Ml6XppMOX6p&NRpl&N63uu__)N)MlXpu))NXuRl&lMZZXWO6XO<RMNZ36O)3MpOR33Z_WXMNpRXXWRuXXZlppM<O&uW&u36WXX3p<Z&pN&l<<3NN<RX_OpWWX)u)R63OpWXl_6pZ<)W<W)&pOllW)WM&upllXWlXZZRuM<)OM<u&_R)_O))66Z<XW3M<Xu6O)&)NO33RplpN3W<M<_&WOXXO&NZ<_W3RN3lulM)ul&WOZ&u<3O_R6_3uOM)pXlZM_XX&_N&WZ_)lR<lO&WW6lu6uWX)N6XppZNOXp&X&u<3pO&<lMXXWO<MXXNu)uWpNOp))Nlpu_&Z6NRWXZMN<Muu<&pX6<)_NXWMROuXM6u&ZlNRuWM6))Rp_)Mp<&R_ZX&M)pX<R)XWO)<<N_XMlMupN6ll6<ulZ6<W6&M6X6MX3M)p&RZNp<p6_Nl<&XuW3N)W<Wpl__WMuXO)uW&uO<<&M)&uZZ<M6Mu<pWMROpXup_O33<33X<l<6)XRluXMMW<Wp&M3pp_R6l<RMW_&lR_ONW<Z6puRl)W6<WWl&<W<W6pN3_3l_M36ONlZpl&3M_X<XlZ6p__O3X3XN3_OMWMpN)<XuupR)lW3Mup36X6<WN6W6uXpNlROORNX&3<3XWup&6_N6RN3pp&Z3R&p_3ZulpMRp3N_<u)ul&MWluR&&XWWZ&M_)up<R)OMM&lXp3NpX)MpNR6)_)OX)&NWplpRNO3ZZ3N<MuW_uMRuu)uO_3_<36_6)lR6OXZlW)3OM&XX3lZXW&Xull&<)<N_6Z&NR<Z6pu63NWOMNN)_l6_OXZMXXXN3X3X3lOMXMO63uOW)3RX&M_M&_pl6_MOuX&33p6u_RWpR_R<Z_WMuXZWpRpZNlp&ZXWWl_<W6_NROXO<Z6ZWZM)3u3W)ZOO6<3NZ&O3N3W)_M6p<)&OWuMMOp3p&X&<W6plOl66Z6N_Wp3NlM&))RpWWWu__ll)lWNXlOWpXpROOO)MOOM3WN6Op&&pl&ONOXX&W_XMpu&u&<X__W&W6_NM&<RuWlRu6&3OW<<3l6l6ORX3Z&6)&_RuOONM_ZZNX<u_&MpZpOR_3<&ROl6OZpZ6MplXZ_W3OlXXX_<N_)Wu<XMRlZ6Op_Z<ZW<M)lXO&OXX)l_<636OOXllWWZZNuOW)WO_)<ZRM3ZWNul&pOWXX)R)<uN)p3l_llX3R6__)pWRlONlM6lO6MW__uOXpM)OO6&Zl&6RR3W_u6<_NOOO3pXNRMuuM63<_uplMXZ3XOZl&XZR)XMMNZ)WXl<X_u__3<pW<XORZ&uW_WpMWX&RMX)6Mu)6X__pM6<3ZNN<pM&Ml3)<O63MONOMlOR33XX6W3Xl&uRuuOuOp_OW_puNZZZ)_Z6N_)<)pN<_p_X<lXXuXR&&N_3XpRZlMZZOXOMu_XWMRlWNuuRlO<3<uR)luRZX<MOp3pOpN_<NWlWu6W3Rl)Mlp_X3Mu<<lZ6p3lMX)M6)63M6&XlRN_ZZpXuRZO_ZlO<NMM6u3)l)l36Z6uZ<lul33ZX__u_<RM__)NZ&RuZ3Z6N3MRW_O33WXl)O&__6p)&M<RXRZ6OZpW3l3WW6Xlp_<WupZpM)WR3_<6&6)l33_X3O&)36Np_<pW6<lZRuZR6lZO)RNlpu_RNO<&XW&MX)MuNpR6NRZZ3&&Mup&MMR6X6uWp<)<3uWu__&<6&OXp)MMu&3)<p<<_))RNlOp)p6lpZ3W_Oup_&p3&X36pR&M<l<Xu6N3ZXp&pO)R&__XN)puW<pN3<3)<<63&Nl_<ZWu&)ZRpO<plXZXO)<_)M_6Rl_<NR_MR)R3<uWp)OO6_RNpW&Z&ZMZpWM3ppWW)uMZl3N&uRMNW<NXWNM)XZ)3OM<)6lW&<)OWX&6Z<ZRW6&l6MWRpp3M63NplWXMNO&ll3NW6<XZZ3WZN3&WW&)N<uWM&lNRl_XNX_pW&&&M&6XuX6uWp6Np363ulWRl<p&NO_6NW_MlO_36u6pZWRZlMWR)W6pRN_3OM<363XWu&pWM&lWO63M&lZOuZ36R_36_Z&MZlZW<",""};return(function(d,...)local b;local l;local s;local f;local r;local o;local e=24915;local n=0;local t={};while n<676 do n=n+1;while n<0xd1 and e%0x38c0<0x1c60 do n=n+1 e=(e*257)%43136 local h=n+e if(e%0x1208)<=0x904 then e=(e-0x14e)%0x50ec while n<0xe2 and e%0x4dd2<0x26e9 do n=n+1 e=(e+292)%43334 local h=n+e if(e%0x2a06)>=0x1503 then e=(e-0x186)%0x9594 local e=23188 if not t[e]then t[e]=0x1 s=tonumber;end elseif e%2~=0 then e=(e+0x11a)%0x345c local e=40971 if not t[e]then t[e]=0x1 r=function(r)local e=0x01 local function t(n)e=e+n return r:sub(e-n,e-0x01)end while true do local n=t(0x01)if(n=="\5")then break end local e=o.byte(t(0x01))local e=t(e)if n=="\2"then e=b.qasGtzIC(e)elseif n=="\3"then e=e~="\0"elseif n=="\6"then f[e]=function(e,n)return d(8,nil,d,n,e)end elseif n=="\4"then e=f[e]elseif n=="\0"then e=f[e][t(o.byte(t(0x01)))];end local n=t(0x08)b[n]=e end end end else e=(e-0x201)%0x720 n=n+1 local e=28359 if not t[e]then t[e]=0x1 l="\4\8\116\111\110\117\109\98\101\114\113\97\115\71\116\122\73\67\0\6\115\116\114\105\110\103\4\99\104\97\114\108\83\71\117\89\105\113\108\0\6\115\116\114\105\110\103\3\115\117\98\70\119\75\115\75\80\68\101\0\6\115\116\114\105\110\103\4\98\121\116\101\85\85\85\108\68\106\113\90\0\5\116\97\98\108\101\6\99\111\110\99\97\116\115\110\66\89\118\84\95\79\0\5\116\97\98\108\101\6\105\110\115\101\114\116\73\90\71\103\67\73\102\106\5";end end end elseif e%2~=0 then e=(e+0x3fd)%0x53a5 while n<0xbb and e%0xf3a<0x79d do n=n+1 e=(e*231)%14485 local f=n+e if(e%0x1086)>0x843 then e=(e+0x24e)%0x5a5a local e=57929 if not t[e]then t[e]=0x1 o=string;end elseif e%2~=0 then e=(e*0xbf)%0x409e local e=18056 if not t[e]then t[e]=0x1 end else e=(e*0x12d)%0x9938 n=n+1 local e=17662 if not t[e]then t[e]=0x1 b={};end end end else e=(e-0x1c3)%0x27e2 n=n+1 while n<0xce and e%0x2a56<0x152b do n=n+1 e=(e-242)%987 local r=n+e if(e%0x3118)>0x188c then e=(e+0x385)%0x9b77 local e=53905 if not t[e]then t[e]=0x1 end elseif e%2~=0 then e=(e-0xde)%0x6123 local e=51494 if not t[e]then t[e]=0x1 f=(not f)and _ENV or f;end else e=(e*0x324)%0x2a26 n=n+1 local e=10853 if not t[e]then t[e]=0x1 f=getfenv and getfenv();end end end end end e=(e-921)%26148 end r(l);local e={};for n=0x0,0xff do local t=b.lSGuYiql(n);e[n]=t;e[t]=n;end local function h(n)return e[n];end local y=(function(d,r)local l,t=0x01,0x10 local n={{},{},{}}local f=-0x01 local e=0x01 local o=d while true do n[0x03][b.FwKsKPDe(r,e,(function()e=l+e return e-0x01 end)())]=(function()f=f+0x01 return f end)()if f==(0x0f)then f=""t=0x000 break end end local f=#r while e<f+0x01 do n[0x02][t]=b.FwKsKPDe(r,e,(function()e=l+e return e-0x01 end)())t=t+0x01 if t%0x02==0x00 then t=0x00 b.IZGgCIfj(n[0x01],(h((((n[0x03][n[0x02][0x00]]or 0x00)*0x10)+(n[0x03][n[0x02][0x01]]or 0x00)+o)%0x100)));o=d+o;end end return b.snBYvT_O(n[0x01])end);r(y(211,"0T9t.e{P/^(<M)rU9Uer<^r)Tt.9(/)()Mte{te)<Ur<(e)T9)P(<Mr<TM.t{9(t<.^.MET)/M^9<Mr<oU.t^)<t/t<T}Mt){M<e)U9^.(Pi</))rTMMU(e(/^<xUJ.te/(eM)r.9t9MTe.e(fMMU^9<e.Mt)MUU9^.<^t<eGt</r{.e{)^rr/iM{^{.<^rrT{./lT9U/<<<reteekPM<Pr^E{eU{P.(P/)(W:te{r(Mr/99t.{)/.<(^tMtTr./PP(e)TTh.T{)(MU(9P9M.)t{{.MTUTTr/r/M<(r{tTt/{)<<PU()h^t/{9(9U/9.tU{(/trtrUM/U/e./.(<)/*ee9P.<)MUze9e{P<e{<^^U{9&ee^(M/TPt<ePP.^Mr^<.r9t){r^(UrT^tTe</()tT9t{U)9</{<PrTteer(^M)U<T9tT{M.{P{)_x.tJee/(r^Ue9{./(<MtUr9er^TPPt(9)ttUe(P^^6rTr)9Ueet9{s<)r(T/P(^.</U9tT../((eP<(<Rett{9^&<<9{e^{)(_MMU/1{ePTr.)(P).ae9)^<MMr{9/.XeM^M)/^.M99TeBP<M(rt6re)/U^{){T())&<{)^^M/ttt9/(/(rtrE9^.99{e{<z)<Q)t({P<eU59t9<eP/^<(rTM^U/ePPr(r)^T(.{PP(t)(aMtMPMtU{)M^Ue9{^t<r<)U)9TP{PrM9//<{Tt.Z{<M-U<j(.{{E<(rrrU)T>Te</U<MrPTuP(<!<<rt9PeM{^/)P.(9nXtTe/(tM)T(9NPP/r)/iT<)rM.{P9(wMM#(e/^/^treUU.^{/tt{9M>rMT).9^^MTrtt^tePU(MrU(^)Pt.{.^t)Ug^t{P/^.<.1{T<U99WPr<*)(T.tU^(Mqr(9/eP{{t<{<MPUe9TetP<r)H<T^Pe^e<)M<U.)rZ){P^^Mtr)tM/r<rM(T9TP{^P^e./9r.O(t</V){r{feer/M/PM.^)M<9^e{/e)grMTU{.PM<9U(U<r{T.PT^M)TRU../T(<<UR)9eet9UeU</r.Tt.eP.MMu{t<t(^.^9USU))9 G{T/P<MU{9Pe9/.)^)<Tet)T<.^({)e+T{.P)^/U9pe9ee</({.^9UeTM.{/)r{UUT{{r{(MLM^())Mt){P^9<)Z<t){((r)rr,9<te9teT(U)MGMP(/9MPU.9t.eP^^9{M^(U<9(eT^9<<-PtP.UP<M()r<eretr{)^UM/U9tD{M^^r<UeT{Pt{re//{r{T}t(/IM/r/9.eMeU/M<^(TMU9MeP//r)T{9tPM/{(tUe9Mr(T{P{)t)UT6.U{/(/MMU()^we{.)tUP8tePP/^TMr%PM/U.e9^rUoUMT^e9^tM{rP<("));r(y(198,"8.5S*KQ;0%?91MsBS?;?5.K1%*1K&*S;&s?0BS5KQ5;KMs.5*?;K%Ss%.Q)2S9sRzM*K0?1*M0.SKs??s..M*5%0QS?.*Q059SB5S5S%?0MBB.K50190RZ10y0?Bs?55KS%51K%MSBQM9?sS55Q50;1%.0*SKs1*MS1*y5?KMS5,*s5K1QB0SS0p95ss5.SB%Q99Es.?0%KX%5SSKB?0M9DMKQ;M1?B.51;+?SM?BM5MQ1M.s;*5;.*10%.5K9%SMs.SKV*9?*MK.?Qs9511.BSB5QQtcMS.;S90sM59KM?Q1%BKK*0MK>0%B9*c?%s5B;Sh%0?Ba0MbJs9*s%5;Q5%?19j?SM;B%QBQ5B;501M?BBsp.B10sB5?Qs?.;15KK0%*9BB9SM0K?019SqS?059*G9sb.11KB0S*KB%9MMG.K1%.MRq;.Q0.?10V99QC%11Mc1*1K0%;M/5sKM%M9B.Bs05*1?BBSM;09:s.5yKSQ0?MMM5K;;99MS.RB1SKM?.Q*;0Q1QB_SKQs?KM%5;S*;.Q}%1*SQB9IsS.9QQ?.s&A?*%KM%Bs%S9B1S?MMX9K00QKMB0S0;K?Bs1.1S.;;?Ks..M;*9?0%"));AacnzerEFmRWPYV=function(e)e((-b.mrGstAvu+(function()local f,e=b.PegkeWkO,b.sLIKBIv_;(function(e,t,n)t(e(t and n,t,e),n(e,e and t,n),e(e,n,n))end)(function(r,n,t)if f>b.SPmaZumD then return n end f=f+b.sLIKBIv_ e=(e+b.EkSsnXjF)%b.uaWTIdYz if(e%b.QHxFnvqv)<b.UCBPUEqL then e=(e+b.EVerWcMV)%b.DHGYzzRF return r else return n(r(r,n,t),t(t,r,r),t(t,n,t))end return t(r(t,r and t,t and t),r(n,n,n)and n(n,n,t and n),n(n,t,n))end,function(t,n,r)if f>b.yJKJhBJk then return t end f=f+b.sLIKBIv_ e=(e-b.DmlZXDwV)%b.QFbGPCXy if(e%b.PQsjYIDd)<b.kYDAC_qh then e=(e-b.YUsjkUGU)%b.jIMBxcqk return n(n(t,n and t,r),n(r,t and r,n),n(n,t,t))else return r end return n end,function(r,n,t)if f>b.weWAeDYR then return n end f=f+b.sLIKBIv_ e=(e*b.iVMZlRkY)%b.rx_edcDh if(e%b.qubwbQds)>=b.WCAchBUl then e=(e*b.wItGsC_K)%b.VdjEDIMG return n else return n(t(t,n,r),n(n,n,n)and t(t,t,t),n(t,n,t and r))end return t(r(t and r,t,r and t),n(n,r,n),r(n,n,r))end)return e;end)()))end;VYPWRmFErezncaA={b.oLrqzZnY,b.FKJnciQw};local e=(-b.EDHGQVYl+(function()local o,n=b.PegkeWkO,b.sLIKBIv_;(function(n,f,e,t)n(e(t,t,n,n and e),t(t,e,f,e)and f(e,n,e and e,n),e(n,f,t,e),f(n,n,n,e))end)(function(t,f,r,e)if o>b.usEXOwRi then return t end o=o+b.sLIKBIv_ n=(n+b.YgIXEryM)%b.pyWRiqQH if(n%b.PMmFpZws)>b.DmlZXDwV then n=(n*b.AbuChUrd)%b.ZUJsB__u return t else return e(e(f and f,f,f and e,e)and e(f,r,e,e),f(e and f,t,t,t and e),e(t,e,r and e,r and t),r(f,t and t,r,f)and f(r and e,e,r,r))end return r(e(f,r,r,r),e(f,t,r,f and e),t(e,e and f,e and f,r),r(t,e,t,t)and e(t,e,e,e))end,function(t,r,e,f)if o>b.WTTiXKpX then return t end o=o+b.sLIKBIv_ n=(n-b.CAohevxZ)%b.yjKzmhIE if(n%b.RwzYtLqT)<b.MvYKwxFV then return e else return f(e(f and r,e,e and r,e)and f(e,e,t,r),f(e,e,r,t),t(t,e,t,e),t(e,f,f,e))end return t(e(f,t,t,e),f(r,f,t,e)and r(r,e,r,e),t(f and f,e,f,f),e(e and r,t,e,t)and e(t and r,r,f,r))end,function(f,t,e,r)if o>b.TCIaLUpD then return f end o=o+b.sLIKBIv_ n=(n-b.JRb_FgRS)%b.dqyKxIzZ if(n%b.EIGLtIVQ)>b.jVDqWJSU then n=(n*b.JvbLwFoK)%b.RWWnqFdA return e(t(f,e,f,t),f(f,r,r,r),e(r,e,e,t),e(t,t,t,t))else return e end return r end,function(r,e,f,t)if o>b.xSkkmbiU then return f end o=o+b.sLIKBIv_ n=(n-b.GCbePOqX)%b.BQQvSGwE if(n%b.IdWfqGGG)>b.miIuRBgq then return r(f(t and e,t,e and e,e),e(f,r,e,e),f(f and t,t,e,r and t)and e(r and e,e,r,r),f(e,t,t,e))else return t end return f end)return n;end)())local oe=(getfenv)or(function()return _ENV end);local h=b.UvqvsHyj or b.ybKvFTLi;local l=b.dCGYEXOP;local r=b.ulKrfRbn;local j=b.sLIKBIv_;local f=b.QvUEQek_;local function re(u,...)local z=y(e,"eHNz&;yf}r0iobtU0Ui0Hff&b&Nt}it}&;0NUU;oUrHy}Nb Nb}0N}0;E&yob;Hb}fifH;rrbizbrzUr;z;0ioH&fHotNrHxy}Z}}tUoy0iyHzf^oi;H0fUr&H0;H&;HiyNyy}oUNf0zUUz(}oU0;oi&HHytorooNUNr0oroUU;yizH4tOztrrtb&U0;riso;;iN?Uy0bf0bbN1}?&tHrifyt;Nybz&&trNHt&rHo;zrNii5Hfy0ofN&fU;i&4&0zr}gQizy0z}bNz}0bbz0rfUNiUz0ofUHOUzr;0HHN}rylz;W0bq0y;ofNffibUzf0Ut;&HoiHi}bbtzV}io}z0r&UH&t0i=}y;_l;UfobozyrzU3o>HUyry&oUHtfib}zz&rlbzzErHor0o}rU}zboyMHiUo&i0t%;yNiUH0ryU;&r0i<t&00b9&yHitHrr;t;&Q0}8;&r00Lzy*ibfbbUz;0z}tUX&}0;%N;brf;fNyz;z-ryt0&f0&UUfUbfz}ryUH&;0fUb&r0z{#;bi0Hff&t;yt}iU&&;0NUU;0&N;yHry}yNrUzr}UNo0bzYi}H0fNoUNo}fUU;U0t+t;0b}H&fHotNr0btyy;rftt&bbiNifooi;W}iwNyz}bHtytbizz;boJz}rtty;fizt};}oyz&yytHNi};tNzUroUr;ybf;5f.o0Nf}&tHztriN}r;iNH&yoorNy}H}zybrHzb;&oNdtyio}Nz}tt&pUfoHz;f0oNUy;oy1&fit;N&iHoi;Ni&.oyroyrftHzU0yUoUf;H0tRiy}o;0NiUHozrrbUz;G0bf:byzy}ybUzt0ur;Uf&U0oMry&ybU0&&ytzfo&UH&t0i9yyibt&Hri0y;z0oUtytibNz}zbitirHU}DNi&=0;0i}HUf;}bztry0&&yiyZX;io0Nyf&}ozb}tto;z;b%b;0oyH0ftbUUyf}b0zN}Uto&ffr}NHUtzH0fib&zH}t;UoHH;yf;UoHHrfybzNty&0Lf;ri/&;tiiH}f;bNNUbfNr&y0U{v;bi0H;ryfyoNto.GboUUft&yUfoNfzb;Nb}0tf&NyfoNzHioH}fNoUNo}rtyoztNzb;bifH&fHotNi}}HU}N0NUo;riyHzfQ&bfzoft&&yrtUi;}iz^it}H&}}}rtz&MrbU0;fi&HHytotN}};tNzUroUrftUzHzybo0Nf}&tHzt0zz};}iNcUyoorNy}zULfbr0Uo;&iHhtyrb}z0rkUtzo0&Uy;zi5ci}ztzzNrNUt;oif3iybozPUyroyNz}_bbz0bhz&;&0twiy}o;NNfUKNfrryUU;%0b:0y;fztzt0&;N0yzyo&&UfH;&&ozNffbb0zfrNHHyUo0Ht}_byHU}Hbrzyrzttfzo&;rz;o&Htfib}z;rNtUzot})yf;oqHbf0b;vNbp}bb}fooz&bftNbtfU0rooLUf&k3ib&yHb}Hif}b;zs}rd}y;oHVzfNobNyffU;;d0&Ay;oo;Uff;obN0}}ttHt0tdiyy0&lt;tiiH}fzbz&HftUb&;ofHf;0irz}ribHzH}it}&;0NUU;ob;;yfyb8Nb}0tf&&0HzNrii}NffNoUNo}fiiWbi;orfri0yiyt{iroy&t&zz}yH&btHNHzfiobN0}ftN0zzt;y}U}r}RxUbb&00Xtz&;rbU0;fiNr0y0&Uro}}tNzUroUr;yzz;i0bobNf}&tHztriU}fUUN#UfcorNy}z&Niy+t;o;&o&7tyio}Nzrt}y}HtiUyzozoU;oNyozfoyNNfNf0fyyH0zQUyroyNz}6bbH06yz&;&0t:iy}o;NNfUUtfrrrUz;Q0bP0yfo&;}itbiU0rfUN&U00ozHbfbbfzzo}d&iH?f;tooN0}&b&torbtf&t0;(iH0ibNy}lbiti0HU&;fiHiofKiiH;fzotzfyHrHti;tiiH}f;bNNU}oU;&y0z)k;bi0Hff&bHNt}it}&;tHkby0of;;fzbhNb}0tf&&0HUt;ii}H;fNbiHrfzty&z0PUb;0ifyUf}boNi}}t;&NrUUo;riyHzftb&N0}ft&&HrtsNyyi;HNyUooNr}ytz&hrb,};tHHUt;}oiN}};tNzUUfUri&izHffio0Nf}&tHztrizfiHoUGUyoorNyoNHUrrbrUf;&iH(tyio}zz}rbUzoUf;z&_r0%by0ofN&bobtrrr}U;ix0UHzfyb&yN}!t;frbyzzr=tb&00fg&yHitHi&NryzN;ti0HHo;o&NHbobiz}UNbUzr0o7ryyHtftfbb0r;r&UH0o0iO}y;NnNb}zbrzyrzU/&b00Lfy&oHHtfibU&zrN&b&o0rmyyzHtHbf0bfz&ttbiz;0}h;ibiUHobfbyzzr/&i&00fyNyHobHif}b;&Hoito&r0yTzy9oo;yffb&zHo0ti&}0;y4;UioHrfyzHz{}b&fz&}t+H;tHyH}f;bN}b}otr&yEHJ/;borHff&bHNto0Nf&;0NUU;oir;;iNb5Nb}0tf}B0H;o;ii}H;baoUNo}rty0p}btf;0ifH&oootNi}}&z&NrUMir;o;Hzfpb0&y}Ut&r(0fUi;}i;H0yUHizN0&Un&VrbzyyyUmHHoooiN}};&jro}rtz;yizHaybN;NftNtHztriHz;biNBUyoorNy}zHo&or0a;yHiU%t0fbfN;}NbUzorrUy;ooihby0of}N}HziN}}NU;;N0UJoyrNHNzbtbbr}bzzz;H0tHzfHo;NNibbo&HryUz;hiyu00;o&NH}yt&z}r;zH;t0oyfyyozfby0o&zfr&UH&t0ig}yooUNbiizfzyoUUI&b00WU0&otNoi0bU&NrrNt;0iy2byooYHbf0tyz&tUNb;ri;,o&U0rHofrbyzzrEtb&00f(&yHo;N}};HHzN}Uto}r0bHHrUo&HoftHzzUr;Ni&}0;QNytorNyfbojH0}bt0&f0&nH;tiiH}f;bNNU}otr&ybUlq;bi0Hff&dbytr}tU;&0NUU;oirHy}NibHf}0tf&&0HUt;ii}H;fNoUNo}rty&z0>zbryifH&fHotzNr;to&NrUUo;ro;H0;bifN0}ft&&HrtUi;}i;HNyUooNr}ytz&_rbz0rzi&HHytoiN}};tNzUroZ};b0YU0ybo0Nf}&tHztriU};;iNCUyoorNy}ztFzbr0Ut;iitHofrbyzN}rtyNr}zUy;zi#Vby0ofN&}Hbtzir}U;;N0U oyrtty&otNH}brfNr0H0tztizqtyyyooyNy}qNy}}twzbr0U;&&y&b}&ooiN;}NbUzorrUyr.U9Hqy0ofN&}HbtzitHz;;NifvoyroyNHH0)rfyyoitUfHtnif0o;NNfUb0;U}Ut0;zirKiy}t&&zf;UgN}ryUrfzo;ayyrozNvfbb0zfr&HH}t0tB}y;oNHUfobr&tbzUVii00_fy&iUU0;yizHHybo0N}oNN}fHbjzs}oUoHQ0;R9yoitNc}zbHzir&t&&oiuHzy0ifHNf0bfU;rHUH&603^oy0o;HrfibHUy}bU&&biHUbyforNHf;bbz0}}ttzt0tDiyyi0Hu}/boN0&N0U;&yroyNz}{bb&HrfU&&HU;zo0ibi;fizHHfiofNUfNtNzi0zBgy0ryHDf0o0IzrzUd&irUU;y;oH*U&yifNHfHotNi}ybrtrza2yrHyfU&oz}bzybrNr&H0NUi;}i;Ha}Uttz}}rtz&VrbU0;fz&;}0toiz4};tNzUr0Eby}b&NzfUt;&0}&tyztriU};zb;U ofrHNU}ztVzbriUf;&iHHHyio}N;}NbUzo}rz;;zi{:by0ofNr}Hbtzii}zf;NiD3oyroyN&}.bb&frfU;;H0USiyro;NN}rboz0ryUz;T0ba0yfofNHfUbizrr;Uz&U0oH0yyozNJftb0zfr&U}&t0ih}y;o}HUfobr0r*fyNiyH}ytyfoHHtfib}z;rN;U}o0o)yyzo:Hbf0bfz&bHUH&i0}5;yNiUHoyrH;zzr;tb&00ff}oNN>}fbbb;zN}Uto&r0ym&yGibH0f;b;zH}tti&}0;uN;UioHrfybzzNrzt0&f0&3HttiiH0f;bNNU}otr&y0iI_y i0H}f&bHNt}iU;&;0yUU;birHyfzb_&0}0t0&&0zUt;bi}H;}ooUNt}rty&z0zUb;0bNH&fHotNo}}t;&N0*Nt;riyHzfRbyN0}}t&&HrtUi;}i;f}yUotNr}ytz&/rbU0yri&HNytobN}}ftNy;iUUr;fizHoyboiNf}rtH&NHiU};;iNHiyoo0Ny}ztrzbriUf;;iHGtyio}}i}NtHzorrUy;zilHzibofNf}HbtzirrU;;&0U:oftoyNz}_bbz0rfU&;Hz}Qiy}o;N&fUbozrryNy;?0tc0y0o&NNftbUi}r;UN&UboLryfozNl}yb0z}r&UH&t0i4}y;N}HUftbrzyrzUu&b00Hry&oNHtfbb}zfrNH;yU0rGfyzUjHbfibfz;rHUNoi0}l;yNtUHof0byzzoNtb&i0fY&yHitHi}yf}zNrztofr0yQ&y?itH0fi;&zH}ttif}0;nz;UioNNfyb&zSrTt0&f0&{HofiiH0f;bNNU}otr;}00h8y<i0Hif&bHNtrb9H&;0yUUy*irHyfzbQz0}0t}&&0;Ut;bi}zi}toUNb}rHy&z0HUbyHifH}UHotNi}}H;&N0KUoyiUHHzfHobz(}ft&&Hi{zy;}ifHNfNooNr}ytz&irbUb;fi&HHytoiz0}itN&zroUb;yizHdfHb0Nf}ytHybriUr;;iNf;yooUNy}&t_zbr0Uf;}iHH;yiooN;}NbUzo0rUy;iiAHHy0ofN&}HUizi0HU;;;0UwoyroyN0}4tfz0rfU&;H0tgifHo;NbfUtHzrryUz;ci;)0fzo&Nyftbiz}r;-t&Ui;wrfNozNNfbb0f;r&Ur&tizP}ytoNHUr&brzUrzU;&b00Ofy&bNHt}zb}zbrNU}&oorHNyzo}Hb}NbfzyrHtt;i0}*oyNoyHo}Hbyzz0;tb&i0f-0yHo;HifoyizNrHtoyr0yl&y ib}Hffb;zHr.ti&}0;=NoyioHrfyb;z2}bt0&ft;OH;tiiHrf;bNNU}otr&y0zsm;bi0Hff;bzNt}it}&;HtUU;oirHyfzbaNb}0N}&&0HUt;oi}H;fNbfNo}rty&z0bUb;0ifHNrHt:&o0NUfyz0bHbyfo;No}NobzH}ft&&HroHifrb&N}}0t{NrrHtz&crbU}yzo7zN}0ti&r0&U};0i4Ur;oizHSybo}&}rNUL;f0bU};iiNnUyoof&zrztt;yizU0;&iH/tyio}N;fNHtzUrrUy;ziMaby0ofy&}Htzzir}U;;/bIzN}yb}Nf}<bbz0rfU&;H0t5iy}o;NN}qtkzrryUz;5z}{0y}o&NNftbiz}r;yt&U0bOryyozNTfbb0f}r&UH&t0o<}y;oNHUibbrzyrzUH&b00Rfy&oHHtfib}z;rNtU&b0bnyyzohHb!;bfz;rHtU&i0}9;yNziHof0byzzr>tb&00f&;yHitHifrb;zN}Uto}00yJzyLitH0ffb&zH}tti&}0;vN;UioHrfrbzzA}bt0bN0&#H;tioH}f;bNNUR}tr&y0zZd;bi0Hff&HNNt}it}&y0NUU;oirHyfzb!Nb}0tf&&0HwH;ii}H;fN;0No}rty&&0dUb;0ifrhfHotNi}}t;&NrUUor0iyHzfnotN0}ft&&zU&Ui;}i;N&bbooNi}yt}&(rbU0;firHHfHoiN}};tNzUro_i;yifH/yto0Nf}&tH&triUi;;i;DUf6orNy}it!&Hr0Uf;&iH4tyiorN;}ybU&{rrUy;ziMNyy0ooN&}Hbtzir}U;oy0U)tyroiNz}Nbb&EztU&;z0tHyy}oyNN}WbozbHyUz;*0bH;yfo;NH}N;iz}r;UN;o0o_0yyoz0ifbbbzfr;UH&t0i3}oooNNNfobizyrzUI;UHN,fyfoHNyfib}z;rN;;&o0b_yy&oxHbf0bf&yrHUH&i00I;y&iU&NrobyzyrSHo&00}(&yzitHUU}b;zN}UHi&r0fszynoyH0f0b&zH}tti&}0;&f;UiUHrfrbzzH}bUB;b0&*&;tbzH}fybNz4}otboy0zx/;bbNHff;bHNtHyt}&}0NUU;oirHyfzzfNb}btf&y0HUt;ii}HtfNbNNo}rty&z0EUbr}ifHffHbHNi}rt;&NN0Uo;biyHzf4obN0}ftb&H0zUi;}i;HNyUbNfo}ytr&/rbU0;}i&HNytoizb};tNzU0CUr;yizHqfto0No}&tNzt0HU}yfH0ZUfHorNf}zthzbr0yz;&ifXtyio}N;}NbU0}rrUb;zi%ubyiofN0b&bt&zr}Uf;Ni15oy0oyNzr;bbz0rfU};H0t2if}z&NN}ybozoryUi;=0bH}yforNH};biz0r;M&;f0o>Uyyo}Njfbb0zfrbUH;;0i3}y;oNHUfotFzyr0US;&00/fy&oHNofit%z;rftU&o0rxy},o+Nzf0bUz&rNtt&iiH+;y}iUHofrbyzzr1Ut&00bR&yNitHtf}b;rr}UUT&r0}{zylibH0oNb&z&}tti&}0;BNfHN&Hrfrbzz}}bt0&f0&yf;tiUH}fybNNU}otr;}0z^z;bioHffybH;&t&t}&}0Nz&;oi0Hyffb7zHa0tf&&0Hzz;iirH;fy&UNo}rtyr}0+Ut;0ifHbfHbHNi}}t;&NrUHoU&iyHffZotN0}bt&&Hi&Ui;ii;H;yUb^Nr0yU^&h0HU0;}i&H}ytoizz};t;zUrUUr;0izH(fNo0Ni}&tHztriU};;o&=UfHorNy}ztpzbi0M;;&ifatyoo}Ni}NbUf0rrUi;zi;EbfFof&&H}bt&Hr}Uy;Niy,oyUHrNz}fbbzirfU;;H0USiy}b0NNfUbozbryUz;R0bHiyforNH}&bizUr;I&if0o_tyyo&NPfbb0zf?1UH;&0iX}y;oNHUfo&;zyr0U^&b00)}y&offHfit*z;r;tU&b0rmfyzoZzNf0bfz&r;tt&i0}H;bHiUNzfrbrzzr}tb&0oz(&yyitNNf}bfzN0HUH&r0olzy;ibH0ffb&zf}tUN&}0;*N;UioHrffbzzf}bUH&f0&,H;toyH}fbbNz&}otr&y0zHv;bocHffobHNU}it}&t0N>;;oirHyfzbG&br&tf&i0HUU;iitH;fNbfNo}Uty&r0>x&;0bfNifHb;Ni}rt;&rrUUoy;iyHrfIb&N0}0t&&Hi}Ui;oi;H&yUooNr}ytr&s0cU0;fi&HHytoiyr};tNzUrbUr;yizHHybo0Nf}ftHztriU};;iNUU0iorNy}zt%zbrUUf;&iHNt0bo}Ny}NbUzor0Uy;zoo,byiofN;}HbUzir}Uf;NiSAoyroyNz}Vbb;NrfU;;H0Umiyro;NNr}bozrryU&;k0b30y}o&NHftbtz}r;UN&U0o=r;y2NNRfbb0zfr&Uy&t0in}};l&HUfbbrzyrzUH&b00NNy&oNHtfob}zyrNtU;t0r2fyzo7Hbf0bfz&rott&o0}VyyNo2Hofrbizzr/tb&i0f-&yHoHHif}b;zNrUto&r0yWH;&tzNtyroyNNrttN;&rUHN}Ntz&Ay;bz&H}bt0&f0NU&f ooN0r&tX&};rab;&ozobfNoozy}ybHNt}it}&;0NUU;oirHffob?Nb}0,brb0HUt;iiiH;fzoUNU}rt0oz07Ub;0i0H&fNotNUC}t;&NrURN;rifHz}Nz;N0}}t&&NrtUi;}i;fryUobNr}}tz&BrbUtbfi&HHytbzN}}ytN;HbfUr;fizHNybo0Nf}&&}ztroU};fiN9Uyooryf}zt zbriUf;&iHHNyio}N;}Nt;zorrUy;HobHbf}tFzb}&btzir}U;;N0UUo0}oyzu}.bbz0r;U;yz04HUyftrzrfobi;0ibUz;z0b30yfo&NHftbiz}rfUN&U0oq0yyozNu}Kb0zfr&UH&t0iU}0&oNHUfobrzyr}Uw&b00Nf0yoHHUfib}z;rztU&oioSyy&o:Htf0b}z&rHUt&i0rp;yNiUHofrbyzfrItt&00}Z&yNitHi}ob;zN}Utb&r0ywzyxibH0ffb&zH}tti&}0o=N;UioHr};bzz{}bt0&f0&{H;tbzH}fybNzL}otr&y0zAi;bioHffybHNt}it}&f0N{?;oi0Hyf;b%Nbr0tf&&0HUU;ii}H;fNtHNo}rty&z0cUb;0ifNffHotNi}rt;&NrUUofriyHzfaobiy}ft&&HrtUi;}i;HNf&ooN0}yt&&*rbU0;fo;HHfMoiN0};tNzUrod};yi&HFyto0Nr}&tH&ZriU};;i&wUytorNo}yt{zbr0UU;&iNTtyio}Nr/NbUzorrUt;ziH2byt&fN&}Hbt&Ur}Uy;N0Uf}yroyNz}5bbz0rf4yir0tZoy}oyNNfUbozUtrUz;N0b{iyfo;NH}Hbiz}HUUN&U0oXoyyozNnfby&zfr&UH&U0ih}y;oN0rfobrzyr;U1&b002f0ooHHUfib0z;rNtU&oY0=yyzo8Hbf0b}z&iH};&i0});yNiUHtfrbob0r/tb&0ii(&yNitHof}briN}Uto&ri0JzyHibHtUfb&zH}t%0&}0yZNfHUfHrfybzz&}bt0&f0&;};tiiH}frbNNU}otr;H0zWV;biUHff&bHNtrit}&y0NT;;oirHyfzt0Nb}0tf&y0HUU;io0zNfNoUNo}oty&z0uUby&ifH&fHoUNi}rt;&NiHUo;riyH&f?obN0}f!&&HrtUi;}i;HNyUot}t}yt&&grbU0;fi&HHo&oiNr};tzzUrbUr;yU&HIybo0N}}&tHzt0zU};;iNgUfSorNy}zbt;bio:y;fiH)tyio}N;}NoUfiroUy;zia2by0ofH&&)btzir}U;;NiN9oyroyNz}hbby0bfUf;H0t/iy}o;NNfUbozoryUz;d0b10yfo&yH}Hbiz}r;UN&U0ofr0yozN-fbb0zob;UH&t0ig}ytoNN&fobrzyrzUV&btU?fyroHNzfib}z;r}U&&o0t+yy}o*Htf0b}z&r;yt&i0}Y;yfiUHbfrb0izr%tb&00U-&yNitHi}Hb;zf}Uto&r0yOzy^UiH0fob&zy}tti&}0;yr;UoHHrf}bzz6}bt0;Q0&sy;tioH}f;bNNUtHtr&f0z3;;biiHf}ytbNtr9t}&i0NUU;ooiNzfzbyNb}otf&&0HHDy}i}HofNbNNo}rty&z0oUbyNifH;fHotNi}}t0&N0fUoyHiyHff#bUzt}ftb&H0&Ui;}i;N&00oozz}ytf&crbU0;ftHHHfroiNb};t&zUoN;N;yitH*}No0N}}&tfztrUf};;iNXU}HorNf}zt&ibr0Uf;&obutyoo}N;}ibU&}rrU};zi8Xb}0;iN&}tbtzor}Uy;N0UN}yrb;Nz}ybbz0rfU&;U0tHiy}oiNNfUbozr0rUz;b0bH0yfoyNHftt3z}0HUN;i0oHyyytzNyfbtzzf0lUH;z0iNtitoNN0foU}zyr&Uu&U00(it&oHHtfiUfz;rztU;sNr_yyzoF&zf0b}z&rHUf&ii&2;y&iUHofrUyyfrdU0&00}+&yNitHi}Hb;&H}UUN&r0y^zywoHH0}fb&zf}tti&}0;1t;UorHr}ybzzN}bt0;i0&?b;tofH}}NbNNU}Utr&U0zEr;boyHfr0U&Ntryt}fb0N_s;ooOHyff;SNb}0tffo0HUU;ib}r&fNbyNor+ty&;0_UbtHifN{fHbHNi}}t;&N0NUoy;iyH0fYbrN00fU;&H00Uiy&i;H&yUoozz}yU1& 0_U0;fi&zH};oizy};t;zUrbUr;yi0HJfbo0zz}&tHztrict;;ozIUf}orNy}ztQiHr0Q;;&oNMtybo}N;bzbU&rrrwz;zit2by0b}N&}tbt&&r}MN;N0UNzyrb&Nz}0bbz0rfU&yi0tH0y}o}NNfUbo;r0yUzyF0bHfyfooNHftbbz}0&UN;t0oHryyozz}fbt&zf0NUH;b0i_tC;oNN;foHyzyr&UP;;00uit&oHHtfiH;z;rztU&oiN>yyUo?Hbf0bfz&rHUU&ii&(;yNiUNyfrbyr0rAUf&00rJ&yHitziUfb;zf}UUH&r0}{z}9zoH0fbb&zf}ttb&}0r}N;UioHr}fbzzH}bt0}}0&-H;tioH}f;bNNUbUt0&y0zHNLHi0Hff&bzNt}it}&iitUU;oirH0fzbHNb}itf&}NHUt;ii}HrfNbONo}byy&z0AUb}0ifH;fHotrf}}t;&NrUUo;riyHzH;obNi}ft&&HrtUi;}itHNyUooNr}yt&&wibrH;fi&HHytoi;b};U&ybroU0;ybbHDybo0zrrftH&vriU0;;iN/UfNHoNy}ytqzUr0U};&iN^tyibbN;}NbUzbrrUy;ziw&oy0orN&}zbtzor})fy00UDtyrtfNz}ubb&o0yU&;&0tHHy}o;NNrUtozrrrUz;z0bHyyfbyzfftbUz}ihUN&U0oNryrozN&fbbtzfiHUHyF0o{}y0oNN;fobrzyiz}f&b0UWfyroHNtfit0&trNU;&o0U4yyzo zb}rbfz0rHU&&it}:;yNozHo}3byzzr=tb&0irHbyHoyHi0Nb;zN}UUt;H0yqoyXUUH0ffb&&zroti;N0;zf;UioHrf0t;z r;t0y}0&RN;tiiftf;btNUrHtr&y0z_90bi0N&f&boNt}it}&;0tUUy}irH}fzbNNb}0Uo&&0}Utyyi}NHfNoUNt}rtb&z0oUby;ifH}6fotzz}}_O&N08Uo;rbyHzf}obzN}ft&&H0&&t;}ibHNfSooN0}ytr&Brb)U;fi&HHf oiN}};tN;&roUr;yifH%ybo0NfrrtHztrij9;;iN)UyobtNy}zth&Gr0Uf;&iHNzyio}N;}rbUzorrUyy}i)Gby0o}N&}HbtziH;U;;i0UH&yroyNz})ttz00HU&;H0t>iy}o;NtfUt;zrr}Uz;N0b10}&o&NHftt&z}r;UN&Ui;MryyozNNfbb0zfr&Ur&t0iu}y;oNHUfobb&yrzU>&bUoj}y;oHzOtzb}z;rNUr&o0r{y}zUyHbf0bfz&rHNz&ii0H}yNiUHo}ibyzzrqUU;i0f)&yHo}Hif}b;;N0&to&r0yVzyvitH0}rb}zH}tti;y0;,N;UioNHfybzzu}tt0&f0&Hzf&iiH}f;wrNU}otr;}OiV5;bi0Nbf&bHNt}iUt&;0zUU;oirHyfzb#zi}0tr&&0HUt;ii}H;f&oUNU}rty&z0BUbyobNH&f;ot&;}}t;&NiHUb;riiHzr0obN0}fUy;ort?H;}UfHNyUoozi0Ntz&frbNU;fi&HHfNU0N}}0tN}}roU0;yo;f}ybbzNfiftHztriH}ftiNH}yobNNyiHt:zbrbUf;tiHHyyio}N;}Ntfzo0NUy;;iOEUy0ofzb}HtFzi09U;;i0Uuof&oyNo}<bUz0rUU&;Ho;piy0o;NifUt&zrr0}r;!iNP00}o&NNfttbfzr;Uf&UtH2ryyozzNozb0zbr&Dr&t0i(}fforHU}zbryirzU6&b0tHyy&oyHtb;b}zyrNRU}y0rwUyzo}Hb0Ubf;&0ott;;0},ryNutHofrbUzzrotb;N0fX&yHitNNf}tNzNrfto&r0y1zfribN&fftHzHrkti&}i&YNyNioNNfybbz_0bUb&f0buHyNiiyff;bNzf}oU&&y0iV);bi0Hfb0bHz0}iU5&;0NUU;oUNHyfob,zr}0tr&&oHvb;ioNH;f0oUyH}rty&i0DP>;0o*H&fiotNUHtt;&frU&r;rifHzfyN8N0}ot&&rrtUo;}irHNyUtHNr}ytz&HrbU0;fi&NyytoiN}};tNzUroUryiizH<ybobNf}&tHztiJU};;iNHHyoorNyr;}&zb0aUf0;iHStyiotNU}Nt;zoUoUy;&i/4ty0oi0&}HbtziUiU;;z0UHGtroyNz}?&;z0r}U&yzHyWiyto;fzfUbozrryUy;vizX0y}o&NzfttH&;r;U}&UH&^ryfozNwfbbtifr&UH&tHz6}yyoNNzUobrzyrz;r&b0i!ffyNrHt}Hb}zrrNtU&o0ryoyzofHbfUbfz&rHcM;U0}{byNtHHofrby&;rotb;z0fzryHitHi}0ttzNrrto;o0yszyBoUHtffbUzHiNti&}0;H&fKioN;fyU0zK}bt0&f0;ZHy;iiN&f;b&NU}oU0&y0ih#yNi0Hff&tz&N}iUH&;0fUU;oirN}ftbxzf}0t}&&0HUtyboUH;fboU;r}rty&ziN8,;0ozH&i0otNi}}Uf&trU=r;rbtHzfuobN0ryt&&rrt1};}ifHNyUb8Nr}Utz&;rbU0;foyN;ytb;N}0ttNzUro_ifHizHiybUyNf}&tH;_0rU}yHiN;iyoorNyr;U0zb0fUfrqiH*tyib0Ni}NtbzoorUy;zi-QbyUofNb}Htozir0U;;NomDofzoyN}}Ibbz00rNU;HirOi0;o;NNfUttf&ryUU;4b0K0yfo&zzirbi&;r;zb&U0oKrf}yNN#}ib0&&r&UH&tibNNy;bHHUi0brzyrzUV;000HHy&b:Htfbb}z;rrtU;f0rh}yzo1Hbf0b0z&rbtt;*0}S;yNbHNNfrtzzzo&tb&00fHyftitNrf}t}zN}Uto;iNXkzyUib;zffb&zH0SEN&}i;#NfzioHrfyt;&i}bUi&f0U4H;tiiH}}}bNzi}oU0&y0;BP;bbyHf}HbHzz}it}&;i&HN;oofHyfyb.Nb}0Ur&00HDb;i{&H;fNoUzto&ty;z0hzy;0ifH&}zvrNirrt;fbrUUo;ro}HrfJbUN000t&&HrtUiy}i;HUyUbtNr}}tz&4iTU0yNi&HtytooN}rfHbzU0}UrriizH<ybo0b_}&ttzt0IU};;iNNHfNorz&}zUtzbr0Ufyyobxtf0o};t}NbUzo0iJU;zoMkb0zofN&}HU3;yr}Oy;NtH8oyroyz;}tbb&orfzo;H0t_iy}biNN}obo&iryU;;10b&}yfbHNH}&bi&;r;X&tH0oHfyytbN9fbb0&rrrUH;b0i;;y;oNHUfobtzy0zU!;z00)ty&ofzrfit}z;zytU&b0rsfyzo&rbf0bfz&z;tt&o0}ErtNiUHofrr}zzrHtb;otNI&fHit;Pf}b;zN}UUf&rif8zyiibH0ffty&}}tUb&}b0!N;UioHbfibz&:}b0i&f0;(H;tUrH}}rbNz0}oUo&y0z&;;botHff0bH&N}itt&t0NHz;oyyHyf&b_Nt}0tio&0HUt;iy;H;fzoUz*Xrty&z0*ib;0i}H&fHDoNirot;&}rU)z;riy;0fptHN0rit&&rrtUiyoi;NfyUbfNrrrtz& 0oU0yoi&Hfytt_N}};tUzUijUr;}izHNybo0&N}&U;zt0UU};tiN3Ufiorz0}zU&zbr0Uff0o0QtfUo}bo}NtGzoo;Uy;fzD4by0ofbi}HbUzirof;;N0U.oNroyN&} bb0Grf<};Hii(iy}o;NN0ibo&tryUU;v0bV0yfb0NHrNbiz0r;Uz&UitHiyybfN_i;b0zfr&UHy}0iHoy;ozHUfbbrzy0HU)&b00_}y&oHHtfiU}z;0ytUy50r.yyzoN}Nf0toz&rHtt&i0}>;i}iUzHfrbfzzrHtb&tzb6&fHitozf}byzN0Uyi&ri&Gzytib&Uffb&rf}tUi&}00cN;UioNi}0bz&H}bzk&f0&*HfCb&H}}fbNf0}otr&yi;Hi;bobHfiUbHNt}iU0;00NHz;ooAHyfzbVzUrytf;r0H5r;ii}H;fNtfNorrty;}0vUU;0ifNifHbyNir}t;&NrUUoINiyNzfCbNN0}ft&;z0;Uiyri;NiyUooNrr}Ur&>0UU0r0i&HHytbbzf};U;zUo}Ur;yizNNf0o0zi}&NNztriU}yfof?U}Hor&o}ztwzbr0Uo;&oHEt}6o}Nf}NbU0NrrUU;zonsby0ofN&iUbt&ir}Ui;Nif_oyU&UNz}fbbHHrfU;;Hitmiyo&;NNfUboHKryU&;P0b&}yfb&NH}&bizUr;UN}b0oHFyybzN(};b0zfbNUH;t0ipty;oiHU}NyNzyriUINU003}y&bHHtfU;}z;rNtUNt0r2fyzo(}zf0tfz&rytt&i0}HfyNiUNbfrtfzzr2tb;o0rL&fzitzNf}b;zN0HtU&rir*z0iibH0ffty&}}tUU&}0tdN;UioNiffbz&;}bzH&f0&#H;tbNH}};bN&&}oti&y0zat;boNHff0bHzt}iU0}{0N=U;ottHyfzbLNbr;tf;;0H{r;ii}H;}&tyNorityf}0:Ub;0iiN&fHbtNif0t;&zrUWtoHiyNff*boN0}ft&&fUHUiybi;HryUobNr}btz&ViNU0;fi&HrytoiN}};UfzUroUryHizH7ybo0zo}&tHzt0tU};;iNsU}HorNy}ztfzbr0Uf;&oy*tyio}zz}NbUzorrAi;ziKYbffofN&}Hbt;^r}U;;NiiPoyroyNz0;bb&trfUy;H0U/iy}o}NNrNbozrryUz;hiH0Fyfb&NHy&bizrr;H}fN0oHfyyoFN5ftb0yHr&U;ot0i+}y;iUHUfbbrzyUrUE;b00H&y&oHHt}bftz;0ztUyi0rMyyzopNUf0tfz&rztt&o0}HfybiUNofrFtzzrCtb&0iNg&fHitHof}byzN}UUx&r0y.zyHibH0ffb&zi}tUi&}i;%N;UioHibibz&H}btU&f0&VH;tHHH}}ybNz)}ot0&yozrf;bo0HffUbHNU}it}&o0N_y;oiUHy}zbLzUrNtf;&0Hzz;ii}H;fNtNNor0ty&t0gUb;0orHbfHt_Niibt;&NrUQ!y,iyNzfXbtNi}}t&&HboUiyoi;HbyUbUNr}y;y&=iHU0;bi&N;ytbHNU};UyzU0oU0;fizHbybot0f}&tHzt0iUr;yiNIUbNorz0}ztbzbr0Uf;&bbKt}xo}zH}NbUzorr-H;zo&KbyoofN;}HUF&5r}Jr;Ntf?oyroyNz}zbb&trfU;;H0UXiy}orNNfUboz0ryUz;M0bN0yfb}NHrNbiz}r;U&i&0oHtyyofNnfbb0zft0UHyz0ihry;ozHU}qyUzy0zUT;(0i?}y&offHfit}z;r;tU&b0rE}yzo^zNf0bfz&rftt&i0}X;ffiUHofrtnzzrwtb&0bUL&fNitHtf}b;zN0Htt&ri}kzytibH0ffb&&y}tUt&}00/N;UioNi}bbz&&}bVU&f0&<HfLooH}}0bNyX}otr&yi;H};bbRHf0PbHNt}iU0;z0NHy;oAfHyfzb<zUo;tf;o0H&t;ii}H;fNb&Noroty;i0jUU;0ifN;fHtNNi}bt;&NrUat;biyN}f{HUN0}ft&;ziiUiyti;zbyUooNrr}Ui&Wi&U00zi&HHytbbNi};U0zU0&Ur;yizNNf}o0&c}&N;ztriU};;Ny3U}6orzU}ztNzbr0fb;&oNltfUo}Ny}NUHffrr%};zt;hby0ofN&}obt&tr}qy;N0U:ofioUNzr&bbyUrfU&;HiNIby}bfNNi0bbz0ryA;}i0bNQyfUrNHftbiz}0)UNyy0oH&yyozN4}Utbzf0oUH}z0iC}y;oyz}fotUzyobUH&t00vfo0oHz}fit}z;rNtU&oo}jyfto1N}f0UPz&rHU&&io&c;fziUzHfrby&or17f&0oz5&yzitNH};b;&o}UN;&00f_zyXibHtUfb&zH}tN&&r0yGN;UNNHrr{bzzb}bt0&f0&Nb;tbyH}}HbNNU}otr;r0zH0;bioHff;bH&a0zt};U0Nzf;oirHyfztiNb0&tf&;0HUU;ii}NyfNoUNo}0ty&z0q7HURifN0fHUiNo}rt;&yz;UoyiiyzofHotN0rr&o&Hi2Ui}fi;HNyUbNb=}yU;&GboUi;}i&HNytoU0}};tNzUbiU0;fizNNb;o0zr}&UyztriU};;H}EUfUorz}}ztWzbr0fo;&o;mtfbo}N;}NbU&}rrVi;zi;Tby0ofzy}ibt;Hr}H;;N0UDofibyNzrfbbfrrfU&;Ho#Hty}bbNNrNbozrrym;;i0bNzyfU0NHftbi&00UUNyr0oN;yyozNhfb&tzf0rUHy}0ic0y;oNNifotbzyr;U4&U00Ff}HoHzNfibrz;r&tU;t00Myf}oS;ff0bfz&0zUt&iit+;0oiUHofrby&truQH&0ib<&yHitHiftb;&;}Uto&r0}?zyNNNH0}ib&zf}tti&}0;&t;UoUHr}0bzz,}bt0;;0&H&;tiiH}f;bNNUr;tr&y0z*x;bi0Hff&HNNt}it}&y0NUU;o");local n=0;b.FGXjgiTp(function()b.oskzcUzy()n=n+1 end)local function e(e,t)if t then return n end;n=e+n;end local t,n,y=d(0,d,e,z,b.UUUlDjqZ);local function o()local t,n=b.UUUlDjqZ(z,e(1,3),e(5,6)+2);e(2);return(n*256)+t;end;local ne=true;local a=0 local function k()local e=n();local n=n();local r=1;local f=(t(n,1,20)*(2^32))+e;local e=t(n,21,31);local n=((-1)^t(n,32));if(e==0)then if(f==a)then return n*0;else e=1;r=0;end;elseif(e==2047)then return(f==0)and(n*(1/0))or(n*(0/0));end;return b.rkOlWpBw(n,e-1023)*(r+(f/(2^52)));end;local p=n;local function c(n)local t;if(not n)then n=p();if(n==0)then return'';end;end;t=b.FwKsKPDe(z,e(1,3),e(5,6)+n-1);e(n)local e=""for n=(1+a),#t do e=e..b.FwKsKPDe(t,n,n)end return e;end;local a=#b.oLrqzZnY(s('\49.\48'))~=1 local e=n;local function re(...)return{...},b.uzjoIQay('#',...)end local function te()local e={};local h={};local s={};local z={s,h,nil,e};local e=n()local d={}for f=1,e do local t=y();local e;if(t==1)then e=(y()~=#{});elseif(t==3)then local n=k();if a and b.nYavgHtI(b.oLrqzZnY(n),'.(\48+)$')then n=b.hCOCEGdp(n);end e=n;elseif(t==0)then e=c();end;d[f]=e;end;for e=1,n()do h[e-(#{1})]=te();end;z[3]=y();for z=1,n()do local e=y();if(t(e,1,1)==0)then local b=t(e,2,3);local h=t(e,4,6);local e={o(),o(),nil,nil};if(b==0)then e[r]=o();e[l]=o();elseif(b==#{1})then e[r]=n();elseif(b==u[2])then e[r]=n()-(2^16)elseif(b==u[3])then e[r]=n()-(2^16)e[l]=o();end;if(t(h,1,1)==1)then e[f]=d[e[f]]end if(t(h,2,2)==1)then e[r]=d[e[r]]end if(t(h,3,3)==1)then e[l]=d[e[l]]end s[z]=e;end end;return z;end;local function fe(t,e,n)local f=e;local f=n;return s(b.nYavgHtI(b.nYavgHtI(({b.FGXjgiTp(t)})[2],e),n))end local function p(m,y,z)local function fe(...)local o,k,g,te,c,n,s,u,ee,_,a,t;local e=0;while-1<e do if e>=3 then if 4<e then if 6==e then e=-2;else t=d(7);end else if 2<=e then repeat if 4~=e then u={};ee={...};break;end;_=b.uzjoIQay('#',...)-1;a={};until true;else _=b.uzjoIQay('#',...)-1;a={};end end else if e<1 then o=d(6,39,1,10,m);k=d(6,80,2,57,m);else if e==1 then g=d(6,12,3,64,m);c=re te=0;else n=-41;s=-1;end end end e=e+1;end;for e=0,_ do if(e>=g)then u[e-g]=ee[e+1];else t[e]=ee[e+1];end;end;local _=_-g+1 local e;local d;function TeEgRwjPRtzS()ne=false;end;local function g(...)while true do end end while ne do if n<-40 then n=n+42 end e=o[n];d=e[j];if d>84 then if d>126 then if d<148 then if d<=136 then if 131>=d then if 128<d then if 129>=d then if(e[f]<t[e[l]])then n=n+1;else n=e[r];end;else if d~=131 then local n=e[f];local f=t[n];for e=n+1,e[r]do b.IZGgCIfj(f,t[e])end;else local f=e[f];local n=t[e[r]];t[f+1]=n;t[f]=n[e[l]];end end else if d>125 then for o=33,59 do if 128~=d then t[e[f]]=t[e[r]]+e[l];break;end;n=e[r];break;end;else t[e[f]]=t[e[r]]+e[l];end end else if 134>d then if 132==d then t[e[f]]=t[e[r]]*e[l];else for d=0,6 do if d>=3 then if d>=5 then if 6==d then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end else if 4>d then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end end else if d>=1 then if d>=0 then for l=10,94 do if d>1 then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end else if 134>=d then local n=e[f];local f=t[n];for e=n+1,e[r]do b.IZGgCIfj(f,t[e])end;else if d>135 then local o=e[f];local r={};for e=1,#a do local e=a[e];for n=0,#e do local e=e[n];local f=e[1];local n=e[2];if f==t and n>=o then r[n]=f[n];e[1]=r;end;end;end;else local b,h;for d=0,6 do if d<3 then if d>0 then if d>0 then repeat if 2~=d then t[e[f]]=t[e[r]]%t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+e[l];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]]+e[l];n=n+1;e=o[n];end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end else if 4>=d then if 4~=d then t[e[f]]=y[e[r]];n=n+1;e=o[n];else b=e[f];h=t[e[r]];t[b+1]=h;t[b]=h[e[l]];n=n+1;e=o[n];end else if d>1 then for l=43,67 do if 5~=d then t[e[f]]=t[e[r]];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end end end end end else if d>=142 then if d>=145 then if d>=146 then if 145<d then for b=49,69 do if 147~=d then local b,z,h,y,s,d;for d=0,3 do if 2>d then if 1~=d then d=0;while d>-1 do if 3>d then if 0>=d then b=e;else if 1~=d then h=r;else z=f;end end else if d>=5 then if d>=4 then repeat if 5<d then d=-2;break;end;t(s,y);until true;else d=-2;end else if 1<d then repeat if 4~=d then y=b[h];break;end;s=b[z];until true;else s=b[z];end end end d=d+1 end n=n+1;e=o[n];else d=0;while d>-1 do if 3>d then if 0>=d then b=e;else if d~=-3 then for e=23,94 do if 1<d then h=r;break;end;z=f;break;end;else h=r;end end else if 4<d then if d~=1 then for e=40,70 do if d>5 then d=-2;break;end;t(s,y);break;end;else d=-2;end else if d>-1 then for e=21,98 do if d~=3 then s=b[z];break;end;y=b[h];break;end;else y=b[h];end end end d=d+1 end n=n+1;e=o[n];end else if d~=-2 then for b=23,83 do if 2<d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else if not t[e[f]]then n=n+1;else n=e[r];end;end end end break;end;local d,l,h;for b=0,2 do if 0>=b then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if-3~=b then repeat if b~=2 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]h=t[d+2];if(h>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end break;end;else local d,l,h;for b=0,2 do if 0>=b then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if-3~=b then repeat if b~=2 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]h=t[d+2];if(h>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local e=e[f];do return h(t,e,s)end;end else if 143>d then do return t[e[f]]end else if 141~=d then for b=21,68 do if d>143 then local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return end;break;end;local n=e[f];do return t[n](h(t,n+1,e[r]))end;break;end;else local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return end;end end end else if 138>=d then if 137<d then t[e[f]]=y[e[r]];else local o=t[e[l]];if not o then n=n+1;else t[e[f]]=o;n=e[r];end;end else if d>139 then if 140<d then for e=e[f],e[r]do t[e]=nil;end;else local b;for d=0,5 do if d>=3 then if d<=3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else if d==5 then if t[e[f]]then n=n+1;else n=e[r];end;else b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];end end else if d<1 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else if d~=-2 then for l=22,81 do if d>1 then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end end end end end else t[e[f]]=(e[r]~=0);end end end end else if d>=159 then if d>163 then if d<167 then if 165<=d then if d~=163 then for l=14,68 do if d>165 then local l,b,a,s,y,d,h;d=0;while d>-1 do if 3>d then if 1>d then l=e;else if-3~=d then for e=13,95 do if 2~=d then b=f;break;end;a=r;break;end;else b=f;end end else if d>=5 then if 4~=d then for e=32,57 do if d~=5 then d=-2;break;end;t(y,s);break;end;else d=-2;end else if d>=2 then for e=35,74 do if 3~=d then y=l[b];break;end;s=l[a];break;end;else y=l[b];end end end d=d+1 end n=n+1;e=o[n];h=e[f]t[h](t[h+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;break;end;local r,l,d;for h=0,1 do if-3<h then for y=45,94 do if h>0 then r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;break;end;r=e[f];s=r+_-1;for e=r,s do l=u[e-r];t[e]=l;end;n=n+1;e=o[n];break;end;else r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;end end break;end;else local r,l,d;for h=0,1 do if-3<h then for y=45,94 do if h>0 then r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;break;end;r=e[f];s=r+_-1;for e=r,s do l=u[e-r];t[e]=l;end;n=n+1;e=o[n];break;end;else r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;end end end else for d=0,1 do if d~=-3 then repeat if 0~=d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else if not t[e[f]]then n=n+1;else n=e[r];end;end end end else if d>167 then if 166<d then repeat if 169~=d then z[e[r]]=t[e[f]];break;end;local _,k,u,p,c,_,d,l,s,y,b,z,a;d=0;while d>-1 do if d>3 then if d<=5 then if d==5 then z=l[k];else c=p[l[u]];end else if d>=4 then repeat if d>6 then d=-2;break;end;t[z]=c;until true;else d=-2;end end else if 1<d then if 3==d then p=t;else u=r;end else if-4<=d then repeat if d<1 then l=e;break;end;k=f;until true;else l=e;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if d<1 then l=e;else if d==1 then s=f;else y=r;end end else if d<5 then if d<4 then b=l[y];else z=l[s];end else if d>1 then repeat if 5~=d then d=-2;break;end;t(z,b);until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d<5 then if d~=-1 then for e=42,61 do if d<4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end else if 3~=d then for e=46,81 do if d<6 then t(z,b);break;end;d=-2;break;end;else t(z,b);end end else if d>0 then if 0<d then repeat if 1~=d then y=r;break;end;s=f;until true;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>2 then if 5<=d then if 6~=d then t(z,b);else d=-2;end else if d>=0 then repeat if 4>d then b=l[y];break;end;z=l[s];until true;else b=l[y];end end else if 0>=d then l=e;else if d>1 then y=r;else s=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if 1<=d then if-1~=d then for e=33,78 do if d~=2 then s=f;break;end;y=r;break;end;else y=r;end else l=e;end else if d>=5 then if d==6 then d=-2;else t(z,b);end else if d~=0 then for e=10,76 do if d~=4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4>=d then if d>3 then z=l[s];else b=l[y];end else if d>1 then repeat if d>5 then d=-2;break;end;t(z,b);until true;else t(z,b);end end else if d>=1 then if d==1 then s=f;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))until true;else local _,c,p,u,k,_,d,l,s,y,b,z,a;d=0;while d>-1 do if d>3 then if d<=5 then if d==5 then z=l[c];else k=u[l[p]];end else if d>=4 then repeat if d>6 then d=-2;break;end;t[z]=k;until true;else d=-2;end end else if 1<d then if 3==d then u=t;else p=r;end else if-4<=d then repeat if d<1 then l=e;break;end;c=f;until true;else l=e;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if d<1 then l=e;else if d==1 then s=f;else y=r;end end else if d<5 then if d<4 then b=l[y];else z=l[s];end else if d>1 then repeat if 5~=d then d=-2;break;end;t(z,b);until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d<5 then if d~=-1 then for e=42,61 do if d<4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end else if 3~=d then for e=46,81 do if d<6 then t(z,b);break;end;d=-2;break;end;else t(z,b);end end else if d>0 then if 0<d then repeat if 1~=d then y=r;break;end;s=f;until true;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>2 then if 5<=d then if 6~=d then t(z,b);else d=-2;end else if d>=0 then repeat if 4>d then b=l[y];break;end;z=l[s];until true;else b=l[y];end end else if 0>=d then l=e;else if d>1 then y=r;else s=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if 1<=d then if-1~=d then for e=33,78 do if d~=2 then s=f;break;end;y=r;break;end;else y=r;end else l=e;end else if d>=5 then if d==6 then d=-2;else t(z,b);end else if d~=0 then for e=10,76 do if d~=4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4>=d then if d>3 then z=l[s];else b=l[y];end else if d>1 then repeat if d>5 then d=-2;break;end;t(z,b);until true;else t(z,b);end end else if d>=1 then if d==1 then s=f;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))end else if not t[e[f]]then n=n+1;else n=e[r];end;end end else if d<161 then if d>159 then if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;else local l;for d=0,6 do if d<=2 then if 1>d then t(e[f],e[r]);n=n+1;e=o[n];else if-1<=d then for b=39,56 do if 2~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end end else if 5>d then if d==4 then t[e[f]]=t[e[r]];n=n+1;e=o[n];else t[e[f]]={};n=n+1;e=o[n];end else if d>=2 then for l=17,90 do if 6>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);break;end;else t(e[f],e[r]);end end end end end else if 162>d then do return end;else if d~=163 then local e=e[f]t[e]=t[e](t[e+1])else if(e[f]<t[e[l]])then n=n+1;else n=e[r];end;end end end end else if d>152 then if d>155 then if d<=156 then local b,y,s,h,a,z,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 3>=d then if 2<=d then if d>=0 then for e=27,58 do if d>2 then h=t;break;end;s=r;break;end;else h=t;end else if-1<=d then for n=10,95 do if d~=0 then y=f;break;end;b=e;break;end;else b=e;end end else if 6<=d then if d>2 then repeat if 6<d then d=-2;break;end;t[z]=a;until true;else d=-2;end else if 4==d then a=h[b[s]];else z=b[y];end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;else if 155<d then for o=34,82 do if d~=158 then local e=e[f]t[e](t[e+1])break;end;if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;break;end;else local e=e[f]t[e](t[e+1])end end else if 153<d then if d>152 then repeat if 154~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=(e[r]~=0);n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];break;end;for d=0,1 do if-2<=d then repeat if 0~=d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else if not t[e[f]]then n=n+1;else n=e[r];end;end end until true;else t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=(e[r]~=0);n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];end else t[e[f]]=(e[r]~=0);end end else if 150<=d then if d<151 then local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end else if d<152 then t[e[f]]=t[e[r]][e[l]];else t[e[f]]=t[e[r]]-e[l];end end else if 146~=d then for b=48,93 do if 149>d then local d,b;d=e[f];b=t[e[r]];t[d+1]=b;t[d]=b[e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]]*e[l];break;end;t[e[f]]=t[e[r]]-t[e[l]];break;end;else local d,b;d=e[f];b=t[e[r]];t[d+1]=b;t[d]=b[e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]]*e[l];end end end end end else if d<106 then if 95>d then if d>89 then if 91>=d then if d>87 then repeat if d<91 then local b;for d=0,6 do if d<=2 then if 1<=d then if d>=-1 then repeat if d<2 then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end else if d<=4 then if 2~=d then for b=18,65 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 6~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];else b=e[f]t[b](h(t,b+1,e[r]))end end end end break;end;t[e[f]]=t[e[r]]+t[e[l]];until true;else local b;for d=0,6 do if d<=2 then if 1<=d then if d>=-1 then repeat if d<2 then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end else if d<=4 then if 2~=d then for b=18,65 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 6~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];else b=e[f]t[b](h(t,b+1,e[r]))end end end end end else if 93>d then n=e[r];else if 92<d then repeat if 94>d then local e=e[f]t[e]=t[e](h(t,e+1,s))break;end;local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;until true;else local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;end end end else if 86>=d then if 85<d then t[e[f]]();else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t[e[f]]=#t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]]-t[e[l]];n=n+1;e=o[n];t(e[f],e[r]);end else if 88<=d then if d==89 then if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;else local o=t[e[l]];if not o then n=n+1;else t[e[f]]=o;n=e[r];end;end else local d;y[e[r]]=t[e[f]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end end end else if d<=99 then if d<=96 then if d>92 then repeat if 95<d then t[e[f]]=t[e[r]]%t[e[l]];break;end;local f=e[f];local n=t[e[r]];t[f+1]=n;t[f]=n[e[l]];until true;else t[e[f]]=t[e[r]]%t[e[l]];end else if d>97 then if 99==d then if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;else local n=e[f];do return t[n](h(t,n+1,e[r]))end;end else local e=e[f];local n=t[e];for e=e+1,s do b.IZGgCIfj(n,t[e])end;end end else if d>=103 then if d>=104 then if 101~=d then for b=43,95 do if 104<d then local d;for b=0,4 do if b<=1 then if-3<b then repeat if 0~=b then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if b<3 then t(e[f],e[r]);n=n+1;e=o[n];else if b>=2 then for y=42,95 do if b<4 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end end end end break;end;t[e[f]]=z[e[r]];break;end;else local d;for b=0,4 do if b<=1 then if-3<b then repeat if 0~=b then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if b<3 then t(e[f],e[r]);n=n+1;e=o[n];else if b>=2 then for y=42,95 do if b<4 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end end end end end else do return t[e[f]]end end else if d>100 then if 101~=d then local o,y,h,d,l,b;local n=0;while n>-1 do if 4>n then if 2<=n then if n~=2 then d=t;else h=r;end else if-1<=n then for t=16,71 do if 1~=n then o=e;break;end;y=f;break;end;else o=e;end end else if 5>=n then if n~=5 then l=d[o[h]];else b=o[y];end else if 6==n then t[b]=l;else n=-2;end end end n=n+1 end else t[e[f]]=p(k[e[r]],nil,z);end else if not t[e[f]]then n=n+1;else n=e[r];end;end end end end else if 115>=d then if d<111 then if 108<=d then if d>=109 then if 106<=d then repeat if 110~=d then t[e[f]]={};break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]={};until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]={};end else t[e[f]]={};end else if 105<d then repeat if 107~=d then t[e[f]]=z[e[r]];break;end;t[e[f]]=t[e[r]]+e[l];until true;else t[e[f]]=z[e[r]];end end else if 112<d then if d>=114 then if d~=110 then repeat if 114~=d then for d=0,1 do if d~=-4 then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end break;end;t[e[f]]=t[e[r]]%e[l];until true;else for d=0,1 do if d~=-4 then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end else local s,z,h,b,d,y,o;local n=0;while n>-1 do if 3>n then if n>0 then if 1<n then d=b[z];else b=e;end else s=f;z=r;h=l;end else if n<=4 then if-1~=n then repeat if n<4 then y=b[s];break;end;o=t[d];for e=1+d,b[h]do o=o..t[e];end;until true;else o=t[d];for e=1+d,b[h]do o=o..t[e];end;end else if 2<=n then for e=13,85 do if 5<n then n=-2;break;end;t[y]=o;break;end;else n=-2;end end end n=n+1 end end else if d>=110 then for b=47,71 do if 111~=d then t[e[f]]=t[e[r]][t[e[l]]];break;end;local b;for d=0,6 do if 3<=d then if d<=4 then if d~=-1 then for b=49,86 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end else if 3~=d then repeat if 5<d then b=e[f]t[b](h(t,b+1,e[r]))break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if 0<d then if d>1 then t[e[f]]=z[e[r]];n=n+1;e=o[n];else b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end end end break;end;else t[e[f]]=t[e[r]][t[e[l]]];end end end else if d<121 then if 117>=d then if d<117 then local n=e[f]t[n]=t[n](h(t,n+1,e[r]))else t[e[f]]=t[e[r]]+t[e[l]];end else if 118<d then if d~=120 then if t[e[f]]then n=n+1;else n=e[r];end;else local d,l,b;for h=0,2 do if 1<=h then if 0<h then for y=47,62 do if 2>h then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end end end else t[e[f]][t[e[r]]]=t[e[l]];end end else if d<124 then if 122>d then local e=e[f];s=e+_-1;for n=e,s do local e=u[n-e];t[n]=e;end;else if 122==d then local l;for d=0,6 do if 3<=d then if 5<=d then if 5<d then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end else if 2<d then repeat if 4>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if d>0 then if d>0 then repeat if 2>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end else local l,d,h,b,o;local n=0;while n>-1 do if 3<=n then if 5<=n then if n>=2 then repeat if 5~=n then n=-2;break;end;t(o,b);until true;else t(o,b);end else if 2~=n then repeat if 3<n then o=l[d];break;end;b=l[h];until true;else o=l[d];end end else if n>=1 then if n~=-1 then repeat if n<2 then d=f;break;end;h=r;until true;else d=f;end else l=e;end end n=n+1 end end end else if d>124 then if d>=121 then repeat if d~=126 then local d,z,h,b,y,l;t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];d=e[f];z={};for e=1,#a do h=a[e];for e=0,#h do b=h[e];y=b[1];l=b[2];if y==t and l>=d then z[l]=y[l];b[1]=z;end;end;end;n=n+1;e=o[n];n=e[r];break;end;t[e[f]]();until true;else local d,y,h,b,z,l;t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];d=e[f];y={};for e=1,#a do h=a[e];for e=0,#h do b=h[e];z=b[1];l=b[2];if z==t and l>=d then y[l]=z[l];b[1]=y;end;end;end;n=n+1;e=o[n];n=e[r];end else y[e[r]]=t[e[f]];end end end end end end else if 42>d then if 21<=d then if 30>=d then if d<=25 then if 23<=d then if d>=24 then if 22<d then repeat if 25~=d then local h,b;for d=0,4 do if d<=1 then if d>-4 then for b=21,76 do if 0~=d then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 2<d then if d==3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else h=e[r];b=t[h]for e=h+1,e[l]do b=b..t[e];end;t[e[f]]=b;end else t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];end end end break;end;local b,h,y;for d=0,6 do if 3<=d then if 4<d then if d==6 then b=e[f];h=t[b]y=t[b+2];if(y>0)then if(h>t[b+1])then n=e[r];else t[b+3]=h;end elseif(h<t[b+1])then n=e[r];else t[b+3]=h;end else t(e[f],e[r]);n=n+1;e=o[n];end else if d>0 then repeat if 4~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end end else if 1>d then t[e[f]]=z[e[r]];n=n+1;e=o[n];else if d>-1 then repeat if 2~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;t[e[f]]={};n=n+1;e=o[n];until true;else t[e[f]]={};n=n+1;e=o[n];end end end end until true;else local h,b;for d=0,4 do if d<=1 then if d>-4 then for b=21,76 do if 0~=d then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 2<d then if d==3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else h=e[r];b=t[h]for e=h+1,e[l]do b=b..t[e];end;t[e[f]]=b;end else t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];end end end end else local e=e[f];s=e+_-1;for n=e,s do local e=u[n-e];t[n]=e;end;end else if d==21 then local o,h,y,d,b,l;local n=0;while n>-1 do if n<=3 then if n>=2 then if-1~=n then repeat if n~=3 then y=r;break;end;d=t;until true;else d=t;end else if n>0 then h=f;else o=e;end end else if n>5 then if n>3 then repeat if n~=6 then n=-2;break;end;t[l]=b;until true;else n=-2;end else if 4<n then l=o[h];else b=d[o[y]];end end end n=n+1 end else local l,b,y,z,h,d;t[e[f]]={};n=n+1;e=o[n];t[e[f]]={};n=n+1;e=o[n];t[e[f]]={};n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if d>=5 then if 3<d then repeat if d~=6 then t(h,z);break;end;d=-2;until true;else t(h,z);end else if 4~=d then z=l[y];else h=l[b];end end else if d<1 then l=e;else if d>=0 then for e=13,96 do if d>1 then y=r;break;end;b=f;break;end;else b=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d<=2 then if 0>=d then l=e;else if-3<d then for e=37,94 do if 1<d then y=r;break;end;b=f;break;end;else y=r;end end else if d>4 then if 6==d then d=-2;else t(h,z);end else if d>2 then for e=46,87 do if d~=3 then h=l[b];break;end;z=l[y];break;end;else h=l[b];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if 4>=d then if 1<d then for e=40,98 do if d~=4 then z=l[y];break;end;h=l[b];break;end;else h=l[b];end else if d~=5 then d=-2;else t(h,z);end end else if d>=1 then if d~=-1 then for e=29,71 do if 1<d then y=r;break;end;b=f;break;end;else b=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if d>=5 then if 2<=d then repeat if d~=5 then d=-2;break;end;t(h,z);until true;else d=-2;end else if d>1 then for e=17,62 do if 4>d then z=l[y];break;end;h=l[b];break;end;else z=l[y];end end else if d>=1 then if d>=-1 then repeat if 1~=d then y=r;break;end;b=f;until true;else b=f;end else l=e;end end d=d+1 end end end else if 28<=d then if 29<=d then if 28<d then repeat if d~=29 then local n=e[f]t[n]=t[n](h(t,n+1,e[r]))break;end;local _,s,z,y,_,d,a,l,u,p,k,c,b;d=0;while d>-1 do if 2>=d then if d>=1 then if-3<d then for e=26,81 do if 1<d then z=r;break;end;s=f;break;end;else z=r;end else l=e;end else if 5<=d then if 1<=d then repeat if d<6 then t(b,y);break;end;d=-2;until true;else t(b,y);end else if d>3 then b=l[s];else y=l[z];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if 4<d then if d~=6 then t(b,y);else d=-2;end else if d>=-1 then for e=22,80 do if 3<d then b=l[s];break;end;y=l[z];break;end;else y=l[z];end end else if 0<d then if-2~=d then for e=45,78 do if d>1 then z=r;break;end;s=f;break;end;else z=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 3<=d then if 4<d then if d>=1 then for e=48,86 do if 6>d then t(b,y);break;end;d=-2;break;end;else t(b,y);end else if 2~=d then for e=36,91 do if 3~=d then b=l[s];break;end;y=l[z];break;end;else y=l[z];end end else if d>0 then if d>1 then z=r;else s=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4<d then if 4~=d then repeat if 5~=d then d=-2;break;end;t(b,y);until true;else t(b,y);end else if 0~=d then for e=30,94 do if 3<d then b=l[s];break;end;y=l[z];break;end;else b=l[s];end end else if d>0 then if 0~=d then for e=44,56 do if 2>d then s=f;break;end;z=r;break;end;else s=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d>=5 then if 5==d then t(b,y);else d=-2;end else if d==4 then b=l[s];else y=l[z];end end else if d<1 then l=e;else if-2<d then repeat if 1~=d then z=r;break;end;s=f;until true;else s=f;end end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))n=n+1;e=o[n];d=0;while d>-1 do if 3>=d then if 2<=d then if 3~=d then p=r;else k=t;end else if 0<d then u=f;else l=e;end end else if 5<d then if 6==d then t[b]=c;else d=-2;end else if 1~=d then repeat if d~=4 then b=l[u];break;end;c=k[l[p]];until true;else b=l[u];end end end d=d+1 end until true;else local n=e[f]t[n]=t[n](h(t,n+1,e[r]))end else local l;for d=0,6 do if d>2 then if 4>=d then if 2<=d then repeat if d~=3 then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if d~=3 then repeat if 6~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);until true;else t(e[f],e[r]);n=n+1;e=o[n];end end else if d<=0 then t(e[f],e[r]);n=n+1;e=o[n];else if d~=1 then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end end end end end else if 26~=d then local d,y;for b=0,6 do if 3>b then if 0<b then if b~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if b<=4 then if-1~=b then repeat if b>3 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];until true;else t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];end else if 5==b then d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];else t[e[f]]=t[e[r]];end end end end else t[e[f]]=t[e[r]][e[l]];end end end else if d>35 then if d<39 then if 36<d then if d<38 then local r,b,h,l,y,d;for z=0,1 do if 1>z then r=e[f]t[r](t[r+1])n=n+1;e=o[n];else r=e[f];b={};for e=1,#a do h=a[e];for e=0,#h do l=h[e];y=l[1];d=l[2];if y==t and d>=r then b[d]=y[d];l[1]=b;end;end;end;end end else z[e[r]]=t[e[f]];end else local d;t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]];end else if 39>=d then local s=k[e[r]];local h;local d={};h=b.bKAFqMnc({},{__index=function(n,e)local e=d[e];return e[1][e[2]];end,__newindex=function(t,e,n)local e=d[e]e[1][e[2]]=n;end;});for f=1,e[l]do n=n+1;local e=o[n];if e[j]==21 then d[f-1]={t,e[r]};else d[f-1]={y,e[r]};end;a[#a+1]=d;end;t[e[f]]=p(s,h,z);else if 39~=d then for b=27,84 do if 40<d then local b;for d=0,5 do if 2<d then if d<4 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];else if 1~=d then repeat if d~=4 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else if d<1 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if 1<d then b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end break;end;y[e[r]]=t[e[f]];break;end;else local b;for d=0,5 do if 2<d then if d<4 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];else if 1~=d then repeat if d~=4 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else if d<1 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if 1<d then b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end end end end else if d<=32 then if 27~=d then repeat if 32>d then local d;for b=0,3 do if 2<=b then if 3>b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if t[e[f]]then n=n+1;else n=e[r];end;end else if 0~=b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end break;end;for e=e[f],e[r]do t[e]=nil;end;until true;else local d;for b=0,3 do if 2<=b then if 3>b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if t[e[f]]then n=n+1;else n=e[r];end;end else if 0~=b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end end else if 34>d then local e=e[f]t[e]=t[e]()else if d>=30 then for o=39,68 do if 34~=d then if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;local e=e[f];do return h(t,e,s)end;break;end;else local e=e[f];do return h(t,e,s)end;end end end end end else if d>9 then if d>=15 then if 18<=d then if 19<=d then if d==20 then local d;for l=0,6 do if l<=2 then if l>=1 then if l<2 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end else if l>=5 then if 1<=l then repeat if 6~=l then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];until true;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end else if l~=2 then repeat if 3<l then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local e=e[f]t[e](t[e+1])end else local e=e[f]t[e]=t[e](t[e+1])end else if d>=16 then if 13~=d then for n=14,64 do if 17~=d then t[e[f]]=p(k[e[r]],nil,z);break;end;t[e[f]][t[e[r]]]=t[e[l]];break;end;else t[e[f]]=p(k[e[r]],nil,z);end else local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];d=e[f];do return t[d](h(t,d+1,e[r]))end;n=n+1;e=o[n];d=e[f];do return h(t,d,s)end;n=n+1;e=o[n];do return end;end end else if 12>d then if d~=9 then for b=33,52 do if 10~=d then local d,l,b;for h=0,2 do if 0>=h then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h>-3 then for y=38,95 do if h>1 then d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end end end break;end;local s,y,z,d,h,b;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];s=e[f];y={};for e=1,#a do z=a[e];for e=0,#z do d=z[e];h=d[1];b=d[2];if h==t and b>=s then y[b]=h[b];d[1]=y;end;end;end;break;end;else local d,l,b;for h=0,2 do if 0>=h then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h>-3 then for y=38,95 do if h>1 then d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end end end end else if 13>d then local d,a,y,b;for l=0,5 do if 2>=l then if 0<l then if-3<=l then for b=14,60 do if l~=1 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f]t[d]=t[d]()n=n+1;e=o[n];break;end;else d=e[f]t[d]=t[d]()n=n+1;e=o[n];end else d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];end else if l>3 then if l>4 then d=e[f]t[d]=t[d](h(t,d+1,s))else d=e[f]a,y=c(t[d](h(t,d+1,e[r])))s=y+d-1 b=0;for e=d,s do b=b+1;t[e]=a[b];end;n=n+1;e=o[n];end else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end end else if d>=10 then repeat if 13~=d then t[e[f]][e[r]]=t[e[l]];break;end;if t[e[f]]then n=n+1;else n=e[r];end;until true;else if t[e[f]]then n=n+1;else n=e[r];end;end end end end else if 4>=d then if 2>d then if d~=-2 then for b=13,95 do if d>0 then t[e[f]]=t[e[r]]-t[e[l]];break;end;local b;for d=0,6 do if d>2 then if 4>=d then if d==3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if d>2 then repeat if 6~=d then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];until true;else t[e[f]]=t[e[r]][t[e[l]]];end end else if 1<=d then if d~=-1 then for l=49,61 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end break;end;else local b;for d=0,6 do if d>2 then if 4>=d then if d==3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if d>2 then repeat if 6~=d then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];until true;else t[e[f]]=t[e[r]][t[e[l]]];end end else if 1<=d then if d~=-1 then for l=49,61 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end end else if d<3 then if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;else if d~=2 then repeat if 4~=d then local d;for l=0,1 do if-1<l then repeat if 0~=l then if t[e[f]]then n=n+1;else n=e[r];end;break;end;d=e[f]t[d]=t[d]()n=n+1;e=o[n];until true;else d=e[f]t[d]=t[d]()n=n+1;e=o[n];end end break;end;local l,b,s,u,a,z,d,p;for d=0,6 do if d<3 then if 1<=d then if d~=2 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if d>=5 then if 6>d then d=0;while d>-1 do if d<4 then if 2>d then if d>-4 then for n=24,86 do if 1>d then l=e;break;end;b=f;break;end;else b=f;end else if d~=-2 then repeat if 3~=d then s=r;break;end;u=t;until true;else s=r;end end else if 5<d then if 4<d then repeat if 7>d then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if 2<d then for e=37,77 do if d>4 then z=l[b];break;end;a=u[l[s]];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];else p=e[f]t[p]=t[p](h(t,p+1,e[r]))end else if 2<=d then repeat if 3<d then d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];break;end;d=0;while d>-1 do if 4>d then if d>=2 then if d>=1 then repeat if d>2 then u=t;break;end;s=r;until true;else s=r;end else if-1<d then repeat if 1>d then l=e;break;end;b=f;until true;else b=f;end end else if d>5 then if 3<d then repeat if d~=7 then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if d~=2 then for e=48,60 do if 5>d then a=u[l[s]];break;end;z=l[b];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];until true;else d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];end end end end until true;else local l,b,s,u,a,z,d,p;for d=0,6 do if d<3 then if 1<=d then if d~=2 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if d>=5 then if 6>d then d=0;while d>-1 do if d<4 then if 2>d then if d>-4 then for n=24,86 do if 1>d then l=e;break;end;b=f;break;end;else b=f;end else if d~=-2 then repeat if 3~=d then s=r;break;end;u=t;until true;else s=r;end end else if 5<d then if 4<d then repeat if 7>d then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if 2<d then for e=37,77 do if d>4 then z=l[b];break;end;a=u[l[s]];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];else p=e[f]t[p]=t[p](h(t,p+1,e[r]))end else if 2<=d then repeat if 3<d then d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];break;end;d=0;while d>-1 do if 4>d then if d>=2 then if d>=1 then repeat if d>2 then u=t;break;end;s=r;until true;else s=r;end else if-1<d then repeat if 1>d then l=e;break;end;b=f;until true;else b=f;end end else if d>5 then if 3<d then repeat if d~=7 then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if d~=2 then for e=48,60 do if 5>d then a=u[l[s]];break;end;z=l[b];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];until true;else d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];end end end end end end end else if 6<d then if d>=8 then if d>=5 then repeat if d~=9 then local l,z,y,a,h,d,b,s,u;for d=0,2 do if 0<d then if-3<=d then for p=23,88 do if 2~=d then d=0;while d>-1 do if d<=2 then if 1<=d then if 0~=d then repeat if 2~=d then z=f;break;end;y=r;until true;else y=r;end else l=e;end else if d<=4 then if d>2 then repeat if 3<d then h=l[z];break;end;a=l[y];until true;else h=l[z];end else if 5<d then d=-2;else t(h,a);end end end d=d+1 end n=n+1;e=o[n];break;end;b=e[f];s=t[b]u=t[b+2];if(u>0)then if(s>t[b+1])then n=e[r];else t[b+3]=s;end elseif(s<t[b+1])then n=e[r];else t[b+3]=s;end break;end;else d=0;while d>-1 do if d<=2 then if 1<=d then if 0~=d then repeat if 2~=d then z=f;break;end;y=r;until true;else y=r;end else l=e;end else if d<=4 then if d>2 then repeat if 3<d then h=l[z];break;end;a=l[y];until true;else h=l[z];end else if 5<d then d=-2;else t(h,a);end end end d=d+1 end n=n+1;e=o[n];end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end end break;end;t[e[f]]=y[e[r]];until true;else t[e[f]]=y[e[r]];end else local d,b,y;for h=0,4 do if 1<h then if h<=2 then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h~=-1 then repeat if 3<h then d=e[f];b=t[d]y=t[d+2];if(y>0)then if(b>t[d+1])then n=e[r];else t[d+3]=b;end elseif(b<t[d+1])then n=e[r];else t[d+3]=b;end break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else d=e[f];b=t[d]y=t[d+2];if(y>0)then if(b>t[d+1])then n=e[r];else t[d+3]=b;end elseif(b<t[d+1])then n=e[r];else t[d+3]=b;end end end else if 0~=h then t(e[f],e[r]);n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end end else if d~=1 then repeat if d~=5 then local s,u,z,a,p,d,l,y;for d=0,2 do if 1<=d then if d>0 then repeat if 2>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;until true;else l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;end else d=0;while d>-1 do if 2>=d then if 1>d then s=e;else if-1<d then for e=29,57 do if 1<d then z=r;break;end;u=f;break;end;else z=r;end end else if d>4 then if d>=2 then repeat if d~=6 then t(p,a);break;end;d=-2;until true;else d=-2;end else if-1<=d then for e=18,98 do if d<4 then a=s[z];break;end;p=s[u];break;end;else a=s[z];end end end d=d+1 end n=n+1;e=o[n];end end break;end;local l;for d=0,6 do if 2>=d then if 1<=d then if d>-3 then repeat if 2~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end else if 5>d then if d~=3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if 3<=d then for l=33,54 do if 6>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);break;end;else t(e[f],e[r]);end end end end until true;else local s,p,z,a,u,d,l,y;for d=0,2 do if 1<=d then if d>0 then repeat if 2>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;until true;else l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;end else d=0;while d>-1 do if 2>=d then if 1>d then s=e;else if-1<d then for e=29,57 do if 1<d then z=r;break;end;p=f;break;end;else z=r;end end else if d>4 then if d>=2 then repeat if d~=6 then t(u,a);break;end;d=-2;until true;else d=-2;end else if-1<=d then for e=18,98 do if d<4 then a=s[z];break;end;u=s[p];break;end;else a=s[z];end end end d=d+1 end n=n+1;e=o[n];end end end end end end end else if d>=63 then if 73<d then if d>78 then if 82>d then if 80<=d then if d~=79 then for b=49,84 do if d~=81 then local b;for d=0,3 do if d>1 then if 0<d then for b=38,57 do if d>2 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;else t[e[f]][t[e[r]]]=t[e[l]];end else if-1~=d then repeat if d~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end break;end;local d,d,d,c,k,d,d,s,p,u,h,z,a,b;for d=0,6 do if d>2 then if d>4 then if d>1 then repeat if 6~=d then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;d=0;while d>-1 do if 2>=d then if d>0 then if 2==d then z=h[p];else h=e;end else s=f;p=r;u=l;end else if d<5 then if d~=1 then for e=14,94 do if 3<d then b=t[z];for e=1+z,h[u]do b=b..t[e];end;break;end;a=h[s];break;end;else b=t[z];for e=1+z,h[u]do b=b..t[e];end;end else if 1~=d then repeat if d~=6 then t[a]=b;break;end;d=-2;until true;else d=-2;end end end d=d+1 end until true;else d=0;while d>-1 do if 2>=d then if d>0 then if 2==d then z=h[p];else h=e;end else s=f;p=r;u=l;end else if d<5 then if d~=1 then for e=14,94 do if 3<d then b=t[z];for e=1+z,h[u]do b=b..t[e];end;break;end;a=h[s];break;end;else b=t[z];for e=1+z,h[u]do b=b..t[e];end;end else if 1~=d then repeat if d~=6 then t[a]=b;break;end;d=-2;until true;else d=-2;end end end d=d+1 end end else if d==4 then t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end end else if 1<=d then if-1~=d then repeat if d<2 then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;d=0;while d>-1 do if d<4 then if d<2 then if d~=-3 then for n=43,77 do if 0<d then s=f;break;end;h=e;break;end;else s=f;end else if-2<d then for e=32,80 do if 2~=d then c=t;break;end;p=r;break;end;else c=t;end end else if 6>d then if d>4 then a=h[s];else k=c[h[p]];end else if 6<d then d=-2;else t[a]=k;end end end d=d+1 end n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];end else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end break;end;else local b;for d=0,3 do if d>1 then if 0<d then for b=38,57 do if d>2 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;else t[e[f]][t[e[r]]]=t[e[l]];end else if-1~=d then repeat if d~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end else t[e[f]]=t[e[r]]*e[l];end else if 82<d then if d==84 then local e=e[f]local f,n=c(t[e](t[e+1]))s=n+e-1 local n=0;for e=e,s do n=n+1;t[e]=f[n];end;else local s=k[e[r]];local h;local d={};h=b.bKAFqMnc({},{__index=function(n,e)local e=d[e];return e[1][e[2]];end,__newindex=function(t,e,n)local e=d[e]e[1][e[2]]=n;end;});for f=1,e[l]do n=n+1;local e=o[n];if e[j]==21 then d[f-1]={t,e[r]};else d[f-1]={y,e[r]};end;a[#a+1]=d;end;t[e[f]]=p(s,h,z);end else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;end end else if d>=76 then if d>=77 then if 74~=d then for b=31,81 do if 77~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;break;end;t[e[f]][e[r]]=t[e[l]];break;end;else t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else local d,u,z,l,y,b;d=e[f];do return t[d](h(t,d+1,e[r]))end;n=n+1;e=o[n];d=e[f];do return h(t,d,s)end;n=n+1;e=o[n];d=e[f];u={};for e=1,#a do z=a[e];for e=0,#z do l=z[e];y=l[1];b=l[2];if y==t and b>=d then u[b]=y[b];l[1]=u;end;end;end;end else if d~=74 then local o=e[f];local f={};for e=1,#a do local e=a[e];for n=0,#e do local n=e[n];local r=n[1];local e=n[2];if r==t and e>=o then f[e]=r[e];n[1]=f;end;end;end;else t[e[f]]=t[e[r]]%e[l];end end end else if d>67 then if d>=71 then if d>71 then if d~=69 then repeat if 73~=d then local e=e[f]local f,n=c(t[e](t[e+1]))s=n+e-1 local n=0;for e=e,s do n=n+1;t[e]=f[n];end;break;end;local h,a,b,z,y,s,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 1<d then if d>=-1 then for e=33,93 do if d>2 then z=t;break;end;b=r;break;end;else b=r;end else if d~=0 then a=f;else h=e;end end else if 5>=d then if d>=2 then for e=34,59 do if 4<d then s=h[a];break;end;y=z[h[b]];break;end;else y=z[h[b]];end else if 3<d then repeat if 7~=d then t[s]=y;break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;until true;else local h,a,b,y,z,s,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 1<d then if d>=-1 then for e=33,93 do if d>2 then y=t;break;end;b=r;break;end;else b=r;end else if d~=0 then a=f;else h=e;end end else if 5>=d then if d>=2 then for e=34,59 do if 4<d then s=h[a];break;end;z=y[h[b]];break;end;else z=y[h[b]];end else if 3<d then repeat if 7~=d then t[s]=z;break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else local d;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=#t[e[r]];n=n+1;e=o[n];if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;end else if 68>=d then local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;else if 69==d then for d=0,1 do if-4~=d then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if not t[e[f]]then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else local h,z,a,s,y,d,l,b,u;for d=0,2 do if 0<d then if 0<d then for p=35,80 do if d<2 then d=0;while d>-1 do if 3>d then if d>0 then if-2<=d then repeat if d~=2 then z=f;break;end;a=r;until true;else z=f;end else h=e;end else if 5>d then if d~=-1 then repeat if 3~=d then y=h[z];break;end;s=h[a];until true;else y=h[z];end else if d>4 then repeat if d>5 then d=-2;break;end;t(y,s);until true;else t(y,s);end end end d=d+1 end n=n+1;e=o[n];break;end;l=e[f];b=t[l]u=t[l+2];if(u>0)then if(b>t[l+1])then n=e[r];else t[l+3]=b;end elseif(b<t[l+1])then n=e[r];else t[l+3]=b;end break;end;else l=e[f];b=t[l]u=t[l+2];if(u>0)then if(b>t[l+1])then n=e[r];else t[l+3]=b;end elseif(b<t[l+1])then n=e[r];else t[l+3]=b;end end else d=0;while d>-1 do if d<3 then if d<1 then h=e;else if 0<d then for e=16,78 do if 1<d then a=r;break;end;z=f;break;end;else a=r;end end else if d<=4 then if 1<d then repeat if d~=4 then s=h[a];break;end;y=h[z];until true;else y=h[z];end else if d>=1 then repeat if 6~=d then t(y,s);break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];end end end end end else if d>=65 then if 66>d then do return end;else if 62<d then for b=36,93 do if d>66 then local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end break;end;local b,y,s,h,a,z,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 2>d then if d~=-4 then repeat if d~=0 then y=f;break;end;b=e;until true;else b=e;end else if d>=1 then for e=44,88 do if 3~=d then s=r;break;end;h=t;break;end;else h=t;end end else if d<=5 then if 1<=d then repeat if 5>d then a=h[b[s]];break;end;z=b[y];until true;else z=b[y];end else if d>6 then d=-2;else t[z]=a;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;break;end;else local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end end end else if d>59 then repeat if 63~=d then local b,z,s,o,y,h,d;local n=0;while n>-1 do if 2>=n then if n<=0 then b=f;z=r;s=l;else if n~=0 then for t=14,95 do if 1<n then y=o[z];break;end;o=e;break;end;else o=e;end end else if 4>=n then if n>=1 then for e=18,60 do if n~=3 then d=t[y];for e=1+y,o[s]do d=d..t[e];end;break;end;h=o[b];break;end;else h=o[b];end else if n~=5 then n=-2;else t[h]=d;end end end n=n+1 end break;end;local b;for d=0,6 do if d>=3 then if 5>d then if 1<d then repeat if 4>d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else if 1<=d then for b=23,64 do if d>5 then t[e[f]]=z[e[r]];break;end;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;else t[e[f]]=z[e[r]];end end else if 0>=d then b=e[f]t[b](t[b+1])n=n+1;e=o[n];else if d>0 then repeat if 1~=d then t[e[f]]=z[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end end end until true;else local b,z,s,o,y,h,d;local n=0;while n>-1 do if 2>=n then if n<=0 then b=f;z=r;s=l;else if n~=0 then for t=14,95 do if 1<n then y=o[z];break;end;o=e;break;end;else o=e;end end else if 4>=n then if n>=1 then for e=18,60 do if n~=3 then d=t[y];for e=1+y,o[s]do d=d..t[e];end;break;end;h=o[b];break;end;else h=o[b];end else if n~=5 then n=-2;else t[h]=d;end end end n=n+1 end end end end end else if d>51 then if 57<=d then if 59>=d then if d<58 then local d;for b=0,2 do if b<=0 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b==2 then t[e[f]][t[e[r]]]=t[e[l]];else t[e[f]]=t[e[r]]-e[l];n=n+1;e=o[n];end end end else if 57<d then for n=36,98 do if 59>d then t[e[f]]=t[e[r]]-e[l];break;end;local d,h,l,b,o;local n=0;while n>-1 do if 3<=n then if 4<n then if 4~=n then repeat if 6~=n then t(o,b);break;end;n=-2;until true;else t(o,b);end else if 0~=n then for e=42,89 do if n<4 then b=d[l];break;end;o=d[h];break;end;else o=d[h];end end else if n>0 then if-3<=n then for e=36,76 do if 1~=n then l=r;break;end;h=f;break;end;else l=r;end else d=e;end end n=n+1 end break;end;else t[e[f]]=t[e[r]]-e[l];end end else if 61>d then t[e[f]]=#t[e[r]];else if 58<=d then for n=45,83 do if d<62 then local e=e[f]t[e]=t[e]()break;end;t[e[f]]=t[e[r]][t[e[l]]];break;end;else local e=e[f]t[e]=t[e]()end end end else if d>53 then if d<=54 then for d=0,6 do if 2>=d then if 1>d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if-2<d then repeat if d>1 then t[e[f]]=z[e[r]];n=n+1;e=o[n];break;end;z[e[r]]=t[e[f]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end else if d>4 then if 2<d then repeat if d>5 then z[e[r]]=t[e[f]];break;end;t[e[f]]=(e[r]~=0);n=n+1;e=o[n];until true;else z[e[r]]=t[e[f]];end else if d~=4 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else z[e[r]]=t[e[f]];n=n+1;e=o[n];end end end end else if d~=55 then for d=0,6 do if 2>=d then if 1>d then t[e[f]]={};n=n+1;e=o[n];else if d~=2 then t(e[f],e[r]);n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if d<5 then if d~=2 then repeat if 3~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else if d==6 then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local l;for d=0,6 do if d>=3 then if d<=4 then if d>=0 then repeat if 3~=d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end else if d~=3 then for l=48,98 do if d~=5 then t(e[f],e[r]);break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t(e[f],e[r]);end end else if 0<d then if d~=-1 then for l=16,92 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end end end else if d~=49 then repeat if 53~=d then local d,y;for b=0,5 do if 3>b then if 1<=b then if b>-2 then repeat if 2>b then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if 3>=b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b>=3 then for d=44,64 do if 5>b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+t[e[l]];break;end;else t[e[f]]=t[e[r]]+t[e[l]];end end end end break;end;local e=e[f];local n=t[e];for e=e+1,s do b.IZGgCIfj(n,t[e])end;until true;else local d,y;for b=0,5 do if 3>b then if 1<=b then if b>-2 then repeat if 2>b then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if 3>=b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b>=3 then for d=44,64 do if 5>b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+t[e[l]];break;end;else t[e[f]]=t[e[r]]+t[e[l]];end end end end end end end else if 47<=d then if 48<d then if d<=49 then local e=e[f]t[e]=t[e](h(t,e+1,s))else if 47<=d then for n=14,69 do if 50~=d then local n=e[f]t[n](h(t,n+1,e[r]))break;end;t[e[f]]=#t[e[r]];break;end;else t[e[f]]=#t[e[r]];end end else if d>=45 then for o=14,71 do if 48>d then local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end break;end;local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end break;end;else local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end end end else if 43<d then if d>=45 then if d~=42 then for b=37,71 do if d>45 then for d=0,1 do if-4<d then for l=17,89 do if d>0 then t[e[f]]=z[e[r]];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end end break;end;t[e[f]]=t[e[r]]%t[e[l]];break;end;else t[e[f]]=t[e[r]]%t[e[l]];end else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else if 40~=d then repeat if d~=43 then local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;break;end;local n=e[f]t[n](h(t,n+1,e[r]))until true;else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;end end end end end end end n=1+n;end;end;return fe end;local r=0xff;local o={};local d=(1);local f='';(function(n)local t=n local l=0x00 local e=0x00 t={(function(b)if l>0x30 then return b end l=l+1 e=(e+0x995-b)%0x35 return(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xef);r[2]=(r[2]*(fe(function()o()end,h(f))-fe(r[1],h(f))))+1;o[d]={};r=r[2];d=d+r;end return true end)'pFTog'and t[0x3](0x2c4+b))or(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x64);end return true end)'JpjmH'and t[0x1](b+0x3a8))or(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x3a);end return true end)'eyTua'and t[0x2](b+0x272))or b end),(function(f)if l>0x22 then return f end l=l+1 e=(e+0xfd6-f)%0x47 return(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xe5);end return true end)'bIEKJ'and t[0x2](0x182+f))or(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x65);end return true end)'RiyOs'and t[0x1](f+0x2fb))or(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xb5);end return true end)'QQWwz'and t[0x3](f+0x21e))or f end),(function(h)if l>0x2d then return h end l=l+1 e=(e+0xabe-h)%0x29 return(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x2c);f={f..'\58 a',f};o[d]=te();d=d+((not b.IxrpaEaT)and 1 or 0);f[1]='\58'..f[1];r[2]=0xff;end return true end)'XDFzv'and t[0x1](0x2e1+h))or(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xaa);o[d]=oe();d=d+r;end return true end)'inCDP'and t[0x2](h+0x223))or(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x1e);f='\37';r={function()r()end};f=f..'\100\43';end return true end)'oBEOy'and t[0x3](h+0x3d6))or h end)}t[0x3](0x24d7)end){};local e=p(h(o));o[2]={};o[1]=e(o[1])AacnzerEFmRWPYV=nil;e=p(h(o))return e(...);end return re((function()local n={}local e=0x01;local t;if b.IxrpaEaT then t=b.IxrpaEaT(re)else t=''end if b.nYavgHtI(t,b.AvsKrrdr)then e=e+0;else e=e+1;end n[e]=0x02;n[n[e]+0x01]=0x03;return n;end)(),...)end)((function(t,e,n,f,r,o)local o;if t>3 then if t<=5 then if t~=1 then for o=46,58 do if 4~=t then local t=f;do return function()local e=e(n,t(t,t),t(t,t));t(1);return e;end;end;break;end;local t=f;local r,f,o=r(2);do return function()local n,e,d,l=e(n,t(t,t),t(t,t)+3);t(4);return(l*r)+(d*f)+(e*o)+n;end;end;break;end;else local t=f;do return function()local e=e(n,t(t,t),t(t,t));t(1);return e;end;end;end else if 7<=t then if 7~=t then do return n(t,nil,n);end else do return setmetatable({},{['__\99\97\108\108']=function(e,r,t,f,n)if n then return e[n]elseif f then return e else e[r]=t end end})end end else do return r[n]end;end end else if 2>t then if t>=-3 then for o=11,82 do if t>0 then do return function(n,e,t)if t then local e=(n/2^(e-1))%2^((t-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(n%(e+e)>=e)and 1 or 0;end;end;end;break;end;do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;break;end;else do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;end else if 0~=t then for o=40,74 do if t~=3 then do return 16777216,65536,256 end;break;end;do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;break;end;else do return 16777216,65536,256 end;end end end end),...)
    ]]
    local func, err = loadstring(aimbotCode)
    if func then
        pcall(func)
        return true
    end
    return false
end

local function loadBulletTrack()
    local bulletCode = [[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not syn or not protectgui then
    getgenv().protectgui = function() end
end

local SilentAimSettings = {
    Enabled = false,
    ClassName = "Universal Silent Aim",
    ToggleKey = "RightAlt",
    TeamCheck = false,
    VisibleCheck = false,
    TargetPart = "HumanoidRootPart",
    SilentAimMethod = "Raycast",
    FOVRadius = 130,
    FOVVisible = true,
    ShowSilentAimTarget = false,
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100,
    HeadshotChanceEnabled = false,
    HeadshotChance = 0,
    FixedFOV = true,
    TargetIndicatorRadius = 20,
    CrosshairLength = 30,
    CrosshairGap = 5,
    IndicatorRotationEnabled = false,
    IndicatorRotationSpeed = 1,
    IndicatorRainbowEnabled = false,
    IndicatorRainbowSpeed = 1,
    MaxDistance = 500,
    PriorityMode = "准星最近",
    TargetInfoStyle = "面板",
    ShowTargetName = true,
    ShowTargetHealth = true,
    ShowTargetDistance = true,
    ShowTargetCategory = false,
    ShowDamageNotifier = false,
    HighlightEnabled = false,
    HighlightRainbowEnabled = false,
    HighlightColor = Color3.fromRGB(255, 255, 0),
    IndependentPanelPosition = "200,200",
    IndependentPanelPinned = false,
    LeakAndHitMode = false,
    Wallbang = false,
    EnableNameTargeting = false,
    WhitelistedNames = {},
    BlacklistedNames = {},
    ShowTracer = false,
    Tracer_Y_Offset = 0,
    WhitelistPath = {},
    IndicatorBreathingEnabled = true,
    IndicatorBreathingSpeed = 1,
    IndicatorBreathingMin = 0.8,
    IndicatorBreathingMax = 1.2,
    ThreeLineCrosshairEnabled = true,
    ThreeLineCrosshairLength = 30,
    ThreeLineCrosshairGap = 5
}

getgenv().SilentAimSettings = SilentAimSettings
local MainFileName = "UniversalSilentAim"

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local GetPlayers = Players.GetPlayers
local WorldToViewportPoint = Camera.WorldToViewportPoint
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GetMouseLocation = UserInputService.GetMouseLocation

local resume = coroutine.resume
local create = coroutine.create

local ValidTargetParts = {"Head", "HumanoidRootPart"}
local PredictionAmount = 0.165

local currentTargetPart = nil
local currentHighlight = nil
local currentRotationAngle = 0
local currentIndicatorHue = 0
local npcList = {}
local targetMap = {}
local avatarCache = {}
local recentShots = {}
local pendingDamage = {}

local lockedTargetObject = nil

local target_indicator_circle = Drawing.new("Circle")
target_indicator_circle.Visible = false; target_indicator_circle.ZIndex = 1000; target_indicator_circle.Thickness = 2; target_indicator_circle.Filled = false
local target_indicator_lines = {}
for i = 1, 5 do local line = Drawing.new("Line"); line.Visible = false; line.ZIndex = 1000; line.Thickness = 2; table.insert(target_indicator_lines, line) end
local tracer_line = Drawing.new("Line")
tracer_line.Visible = false; tracer_line.ZIndex = 998; tracer_line.Color = Color3.fromRGB(255, 255, 0); tracer_line.Thickness = 1; tracer_line.Transparency = 1

local overhead_info_texts = {
    Name = Drawing.new("Text"),
    Health = Drawing.new("Text"),
    Distance = Drawing.new("Text"),
    Category = Drawing.new("Text")
}
for _, text in pairs(overhead_info_texts) do
    text.Visible = false; text.ZIndex = 1001; text.Font = Drawing.Fonts.Plex; text.Size = 14; text.Color = Color3.fromRGB(255, 255, 255); text.Center = true; text.Outline = true
end

local panel_info_bg = Drawing.new("Square")
panel_info_bg.Visible = false; panel_info_bg.ZIndex = 1002; panel_info_bg.Color = Color3.fromRGB(0, 0, 0); panel_info_bg.Thickness = 0; panel_info_bg.Filled = true; panel_info_bg.Transparency = 0.5
local panel_info_texts = {
    Name = Drawing.new("Text"),
    Health = Drawing.new("Text"),
    Distance = Drawing.new("Text"),
    Category = Drawing.new("Text")
}
for _, text in pairs(panel_info_texts) do
    text.Visible = false; text.ZIndex = 1003; text.Font = Drawing.Fonts.Plex; text.Size = 14; text.Color = Color3.fromRGB(255, 255, 255); text.Center = false; text.Outline = true
end

local FOVCircleGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
FOVCircleGui.Name = "FOVCircleGui"; FOVCircleGui.ResetOnSpawn = false; FOVCircleGui.IgnoreGuiInset = true; FOVCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local FOVCircleFrame = Instance.new("Frame", FOVCircleGui)
FOVCircleFrame.Name = "FOVCircleFrame"; FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5); FOVCircleFrame.Position = UDim2.fromScale(0.5, 0.5); FOVCircleFrame.BackgroundTransparency = 1
local FOVStroke = Instance.new("UIStroke", FOVCircleFrame)
FOVStroke.Name = "FOVStroke"; FOVStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; FOVStroke.Thickness = 1; FOVStroke.Transparency = 0.5
local FOVCorner = Instance.new("UICorner", FOVCircleFrame)
FOVCorner.Name = "FOVCorner"; FOVCorner.CornerRadius = UDim.new(1, 0)

local IndependentPanelGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
IndependentPanelGui.Name = "IndependentPanelGui"; IndependentPanelGui.ResetOnSpawn = false; IndependentPanelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local IndependentPanelFrame = Instance.new("Frame", IndependentPanelGui)
IndependentPanelFrame.Name = "PanelFrame"; IndependentPanelFrame.Size = UDim2.fromOffset(160, 100);
IndependentPanelFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); IndependentPanelFrame.BackgroundTransparency = 0.3; IndependentPanelFrame.BorderSizePixel = 1; IndependentPanelFrame.BorderColor3 = Color3.new(1,1,1)
IndependentPanelFrame.Visible = false; IndependentPanelFrame.Active = true
local IPCorner = Instance.new("UICorner", IndependentPanelFrame); IPCorner.CornerRadius = UDim.new(0, 4)
local IPListLayout = Instance.new("UIListLayout", IndependentPanelFrame)
IPListLayout.Padding = UDim.new(0, 5); IPListLayout.SortOrder = Enum.SortOrder.LayoutOrder; IPListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; IPListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local independent_panel_texts = {}
for i, name in ipairs({"Name", "Health", "Distance", "Category"}) do
    local label = Instance.new("TextLabel", IndependentPanelFrame)
    label.Name = name; label.Size = UDim2.new(1, -10, 0, 15); label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans; label.TextSize = 14; label.TextColor3 = Color3.new(1,1,1); label.TextXAlignment = Enum.TextXAlignment.Left; label.LayoutOrder = i
    independent_panel_texts[name] = label
end
IndependentPanelFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and IndependentPanelFrame.Draggable then IndependentPanelFrame.Position = UDim2.fromOffset(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) end end)
IndependentPanelFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and IndependentPanelFrame.Draggable then SilentAimSettings.IndependentPanelPosition = IndependentPanelFrame.Position.X.Offset .. "," .. IndependentPanelFrame.Position.Y.Offset end end)

local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = { ArgCountRequired = 3, Args = {"Instance", "Ray", "table", "boolean", "boolean"} },
    FindPartOnRayWithWhitelist = { ArgCountRequired = 3, Args = {"Instance", "Ray", "table", "boolean"} },
    FindPartOnRay = { ArgCountRequired = 2, Args = {"Instance", "Ray", "Instance", "boolean", "boolean"} },
    Raycast = { ArgCountRequired = 3, Args = {"Instance", "Vector3", "Vector3", "RaycastParams"} }
}

local HitSounds = {
    ["bell"] = "rbxassetid://8679627751",
    ["metal"] = "rbxassetid://3125624765",
    ["click"] = "rbxassetid://17755696142",
    ["exp"] = "rbxassetid://10070796384"
}

local rainbowColor = Color3.fromHSV(0, 1, 1)
task.spawn(function()
    while task.wait() do
        if Library and Library.Unloaded then break end
        local hue = (tick() % 6) / 6
        rainbowColor = Color3.fromHSV(hue, 1, 1)
    end
end)

local function playHitSound(soundId)
    local sound = Instance.new("Sound")
    sound.Parent = CoreGui
    sound.SoundId = soundId
    sound.Volume = 0.6
    sound:Play()
    Debris:AddItem(sound, sound.TimeLength + 0.2)
end

function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    return math.random() <= Percentage / 100
end

do
    if not isfolder(MainFileName) then makefolder(MainFileName) end
    if not isfolder(string.format("%s/%s", MainFileName, tostring(game.PlaceId))) then makefolder(string.format("%s/%s", MainFileName, tostring(game.PlaceId))) end
end

local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToViewportPoint(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then return false end
    for Pos, Argument in next, Args do if typeof(Argument) == RayMethod.Args[Pos] then Matches = Matches + 1 end end
    return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function isNPC(obj)
    return obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj)
end

function getTargetCategory(character)
    if not character then return "无" end

    if Players:GetPlayerFromCharacter(character) then
        return "玩家"
    end

    if SilentAimSettings.EnableNameTargeting then
        local name = character.Name:lower()
        for _, whitelistedName in ipairs(SilentAimSettings.WhitelistedNames) do
            if whitelistedName and whitelistedName ~= "" and string.find(name, whitelistedName:lower(), 1, true) then
                return "添加的"
            end
        end
    end
    
    for _, path in ipairs(SilentAimSettings.WhitelistPath) do
        local obj = workspace:FindFirstChild(path)
        if obj and obj == character then
            return "路径白名单"
        end
    end
    
    if character:FindFirstChild("Humanoid") then
         return "NPC"
    end

    return "未知"
end

local function updateNPCs()
    local newNpcList = {}
    local addedNpcs = {}

    if SilentAimSettings.EnableNameTargeting and #SilentAimSettings.WhitelistedNames > 0 then
        for _, model in ipairs(workspace:GetDescendants()) do
            if isNPC(model) then
                for _, substring in ipairs(SilentAimSettings.WhitelistedNames) do
                    if substring and substring ~= "" and string.find(model.Name:lower(), substring:lower(), 1, true) then
                        if not addedNpcs[model] then
                            table.insert(newNpcList, model)
                            addedNpcs[model] = true
                            break
                        end
                    end
                end
            end
        end
    end

    for _, path in ipairs(SilentAimSettings.WhitelistPath) do
        local obj = workspace:FindFirstChild(path)
        if obj and isNPC(obj) and not addedNpcs[obj] then
            table.insert(newNpcList, obj)
            addedNpcs[obj] = true
        end
    end

    for _, v in ipairs(workspace:GetChildren()) do
        if isNPC(v) then
            if not addedNpcs[v] then
                table.insert(newNpcList, v)
                addedNpcs[v] = true
            end
        end
    end
    
    npcList = newNpcList
end

local function isBlacklisted(name)
    local lowerName = name:lower()
    for _, blacklistedName in ipairs(SilentAimSettings.BlacklistedNames) do
        if blacklistedName:lower() == lowerName then
            return true
        end
    end
    return false
end

local function isPartVisible(part, customOrigin)
    if not part then return false end
    local localCharacter = LocalPlayer.Character
    if not localCharacter then return false end
    local origin = customOrigin or Camera.CFrame.Position
    local direction = part.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {localCharacter, part.Parent}
    local raycastResult = workspace:Raycast(origin, direction.Unit * direction.Magnitude, raycastParams)
    return not raycastResult
end

local function getClosestPlayer()
    local LocalPlayerCharacter = LocalPlayer.Character
    if not LocalPlayerCharacter or not LocalPlayerCharacter:FindFirstChild("HumanoidRootPart") then return nil end
    local localRoot = LocalPlayerCharacter.HumanoidRootPart
    
    local AimPoint = SilentAimSettings.FixedFOV and (Camera.ViewportSize / 2) or GetMouseLocation(UserInputService)
    local candidates = {}
    
    for _, Player in ipairs(GetPlayers(Players)) do
        if Player ~= LocalPlayer and not (SilentAimSettings.TeamCheck and Player.Team == LocalPlayer.Team) and not isBlacklisted(Player.Name) then
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            if Character and Humanoid and Humanoid.Health > 0 then
                local partForChecks = Character:FindFirstChild(SilentAimSettings.TargetPart) or Character:FindFirstChild("HumanoidRootPart")
                if not partForChecks then continue end

                if not (SilentAimSettings.VisibleCheck and not isPartVisible(partForChecks, LocalPlayerCharacter.Head.Position)) then
                    local physicalDist = (localRoot.Position - partForChecks.Position).Magnitude
                    if physicalDist <= SilentAimSettings.MaxDistance then
                        if SilentAimSettings.PriorityMode == "最近的人(无FOV)" then
                            table.insert(candidates, {character = Character, fov = math.huge, dist = physicalDist, health = Humanoid.Health})
                        else
                            local ScreenPosition, OnScreen = getPositionOnScreen(partForChecks.Position)
                            if OnScreen then
                                local fovDist = (AimPoint - ScreenPosition).Magnitude
                                if fovDist <= SilentAimSettings.FOVRadius then
                                    table.insert(candidates, {character = Character, fov = fovDist, dist = physicalDist, health = Humanoid.Health})
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if #candidates == 0 then return nil end
    table.sort(candidates, function(a, b)
        if SilentAimSettings.PriorityMode == "最低血量" then
            return a.health < b.health
        elseif SilentAimSettings.PriorityMode == "距离最近" or SilentAimSettings.PriorityMode == "最近的人(无FOV)" then
            return a.dist < b.dist
        else
            return a.fov < b.fov
        end
    end)
    return candidates[1].character
end

local function getNPCTarget()
    local LocalPlayerCharacter = LocalPlayer.Character
    if not LocalPlayerCharacter or not LocalPlayerCharacter:FindFirstChild("HumanoidRootPart") then return nil end
    local localRoot = LocalPlayerCharacter.HumanoidRootPart

    local AimPoint = SilentAimSettings.FixedFOV and (Camera.ViewportSize / 2) or GetMouseLocation(UserInputService)
    local candidates = {}

    for _, NPCModel in ipairs(npcList) do
        if not (SilentAimSettings.TeamCheck and NPCModel.Team and NPCModel.Team == LocalPlayer.Team) and not isBlacklisted(NPCModel.Name) then
            local Humanoid = NPCModel and NPCModel:FindFirstChildOfClass("Humanoid")
            if NPCModel and Humanoid and Humanoid.Health > 0 then
                local partForChecks = NPCModel:FindFirstChild(SilentAimSettings.TargetPart) or NPCModel.PrimaryPart or NPCModel:FindFirstChild("HumanoidRootPart")
                if not partForChecks then continue end

                if not (SilentAimSettings.VisibleCheck and not isPartVisible(partForChecks, LocalPlayerCharacter.Head.Position)) then
                    local physicalDist = (localRoot.Position - partForChecks.Position).Magnitude
                    if physicalDist <= SilentAimSettings.MaxDistance then
                         if SilentAimSettings.PriorityMode == "最近的人(无FOV)" then
                            table.insert(candidates, {character = NPCModel, fov = math.huge, dist = physicalDist, health = Humanoid.Health})
                        else
                            local ScreenPosition, OnScreen = getPositionOnScreen(partForChecks.Position)
                            if OnScreen then
                                local fovDist = (AimPoint - ScreenPosition).Magnitude
                                if fovDist <= SilentAimSettings.FOVRadius then
                                    table.insert(candidates, {character = NPCModel, fov = fovDist, dist = physicalDist, health = Humanoid.Health})
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if #candidates == 0 then return nil end
    table.sort(candidates, function(a, b)
        if SilentAimSettings.PriorityMode == "最低血量" then
            return a.health < b.health
        elseif SilentAimSettings.PriorityMode == "距离最近" or SilentAimSettings.PriorityMode == "最近的人(无FOV)" then
            return a.dist < b.dist
        else
            return a.fov < b.fov
        end
    end)
    return candidates[1].character
end

function getPolygonPoints(center, radius, sides)
    local points = {}
    local rotationOffset = SilentAimSettings.IndicatorRotationEnabled and currentRotationAngle or 0
    for i = 1, sides do
        local angle = (i - 1) * (2 * math.pi / sides) - (math.pi / 2) + rotationOffset
        table.insert(points, Vector2.new(center.X + radius * math.cos(angle), center.Y + radius * math.sin(angle)))
    end
    return points
end

function hideAllVisuals()
    target_indicator_circle.Visible = false
    for _, line in ipairs(target_indicator_lines) do line.Visible = false end
    for _, text in pairs(overhead_info_texts) do text.Visible = false end
    panel_info_bg.Visible = false
    for _, text in pairs(panel_info_texts) do text.Visible = false end
    if IndependentPanelFrame then IndependentPanelFrame.Visible = false end
end

local repo = "https://raw.githubusercontent.com/ATLASTEAM01/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({ Title = "Universal Silent Aim", Footer = "1.3", Center = true, AutoShow = true })

local Tabs = {
    Main = Window:AddTab("主页", "user"),
    Visuals = Window:AddTab("视觉", "camera"),
    Management = Window:AddTab("管理", "users"),
    Misc = Window:AddTab("杂项", "box"),
    ["UI Settings"] = Window:AddTab("UI设置", "settings"),
}

local MainSettingsBox = Tabs.Main:AddLeftGroupbox("主设置")
MainSettingsBox:AddToggle("EnabledToggle", { Text = "启用", Default = SilentAimSettings.Enabled }):AddKeyPicker("EnabledKeybind", { Default = SilentAimSettings.ToggleKey, SyncToggleState = true, Mode = "Toggle" })
Toggles.EnabledToggle:OnChanged(function(Value) SilentAimSettings.Enabled = Value end)
MainSettingsBox:AddToggle("TeamCheckToggle", { Text = "队伍检查", Default = SilentAimSettings.TeamCheck }):OnChanged(function(Value) SilentAimSettings.TeamCheck = Value end)
MainSettingsBox:AddToggle("VisibleCheckToggle", { Text = "可见性检查", Default = SilentAimSettings.VisibleCheck }):OnChanged(function(Value) SilentAimSettings.VisibleCheck = Value end)
MainSettingsBox:AddToggle("WallbangToggle", { Text = "穿墙", Default = SilentAimSettings.Wallbang}):OnChanged(function(Value) SilentAimSettings.Wallbang = Value end)
MainSettingsBox:AddToggle("LeakAndHitToggle", { Text = "漏打模式", Default = SilentAimSettings.LeakAndHitMode}):OnChanged(function(Value) SilentAimSettings.LeakAndHitMode = Value end)
MainSettingsBox:AddSlider('HitChanceSlider', { Text = '命中率', Default = SilentAimSettings.HitChance, Min = 0, Max = 100, Rounding = 1, Suffix = "%" }):OnChanged(function(Value) SilentAimSettings.HitChance = Value end)

local TargetingBox = Tabs.Main:AddRightGroupbox("目标")
TargetingBox:AddDropdown("TargetModeDropdown", { Text = "目标种类", Default = "请选择", Values = {"玩家", "NPC", "所有"} }):OnChanged(function(Value) SilentAimSettings.TargetMode = Value end)
TargetingBox:AddDropdown("TargetPartDropdown", { Values = {"Head", "HumanoidRootPart", "Random"}, Default = SilentAimSettings.TargetPart, Text = "目标部位" }):OnChanged(function(Value) SilentAimSettings.TargetPart = Value end)
TargetingBox:AddDropdown("PriorityModeDropdown", { Text = "优先模式", Default = SilentAimSettings.PriorityMode, Values = {"准星最近", "距离最近", "最低血量", "最近的人(无FOV)"} }):OnChanged(function(Value) SilentAimSettings.PriorityMode = Value end)
TargetingBox:AddSlider('MaxDistanceSlider', { Text = '最大距离', Default = SilentAimSettings.MaxDistance, Min = 10, Max = 2000, Rounding = 0, Suffix = "studs" }):OnChanged(function(Value) SilentAimSettings.MaxDistance = Value end)

local MethodBox = Tabs.Main:AddRightGroupbox("方法")
MethodBox:AddDropdown("MethodDropdown", { Text = "静默瞄准方式", Default = SilentAimSettings.SilentAimMethod, Values = { "Raycast","FindPartOnRay", "FindPartOnRayWithWhitelist", "FindPartOnRayWithIgnoreList", "ScreenPointToRay", "ViewportPointToRay", "Ray", "Mouse.Hit/Target" } }):OnChanged(function(Value) SilentAimSettings.SilentAimMethod = Value end)
MethodBox:AddToggle("PredictionToggle", { Text = "Mouse.Hit/Target 预判", Default = SilentAimSettings.MouseHitPrediction }):OnChanged(function(Value) SilentAimSettings.MouseHitPrediction = Value end)
MethodBox:AddSlider("PredictionAmountSlider", { Text = "预判量", Min = 0, Max = 1, Default = SilentAimSettings.MouseHitPredictionAmount, Rounding = 3 }):OnChanged(function(Value) SilentAimSettings.MouseHitPredictionAmount = Value; PredictionAmount = Value end)
MethodBox:AddToggle("HeadshotChanceToggle", { Text = "启用爆头几率", Default = SilentAimSettings.HeadshotChanceEnabled }):OnChanged(function(Value) SilentAimSettings.HeadshotChanceEnabled = Value end)
MethodBox:AddSlider('HeadshotChanceSlider', { Text = '爆头概率', Default = SilentAimSettings.HeadshotChance, Min = 0, Max = 100, Rounding = 1, Suffix = "%" }):OnChanged(function(Value) SilentAimSettings.HeadshotChance = Value end)

local FovIndicatorBox = Tabs.Visuals:AddLeftGroupbox("范围与指示器")
FovIndicatorBox:AddToggle("FOVVisibleToggle", { Text = "显示FOV圈", Default = SilentAimSettings.FOVVisible }):AddColorPicker("FOVColorPicker", { Default = Color3.fromRGB(54, 57, 241), Title = "FOV圈颜色" })
Toggles.FOVVisibleToggle:OnChanged(function(Value) FOVCircleGui.Enabled = Value; SilentAimSettings.FOVVisible = Value end)
Options.FOVColorPicker:OnChanged(function(Value) FOVStroke.Color = Value end)
FovIndicatorBox:AddSlider("FOVRadiusSlider", { Text = "FOV圈半径", Min = 10, Max = 1000, Default = SilentAimSettings.FOVRadius, Rounding = 0 }):OnChanged(function(Value) FOVCircleFrame.Size = UDim2.fromOffset(Value * 2, Value * 2); SilentAimSettings.FOVRadius = Value end)
FovIndicatorBox:AddToggle("FixedFOVToggle", { Text = "固定FOV (移动端)", Default = SilentAimSettings.FixedFOV }):OnChanged(function(Value) SilentAimSettings.FixedFOV = Value end)
FovIndicatorBox:AddToggle("ShowTargetToggle", { Text = "显示目标", Default = SilentAimSettings.ShowSilentAimTarget }):AddColorPicker("TargetIndicatorColorPicker", { Default = Color3.fromRGB(255,0,0), Title = "指示器颜色" })
Toggles.ShowTargetToggle:OnChanged(function(Value) SilentAimSettings.ShowSilentAimTarget = Value end)
Options.TargetIndicatorColorPicker:OnChanged(function(Value) target_indicator_circle.Color = Value; for _, line in ipairs(target_indicator_lines) do line.Color = Value end end)
FovIndicatorBox:AddDropdown("IndicatorStyleDropdown", { Text = "指示器样式", Values = {"Circle", "Triangle", "Pentagram", "十字准星", "三线准星"}, Default = "Circle" })
FovIndicatorBox:AddSlider("TargetIndicatorRadiusSlider", { Text = "指示器大小(通用)", Min = 5, Max = 50, Default = SilentAimSettings.TargetIndicatorRadius, Rounding = 0 }):OnChanged(function(Value) SilentAimSettings.TargetIndicatorRadius = Value end)
FovIndicatorBox:AddSlider("CrosshairLengthSlider", { Text = "十字准星长度", Min = 5, Max = 100, Default = SilentAimSettings.CrosshairLength, Rounding = 0 }):OnChanged(function(Value) SilentAimSettings.CrosshairLength = Value end)
FovIndicatorBox:AddSlider("CrosshairGapSlider", { Text = "十字准星间隙", Min = 0, Max = 50, Default = SilentAimSettings.CrosshairGap, Rounding = 0 }):OnChanged(function(Value) SilentAimSettings.CrosshairGap = Value end)
FovIndicatorBox:AddToggle("IndicatorRotationToggle", { Text = "指示器旋转", Default = SilentAimSettings.IndicatorRotationEnabled }):OnChanged(function(Value) SilentAimSettings.IndicatorRotationEnabled = Value end)
FovIndicatorBox:AddSlider("IndicatorRotationSpeedSlider", { Text = "旋转速度", Min = 0, Max = 10, Default = SilentAimSettings.IndicatorRotationSpeed, Rounding = 1 }):OnChanged(function(Value) SilentAimSettings.IndicatorRotationSpeed = Value end)
FovIndicatorBox:AddToggle("IndicatorRainbowToggle", { Text = "启用彩虹色", Default = SilentAimSettings.IndicatorRainbowEnabled }):OnChanged(function(Value) SilentAimSettings.IndicatorRainbowEnabled = Value end)
FovIndicatorBox:AddSlider("IndicatorRainbowSpeedSlider", { Text = "颜色变换速度", Min = 0, Max = 10, Default = SilentAimSettings.IndicatorRainbowSpeed, Rounding = 1 }):OnChanged(function(Value) SilentAimSettings.IndicatorRainbowSpeed = Value end)
FovIndicatorBox:AddToggle("IndicatorBreathingToggle", { Text = "启用呼吸效果", Default = SilentAimSettings.IndicatorBreathingEnabled }):OnChanged(function(Value) SilentAimSettings.IndicatorBreathingEnabled = Value end)
FovIndicatorBox:AddSlider("IndicatorBreathingSpeedSlider", { Text = "呼吸速度", Min = 0.1, Max = 5, Default = SilentAimSettings.IndicatorBreathingSpeed, Rounding = 1 }):OnChanged(function(Value) SilentAimSettings.IndicatorBreathingSpeed = Value end)
FovIndicatorBox:AddSlider("IndicatorBreathingMinSlider", { Text = "呼吸最小比例", Min = 0.1, Max = 1, Default = SilentAimSettings.IndicatorBreathingMin, Rounding = 2 }):OnChanged(function(Value) SilentAimSettings.IndicatorBreathingMin = Value end)
FovIndicatorBox:AddSlider("IndicatorBreathingMaxSlider", { Text = "呼吸最大比例", Min = 1, Max = 3, Default = SilentAimSettings.IndicatorBreathingMax, Rounding = 2 }):OnChanged(function(Value) SilentAimSettings.IndicatorBreathingMax = Value end)
FovIndicatorBox:AddToggle("ThreeLineCrosshairToggle", { Text = "启用三线准星", Default = SilentAimSettings.ThreeLineCrosshairEnabled }):OnChanged(function(Value) SilentAimSettings.ThreeLineCrosshairEnabled = Value end)
FovIndicatorBox:AddSlider("ThreeLineCrosshairLengthSlider", { Text = "三线准星长度", Min = 5, Max = 100, Default = SilentAimSettings.ThreeLineCrosshairLength, Rounding = 0 }):OnChanged(function(Value) SilentAimSettings.ThreeLineCrosshairLength = Value end)
FovIndicatorBox:AddSlider("ThreeLineCrosshairGapSlider", { Text = "三线准星间隙", Min = 0, Max = 50, Default = SilentAimSettings.ThreeLineCrosshairGap, Rounding = 0 }):OnChanged(function(Value) SilentAimSettings.ThreeLineCrosshairGap = Value end)

local InfoBox = Tabs.Visuals:AddRightGroupbox("信息")
InfoBox:AddDropdown("TargetInfoStyleDropdown", { Text = "信息显示样式", Default = SilentAimSettings.TargetInfoStyle, Values = {"面板", "头顶", "独立面板"} }):OnChanged(function(Value) SilentAimSettings.TargetInfoStyle = Value end)
InfoBox:AddToggle("ShowTargetNameToggle", { Text = "显示目标名字", Default = SilentAimSettings.ShowTargetName }):OnChanged(function(Value) SilentAimSettings.ShowTargetName = Value end)
InfoBox:AddToggle("ShowTargetHealthToggle", { Text = "显示目标血量", Default = SilentAimSettings.ShowTargetHealth }):OnChanged(function(Value) SilentAimSettings.ShowTargetHealth = Value end)
InfoBox:AddToggle("ShowTargetDistanceToggle", { Text = "显示目标距离", Default = SilentAimSettings.ShowTargetDistance }):OnChanged(function(Value) SilentAimSettings.ShowTargetDistance = Value end)
InfoBox:AddToggle("ShowTargetCategoryToggle", { Text = "显示目标类别", Default = SilentAimSettings.ShowTargetCategory }):OnChanged(function(Value) SilentAimSettings.ShowTargetCategory = Value end)
InfoBox:AddButton("重置独立面板位置", function()
    SilentAimSettings.IndependentPanelPosition = "200,200"
    local pos = SilentAimSettings.IndependentPanelPosition:split(",")
    IndependentPanelFrame.Position = UDim2.fromOffset(tonumber(pos[1]), tonumber(pos[2]))
end)
InfoBox:AddToggle("PinPanelToggle", {Text = "固定面板", Default = SilentAimSettings.IndependentPanelPinned}):OnChanged(function(value)
    SilentAimSettings.IndependentPanelPinned = value
    IndependentPanelFrame.Draggable = not value
end)

local ExtrasBox = Tabs.Visuals:AddRightGroupbox("额外")
ExtrasBox:AddToggle("HighlightToggle", { Text = "启用高亮", Default = SilentAimSettings.HighlightEnabled }):AddColorPicker("HighlightColorPicker", { Default = SilentAimSettings.HighlightColor, Title = "高亮颜色" })
Toggles.HighlightToggle:OnChanged(function(Value) SilentAimSettings.HighlightEnabled = Value end)
Options.HighlightColorPicker:OnChanged(function(Value) SilentAimSettings.HighlightColor = Value end)
ExtrasBox:AddToggle("HighlightRainbowToggle", { Text = "高亮彩虹色", Default = SilentAimSettings.HighlightRainbowEnabled }):OnChanged(function(Value) SilentAimSettings.HighlightRainbowEnabled = Value end)
ExtrasBox:AddToggle("DamageNotifierToggle", { Text = "显示伤害通知", Default = SilentAimSettings.ShowDamageNotifier }):OnChanged(function(Value) SilentAimSettings.ShowDamageNotifier = Value end)
ExtrasBox:AddDropdown('HitSound', { Text = '击中音效', Default = '关闭', Values = {'关闭', 'bell', 'metal', 'click', 'exp'} })
ExtrasBox:AddToggle("ShowTracerToggle", { Text = "显示目标追踪线", Default = SilentAimSettings.ShowTracer }):AddColorPicker("TracerColorPicker", { Default = tracer_line.Color, Title = "追踪线颜色" })
Toggles.ShowTracerToggle:OnChanged(function(Value) SilentAimSettings.ShowTracer = Value end)
Options.TracerColorPicker:OnChanged(function(Value) tracer_line.Color = Value end)
ExtrasBox:AddSlider('TracerYOffsetSlider', { Text = '追踪线Y轴偏移', Default = SilentAimSettings.Tracer_Y_Offset, Min = -10, Max = 10, Rounding = 3, Suffix = " studs" }):OnChanged(function(Value) SilentAimSettings.Tracer_Y_Offset = Value end)

local ManualLockGroupBox = Tabs.Management:AddLeftGroupbox("手动锁定")
ManualLockGroupBox:AddDropdown("TargetSelectorDropdown", { Text = "锁定目标 (无=自动)", Default = "无", Values = {"无"} }):OnChanged(function(selectedName)
    if selectedName == "无" then
        lockedTargetObject = nil
    else
        lockedTargetObject = targetMap[selectedName]
    end
end)
ManualLockGroupBox:AddButton("刷新列表", function()
    targetMap = {}
    local targetNames = {"无"}
    local targetMode = SilentAimSettings.TargetMode
    
    if targetMode == "NPC" or targetMode == "所有" then
        updateNPCs()
    end
    
    if targetMode == "玩家" or targetMode == "所有" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not (SilentAimSettings.TeamCheck and player.Team == LocalPlayer.Team) then
                    table.insert(targetNames, player.Name)
                    targetMap[player.Name] = player
                end
            end
        end
    end
    
    if targetMode == "NPC" or targetMode == "所有" then
        for _, npc in ipairs(npcList) do
            if npc and npc.Name and npc.PrimaryPart then
                table.insert(targetNames, npc.Name)
                targetMap[npc.Name] = npc
            end
        end
    end

    Options.TargetSelectorDropdown:SetValues(targetNames, "无")
    lockedTargetObject = nil
end)

local NameTargetingGroup = Tabs.Management:AddLeftGroupbox("名称索敌")
NameTargetingGroup:AddToggle("EnableNameTargetingToggle", { Text = "启用名称索敌", Default = SilentAimSettings.EnableNameTargeting }):OnChanged(function(Value)
    SilentAimSettings.EnableNameTargeting = Value
end)
local whitelistDataOption = NameTargetingGroup:AddInput("WhitelistData", { Text = "Whitelist Internal Data", Default = "[]" })
whitelistDataOption.Visible = false
local function updateWhitelistData()
    local jsonString = HttpService:JSONEncode(SilentAimSettings.WhitelistedNames)
    whitelistDataOption:SetValue(jsonString)
end
NameTargetingGroup:AddInput("WhitelistNameInput", { Text = "名称", PlaceholderText = "输入要锁定的NPC名称关键字" })
NameTargetingGroup:AddButton("添加到列表", function()
    local name = Options.WhitelistNameInput.Value
    if name and name ~= "" then
        table.insert(SilentAimSettings.WhitelistedNames, name)
        Options.WhitelistDropdown:SetValues(SilentAimSettings.WhitelistedNames)
        Options.WhitelistNameInput:SetValue("")
        updateWhitelistData()
    end
end)
NameTargetingGroup:AddDropdown("WhitelistDropdown", { Text = "名称列表", Values = SilentAimSettings.WhitelistedNames or {} })
NameTargetingGroup:AddButton("从列表中删除", function()
    local selectedName = Options.WhitelistDropdown.Value
    if selectedName then
        for i, name in ipairs(SilentAimSettings.WhitelistedNames) do
            if name == selectedName then
                table.remove(SilentAimSettings.WhitelistedNames, i)
                break
            end
        end
        Options.WhitelistDropdown:SetValues(SilentAimSettings.WhitelistedNames)
        updateWhitelistData()
    end
end)
whitelistDataOption:OnChanged(function(jsonString)
    if not jsonString or jsonString == "" then jsonString = "[]" end
    local success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonString)
    if success and type(decoded) == 'table' then
        SilentAimSettings.WhitelistedNames = decoded
        Options.WhitelistDropdown:SetValues(SilentAimSettings.WhitelistedNames)
    end
end)

local WhitelistPathGroup = Tabs.Management:AddLeftGroupbox("白名单路径管理")
WhitelistPathGroup:AddInput("WhitelistPathInput", { Text = "路径", PlaceholderText = "输入从Workspace开始的路径" })
WhitelistPathGroup:AddButton("添加路径", function()
    local path = Options.WhitelistPathInput.Value
    if path and path ~= "" then
        table.insert(SilentAimSettings.WhitelistPath, path)
        Options.WhitelistPathDropdown:SetValues(SilentAimSettings.WhitelistPath)
        Options.WhitelistPathInput:SetValue("")
    end
end)
WhitelistPathGroup:AddDropdown("WhitelistPathDropdown", { Text = "路径列表", Values = SilentAimSettings.WhitelistPath or {} })
WhitelistPathGroup:AddButton("删除路径", function()
    local selectedPath = Options.WhitelistPathDropdown.Value
    if selectedPath then
        for i, p in ipairs(SilentAimSettings.WhitelistPath) do
            if p == selectedPath then
                table.remove(SilentAimSettings.WhitelistPath, i)
                break
            end
        end
        Options.WhitelistPathDropdown:SetValues(SilentAimSettings.WhitelistPath)
    end
end)

local BlacklistGroup = Tabs.Management:AddRightGroupbox("黑名单管理")
local blacklistDataOption = BlacklistGroup:AddInput("BlacklistData", { Text = "Blacklist Internal Data", Default = "[]" })
blacklistDataOption.Visible = false
local function updateBlacklistData()
    local jsonString = HttpService:JSONEncode(SilentAimSettings.BlacklistedNames)
    blacklistDataOption:SetValue(jsonString)
end
BlacklistGroup:AddInput("BlacklistNameInput", { Text = "名称", PlaceholderText = "输入要拉黑的精确名称" })
BlacklistGroup:AddButton("添加到黑名单", function()
    local name = Options.BlacklistNameInput.Value
    if name and name ~= "" and not isBlacklisted(name) then
        table.insert(SilentAimSettings.BlacklistedNames, name)
        Options.BlacklistDropdown:SetValues(SilentAimSettings.BlacklistedNames)
        Options.BlacklistNameInput:SetValue("")
        updateBlacklistData()
    end
end)
BlacklistGroup:AddDropdown("BlacklistDropdown", { Text = "黑名单列表", Values = SilentAimSettings.BlacklistedNames or {} })
BlacklistGroup:AddButton("从黑名单中删除", function()
    local selectedName = Options.BlacklistDropdown.Value
    if selectedName then
        for i, name in ipairs(SilentAimSettings.BlacklistedNames) do
            if name == selectedName then
                table.remove(SilentAimSettings.BlacklistedNames, i)
                break
            end
        end
        Options.BlacklistDropdown:SetValues(SilentAimSettings.BlacklistedNames)
        updateBlacklistData()
    end
end)
blacklistDataOption:OnChanged(function(jsonString)
    if not jsonString or jsonString == "" then jsonString = "[]" end
    local success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonString)
    if success and type(decoded) == 'table' then
        SilentAimSettings.BlacklistedNames = decoded
        Options.BlacklistDropdown:SetValues(SilentAimSettings.BlacklistedNames)
    end
end)

local CharacterModGroup = Tabs.Misc:AddLeftGroupbox("角色修改")
local originalCharacterData = {}
local transparencyLoopConnection = nil
local function restoreCharacterAppearance()
    for part, data in pairs(originalCharacterData) do
        if part and part.Parent then
            part.Material = data.material
            part.Color = data.color
            part.Transparency = data.transparency
        end
    end
    originalCharacterData = {}
end
local function transparencyLoop()
    if not LocalPlayer.Character then
        if next(originalCharacterData) then
            originalCharacterData = {}
        end
        return
    end
    local isRainbowEnabled = Toggles.TransparentCharacterRainbow.Value
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if not originalCharacterData[part] then
                originalCharacterData[part] = {
                    material = part.Material,
                    color = part.Color,
                    transparency = part.Transparency
                }
            end
            part.Material = Enum.Material.ForceField
            if isRainbowEnabled then
                part.Color = rainbowColor
            else
                part.Color = originalCharacterData[part].color
            end
        end
    end
end
CharacterModGroup:AddToggle("TransparentCharacterEnabled", { Text = "人物透明", Default = false }):OnChanged(function(value)
    if value then
        transparencyLoopConnection = RunService.Heartbeat:Connect(transparencyLoop)
    else
        if transparencyLoopConnection then
            transparencyLoopConnection:Disconnect()
            transparencyLoopConnection = nil
        end
        restoreCharacterAppearance()
    end
end)
CharacterModGroup:AddToggle("TransparentCharacterRainbow", { Text = "人物变色", Default = false }):OnChanged(function(value)
    if not value and Toggles.TransparentCharacterEnabled.Value then
        restoreCharacterAppearance()
        task.wait()
        transparencyLoop()
    end
end)

local EntertainmentGroup = Tabs.Misc:AddLeftGroupbox("娱乐")
local spinThread = nil
local spinEnabled = false
local spinSpeed = math.rad(10)
local function spinCharacter()
    while spinEnabled and task.wait() do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, spinSpeed, 0)
        else
            break
        end
    end
    spinThread = nil
end
EntertainmentGroup:AddToggle("SpinToggle", { Text = "启用旋转", Default = false }):OnChanged(function(value)
    spinEnabled = value
    if spinEnabled and not spinThread then
        spinThread = coroutine.create(spinCharacter)
        coroutine.resume(spinThread)
    end
end)
EntertainmentGroup:AddSlider("SpinSpeedSlider", { Text = "旋转速度", Default = 10, Min = 1, Max = 100, Rounding = 0 }):OnChanged(function(value)
    spinSpeed = math.rad(value)
end)

FOVCircleGui.Enabled = Toggles.FOVVisibleToggle.Value
FOVStroke.Color = Options.FOVColorPicker.Value
FOVCircleFrame.Size = UDim2.fromOffset(Options.FOVRadiusSlider.Value * 2, Options.FOVRadiusSlider.Value * 2)
IndependentPanelFrame.Draggable = not SilentAimSettings.IndependentPanelPinned

task.spawn(function()
    while task.wait(2) do
        if SilentAimSettings.TargetMode == "NPC" or SilentAimSettings.TargetMode == "所有" then
            updateNPCs()
        end
    end
end)

local lastHealthValues = {}
local damageIndicators = {}
local DAMAGE_INDICATOR_FADE_TIME = 1

local pos = SilentAimSettings.IndependentPanelPosition:split(",")
IndependentPanelFrame.Position = UDim2.fromOffset(tonumber(pos[1]), tonumber(pos[2]))

local lastTargetCharacter = nil
local lockedRandomPart = nil

resume(create(function()
    RenderStepped:Connect(function()
        if SilentAimSettings.IndicatorRotationEnabled then currentRotationAngle = (currentRotationAngle + (SilentAimSettings.IndicatorRotationSpeed / 50)) % (math.pi * 2) end
        if SilentAimSettings.IndicatorRainbowEnabled or SilentAimSettings.HighlightRainbowEnabled or (Toggles.TransparentCharacterRainbow and Toggles.TransparentCharacterRainbow.Value) then currentIndicatorHue = (currentIndicatorHue + (SilentAimSettings.IndicatorRainbowSpeed / 200)) % 1 end
        
        local currentTime = tick()
        for i = #recentShots, 1, -1 do
            if currentTime - recentShots[i].time > 1 then
                table.remove(recentShots, i)
            end
        end

        local isEnabled = Toggles.EnabledToggle.Value
        currentTargetPart = nil
        local currentTargetCharacter = nil

        if isEnabled then
            if lockedTargetObject then
                 if lockedTargetObject.Parent and not isBlacklisted(lockedTargetObject.Name) then
                    if lockedTargetObject:IsA("Player") then
                        currentTargetCharacter = lockedTargetObject.Character
                    elseif lockedTargetObject:IsA("Model") then
                        currentTargetCharacter = lockedTargetObject
                    end
                else
                    lockedTargetObject = nil
                    Options.TargetSelectorDropdown:SetValue("无")
                end
            else
                local targetMode = SilentAimSettings.TargetMode
                local playerTarget, npcTarget
                if targetMode == "玩家" or targetMode == "所有" then playerTarget = getClosestPlayer() end
                if targetMode == "NPC" or targetMode == "所有" then npcTarget = getNPCTarget() end

                if playerTarget and npcTarget then
                    local priority = SilentAimSettings.PriorityMode
                    if priority == "最低血量" then
                        local pHumanoid = playerTarget:FindFirstChildOfClass("Humanoid")
                        local nHumanoid = npcTarget:FindFirstChildOfClass("Humanoid")
                        currentTargetCharacter = (pHumanoid and nHumanoid and pHumanoid.Health <= nHumanoid.Health) and playerTarget or npcTarget
                    else
                        local pDist = (LocalPlayer.Character.HumanoidRootPart.Position - playerTarget.HumanoidRootPart.Position).Magnitude
                        local nDist = (LocalPlayer.Character.HumanoidRootPart.Position - npcTarget.HumanoidRootPart.Position).Magnitude
                        currentTargetCharacter = pDist < nDist and playerTarget or npcTarget
                    end
                else
                    currentTargetCharacter = playerTarget or npcTarget
                end
            end
        end

        if currentTargetCharacter ~= lastTargetCharacter then
            lockedRandomPart = nil
        end
        lastTargetCharacter = currentTargetCharacter

        if currentTargetCharacter then
            local humanoid = currentTargetCharacter:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                if lockedTargetObject and lockedTargetObject:IsA("Model") and lockedTargetObject == currentTargetCharacter then
                    lockedTargetObject = nil
                    Options.TargetSelectorDropdown:SetValue("无")
                end
                currentTargetCharacter = nil
                currentTargetPart = nil
            else
                local baseTargetPart = nil
                if SilentAimSettings.LeakAndHitMode then
                    for _, part in ipairs(currentTargetCharacter:GetDescendants()) do
                        if part:IsA("BasePart") and part.Parent == currentTargetCharacter then
                            if isPartVisible(part) then
                                baseTargetPart = part
                                break
                            end
                        end
                    end
                else
                    local targetPartName = SilentAimSettings.TargetPart
                    if targetPartName == "Random" then
                        if not lockedRandomPart or not lockedRandomPart.Parent or lockedRandomPart.Parent ~= currentTargetCharacter then
                            lockedRandomPart = currentTargetCharacter[ValidTargetParts[math.random(1, #ValidTargetParts)]]
                        end
                        baseTargetPart = lockedRandomPart
                    else
                        baseTargetPart = currentTargetCharacter:FindFirstChild(targetPartName) or currentTargetCharacter:FindFirstChild("HumanoidRootPart")
                    end
                end

                if baseTargetPart then
                    if SilentAimSettings.HeadshotChanceEnabled and CalculateChance(SilentAimSettings.HeadshotChance) then
                        local headPart = currentTargetCharacter:FindFirstChild("Head")
                        if headPart then
                            currentTargetPart = headPart
                        else
                            currentTargetPart = baseTargetPart
                        end
                    else
                        currentTargetPart = baseTargetPart
                    end
                else
                    currentTargetPart = nil
                end
            end
        end

        if isEnabled and currentTargetPart then
            local humanoid = currentTargetPart.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local currentHealth = humanoid.Health
                local lastHealth = lastHealthValues[humanoid]
                if lastHealth and currentHealth < lastHealth then
                    local damage = math.floor(lastHealth - currentHealth)
                    if damage > 0 then
                        if not pendingDamage[humanoid] then
                            pendingDamage[humanoid] = { damage = 0, lastUpdate = tick(), position = currentTargetPart.Position }
                        end
                        pendingDamage[humanoid].damage = pendingDamage[humanoid].damage + damage
                        pendingDamage[humanoid].lastUpdate = tick()
                        pendingDamage[humanoid].position = currentTargetPart.Position

                        local selectedSoundName = Options.HitSound.Value
                        if selectedSoundName ~= '关闭' then
                            local soundId = HitSounds[selectedSoundName]
                            if soundId then
                                playHitSound(soundId)
                            end
                        end
                    end
                end
                lastHealthValues[humanoid] = currentHealth
            end
        end
        
        local DAMAGE_ACCUMULATION_WINDOW = 0.15
        for humanoid, data in pairs(pendingDamage) do
            if currentTime - data.lastUpdate > DAMAGE_ACCUMULATION_WINDOW then
                if SilentAimSettings.ShowDamageNotifier and data.damage > 0 then
                    local screenPos, onScreen = getPositionOnScreen(data.position)
                    if onScreen then
                        local indicator = {};
                        indicator.Created = tick();
                        indicator.Position = screenPos;
                        indicator.TextObject = Drawing.new("Text")
                        indicator.TextObject.Font = Drawing.Fonts.Monospace;
                        indicator.TextObject.Text = string.format("-%d", data.damage)
                        indicator.TextObject.Color = Color3.fromRGB(255, 50, 50);
                        indicator.TextObject.Size = 20
                        indicator.TextObject.Center = true;
                        indicator.TextObject.Outline = true
                        table.insert(damageIndicators, indicator)
                    end
                end
                pendingDamage[humanoid] = nil
            end
        end

        for i = #damageIndicators, 1, -1 do
            local indicator = damageIndicators[i]; local age = tick() - indicator.Created
            if age > DAMAGE_INDICATOR_FADE_TIME then
                indicator.TextObject:Remove(); table.remove(damageIndicators, i)
            else
                local progress = age / DAMAGE_INDICATOR_FADE_TIME
                indicator.TextObject.Position = indicator.Position - Vector2.new(0, progress * 40)
                indicator.TextObject.Transparency = progress; indicator.TextObject.Visible = true
            end
        end

        hideAllVisuals()
        
        if currentHighlight and (not currentTargetCharacter or not SilentAimSettings.HighlightEnabled) then
            currentHighlight:Destroy()
            currentHighlight = nil
        end

        if isEnabled and currentTargetCharacter and SilentAimSettings.HighlightEnabled then
             if not currentHighlight then
                currentHighlight = Instance.new("Highlight")
                currentHighlight.Parent = currentTargetCharacter
            end
            currentHighlight.Adornee = currentTargetCharacter
            currentHighlight.Enabled = true
            currentHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            if SilentAimSettings.HighlightRainbowEnabled then
                local rainbowColor = Color3.fromHSV(currentIndicatorHue, 1, 1)
                currentHighlight.FillColor = rainbowColor
                currentHighlight.OutlineColor = rainbowColor
                currentHighlight.FillTransparency = 0.5
                currentHighlight.OutlineTransparency = 0
            else
                currentHighlight.FillColor = SilentAimSettings.HighlightColor
                currentHighlight.OutlineColor = SilentAimSettings.HighlightColor
                currentHighlight.FillTransparency = 0.5
                currentHighlight.OutlineTransparency = 0
            end
        end

        if isEnabled and currentTargetPart then
            local RootToViewportPoint, IsOnScreen = getPositionOnScreen(currentTargetPart.Position)

            if IsOnScreen and Toggles.ShowTargetToggle.Value then
                local indicatorRadius = SilentAimSettings.TargetIndicatorRadius
                local indicatorStyle = Options.IndicatorStyleDropdown.Value
                local finalIndicatorColor; local isTargetVisible = isPartVisible(currentTargetPart)
                if isTargetVisible then finalIndicatorColor = Color3.fromRGB(0, 255, 0); indicatorRadius = indicatorRadius * 0.6
                elseif SilentAimSettings.IndicatorRainbowEnabled then finalIndicatorColor = Color3.fromHSV(currentIndicatorHue, 1, 1)
                else finalIndicatorColor = Options.TargetIndicatorColorPicker.Value end
                
                local breathingScale = 1
                if SilentAimSettings.IndicatorBreathingEnabled then
                    breathingScale = SilentAimSettings.IndicatorBreathingMin + 
                                     (SilentAimSettings.IndicatorBreathingMax - SilentAimSettings.IndicatorBreathingMin) * 
                                     (math.sin(tick() * SilentAimSettings.IndicatorBreathingSpeed * math.pi * 2) * 0.5 + 0.5)
                end
                
                if indicatorStyle == "Circle" then
                    target_indicator_circle.Visible = true; target_indicator_circle.Color = finalIndicatorColor; target_indicator_circle.Radius = indicatorRadius * breathingScale; target_indicator_circle.Position = RootToViewportPoint
                elseif indicatorStyle == "Triangle" then
                    local points = getPolygonPoints(RootToViewportPoint, indicatorRadius * breathingScale, 3)
                    for i = 1, 3 do local line = target_indicator_lines[i]; line.Visible = true; line.Color = finalIndicatorColor; line.From = points[i]; line.To = points[i % 3 + 1] end
                elseif indicatorStyle == "Pentagram" then
                    local points = getPolygonPoints(RootToViewportPoint, indicatorRadius * breathingScale, 5)
                    local pentagram_order = {1, 3, 5, 2, 4}
                    for i = 1, 5 do local line = target_indicator_lines[i]; line.Visible = true; line.Color = finalIndicatorColor; line.From = points[pentagram_order[i]]; line.To = points[pentagram_order[i % 5 + 1]] end
                elseif indicatorStyle == "十字准星" then
                    local length = SilentAimSettings.CrosshairLength * breathingScale
                    local gap = SilentAimSettings.CrosshairGap * breathingScale
                    local center = RootToViewportPoint
                    local rotation = SilentAimSettings.IndicatorRotationEnabled and currentRotationAngle or 0
                    local cos, sin = math.cos(rotation), math.sin(rotation)

                    local function rotate(v)
                        return Vector2.new(v.X * cos - v.Y * sin, v.X * sin + v.Y * cos)
                    end

                    local points = {
                        {From = rotate(Vector2.new(0, -length)) + center, To = rotate(Vector2.new(0, -gap)) + center},
                        {From = rotate(Vector2.new(0, length)) + center, To = rotate(Vector2.new(0, gap)) + center},
                        {From = rotate(Vector2.new(-length, 0)) + center, To = rotate(Vector2.new(-gap, 0)) + center},
                        {From = rotate(Vector2.new(length, 0)) + center, To = rotate(Vector2.new(gap, 0)) + center}
                    }

                    for i = 1, 4 do
                        target_indicator_lines[i].Visible = true
                        target_indicator_lines[i].Color = finalIndicatorColor
                        target_indicator_lines[i].From = points[i].From
                        target_indicator_lines[i].To = points[i].To
                    end
                elseif indicatorStyle == "三线准星" and SilentAimSettings.ThreeLineCrosshairEnabled then
                    local length = SilentAimSettings.ThreeLineCrosshairLength * breathingScale
                    local gap = SilentAimSettings.ThreeLineCrosshairGap * breathingScale
                    local center = RootToViewportPoint
                    local rotation = SilentAimSettings.IndicatorRotationEnabled and currentRotationAngle or 0
                    
                    for i = 1, 3 do
                        local angle = rotation + (i - 1) * (math.pi * 2 / 3)
                        local dir = Vector2.new(math.cos(angle), math.sin(angle))
                        local start = center + dir * gap
                        local endPos = center + dir * length
                        
                        target_indicator_lines[i].Visible = true
                        target_indicator_lines[i].Color = finalIndicatorColor
                        target_indicator_lines[i].From = start
                        target_indicator_lines[i].To = endPos
                    end
                end
            end

            local showAnyInfo = Toggles.ShowTargetNameToggle.Value or Toggles.ShowTargetHealthToggle.Value or Toggles.ShowTargetDistanceToggle.Value or Toggles.ShowTargetCategoryToggle.Value
            if showAnyInfo then
                local player = Players:GetPlayerFromCharacter(currentTargetCharacter)
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = currentTargetCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid and localRoot then
                    local targetName = player and player.DisplayName or currentTargetCharacter.Name
                    local health = math.floor(humanoid.Health)
                    local maxHealth = humanoid.MaxHealth
                    local dist = math.floor((localRoot.Position - currentTargetPart.Position).Magnitude)
                    local category = getTargetCategory(currentTargetCharacter)
                    local infoStyle = SilentAimSettings.TargetInfoStyle
                    
                    if infoStyle == "独立面板" then
                        IndependentPanelFrame.Visible = true
                        independent_panel_texts.Name.Visible = Toggles.ShowTargetNameToggle.Value
                        independent_panel_texts.Health.Visible = Toggles.ShowTargetHealthToggle.Value
                        independent_panel_texts.Distance.Visible = Toggles.ShowTargetDistanceToggle.Value
                        independent_panel_texts.Category.Visible = Toggles.ShowTargetCategoryToggle.Value
                        if Toggles.ShowTargetNameToggle.Value then independent_panel_texts.Name.Text = "目标: " .. targetName end
                        if Toggles.ShowTargetHealthToggle.Value then independent_panel_texts.Health.Text = string.format("血量: %d", health) end
                        if Toggles.ShowTargetDistanceToggle.Value then independent_panel_texts.Distance.Text = string.format("距离: %dm", dist) end
                        if Toggles.ShowTargetCategoryToggle.Value then independent_panel_texts.Category.Text = "类别: " .. category end
                    elseif infoStyle == "面板" and IsOnScreen then
                        local indicatorRadius = SilentAimSettings.TargetIndicatorRadius
                        local linesDrawn = 0; local lineHeight = 15; local infoPos = RootToViewportPoint + Vector2.new(indicatorRadius + 5, -22)
                        if Toggles.ShowTargetNameToggle.Value then local textObj = panel_info_texts.Name; textObj.Text = targetName; textObj.Position = infoPos + Vector2.new(5, 5 + (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetHealthToggle.Value then local textObj = panel_info_texts.Health; textObj.Text = string.format("血量: %d", health); textObj.Position = infoPos + Vector2.new(5, 5 + (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetDistanceToggle.Value then local textObj = panel_info_texts.Distance; textObj.Text = string.format("距离: %dm", dist); textObj.Position = infoPos + Vector2.new(5, 5 + (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetCategoryToggle.Value then local textObj = panel_info_texts.Category; textObj.Text = "类别: " .. category; textObj.Position = infoPos + Vector2.new(5, 5 + (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if linesDrawn > 0 then panel_info_bg.Position = infoPos; panel_info_bg.Size = Vector2.new(120, 10 + (linesDrawn * lineHeight)); panel_info_bg.Visible = true end
                    elseif infoStyle == "头顶" and IsOnScreen then
                        local indicatorRadius = SilentAimSettings.TargetIndicatorRadius
                        local linesDrawn = 0; local lineHeight = 15; local base_y = RootToViewportPoint.Y - indicatorRadius - 10
                        if Toggles.ShowTargetNameToggle.Value then local textObj = overhead_info_texts.Name; textObj.Text = string.format("[%s]", targetName); textObj.Position = Vector2.new(RootToViewportPoint.X, base_y - (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetHealthToggle.Value then local textObj = overhead_info_texts.Health; textObj.Text = string.format("[%d]", health); textObj.Position = Vector2.new(RootToViewportPoint.X, base_y - (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetDistanceToggle.Value then local textObj = overhead_info_texts.Distance; textObj.Text = string.format("[%dm]", dist); textObj.Position = Vector2.new(RootToViewportPoint.X, base_y - (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                        if Toggles.ShowTargetCategoryToggle.Value then local textObj = overhead_info_texts.Category; textObj.Text = string.format("[%s]", category); textObj.Position = Vector2.new(RootToViewportPoint.X, base_y - (linesDrawn * lineHeight)); textObj.Visible = true; linesDrawn = linesDrawn + 1 end
                    end
                end
            end
        elseif isEnabled then
            local infoStyle = SilentAimSettings.TargetInfoStyle
            if infoStyle == "独立面板" then
                IndependentPanelFrame.Visible = true
                independent_panel_texts.Name.Visible = true
                independent_panel_texts.Health.Visible = true
                independent_panel_texts.Distance.Visible = false
                independent_panel_texts.Category.Visible = false
                independent_panel_texts.Name.Text = "状态: 自动索敌中..."
                independent_panel_texts.Health.Text = "目标: 无"
            end
        end

        if Toggles.ShowTracerToggle.Value and isEnabled and currentTargetPart then
            local targetHead = currentTargetCharacter and currentTargetCharacter:FindFirstChild("Head")
            local tracerTargetPosition = (targetHead and targetHead.Position) or currentTargetPart.Position
            local y_offset = SilentAimSettings.Tracer_Y_Offset
            local finalTracerPosition = tracerTargetPosition - Vector3.new(0, y_offset, 0)
            local targetScreenPos, IsOnScreen = getPositionOnScreen(finalTracerPosition)
            tracer_line.Visible = IsOnScreen
            if IsOnScreen then tracer_line.From = Camera.ViewportSize / 2; tracer_line.To = targetScreenPos; tracer_line.Color = Options.TracerColorPicker.Value end
        else
            tracer_line.Visible = false
        end
        
        if Toggles.FOVVisibleToggle.Value then
            if Toggles.FixedFOVToggle.Value then FOVCircleFrame.Position = UDim2.fromScale(0.5, 0.5) else local mousePos = GetMouseLocation(UserInputService); FOVCircleFrame.Position = UDim2.fromOffset(mousePos.X, mousePos.Y) end
        end
    end)
end))

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]
    if SilentAimSettings.Enabled and not checkcaller() and CalculateChance(SilentAimSettings.HitChance) and currentTargetPart then
        local currentMethod = SilentAimSettings.SilentAimMethod
        local shotOrigin = nil

        if (Method == "FindPartOnRayWithIgnoreList" and currentMethod == Method) or
           (Method == "FindPartOnRayWithWhitelist" and currentMethod == Method) or
           ((Method == "FindPartOnRay" or Method == "findPartOnRay") and currentMethod:lower() == Method:lower()) then
            
            if ValidateArguments(Arguments, ExpectedArguments[Method] or ExpectedArguments["FindPartOnRay"]) then
                shotOrigin = Arguments[2].Origin
                table.insert(recentShots, {origin = shotOrigin, time = tick()})
                if SilentAimSettings.Wallbang then
                    return currentTargetPart, currentTargetPart.Position, currentTargetPart.CFrame.LookVector, currentTargetPart.Material
                end
                Arguments[2] = Ray.new(Arguments[2].Origin, getDirection(Arguments[2].Origin, currentTargetPart.Position))
                return oldNamecall(unpack(Arguments))
            end
        elseif Method == "Raycast" and currentMethod == Method then
            if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                shotOrigin = Arguments[2]
                table.insert(recentShots, {origin = shotOrigin, time = tick()})
                if SilentAimSettings.Wallbang then
                    local direction = getDirection(shotOrigin, currentTargetPart.Position)
                    local wallbangParams = RaycastParams.new()
                    wallbangParams.FilterType = Enum.RaycastFilterType.Include
                    wallbangParams.FilterDescendantsInstances = {currentTargetPart.Parent}
                    local newArgs = {self, shotOrigin, direction, wallbangParams}
                    return oldNamecall(unpack(newArgs))
                end
                Arguments[3] = getDirection(Arguments[2], currentTargetPart.Position)
                return oldNamecall(unpack(Arguments))
            end
        elseif (Method == "ScreenPointToRay" or Method == "ViewportPointToRay") and currentMethod == Method and self == Camera then
            shotOrigin = Camera.CFrame.Position
            local direction = (currentTargetPart.Position - shotOrigin).Unit
            table.insert(recentShots, {origin = shotOrigin, time = tick()})
            return Ray.new(shotOrigin, direction)
        end
    end
    return oldNamecall(...)
end))

local oldIndex
local oldRayNew
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if self == Mouse and not checkcaller() and SilentAimSettings.Enabled and SilentAimSettings.SilentAimMethod == "Mouse.Hit/Target" then
        if currentTargetPart then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                table.insert(recentShots, {origin = LocalPlayer.Character.Head.Position, time = tick()})
            end
            if Index == "Target" or Index == "target" then
                return currentTargetPart
            elseif Index == "Hit" or Index == "hit" then
                return (SilentAimSettings.MouseHitPrediction and (currentTargetPart.CFrame + (currentTargetPart.Velocity * currentTargetPart.Velocity.magnitude * SilentAimSettings.MouseHitPredictionAmount))) or currentTargetPart.CFrame
            elseif Index == "X" or Index == "x" then
                return self.X
            elseif Index == "Y" or Index == "y" then
                return self.Y
            elseif Index == "UnitRay" then
                return Ray.new(self.Origin, (self.Hit.p - self.Origin.p).Unit)
            end
        end
    end
    return oldIndex(self, Index)
end))

oldRayNew = hookfunction(Ray.new, newcclosure(function(origin, direction)
    if SilentAimSettings.Enabled and SilentAimSettings.SilentAimMethod == "Ray" and currentTargetPart and not checkcaller() and CalculateChance(SilentAimSettings.HitChance) then
        table.insert(recentShots, {origin = origin, time = tick()})
        local newDirectionVector = getDirection(origin, currentTargetPart.Position)
        return oldRayNew(origin, newDirectionVector)
    end
    return oldRayNew(origin, direction)
end))

Library:OnUnload(function()
    FOVCircleGui:Destroy()
    if IndependentPanelGui then
        IndependentPanelGui:Destroy()
    end
    if currentHighlight then
        currentHighlight:Destroy()
    end
    if transparencyLoopConnection then
        transparencyLoopConnection:Disconnect()
        transparencyLoopConnection = nil
        restoreCharacterAppearance()
    end
    hideAllVisuals()
    oldNamecall:UnHook()
    oldIndex:UnHook()
    oldRayNew:UnHook()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("UniversalSilentAim/Configs")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()
    ]]
    local func, err = loadstring(bulletCode)
    if func then
        pcall(func)
        return true
    end
    return false
end

local function loadFling()
    local flingCode = [[
    local Targets = {"All"}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local AllBool = false

local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) then
                    return x;
                elseif x.DisplayName:lower():match("^"..Name) then
                    return x;
                end
            end
        end
    else
        return
    end
end

local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessoy and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end

if not Welcome then Message("Script by AnthonyIsntHere", "Enjoy!", 5) end
getgenv().Welcome = true
if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end

if AllBool then
    for _,x in next, Players:GetPlayers() do
        SkidFling(x)
    end
end

for _,x in next, Targets do
    if GetPlayer(x) and GetPlayer(x) ~= Player then
        if GetPlayer(x).UserId ~= 1414978355 then
            local TPlayer = GetPlayer(x)
            if TPlayer then
                SkidFling(TPlayer)
            end
        else
            Message("Error Occurred", "This user is whitelisted! (Owner)", 5)
        end
    elseif not GetPlayer(x) and not AllBool then
        Message("Error Occurred", "Username Invalid", 5)
    end
end
    ]]
    local func, err = loadstring(flingCode)
    if func then
        pcall(func)
        return true
    end
    return false
end

local function loadFECar()
    local fecarCode = [[
    local Players = cloneref(game:GetService("Players"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local uScale = function(xScale, yScale)
local screen = workspace.CurrentCamera.ViewportSize
return UDim2.new(0, screen.X * xScale, 0, screen.Y * (yScale or xScale)) end

local uPos = function(xScale, yScale)
local screen = workspace.CurrentCamera.ViewportSize
return UDim2.new(0, screen.X * xScale, 0, screen.Y * yScale) end

local uSize = function(widthScale, heightScale)
local screen = workspace.CurrentCamera.ViewportSize
return UDim2.new(0, screen.X * widthScale, 0, screen.Y * (heightScale or widthScale)) end

 createNotification = function(title, text, duration)
    local notificationGui = Instance.new("ScreenGui", cloneref(game:GetService("CoreGui")))
    notificationGui.Name = "EnhancedNotification"
    notificationGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame", notificationGui)
    mainFrame.Size = uSize(0.25, 0.15)
    mainFrame.Position = UDim2.new(0.75, 0, 0.05, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    
    local titleText = Instance.new("TextLabel", titleBar)
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local timeBarContainer = Instance.new("Frame", mainFrame)
    timeBarContainer.Size = UDim2.new(1, 0, 0, 3)
    timeBarContainer.Position = UDim2.new(0, 0, 0, 28)
    timeBarContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    timeBarContainer.BorderSizePixel = 0
    
    local timeBar = Instance.new("Frame", timeBarContainer)
    timeBar.Size = UDim2.new(1, 0, 1, 0)
    timeBar.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    timeBar.BorderSizePixel = 0
    
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -10, 1, -45)
    contentFrame.Position = UDim2.new(0, 5, 0, 38)
    contentFrame.BackgroundTransparency = 1
    
    local messageText = Instance.new("TextLabel", contentFrame)
    messageText.Size = UDim2.new(1, 0, 1, 0)
    messageText.BackgroundTransparency = 1
    messageText.Text = text
    messageText.Font = Enum.Font.Gotham
    messageText.TextColor3 = Color3.new(1, 1, 1)
    messageText.TextSize = 16
    messageText.TextWrapped = true
    messageText.TextXAlignment = Enum.TextXAlignment.Left
    messageText.TextYAlignment = Enum.TextYAlignment.Top
    messageText.TextTruncate = Enum.TextTruncate.AtEnd
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.75, 0, 0.05, 0)
    mainFrame:TweenSize(uSize(0.25, 0.15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    
    if duration and duration > 0 then
        timeBar:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, duration, true)
        
        task.delay(duration, function()
            mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.wait(0.3)
            notificationGui:Destroy()
        end)
    end
    
    return notificationGui
end





local char = Players.LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") and char.Humanoid.RigType == Enum.HumanoidRigType.R6 then
    createNotification("R6??", "You need to be R15 Dude",8)
    return
end

if getgenv().CarExecuted then return end
getgenv().CarExecuted = true
wait()
createNotification("Fe Silly Car V1.3", "Small GUI Update :3",8)
carstop = false


local plr = Players.LocalPlayer
local cg = cloneref(game:GetService("CoreGui"))
local runService = game:GetService("RunService")

local animData = {
    {id = "76503595759461", mult = 1},
    {id = "115245341767944", mult = 2},
    {id = "127805235430271", mult = 4},
    {id = "138003068153218", mult = 1},
    {id = "116772752010894", mult = 1},
    {id = "116625361313832", mult = 1},
    {id = "81388785824317", mult = 1},
    {id = "108747312576405", mult = 2},
    {id = "113181071290859", mult = 1},
    {id = "134681712937413", mult = 1},
    {id = "115260380433565", mult = 2},
    {id = "72382226286301", mult = 1}
}
local currentIndex = 1
local activeTrack
local activeConn

local sg = Instance.new("ScreenGui", cg)
sg.ResetOnSpawn = false
sg.Name = "SillyCarUI"

mainFrame = Instance.new("Frame", sg)
mainFrame.Size = uSize(0.3,0.6)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true


local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 8)


local shadow = Instance.new("ImageLabel", mainFrame)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1


title = Instance.new("Frame", mainFrame)
title.Size = UDim2.new(1, 0, 0, 32)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
title.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Name = "TitleCorner"

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "FE Silly Car"
titleText.Font = Enum.Font.GothamBold
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextScaled = true
titleText.TextXAlignment = Enum.TextXAlignment.Left




local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)

minBtn = Instance.new("TextButton", title)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -54, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Text = "_"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextScaled = true
buttonCorner:Clone().Parent = minBtn

closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
buttonCorner:Clone().Parent = closeBtn

vp = Instance.new("Frame", mainFrame)
vp.Size = UDim2.new(1, -20, 1, -120)
vp.Position = UDim2.new(0, 10, 0, 50)
vp.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
vp.BorderSizePixel = 0

local vpCorner = Instance.new("UICorner", vp)
vpCorner.CornerRadius = UDim.new(0, 6)

local innerVp = Instance.new("ViewportFrame", vp)
innerVp.Size = UDim2.new(1, -4, 1, -4)
innerVp.Position = UDim2.new(0, 2, 0, 2)
innerVp.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
innerVp.BorderSizePixel = 0

cam = Instance.new("Camera")
cam.CameraType = Enum.CameraType.Scriptable
innerVp.CurrentCamera = cam


local animNameFrame = Instance.new("Frame", mainFrame)
animNameFrame.Size = UDim2.new(1, -20, 0, 24)
animNameFrame.Position = UDim2.new(0, 10, 0, 40)
animNameFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
animNameFrame.BorderSizePixel = 0

local animNameCorner = Instance.new("UICorner", animNameFrame)
animNameCorner.CornerRadius = UDim.new(0, 4)

local animNameText = Instance.new("TextLabel", animNameFrame)
animNameText.Size = UDim2.new(1, 0, 1, 0)
animNameText.BackgroundTransparency = 1
animNameText.Text = "Animation "..currentIndex.."/"..#animData
animNameText.Font = Enum.Font.Gotham
animNameText.TextColor3 = Color3.new(1, 1, 1)
animNameText.TextScaled = true

local buttonContainer = Instance.new("Frame", mainFrame)
buttonContainer.Size = UDim2.new(1, -20, 0, 40)
buttonContainer.Position = UDim2.new(0, 10, 1, -50)
buttonContainer.BackgroundTransparency = 1

prevBtn = Instance.new("TextButton", buttonContainer)
prevBtn.Size = UDim2.new(0, 80, 1, 0)
prevBtn.Position = UDim2.new(0, 0, 0, 0)
prevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
prevBtn.TextColor3 = Color3.new(1, 1, 1)
prevBtn.Text = "◄ Previous"
prevBtn.Font = Enum.Font.Gotham
prevBtn.TextScaled = true
buttonCorner:Clone().Parent = prevBtn

nextBtn = Instance.new("TextButton", buttonContainer)
nextBtn.Size = UDim2.new(0, 80, 1, 0)
nextBtn.Position = UDim2.new(1, -80, 0, 0)
nextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
nextBtn.TextColor3 = Color3.new(1, 1, 1)
nextBtn.Text = "Next ►"
nextBtn.Font = Enum.Font.Gotham
nextBtn.TextScaled = true
buttonCorner:Clone().Parent = nextBtn

selectBtn = Instance.new("TextButton", mainFrame)
selectBtn.Size = UDim2.new(1, -20, 0, 30)
selectBtn.Position = UDim2.new(0, 10, 1, -90)
selectBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
selectBtn.TextColor3 = Color3.new(1, 1, 1)
selectBtn.Text = "SELECT ANIMATION"
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextScaled = true
local selectCorner = Instance.new("UICorner", selectBtn)
selectCorner.CornerRadius = UDim.new(0, 4)

local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = originalColor:lerp(Color3.new(1, 1, 1), 0.1)
        button.Size = originalSize - UDim2.new(0, 2, 0, 2)
        button.Position = button.Position + UDim2.new(0, 1, 0, 1)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
        button.Size = originalSize
        button.Position = button.Position - UDim2.new(0, 1, 0, 1)
    end)
end

setupButtonHover(prevBtn)
setupButtonHover(nextBtn)
setupButtonHover(selectBtn)
setupButtonHover(minBtn)
setupButtonHover(closeBtn)

ensurePrimaryPart = function(m)
    if not m then return end
    if not m.PrimaryPart then
        local root = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
        if root then
            m.PrimaryPart = root
        end
    end
end

realDummy = Players:CreateHumanoidModelFromUserId(9160453052)
realDummy.Parent = workspace
ensurePrimaryPart(realDummy)
repeat task.wait() ensurePrimaryPart(realDummy) until realDummy.PrimaryPart
realDummy:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

vpDummy = realDummy:Clone()
ensurePrimaryPart(vpDummy)
vpDummy.Parent = innerVp
if vpDummy.PrimaryPart and realDummy.PrimaryPart then
    vpDummy:SetPrimaryPartCFrame(realDummy.PrimaryPart.CFrame)
end
local hrp = vpDummy:FindFirstChild("HumanoidRootPart")
if hrp then
    hrp.Transparency = 1
end

for _, part in ipairs(vpDummy:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = false
    end
end
for _, part in ipairs(realDummy:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Transparency = 1
        part.CanCollide = false
    end
end

rotationAngle = 0
rotationSpeed = math.rad(30)
radius = 6
height = 3

runService.RenderStepped:Connect(function(deltaTime)
    if not realDummy.Parent or not vpDummy.Parent then return end
    for _, part in ipairs(realDummy:GetDescendants()) do
        if part:IsA("BasePart") then
            local clonePart = vpDummy:FindFirstChild(part.Name, true)
            if clonePart and part:IsDescendantOf(realDummy) then
                clonePart.CFrame = part.CFrame
            end
        end
    end
    rotationAngle = rotationAngle + rotationSpeed * deltaTime
    local x = math.sin(rotationAngle) * radius
    local z = math.cos(rotationAngle) * radius
    local targetPos = (vpDummy.PrimaryPart and vpDummy.PrimaryPart.Position) or Vector3.new(0, 1, 0)
    cam.CFrame = CFrame.new(targetPos + Vector3.new(x, height, z), targetPos)
end)

hum = realDummy:FindFirstChildWhichIsA("Humanoid")
animator = hum and (hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum))
previewAnimTrack = nil

loadAnim = function(index)
    if previewAnimTrack then
        previewAnimTrack:Stop()
        previewAnimTrack:Destroy()
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animData[index].id
    if animator then
        previewAnimTrack = animator:LoadAnimation(anim)
        previewAnimTrack.Priority = Enum.AnimationPriority.Action
        previewAnimTrack.Looped = true
        previewAnimTrack:Play()
        previewAnimTrack:AdjustWeight(1)
        previewAnimTrack:AdjustSpeed(1)
    end
    animNameText.Text = "Animation "..currentIndex.."/"..#animData
end

loadAnim(currentIndex)

stopAll = function()
    if activeTrack then
        activeTrack:Stop()
        activeTrack:Destroy()
        activeTrack = nil
    end
    if activeConn then
        activeConn:Disconnect()
        activeConn = nil
    end
end

playCarAnim = function(char)
    stopAll()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animData[currentIndex].id
    local track = hum:LoadAnimation(anim)
    activeTrack = track
    track.Priority = Enum.AnimationPriority.Action
    track:Play()
    track.Looped = true
    track:AdjustWeight(1)
    workspace.CurrentCamera.CameraSubject = plr.Character:WaitForChild("Head")
    local lastPosition = root.Position
local lastTime = os.clock()

activeConn = runService.Heartbeat:Connect(function()
    local currentPosition = root.Position
    local currentTime = os.clock()
    local deltaTime = currentTime - lastTime
    
    if deltaTime > 0 then
        local displacement = (currentPosition - lastPosition)
        local velocity = displacement / deltaTime
        local speed = velocity.Magnitude
        
        if speed > 0.1 then
            local dot = root.CFrame.LookVector:Dot(velocity.Unit)
            track:AdjustSpeed((speed / 16) * animData[currentIndex].mult * (dot >= 0 and 1 or -1))
        else
            track:AdjustSpeed(0)
        end
    end
    
    lastPosition = currentPosition
    lastTime = currentTime
end)
end

showConfirmation = function(callback)
if confirmationgui then return end
confirmationgui = true

    local popup = Instance.new("Frame", sg)
    popup.Size = uSize(0.2,0.5)
    popup.Position = uPos(0,0)
    popup.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    popup.BorderSizePixel = 0
    popup.Name = "CloserNig"
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
    
    local shadow = Instance.new("ImageLabel", popup)
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    
    local label = Instance.new("TextLabel", popup)
    label.Size = UDim2.new(1, -20, 0, 60)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = "Are you sure you want to close?\n(it will stop the animation)"
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextWrapped = true
    
    local buttonContainer = Instance.new("Frame", popup)
    buttonContainer.Size = UDim2.new(1, -20, 0, 40)
    buttonContainer.Position = UDim2.new(0, 10, 1, -50)
    buttonContainer.BackgroundTransparency = 1
    
    local yesBtn = Instance.new("TextButton", buttonContainer)
    yesBtn.Size = UDim2.new(0.5, -5, 1, 0)
    yesBtn.Position = UDim2.new(0, 0, 0, 0)
    yesBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.Text = "Yes"
    yesBtn.Font = Enum.Font.Gotham
    yesBtn.TextScaled = true
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 4)
    
    local noBtn = Instance.new("TextButton", buttonContainer)
    noBtn.Size = UDim2.new(0.5, -5, 1, 0)
    noBtn.Position = UDim2.new(0.5, 5, 0, 0)
    noBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.Text = "No"
    noBtn.Font = Enum.Font.Gotham
    noBtn.TextScaled = true
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 4)
    
    setupButtonHover(yesBtn)
    setupButtonHover(noBtn)
    
    yesBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
        callback(true)
        confirmationgui = false
    end)
    noBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
        callback(false)
        confirmationgui = false
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        sg.Enabled = not sg.Enabled
    elseif input.KeyCode == Enum.KeyCode.Left then
        currentIndex = (currentIndex - 2) % #animData + 1
        loadAnim(currentIndex)
    elseif input.KeyCode == Enum.KeyCode.Right then
        currentIndex = currentIndex % #animData + 1
        loadAnim(currentIndex)
    elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
        playCarAnim(plr.Character)
    end
end)

prevBtn.MouseButton1Click:Connect(function()
    currentIndex = (currentIndex - 2) % #animData + 1
    loadAnim(currentIndex)
end)

nextBtn.MouseButton1Click:Connect(function()
    currentIndex = currentIndex % #animData + 1
    loadAnim(currentIndex)
end)

selectBtn.MouseButton1Click:Connect(function()
    playCarAnim(plr.Character)
end)

local minimized = false

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = uSize(0.3,0.1)
        for _, child in ipairs(mainFrame:GetChildren()) do
            if child ~= title and child ~= minBtn and child ~= closeBtn and not child:IsA("UICorner") then
                child.Visible = false
            end
        end
        titleCorner.CornerRadius = UDim.new(0, 8)
    else
        mainFrame.Size = uSize(0.3,0.6)
        for _, child in ipairs(mainFrame:GetChildren()) do
            if not child:IsA("UICorner") then
                child.Visible = true
            end
        end
        titleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    end
end)

closeAll = function()
    stopAll()
    sg:Destroy()
    
end

closeBtn.MouseButton1Click:Connect(function()
    showConfirmation(function(confirm)
        if confirm then
        carstop = true
            closeAll()
            getgenv().CarExecuted = false
            createNotification("Fe Silly Car","Gui Closed..",5)
        end
    end)
end)

plr.CharacterAdded:Connect(function(char)
if carstop == true then
    return
end
    task.wait(1)
    playCarAnim(char)
    getgenv().TiltForCarLoaded = false
    wait()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Gaze-stuff/refs/heads/main/Tilt%20for%20car"))()
end)


loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Gaze-stuff/refs/heads/main/Tilt%20for%20car"))()

loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Shiftlock-script-42373"))()
    ]]
    local func, err = loadstring(fecarCode)
    if func then
        pcall(func)
        return true
    end
    return false
end

local function loadBlackHole()
    local blackholeCode = [[

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

playSound("2865227271")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 190)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 51)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Super Ring Parts v5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(0, 153, 76)
Title.Font = Enum.Font.Fondamento
Title.TextSize = 22
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = Title

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 35)
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.Text = "Off"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Fondamento
ToggleButton.TextSize = 15
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

local DecreaseRadius = Instance.new("TextButton")
DecreaseRadius.Size = UDim2.new(0.2, 0, 0, 35)
DecreaseRadius.Position = UDim2.new(0.1, 0, 0.6, 0)
DecreaseRadius.Text = "<"
DecreaseRadius.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
DecreaseRadius.TextColor3 = Color3.fromRGB(0, 0, 0)
DecreaseRadius.Font = Enum.Font.Fondamento
DecreaseRadius.TextSize = 18
DecreaseRadius.Parent = MainFrame

local DecreaseCorner = Instance.new("UICorner")
DecreaseCorner.CornerRadius = UDim.new(0, 10)
DecreaseCorner.Parent = DecreaseRadius

local IncreaseRadius = Instance.new("TextButton")
IncreaseRadius.Size = UDim2.new(0.2, 0, 0, 35)
IncreaseRadius.Position = UDim2.new(0.7, 0, 0.6, 0)
IncreaseRadius.Text = ">"
IncreaseRadius.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
IncreaseRadius.TextColor3 = Color3.fromRGB(0, 0, 0)
IncreaseRadius.Font = Enum.Font.Fondamento
IncreaseRadius.TextSize = 18
IncreaseRadius.Parent = MainFrame

local IncreaseCorner = Instance.new("UICorner")
IncreaseCorner.CornerRadius = UDim.new(0, 10)
IncreaseCorner.Parent = IncreaseRadius

local RadiusDisplay = Instance.new("TextLabel")
RadiusDisplay.Size = UDim2.new(0.4, 0, 0, 35)
RadiusDisplay.Position = UDim2.new(0.3, 0, 0.6, 0)
RadiusDisplay.Text = "Radius: 50"
RadiusDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
RadiusDisplay.TextColor3 = Color3.fromRGB(0, 0, 0)
RadiusDisplay.Font = Enum.Font.Fondamento
RadiusDisplay.TextSize = 15
RadiusDisplay.Parent = MainFrame

local RadiusCorner = Instance.new("UICorner")
RadiusCorner.CornerRadius = UDim.new(0, 10)
RadiusCorner.Parent = RadiusDisplay

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(1, 0, 0, 20)
Watermark.Position = UDim2.new(0, 0, 1, -20)
Watermark.Text = "Super Ring [V5] by ???!"
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.BackgroundTransparency = 1
Watermark.Font = Enum.Font.Fondamento
Watermark.TextSize = 14
Watermark.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.Fondamento
MinimizeButton.TextSize = 15
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 15)
MinimizeCorner.Parent = MinimizeButton

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
        ToggleButton.Visible = false
        DecreaseRadius.Visible = false
        IncreaseRadius.Visible = false
        RadiusDisplay.Visible = false
        Watermark.Visible = false
    else
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 190), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
        ToggleButton.Visible = true
        DecreaseRadius.Visible = true
        IncreaseRadius.Visible = true
        RadiusDisplay.Visible = true
        Watermark.Visible = true
    end
    playSound("12221967")
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }
    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end
    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end
    EnablePartControl()
end

local radius = 50
local height = 100
local rotationSpeed = 0.5
local attractionStrength = 1000
local ringPartsEnabled = false

local function RetainPart(Part)
    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
            return false
        end

        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        Part.CanCollide = false
        return true
    end
    return false
end

local parts = {}
local function addPart(part)
    if RetainPart(part) then
        if not table.find(parts, part) then
            table.insert(parts, part)
        end
    end
end

local function removePart(part)
    local index = table.find(parts, part)
    if index then
        table.remove(parts, index)
    end
end

for _, part in pairs(workspace:GetDescendants()) do
    addPart(part)
end

workspace.DescendantAdded:Connect(addPart)
workspace.DescendantRemoving:Connect(removePart)

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end
    
    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local tornadoCenter = humanoidRootPart.Position
        for _, part in pairs(parts) do
            if part.Parent and not part.Anchored then
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(radius, distance),
                    tornadoCenter.Y + (height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(radius, distance)
                )
                local directionToTarget = (targetPos - part.Position).unit
                part.Velocity = directionToTarget * attractionStrength
            end
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    ringPartsEnabled = not ringPartsEnabled
    ToggleButton.Text = ringPartsEnabled and "Ring Parts On" or "Ring Parts Off"
    ToggleButton.BackgroundColor3 = ringPartsEnabled and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(160, 82, 45)
    playSound("12221967")
end)

DecreaseRadius.MouseButton1Click:Connect(function()
    radius = math.max(0, radius - 5)
    RadiusDisplay.Text = "Radius: " .. radius
    playSound("12221967")
end)

IncreaseRadius.MouseButton1Click:Connect(function()
    radius = math.min(10000, radius + 5)
    RadiusDisplay.Text = "Radius: " .. radius
    playSound("12221967")
end)

local userId = Players:GetUserIdFromNameAsync("Robloxlukasgames")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

StarterGui:SetCore("SendNotification", {
    Title = "Super ring parts V5",
    Text = "enjoy",
    Icon = content,
    Duration = 5
})

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "Original By Yumm Scriptblox",
    Icon = content,
    Duration = 5
})

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "Edited By ???",
    Icon = content,
    Duration = 5
})

    ]]
    local func, err = loadstring(blackholeCode)
    if func then
        pcall(func)
        return true
    end
    return false
end

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
makeTween(blur, {Size = C.Blur}, 0.4)

local gui = Instance.new("ScreenGui")
gui.Name = "shible"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true

local root = Instance.new("Frame")
root.Name = "MainFrame"
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.45)
root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundColor3 = Theme.Glass
root.BackgroundTransparency = 0.18
root.BorderSizePixel = 0
root.Active = true
root.Visible = true
root.Selectable = false
root.Parent = gui
corner(root, C.Radius)

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -15)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.85
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = root

local grabberArea = Instance.new("Frame")
grabberArea.Size = UDim2.new(1, 0, 0, 36)
grabberArea.BackgroundTransparency = 1
grabberArea.Active = true
grabberArea.Parent = root

local grabber = Instance.new("Frame")
grabber.AnchorPoint = Vector2.new(0.5, 0.5)
grabber.Position = UDim2.new(0.5, 0, 0.5, 0)
grabber.Size = UDim2.new(0, 36, 0, 4)
grabber.BackgroundColor3 = Theme.Grabber
grabber.BackgroundTransparency = 0.3
grabber.BorderSizePixel = 0
grabber.Parent = grabberArea
corner(grabber, 999)

local nav = Instance.new("Frame")
nav.Size = UDim2.new(1, 0, 0, C.NavHeight)
nav.BackgroundTransparency = 1
nav.Parent = root

local title = Instance.new("TextLabel")
title.Text = "shible"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 17
title.TextColor3 = Theme.TextPrimary
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(0.35, 0, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = nav

local expireLabel = Instance.new("TextLabel")
expireLabel.Text = "🔒 等待验证"
expireLabel.Font = Enum.Font.Gotham
expireLabel.TextSize = 12
expireLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
expireLabel.BackgroundTransparency = 1
expireLabel.Position = UDim2.new(0.35, 0, 0, 0)
expireLabel.Size = UDim2.new(0.3, 0, 1, 0)
expireLabel.TextXAlignment = Enum.TextXAlignment.Center
expireLabel.Parent = nav

local minBtn = Instance.new("TextButton")
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Theme.TextSecondary
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -40, 0, 10)
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.AutoButtonColor = false
minBtn.SelectionImageObject = nil
minBtn.Selectable = false
minBtn.Parent = nav

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -C.NavHeight)
contentContainer.Position = UDim2.new(0, 0, 0, C.NavHeight)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = root

local pageMain = Instance.new("Frame")
pageMain.Size = UDim2.new(1, 0, 1, 0)
pageMain.BackgroundTransparency = 1
pageMain.Visible = true
pageMain.Parent = contentContainer
pageMain.Selectable = false

local introContainer = Instance.new("Frame")
introContainer.BackgroundTransparency = 1
introContainer.Position = UDim2.new(0, 16, 0, 8)
introContainer.Size = UDim2.new(1, -32, 1, -96)
introContainer.ClipsDescendants = false
introContainer.Parent = pageMain

local subtitle = Instance.new("TextLabel")
subtitle.Text = "欢迎使用 shible\n群: 434448780"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Theme.TextSecondary
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 0, 0, 0)
subtitle.Size = UDim2.new(1, 0, 1, 0)
subtitle.TextYAlignment = Enum.TextYAlignment.Top
subtitle.TextWrapped = true
subtitle.AutomaticSize = Enum.AutomaticSize.Y
subtitle.Parent = introContainer

local function fitTextToContainer()
    local h = introContainer.AbsoluteSize.Y
    local lh = math.max(16, h / 4)
    subtitle.TextSize = math.clamp(math.floor(lh * 0.55), 12, 22)
    subtitle.TextWrapped = true
end

pcall(fitTextToContainer)
introContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    pcall(fitTextToContainer)
end)

local btnY = C.Height - 96
local confirm = Instance.new("TextButton")
confirm.Text = "确认"
confirm.Font = Enum.Font.GothamSemibold
confirm.TextSize = 14
confirm.TextColor3 = Theme.Accent
confirm.BackgroundTransparency = 1
confirm.Position = UDim2.new(0, 16, 0, btnY)
confirm.Size = UDim2.new(0.5, -22, 0, 36)
confirm.AutoButtonColor = false
confirm.Parent = pageMain
pressEffect(confirm)

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "关闭"
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Theme.Danger
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0.5, 6, 0, btnY)
closeBtn.Size = UDim2.new(0.5, -22, 0, 36)
closeBtn.AutoButtonColor = false
closeBtn.Parent = pageMain
pressEffect(closeBtn)

local pageFunction = Instance.new("Frame")
pageFunction.Size = UDim2.new(1, 0, 1, 0)
pageFunction.BackgroundTransparency = 1
pageFunction.Visible = false
pageFunction.Position = UDim2.new(1, 0, 0, 0)
pageFunction.Parent = contentContainer
pageFunction.Selectable = false

local funcList = Instance.new("ScrollingFrame")
funcList.Size = UDim2.new(0.25, -6, 1, -C.BackBtnHeight - 8)
funcList.Position = UDim2.new(0, 6, 0, 0)
funcList.BackgroundColor3 = Theme.Glass
funcList.BackgroundTransparency = 0.35
funcList.BorderSizePixel = 0
funcList.ScrollBarThickness = 3
funcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
funcList.CanvasSize = UDim2.new(0, 0, 0, 0)
funcList.Parent = pageFunction
corner(funcList, 12)

local overlay = Instance.new("Frame")
overlay.Name = "LockOverlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundTransparency = 1
overlay.Active = true
overlay.Selectable = true
overlay.ZIndex = 10
overlay.Visible = false
overlay.Parent = funcList

local function lockLeftButtons()
    overlay.Visible = true
    for _, btn in ipairs(funcList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Active = false
            btn.Selectable = false
            btn.AutoButtonColor = false
            btn.BackgroundTransparency = 0.8
            btn.TextColor3 = Color3.fromRGB(100, 100, 110)
        end
    end
end

local function unlockLeftButtons()
    overlay.Visible = false
    for _, btn in ipairs(funcList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Active = true
            btn.Selectable = true
            btn.AutoButtonColor = false
            btn.BackgroundTransparency = 0.6
            btn.TextColor3 = Theme.TextPrimary
        end
    end
end

local listLayout = Instance.new("UIListLayout", funcList)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local listPad = Instance.new("UIPadding", funcList)
listPad.PaddingTop = UDim.new(0, 6)
listPad.PaddingBottom = UDim.new(0, 6)
listPad.PaddingLeft = UDim.new(0, 6)
listPad.PaddingRight = UDim.new(0, 6)

local funcContent = Instance.new("ScrollingFrame")
funcContent.Size = UDim2.new(0.75, -12, 1, -C.BackBtnHeight - 8)
funcContent.Position = UDim2.new(0.25, 6, 0, 0)
funcContent.BackgroundColor3 = Theme.Glass
funcContent.BackgroundTransparency = 0.25
funcContent.BorderSizePixel = 0
funcContent.ClipsDescendants = true
funcContent.ScrollBarThickness = 4
funcContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
funcContent.CanvasSize = UDim2.new(0, 0, 0, 0)
funcContent.ScrollingDirection = Enum.ScrollingDirection.Y
funcContent.Parent = pageFunction
corner(funcContent, 12)

local pages = {}
local function createPage(name)
    local pg = Instance.new("Frame")
    pg.Name = name
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.Parent = funcContent
    pages[name] = pg
    return pg
end

local pgAim = createPage("Aim")
local pgSpeed = createPage("Speed")
local pgESP = createPage("ESP")
local pgFly = createPage("Fly")
local pgFun = createPage("Fun")
local pgAnti = createPage("Anti")
local pgHitbox = createPage("Hitbox")
local pgAction = createPage("Action")
local pgServer = createPage("Server")

local FuncState = {
    SpeedEnabled = false,
    SpeedValue = 50,
    ESPEnabled = false,
    HealthBarEnabled = false,
    DistanceEnabled = false,
    SpinEnabled = false,
    SpinSpeed = 50,
    AntiDetect = true,
    AdminDetect = true,
    BypassGroup = true,
    Mode = 1,
    AntennaEnabled = false,
    RadarEnabled = false,
    HitboxEnabled = false,
    HitboxSize = 5,
    BypassAC = true,
    WallCheck = false,
    AntiFall = false,
    Noclip = false,
    ShibleAimLoaded = false,
    BlackHoleLoaded = false,
    FECarLoaded = false,
    InkLoaded = false,
    R6Loaded = false,
    R15Loaded = false,
    WaterWalk = false,
    MapTeleport = false,
    SubZhui = false,
}

local Flinging = false
local waterWalkConnection = nil
local animTracks = {}
local mapTeleportGui = nil
local mapTeleportActive = false
local selectedPosition = nil
local originalCamera = nil
local viewportFrame = nil
local mapCamera = nil
local mapPart = nil
local mapDragging = false
local mapDragStart = nil
local mapCamStart = nil
local mapZoom = 200

local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createButton(parent, yPos, labelText, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -24, 0, 32)
    btn.Position = UDim2.new(0, 12, 0, yPos)
    btn.BackgroundColor3 = Theme.Glass
    btn.BackgroundTransparency = 0.4
    btn.Text = labelText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Theme.TextPrimary
    btn.AutoButtonColor = false
    corner(btn, 8)
    pressEffect(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, yPos, labelText, getState, onToggle)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 36)
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0, 50, 0, 28)
    track.Position = UDim2.new(1, -50, 0, 4)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    track.BorderSizePixel = 0
    corner(track, 14)
    track.Selectable = false

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 22, 0, 22)
    thumb.Position = UDim2.new(0, 3, 0, 3)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    corner(thumb, 11)
    thumb.Selectable = false

    track.Active = true
    local on = false

    pcall(function()
        on = getState()
    end)

    if on then
        track.BackgroundColor3 = Theme.Accent
        thumb.Position = UDim2.new(1, -25, 0, 3)
    end

    local function setState(val)
        on = val
        if on then
            makeTween(track, {BackgroundColor3 = Theme.Accent}, 0.2)
            makeTween(thumb, {Position = UDim2.new(1, -25, 0, 3)}, 0.2)
        else
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
        end
        safeCall(function()
            onToggle(val)
        end, "Toggle:" .. labelText)
    end

    track.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            setState(not on)
        end
    end)
end

local function createSlider(parent, yPos, labelText, minVal, maxVal, initial, onChanged)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 54)
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(0, 45, 0, 18)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local inputBox = Instance.new("TextBox", row)
    inputBox.Text = tostring(initial)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 12
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "输入"
    inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    inputBox.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    inputBox.BackgroundTransparency = 0.2
    inputBox.Position = UDim2.new(1, -56, 0, -1)
    inputBox.Size = UDim2.new(0, 56, 0, 22)
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.ClearTextOnFocus = true
    inputBox.BorderSizePixel = 0
    inputBox.ZIndex = 5
    corner(inputBox, 5)

    local track = Instance.new("TextButton", row)
    track.Size = UDim2.new(1, 0, 0, 12)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    corner(track, 6)
    track.SelectionImageObject = nil
    track.Selectable = false
    track.ZIndex = 2

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    corner(fill, 6)

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = UDim2.new(0, -9, 0, -3)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 4
    corner(thumb, 9)

    local dragging = false

    local function setVal(val)
        val = math.floor(math.clamp(val, minVal, maxVal))
        local ratio = (val - minVal) / (maxVal - minVal)
        inputBox.Text = tostring(val)
        thumb.Position = UDim2.new(ratio, -9, 0, -3)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        safeCall(function()
            onChanged(val)
        end, "Slider:" .. labelText)
    end

    local function updateFromMouse()
        local mouse = UserInputService:GetMouseLocation()
        local ap = track.AbsolutePosition
        local as = track.AbsoluteSize
        local ratio = math.clamp((mouse.X - ap.X) / as.X, 0, 1)
        setVal(math.floor(minVal + (ratio * (maxVal - minVal))))
    end

    track.MouseButton1Down:Connect(function()
        dragging = true
        updateFromMouse()
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (dragging and ((input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch))) then
            updateFromMouse()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            dragging = false
        end
    end)

    inputBox.FocusLost:Connect(function()
        local txt = inputBox.Text:gsub("[^0-9]", "")
        if (txt == "") then
            txt = tostring(minVal)
        end
        setVal(tonumber(txt) or minVal)
    end)

    setVal(initial)
end

local function createMapTeleportUI()
    if mapTeleportGui then
        mapTeleportGui:Destroy()
        mapTeleportGui = nil
    end

    mapTeleportGui = Instance.new("ScreenGui")
    mapTeleportGui.Name = "MapTeleport"
    mapTeleportGui.ResetOnSpawn = false
    mapTeleportGui.IgnoreGuiInset = true
    mapTeleportGui.DisplayOrder = 999
    mapTeleportGui.Parent = PlayerGui

    local bg = Instance.new("Frame", mapTeleportGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.2
    bg.Active = true

    local viewport = Instance.new("ViewportFrame", mapTeleportGui)
    viewport.Size = UDim2.new(1, 0, 1, 0)
    viewport.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    viewport.BackgroundTransparency = 0
    viewport.Active = true
    viewport.Selectable = true

    local mapPart = Instance.new("Part")
    mapPart.Size = Vector3.new(2000, 1, 2000)
    mapPart.Position = Vector3.new(0, -1, 0)
    mapPart.Anchored = true
    mapPart.CanCollide = false
    mapPart.Transparency = 0.2
    mapPart.Color = Color3.fromRGB(100, 200, 255)
    mapPart.Material = Enum.Material.Neon
    mapPart.Parent = workspace

    local gridPart = Instance.new("Part")
    gridPart.Size = Vector3.new(2000, 0.1, 2000)
    gridPart.Position = Vector3.new(0, 0, 0)
    gridPart.Anchored = true
    gridPart.CanCollide = false
    gridPart.Transparency = 0.15
    gridPart.Color = Color3.fromRGB(180, 180, 200)
    gridPart.Material = Enum.Material.Neon
    gridPart.Parent = workspace

    local cam = Instance.new("Camera")
    cam.CameraType = Enum.CameraType.Scriptable
    cam.FieldOfView = 60
    cam.Parent = viewport
    viewport.CurrentCamera = cam

    mapCamera = cam
    mapZoom = 200
    cam.CFrame = CFrame.new(Vector3.new(0, mapZoom, 0), Vector3.new(0, 0, 0))

    local crosshair = Instance.new("Frame", mapTeleportGui)
    crosshair.Size = UDim2.new(0, 20, 0, 2)
    crosshair.Position = UDim2.new(0.5, -10, 0.5, -1)
    crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    crosshair.BorderSizePixel = 0
    crosshair.ZIndex = 10

    local crosshair2 = Instance.new("Frame", mapTeleportGui)
    crosshair2.Size = UDim2.new(0, 2, 0, 20)
    crosshair2.Position = UDim2.new(0.5, -1, 0.5, -10)
    crosshair2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    crosshair2.BorderSizePixel = 0
    crosshair2.ZIndex = 10

    local topLabel = Instance.new("TextLabel", mapTeleportGui)
    topLabel.Size = UDim2.new(0, 400, 0, 30)
    topLabel.Position = UDim2.new(0.5, -200, 0, 10)
    topLabel.BackgroundTransparency = 1
    topLabel.Text = "滚轮缩放 · 拖拽移动 · 点击选择传送位置"
    topLabel.TextColor3 = Color3.fromRGB(255, 255, 200)
    topLabel.Font = Enum.Font.Gotham
    topLabel.TextSize = 16
    topLabel.TextXAlignment = Enum.TextXAlignment.Center

    local selectedLabel = Instance.new("TextLabel", mapTeleportGui)
    selectedLabel.Size = UDim2.new(0, 300, 0, 25)
    selectedLabel.Position = UDim2.new(0.5, -150, 0.9, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = "未选择位置"
    selectedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Center

    local bottomBar = Instance.new("Frame", mapTeleportGui)
    bottomBar.Size = UDim2.new(0.3, 0, 0, 50)
    bottomBar.Position = UDim2.new(0.7, 0, 0.92, 0)
    bottomBar.BackgroundTransparency = 1

    local confirmBtn = Instance.new("TextButton", bottomBar)
    confirmBtn.Size = UDim2.new(0.45, -5, 0, 40)
    confirmBtn.Position = UDim2.new(0, 0, 0.5, -20)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    confirmBtn.Text = "确认传送"
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 14
    corner(confirmBtn, 8)
    pressEffect(confirmBtn)

    local cancelBtn = Instance.new("TextButton", bottomBar)
    cancelBtn.Size = UDim2.new(0.45, -5, 0, 40)
    cancelBtn.Position = UDim2.new(0.55, 5, 0.5, -20)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cancelBtn.Text = "取消"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 14
    corner(cancelBtn, 8)
    pressEffect(cancelBtn)

    local function getWorldPosition(screenX, screenY)
        local viewportSize = viewport.AbsoluteSize
        local relX = screenX / viewportSize.X
        local relY = screenY / viewportSize.Y
        if relX < 0 or relX > 1 or relY < 0 or relY > 1 then
            return nil
        end
        local ray = cam:ViewportPointToRay(relX * viewportSize.X, relY * viewportSize.Y)
        local origin = ray.Origin
        local direction = ray.Direction
        if direction.Y == 0 then return nil end
        local t = -origin.Y / direction.Y
        if t < 0 then return nil end
        local pos = origin + direction * t
        return pos
    end

    local function onMapClick(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local viewportPos = viewport.AbsolutePosition
            local viewportSize = viewport.AbsoluteSize
            local relX = (mousePos.X - viewportPos.X) / viewportSize.X
            local relY = (mousePos.Y - viewportPos.Y) / viewportSize.Y
            if relX >= 0 and relX <= 1 and relY >= 0 and relY <= 1 then
                local pos = getWorldPosition(mousePos.X - viewportPos.X, mousePos.Y - viewportPos.Y)
                if pos then
                    selectedPosition = pos
                    selectedLabel.Text = "已选择: X=" .. math.floor(pos.X) .. " Z=" .. math.floor(pos.Z)
                    selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    local dot = Instance.new("Part", workspace)
                    dot.Size = Vector3.new(2, 0.5, 2)
                    dot.Position = pos + Vector3.new(0, 0.5, 0)
                    dot.Color = Color3.fromRGB(0, 255, 0)
                    dot.Material = Enum.Material.Neon
                    dot.Anchored = true
                    dot.CanCollide = false
                    task.delay(0.5, function()
                        pcall(function() dot:Destroy() end)
                    end)
                end
            end
        end
    end

    viewport.InputBegan:Connect(onMapClick)

    local dragStart = nil
    local dragCamStart = nil

    viewport.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            mapDragging = true
            dragStart = input.Position
            dragCamStart = cam.CFrame
        end
    end)

    viewport.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            mapDragging = false
        end
    end)

    viewport.InputChanged:Connect(function(input)
        if mapDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local moveX = -delta.X * (mapZoom / 6000)
            local moveZ = delta.Y * (mapZoom / 6000)
            local newPos = dragCamStart.Position + Vector3.new(moveX, 0, moveZ)
            cam.CFrame = CFrame.new(newPos, Vector3.new(newPos.X, 0, newPos.Z))
            dragCamStart = cam.CFrame
            dragStart = input.Position
        end
    end)

    viewport.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            local zoomDelta = input.Position.Z
            mapZoom = math.clamp(mapZoom - zoomDelta * 5, 30, 500)
            local currentPos = cam.CFrame.Position
            cam.CFrame = CFrame.new(Vector3.new(currentPos.X, mapZoom, currentPos.Z), Vector3.new(currentPos.X, 0, currentPos.Z))
        end
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        if selectedPosition then
            local hrp = getRootPart()
            if hrp then
                hrp.CFrame = CFrame.new(selectedPosition.X, selectedPosition.Y + 3, selectedPosition.Z)
                Notify("shible", "已传送到选定位置", 2)
                selectedPosition = nil
                selectedLabel.Text = "未选择位置"
                selectedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            end
        else
            Notify("shible", "请先点击地图选择位置", 2)
        end
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        pcall(function() mapPart:Destroy() end)
        pcall(function() gridPart:Destroy() end)
        mapTeleportGui:Destroy()
        mapTeleportGui = nil
        mapTeleportActive = false
        FuncState.MapTeleport = false
        selectedPosition = nil
        mapDragging = false
        Notify("shible", "地图传送已关闭", 2)
    end)

    local function cleanup()
        pcall(function() mapPart:Destroy() end)
        pcall(function() gridPart:Destroy() end)
        if mapTeleportGui then
            mapTeleportGui:Destroy()
            mapTeleportGui = nil
        end
        mapTeleportActive = false
        FuncState.MapTeleport = false
        selectedPosition = nil
        mapDragging = false
    end

    mapTeleportActive = true

    local serverInfo = "未知"
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info then serverInfo = info.Name end
    end)
    Notify("shible", "当前服务器: " .. serverInfo, 2)

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            return
        end
    end)

    task.spawn(function()
        while mapTeleportGui and mapTeleportActive do
            task.wait(0.1)
            if not mapTeleportActive or not mapTeleportGui then
                cleanup()
                break
            end
        end
    end)
end

do
    local p = pgAim
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "玩家自瞄"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    local originalCameraMode = nil
    local originalCameraCFrame = nil
    local scriptLoaded = false

    createToggle(p, y, "静默自瞄", function()
        return scriptLoaded
    end, function(v)
        if v then
            local cam = workspace.CurrentCamera
            if cam then
                originalCameraMode = cam.CameraType
                originalCameraCFrame = cam.CFrame
            end
            scriptLoaded = loadAimbot()
            if not scriptLoaded then
                warn("[静默自瞄] 加载失败")
            end
        else
            local cam = workspace.CurrentCamera
            if cam then
                pcall(function()
                    if originalCameraMode then
                        cam.CameraType = originalCameraMode
                    else
                        cam.CameraType = Enum.CameraType.Custom
                    end
                end)
                pcall(function()
                    if originalCameraCFrame then
                        cam.CFrame = originalCameraCFrame
                    end
                end)
            end
            pcall(function()
                getgenv().AimbotEnabled = false
            end)
            pcall(function()
                getgenv().SilentAim = false
            end)
            pcall(function()
                getgenv()._G.AimbotEnabled = false
            end)
            scriptLoaded = false
        end
    end)

    y = y + 46
    local bulletTrackLoaded = false

    createToggle(p, y, "子弹追踪", function()
        return bulletTrackLoaded
    end, function(v)
        if v then
            bulletTrackLoaded = loadBulletTrack()
            if not bulletTrackLoaded then
                warn("[子弹追踪] 加载失败")
            end
        else
            pcall(function()
                getgenv().BulletTrackEnabled = false
            end)
            pcall(function()
                _G.BulletTrackEnabled = false
            end)
            bulletTrackLoaded = false
        end
    end)

    y = y + 46
    createToggle(p, y, "子追(推荐)", function()
        return FuncState.SubZhui
    end, function(v)
        FuncState.SubZhui = v
        if v then
            Notify("shible", "子追已开启(功能待实现)", 2)
        else
            Notify("shible", "子追已关闭", 2)
        end
    end)
end

do
    local p = pgSpeed
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物移速"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "启用加速", function()
        return FuncState.SpeedEnabled
    end, function(v)
        FuncState.SpeedEnabled = v
        local h = getHumanoid()
        if h then
            h.WalkSpeed = (v and FuncState.SpeedValue) or 16
        end
    end)

    y = y + 46
    createSlider(p, y, "移速 (16-700)", 16, 700, 50, function(v)
        FuncState.SpeedValue = v
    end)

    RunService.Heartbeat:Connect(function()
        if FuncState.SpeedEnabled then
            local h = getHumanoid()
            if (h and (h.WalkSpeed ~= FuncState.SpeedValue)) then
                h.WalkSpeed = FuncState.SpeedValue
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local h = char:FindFirstChild("Humanoid")
        if (h and FuncState.SpeedEnabled) then
            h.WalkSpeed = FuncState.SpeedValue
        end
    end)
end

do
    local p = pgESP
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物功能"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "全身透视", function()
        return FuncState.ESPEnabled
    end, function(v)
        FuncState.ESPEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "头顶血条", function()
        return FuncState.HealthBarEnabled
    end, function(v)
        FuncState.HealthBarEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "距离显示", function()
        return FuncState.DistanceEnabled
    end, function(v)
        FuncState.DistanceEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "人物天线", function()
        return FuncState.AntennaEnabled
    end, function(v)
        FuncState.AntennaEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "玩家雷达", function()
        return FuncState.RadarEnabled
    end, function(v)
        FuncState.RadarEnabled = v
    end)

    local cache = {}
    local antennaLines = {}
    local useDrawing = pcall(function()
        return Drawing.new("Line")
    end)

    if not useDrawing then
        warn("[人物天线] 当前环境不支持 Drawing，天线将无法使用")
    end

    local radarFrame = nil
    local radarPoints = {}
    local radarRadiusPixels = 85
    local radarWorldRange = 300

    local function createRadar()
        if radarFrame then
            return
        end
        radarFrame = Instance.new("Frame")
        radarFrame.Name = "Radar"
        radarFrame.Size = UDim2.new(0, 180, 0, 180)
        radarFrame.AnchorPoint = Vector2.new(1, 0)
        radarFrame.Position = UDim2.new(1, -10, 0, 10)
        radarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        radarFrame.BackgroundTransparency = 0.4
        radarFrame.BorderSizePixel = 0
        radarFrame.ClipsDescendants = true
        radarFrame.Visible = false
        radarFrame.ZIndex = 2
        radarFrame.Parent = gui
        corner(radarFrame, 90)

        local cross = Instance.new("Frame", radarFrame)
        cross.Size = UDim2.new(1, 0, 0, 1)
        cross.Position = UDim2.new(0, 0, 0.5, 0)
        cross.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        cross.BackgroundTransparency = 0.6
        cross.BorderSizePixel = 0

        local cross2 = Instance.new("Frame", radarFrame)
        cross2.Size = UDim2.new(0, 1, 1, 0)
        cross2.Position = UDim2.new(0.5, 0, 0, 0)
        cross2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        cross2.BackgroundTransparency = 0.6
        cross2.BorderSizePixel = 0

        local maxDist = radarWorldRange
        local ringDistances = {150, 300}

        for _, dist in ipairs(ringDistances) do
            local ratio = dist / maxDist
            local ring = Instance.new("Frame", radarFrame)
            ring.Size = UDim2.new(2 * ratio, 0, 2 * ratio, 0)
            ring.Position = UDim2.new(0.5 - ratio, 0, 0.5 - ratio, 0)
            ring.BackgroundTransparency = 1
            ring.BorderSizePixel = 1
            ring.BorderColor3 = Color3.fromRGB(255, 255, 255)
            ring.BorderTransparency = 0.4
            ring.Visible = true
            corner(ring, 90)
        end

        local border = Instance.new("Frame", radarFrame)
        border.Size = UDim2.new(1, 0, 1, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 2
        border.BorderColor3 = Color3.fromRGB(255, 255, 255)
        border.BorderTransparency = 0.2
        border.BorderMode = Enum.BorderMode.Inset
        corner(border, 90)
    end

    local function updateRadar()
        if not FuncState.RadarEnabled then
            if radarFrame then
                radarFrame.Visible = false
            end
            for _, point in pairs(radarPoints) do
                point:Destroy()
            end
            radarPoints = {}
            return
        end

        if not radarFrame then
            createRadar()
        end

        if not radarFrame then
            return
        end

        local myRoot = getRootPart()
        if not myRoot then
            radarFrame.Visible = false
            return
        end

        radarFrame.Visible = true
        local myPos = myRoot.Position
        local radarSize = radarFrame.AbsoluteSize

        if ((radarSize.X == 0) or (radarSize.Y == 0)) then
            return
        end

        local maxDist = radarWorldRange

        for _, point in pairs(radarPoints) do
            point:Destroy()
        end
        radarPoints = {}

        local camera = workspace.CurrentCamera
        local camCF = camera.CFrame
        local forward = camCF.LookVector
        forward = Vector3.new(forward.X, 0, forward.Z).Unit
        if forward.Magnitude < 0.01 then forward = Vector3.new(1,0,0) end
        local right = Vector3.new(forward.Z, 0, -forward.X)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                continue
            end
            if plr.Character then
                local char = plr.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")

                if hrp then
                    local targetPos = hrp.Position
                    local diff = targetPos - myPos
                    local horizontalDist = math.sqrt((diff.X ^ 2) + (diff.Z ^ 2))

                    if (horizontalDist <= maxDist) then
                        local dirWorld = Vector3.new(diff.X, 0, diff.Z).Unit
                        if dirWorld.Magnitude < 0.01 then continue end
                        local fwdComp = dirWorld:Dot(forward)
                        local rightComp = dirWorld:Dot(right)
                        local angle = math.atan2(rightComp, fwdComp)

                        local normalizedDist = horizontalDist / maxDist
                        local pixelOffsetX = normalizedDist * radarRadiusPixels * math.sin(angle)
                        local pixelOffsetY = -normalizedDist * radarRadiusPixels * math.cos(angle)

                        local point = Instance.new("ImageLabel")
                        point.Size = UDim2.new(0, 7, 0, 7)
                        point.AnchorPoint = Vector2.new(0.5, 0.5)
                        point.Position = UDim2.new(0.5, pixelOffsetX, 0.5, pixelOffsetY)
                        point.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        point.BackgroundTransparency = 0
                        point.BorderSizePixel = 0
                        point.ZIndex = 3
                        point.Parent = radarFrame
                        corner(point, 4)
                        radarPoints[plr] = point
                    end
                end
            end
        end
    end

    local function createHealthBar(head)
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESP_HB"
        bb.Size = UDim2.new(0, 55, 0, 5)
        bb.StudsOffset = Vector3.new(0, 1.3, 0)
        bb.Adornee = head
        bb.AlwaysOnTop = true
        bb.MaxDistance = 500
        bb.Enabled = false
        bb.Parent = head

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bg.BackgroundTransparency = 0.15
        bg.BorderSizePixel = 0
        corner(bg, 2)

        local fill = Instance.new("Frame", bb)
        fill.Name = "Fill"
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
        fill.BorderSizePixel = 0
        fill.ZIndex = 2
        corner(fill, 2)

        return bb
    end

    local function getOrCreateESP(char)
        if (cache[char] and cache[char].hl and (cache[char].hl.Parent == char)) then
            return cache[char].hl, cache[char].hb
        end

        cache[char] = nil
        local oldHL = char:FindFirstChild("ESP_Highlight")
        if oldHL then
            oldHL:Destroy()
        end

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 50, 50)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 100, 100)
        hl.OutlineTransparency = 0.05
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = char

        local hb
        local head = char:FindFirstChild("Head")

        if head then
            local oldHB = head:FindFirstChild("ESP_HB")
            if oldHB then
                oldHB:Destroy()
            end
            hb = createHealthBar(head)
        end

        cache[char] = {hl = hl, hb = hb}
        return hl, hb
    end

    local function removeESP(char)
        local entry = cache[char]

        if entry then
            pcall(function()
                if entry.hl then
                    entry.hl:Destroy()
                end
            end)
            pcall(function()
                if entry.hb then
                    entry.hb:Destroy()
                end
            end)
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local d = hrp:FindFirstChild("ESP_Distance")
            if d then
                d:Destroy()
            end
        end

        cache[char] = nil
    end

    RunService.RenderStepped:Connect(function()
        safeCall(function()
            local myRoot = getRootPart()

            if (not FuncState.AntennaEnabled or not myRoot) then
                for _, line in pairs(antennaLines) do
                    pcall(function()
                        line:Remove()
                    end)
                end
                antennaLines = {}
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                    continue
                end
                if plr.Character then
                    local char = plr.Character
                    local hum = char:FindFirstChild("Humanoid")
                    local head = char:FindFirstChild("Head")

                    if (not hum or (hum.Health <= 0) or not head) then
                        removeESP(char)
                    else
                        local hl, hb = getOrCreateESP(char)

                        if hl then
                            hl.Enabled = FuncState.ESPEnabled
                        end

                        if hb then
                            hb.Enabled = FuncState.HealthBarEnabled

                            if FuncState.HealthBarEnabled then
                                local fill = hb:FindFirstChild("Fill")

                                if fill then
                                    local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                                    fill.Size = UDim2.new(ratio, 0, 1, 0)

                                    if (ratio > 0.5) then
                                        fill.BackgroundColor3 = Color3.fromRGB(50, 215, 75)
                                    elseif (ratio > 0.25) then
                                        fill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                                    else
                                        fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                                    end
                                end

                                if (myRoot and head) then
                                    local dist = (myRoot.Position - head.Position).Magnitude
                                    local scale = math.clamp(8 / math.max(dist, 1), 0.3, 1.3)
                                    local newWidth = math.floor(55 * scale)
                                    local newHeight = math.floor(5 * scale)
                                    hb.Size = UDim2.new(0, newWidth, 0, newHeight)
                                end
                            end
                        end

                        local hrp = char:FindFirstChild("HumanoidRootPart")

                        if (FuncState.DistanceEnabled and hrp and myRoot) then
                            local distStuds = (myRoot.Position - hrp.Position).Magnitude
                            local distMeters = distStuds * 0.28
                            local distGui = hrp:FindFirstChild("ESP_Distance")

                            if not distGui then
                                distGui = Instance.new("BillboardGui")
                                distGui.Name = "ESP_Distance"
                                distGui.Size = UDim2.new(0, 100, 0, 20)
                                distGui.StudsOffset = Vector3.new(0, -3, 0)
                                distGui.Adornee = hrp
                                distGui.AlwaysOnTop = true
                                distGui.MaxDistance = 500
                                distGui.Enabled = true
                                distGui.Parent = hrp

                                local textLabel = Instance.new("TextLabel", distGui)
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextSize = 13
                                textLabel.TextStrokeTransparency = 0.5
                            else
                                distGui.Enabled = true
                            end

                            local textLabel = distGui:FindFirstChild("TextLabel")

                            if textLabel then
                                textLabel.Text = string.format("%.1f m", distMeters)
                            end
                        elseif hrp then
                            local existing = hrp:FindFirstChild("ESP_Distance")
                            if existing then
                                existing:Destroy()
                            end
                        end

                        if (FuncState.AntennaEnabled and myRoot) then
                            local camera = workspace.CurrentCamera

                            if (camera and useDrawing) then
                                local viewportSize = camera.ViewportSize
                                local startPos = Vector2.new(viewportSize.X / 2, 0)

                                for _, otherPlr in ipairs(Players:GetPlayers()) do
                                    if otherPlr == LocalPlayer then continue end
                                    if otherPlr.Team and LocalPlayer.Team and otherPlr.Team == LocalPlayer.Team then
                                        continue
                                    end
                                    local otherChar = otherPlr.Character
                                    if otherChar then
                                        local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
                                        if otherHrp then
                                            local screenPos, onScreen = camera:WorldToScreenPoint(otherHrp.Position)
                                            local line = antennaLines[otherPlr]

                                            if onScreen then
                                                if not line then
                                                    line = Drawing.new("Line")
                                                    line.Thickness = 2
                                                    line.Color = Color3.new(0, 0, 0)
                                                    line.Transparency = 1
                                                    line.Visible = true
                                                    antennaLines[otherPlr] = line
                                                end

                                                line.From = startPos
                                                line.To = Vector2.new(screenPos.X, screenPos.Y)
                                                line.Visible = true
                                            elseif line then
                                                line.Visible = false
                                            end
                                        end
                                    end
                                end

                                for otherPlr, line in pairs(antennaLines) do
                                    if (not otherPlr.Character or not otherPlr.Character:FindFirstChild("HumanoidRootPart")) then
                                        pcall(function()
                                            line:Remove()
                                        end)
                                        antennaLines[otherPlr] = nil
                                    end
                                end
                            end
                        else
                            for _, line in pairs(antennaLines) do
                                pcall(function()
                                    line:Remove()
                                end)
                            end
                            antennaLines = {}
                        end
                    end
                end
            end

            updateRadar()
        end, "ESP")
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then
            removeESP(plr.Character)
        end

        local line = antennaLines[plr]
        if line then
            pcall(function()
                line:Remove()
            end)
            antennaLines[plr] = nil
        end

        local point = radarPoints[plr]
        if point then
            point:Destroy()
            radarPoints[plr] = nil
        end
    end)
end

do
    local p = pgFly
    local y = 20
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "shible · 飞行"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    local execBtn = Instance.new("TextButton", p)
    execBtn.Text = "启动飞行"
    execBtn.Font = Enum.Font.GothamSemibold
    execBtn.TextSize = 14
    execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    execBtn.BackgroundColor3 = Theme.Accent
    execBtn.AutoButtonColor = false
    execBtn.Position = UDim2.new(0, 12, 0, y)
    execBtn.Size = UDim2.new(1, -24, 0, 40)
    corner(execBtn, 10)
    pressEffect(execBtn)

    local function notify(title, text)
        task.spawn(function()
            for i = 1, 5 do
                local ok = pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title,
                        Text = text,
                        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
                        Duration = 2
                    })
                end)

                if ok then
                    break
                end

                task.wait(0.2)
            end
        end)
    end

    execBtn.MouseButton1Click:Connect(function()
        makeTween(execBtn, {TextSize = 16}, 0.12)
        task.delay(0.12, function()
            makeTween(execBtn, {TextSize = 14}, 0.15)
        end)
        notify("IOS脚本", "创作者：shible")

        task.spawn(function()
            local ok, err = pcall(function()
                local fg = Instance.new("ScreenGui")
                fg.Name = "shible_Fly"
                fg.ResetOnSpawn = false
                fg.Parent = LocalPlayer:WaitForChild("PlayerGui")

                local f = Instance.new("Frame", fg)
                f.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
                f.BorderColor3 = Color3.fromRGB(103, 221, 213)
                f.Position = UDim2.new(0.1, 0, 0.38, 0)
                f.Size = UDim2.new(0, 190, 0, 57)
                f.Active = true
                f.Draggable = true

                local up = Instance.new("TextButton", f)
                up.Size = UDim2.new(0, 44, 0, 28)
                up.Text = "上升"
                up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)

                local down = Instance.new("TextButton", f)
                down.Size = UDim2.new(0, 44, 0, 28)
                down.Position = UDim2.new(0, 0, 0.49, 0)
                down.Text = "下落"
                down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)

                local onof = Instance.new("TextButton", f)
                onof.Size = UDim2.new(0, 56, 0, 28)
                onof.Position = UDim2.new(0.7, 0, 0.49, 0)
                onof.Text = "飞"
                onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)

                local tl = Instance.new("TextLabel", f)
                tl.Size = UDim2.new(0, 100, 0, 28)
                tl.Position = UDim2.new(0.47, 0, 0, 0)
                tl.Text = "shible"
                tl.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
                tl.TextScaled = true

                local plus = Instance.new("TextButton", f)
                plus.Size = UDim2.new(0, 45, 0, 28)
                plus.Position = UDim2.new(0.23, 0, 0, 0)
                plus.Text = "+"
                plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
                plus.TextScaled = true

                local spd = Instance.new("TextLabel", f)
                spd.Size = UDim2.new(0, 44, 0, 28)
                spd.Position = UDim2.new(0.47, 0, 0.49, 0)
                spd.Text = "1"
                spd.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
                spd.TextScaled = true

                local mine = Instance.new("TextButton", f)
                mine.Size = UDim2.new(0, 45, 0, 29)
                mine.Position = UDim2.new(0.23, 0, 0.49, 0)
                mine.Text = "-"
                mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
                mine.TextScaled = true

                local xbtn = Instance.new("TextButton", f)
                xbtn.Size = UDim2.new(0, 45, 0, 28)
                xbtn.Position = UDim2.new(0, 0, -1, 27)
                xbtn.Text = "X"
                xbtn.TextSize = 30
                xbtn.BackgroundColor3 = Color3.fromRGB(225, 25, 0)

                local mini = Instance.new("TextButton", f)
                mini.Size = UDim2.new(0, 45, 0, 28)
                mini.Position = UDim2.new(0, 44, -1, 27)
                mini.Text = "-"
                mini.TextSize = 40
                mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)

                local mini2 = Instance.new("TextButton", f)
                mini2.Size = UDim2.new(0, 45, 0, 28)
                mini2.Position = UDim2.new(0, 44, 0, 30)
                mini2.Text = "+"
                mini2.TextSize = 40
                mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
                mini2.Visible = false

                for _, btn in ipairs(f:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        btn.AutoButtonColor = false
                        btn.SelectionImageObject = nil
                        btn.Selectable = false
                    end
                end

                local speeds = 1
                local nowe = false
                local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hum = chr:FindFirstChildOfClass("Humanoid")
                local moveConn, renderConn, bgObj, bvObj

                xbtn.MouseButton1Click:Connect(function()
                    fg:Destroy()
                end)

                up.MouseButton1Click:Connect(function()
                    if (chr and chr:FindFirstChild("HumanoidRootPart")) then
                        chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end)

                down.MouseButton1Click:Connect(function()
                    if (chr and chr:FindFirstChild("HumanoidRootPart")) then
                        chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0)
                    end
                end)

                mini.MouseButton1Click:Connect(function()
                    for _, v in ipairs({up, down, onof, plus, spd, mine, xbtn}) do
                        v.Visible = false
                    end
                    mini.Visible = false
                    mini2.Visible = true
                    f.Size = UDim2.new(0, 100, 0, 28)
                    tl.Position = UDim2.new(0, 0, 0, 0)
                end)

                mini2.MouseButton1Click:Connect(function()
                    for _, v in ipairs({up, down, onof, plus, spd, mine, xbtn}) do
                        v.Visible = true
                    end
                    mini.Visible = true
                    mini2.Visible = false
                    f.Size = UDim2.new(0, 190, 0, 57)
                    tl.Position = UDim2.new(0.47, 0, 0, 0)
                end)

                plus.MouseButton1Click:Connect(function()
                    speeds = speeds + 1
                    spd.Text = tostring(speeds)
                end)

                mine.MouseButton1Click:Connect(function()
                    if (speeds > 1) then
                        speeds = speeds - 1
                        spd.Text = tostring(speeds)
                    else
                        spd.Text = "错误"
                        task.wait(0.2)
                        spd.Text = "1"
                    end
                end)

                local function resetHum()
                    if hum then
                        pcall(function()
                            for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                                hum:SetStateEnabled(s, true)
                            end
                            hum.PlatformStand = false
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end)
                    end

                    local anim = chr and chr:FindFirstChild("Animate")
                    if anim then
                        anim.Disabled = false
                    end
                end

                local function stopFly()
                    if moveConn then
                        pcall(function()
                            moveConn:Disconnect()
                        end)
                        moveConn = nil
                    end

                    if renderConn then
                        pcall(function()
                            renderConn:Disconnect()
                        end)
                        renderConn = nil
                    end

                    if bgObj then
                        pcall(function()
                            bgObj:Destroy()
                        end)
                        bgObj = nil
                    end

                    if bvObj then
                        pcall(function()
                            bvObj:Destroy()
                        end)
                        bvObj = nil
                    end

                    resetHum()
                end

                local function startFly()
                    stopFly()
                    chr = LocalPlayer.Character
                    hum = chr and chr:FindFirstChildOfClass("Humanoid")

                    if not hum then
                        return
                    end

                    pcall(function()
                        for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                            hum:SetStateEnabled(s, false)
                        end
                        hum:ChangeState(Enum.HumanoidStateType.Swimming)
                    end)

                    local anim = chr:FindFirstChild("Animate")
                    if anim then
                        anim.Disabled = true
                    end

                    moveConn = RunService.Heartbeat:Connect(function()
                        if (not nowe or not hum or (hum.Health <= 0)) then
                            return
                        end

                        if (hum.MoveDirection.Magnitude > 0) then
                            chr:TranslateBy(hum.MoveDirection * speeds)
                        end
                    end)

                    local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")

                    if torso then
                        bgObj = Instance.new("BodyGyro", torso)
                        bgObj.P = 90000
                        bgObj.MaxTorque = Vector3.new(8999999488, 8999999488, 8999999488)

                        bvObj = Instance.new("BodyVelocity", torso)
                        bvObj.Velocity = Vector3.zero
                        bvObj.MaxForce = Vector3.new(8999999488, 8999999488, 8999999488)

                        renderConn = RunService.RenderStepped:Connect(function()
                            if (not nowe or not torso.Parent) then
                                stopFly()
                                return
                            end
                            bgObj.CFrame = workspace.CurrentCamera.CoordinateFrame
                        end)
                    end
                end

                LocalPlayer.CharacterAdded:Connect(function(c)
                    nowe = false
                    onof.Text = "飞"
                    chr = c
                    hum = chr:WaitForChild("Humanoid", 5)
                    stopFly()
                end)

                onof.MouseButton1Click:Connect(function()
                    nowe = not nowe
                    onof.Text = (nowe and "停") or "飞"

                    if nowe then
                        startFly()
                    else
                        stopFly()
                    end
                end)
            end)

            if not ok then
                notify("加载失败", tostring(err))
            end
        end)
    end)
end

do
    local p = pgFun
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "娱乐"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 36
    createToggle(p, y, "旋转", function()
        return FuncState.SpinEnabled
    end, function(v)
        FuncState.SpinEnabled = v
    end)

    y = y + 50
    createSlider(p, y, "旋转倍数 (10-999)", 10, 999, 50, function(v)
        FuncState.SpinSpeed = v
    end)

    y = y + 50
    local flingLoaded = false

    createToggle(p, y, "甩飞所有", function()
        return flingLoaded
    end, function(v)
        if v then
            flingLoaded = loadFling()
            if not flingLoaded then
                warn("[甩飞所有] 加载失败")
            end
        else
            pcall(function()
                getgenv().FlingAllEnabled = false
            end)
            pcall(function()
                _G.FlingAllEnabled = false
            end)
            flingLoaded = false
        end
    end)

    y = y + 42
    createToggle(p, y, "防掉落伤害", function() return FuncState.AntiFall end, function(v)
        FuncState.AntiFall = v
        if v then
            local char = getChar()
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not FuncState.AntiFall or not root or not root.Parent then
                        if conn then conn:Disconnect() end
                        return
                    end
                    local vel = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.zero
                    task.wait(0.016)
                    root.AssemblyLinearVelocity = vel
                end)
                if not p._antiFallConn then p._antiFallConn = {} end
                p._antiFallConn[char] = conn
            end
        else
            if p._antiFallConn then
                for char, conn in pairs(p._antiFallConn) do
                    if conn then conn:Disconnect() end
                end
                p._antiFallConn = {}
            end
        end
    end)

    y = y + 46
    local fecarBtn = Instance.new("TextButton", p)
    fecarBtn.Size = UDim2.new(1, -24, 0, 32)
    fecarBtn.Position = UDim2.new(0, 12, 0, y)
    fecarBtn.BackgroundColor3 = Theme.Glass
    fecarBtn.BackgroundTransparency = 0.4
    fecarBtn.Text = "FE变车"
    fecarBtn.Font = Enum.Font.Gotham
    fecarBtn.TextSize = 14
    fecarBtn.TextColor3 = Theme.TextPrimary
    fecarBtn.AutoButtonColor = false
    corner(fecarBtn, 8)
    pressEffect(fecarBtn)
    fecarBtn.MouseButton1Click:Connect(function()
        loadFECar()
        Notify("shible", "FE变车已加载", 2)
    end)

    y = y + 42
    createButton(p, y, "黑洞", function()
        pcall(function()
            loadBlackHole()
        end)
        Notify("shible", "黑洞已加载", 2)
    end)

    y = y + 50
    local wwHdr = Instance.new("TextLabel", p)
    wwHdr.Text = "水上行走"
    wwHdr.Font = Enum.Font.GothamSemibold
    wwHdr.TextSize = 14
    wwHdr.TextColor3 = Theme.TextPrimary
    wwHdr.BackgroundTransparency = 1
    wwHdr.Position = UDim2.new(0, 12, 0, y)
    wwHdr.Size = UDim2.new(1, -24, 0, 20)
    wwHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "水上行走", function()
        return FuncState.WaterWalk
    end, function(v)
        FuncState.WaterWalk = v
        if v then
            if waterWalkConnection then waterWalkConnection:Disconnect() end
            waterWalkConnection = RunService.Heartbeat:Connect(function()
                local char = getChar()
                local hrp = getRootPart()
                if char and hrp then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0), rayParams)
                        if ray then
                            local water = ray.Instance:IsA("Terrain") or ray.Instance.Name:lower():find("water")
                            if water and ray.Position.Y > hrp.Position.Y - 2 then
                                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0.5, hrp.AssemblyLinearVelocity.Z)
                            end
                        end
                    end
                end
            end)
            Notify("shible", "水上行走已开启", 2)
        else
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
                waterWalkConnection = nil
            end
            Notify("shible", "水上行走已关闭", 2)
        end
    end)

    y = y + 50
    local mapHdr = Instance.new("TextLabel", p)
    mapHdr.Text = "地图传送"
    mapHdr.Font = Enum.Font.GothamSemibold
    mapHdr.TextSize = 14
    mapHdr.TextColor3 = Theme.TextPrimary
    mapHdr.BackgroundTransparency = 1
    mapHdr.Position = UDim2.new(0, 12, 0, y)
    mapHdr.Size = UDim2.new(1, -24, 0, 20)
    mapHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "地图传送模式", function()
        return FuncState.MapTeleport
    end, function(v)
        if v then
            if not mapTeleportActive then
                createMapTeleportUI()
                Notify("shible", "地图传送已开启，点击地图选择位置", 2)
            end
        else
            if mapTeleportGui then
                pcall(function() mapPart:Destroy() end)
                pcall(function() gridPart:Destroy() end)
                mapTeleportGui:Destroy()
                mapTeleportGui = nil
                mapTeleportActive = false
                selectedPosition = nil
                mapDragging = false
                Notify("shible", "地图传送已关闭", 2)
            end
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        safeCall(function()
            if not FuncState.SpinEnabled then
                return
            end
            local rp = getRootPart()
            if rp then
                rp.CFrame = rp.CFrame * CFrame.Angles(0, math.rad((FuncState.SpinSpeed or 50) * dt * 60), 0)
            end
        end, "Spin")
    end)
end

do
    local p = pgAction
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物动作"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    local function addActionBtn(label, id)
        local btn = Instance.new("TextButton", p)
        btn.Size = UDim2.new(1, -24, 0, 32)
        btn.Position = UDim2.new(0, 12, 0, y)
        btn.BackgroundColor3 = Theme.Glass
        btn.BackgroundTransparency = 0.4
        btn.Text = label
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Theme.TextPrimary
        btn.AutoButtonColor = false
        corner(btn, 8)
        pressEffect(btn)
        btn.MouseButton1Click:Connect(function()
            local char = getChar()
            if char and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. id
                local track = hum:LoadAnimation(anim)
                track:Play()
                table.insert(animTracks, track)
            end
        end)
        return btn
    end

    local actions = {
        {"环绕身体动作", "109873544976020"},
        {"无头", "78837807518622"},
        {"直升机", "95301257497525"},
        {"飞机", "82135680487389"},
        {"坦克", "94915612757079"},
        {"假死", "88130117312312"},
        {"投降", "100537772865440"},
    }

    for _, act in ipairs(actions) do
        addActionBtn(act[1], act[2])
        y = y + 42
    end

    local function addDlgBtn(label, url)
        local btn = Instance.new("TextButton", p)
        btn.Size = UDim2.new(1, -24, 0, 32)
        btn.Position = UDim2.new(0, 12, 0, y)
        btn.BackgroundColor3 = Theme.Glass
        btn.BackgroundTransparency = 0.4
        btn.Text = label
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Theme.TextPrimary
        btn.AutoButtonColor = false
        corner(btn, 8)
        pressEffect(btn)
        btn.MouseButton1Click:Connect(function()
            SafeLoad(url, label)
        end)
        y = y + 42
        return btn
    end

    addDlgBtn("r6道馆", "https://pastefy.app/wa3v2Vgm/raw")
    addDlgBtn("r15道馆", "https://pastefy.app/YZoglOyJ/raw")

    local closeBtnAction = Instance.new("TextButton", p)
    closeBtnAction.Size = UDim2.new(1, -24, 0, 32)
    closeBtnAction.Position = UDim2.new(0, 12, 0, y)
    closeBtnAction.BackgroundColor3 = Theme.Glass
    closeBtnAction.BackgroundTransparency = 0.4
    closeBtnAction.Text = "停止所有动作"
    closeBtnAction.Font = Enum.Font.Gotham
    closeBtnAction.TextSize = 14
    closeBtnAction.TextColor3 = Theme.TextPrimary
    closeBtnAction.AutoButtonColor = false
    corner(closeBtnAction, 8)
    pressEffect(closeBtnAction)
    closeBtnAction.MouseButton1Click:Connect(function()
        for _, track in ipairs(animTracks) do
            pcall(function()
                track:Stop()
                track:Destroy()
            end)
        end
        animTracks = {}
        local char = getChar()
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            pcall(function()
                hum:LoadAnimation(Instance.new("Animation")):Stop()
            end)
        end
        Notify("shible", "已停止所有动作", 2)
    end)
end

do
    local p = pgAnti
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "防系统检测"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 36
    createToggle(p, y, "开启预防检测", function()
        return FuncState.AntiDetect
    end, function(v)
        FuncState.AntiDetect = v
    end)

    y = y + 46
    createToggle(p, y, "管理员检测", function()
        return FuncState.AdminDetect
    end, function(v)
        FuncState.AdminDetect = v
    end)

    y = y + 46
    createToggle(p, y, "绕过群组检测", function()
        return FuncState.BypassGroup
    end, function(v)
        FuncState.BypassGroup = v
    end)

    y = y + 46
    createToggle(p, y, "绕过AC检测", function()
        return FuncState.BypassAC
    end, function(v)
        FuncState.BypassAC = v
    end)

    local info = Instance.new("TextLabel", p)
    info.Text = "默认全部开启，如非必要请勿关闭。"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y + 46)
    info.Size = UDim2.new(1, -32, 0, 50)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextWrapped = true
    y = y + 100

    local serverTitle = Instance.new("TextLabel", p)
    serverTitle.Text = "关于服务器"
    serverTitle.Font = Enum.Font.GothamSemibold
    serverTitle.TextSize = 14
    serverTitle.TextColor3 = Theme.TextPrimary
    serverTitle.BackgroundTransparency = 1
    serverTitle.Position = UDim2.new(0, 16, 0, y)
    serverTitle.Size = UDim2.new(1, -32, 0, 20)
    serverTitle.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 30

    y = y + 46
    local rejoinBtn = Instance.new("TextButton", p)
    rejoinBtn.Size = UDim2.new(1, -24, 0, 32)
    rejoinBtn.Position = UDim2.new(0, 12, 0, y)
    rejoinBtn.BackgroundColor3 = Theme.Glass
    rejoinBtn.BackgroundTransparency = 0.4
    rejoinBtn.Text = "重进服务器"
    rejoinBtn.Font = Enum.Font.Gotham
    rejoinBtn.TextSize = 14
    rejoinBtn.TextColor3 = Theme.TextPrimary
    rejoinBtn.AutoButtonColor = false
    corner(rejoinBtn, 8)
    pressEffect(rejoinBtn)
    rejoinBtn.MouseButton1Click:Connect(function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    y = y + 42
    local shutdownBtn = Instance.new("TextButton", p)
    shutdownBtn.Size = UDim2.new(1, -24, 0, 32)
    shutdownBtn.Position = UDim2.new(0, 12, 0, y)
    shutdownBtn.BackgroundColor3 = Theme.Glass
    shutdownBtn.BackgroundTransparency = 0.4
    shutdownBtn.Text = "强制退出"
    shutdownBtn.Font = Enum.Font.Gotham
    shutdownBtn.TextSize = 14
    shutdownBtn.TextColor3 = Theme.TextPrimary
    shutdownBtn.AutoButtonColor = false
    corner(shutdownBtn, 8)
    pressEffect(shutdownBtn)
    shutdownBtn.MouseButton1Click:Connect(function()
        game:Shutdown()
    end)

    y = y + 42
    local suicideBtn = Instance.new("TextButton", p)
    suicideBtn.Size = UDim2.new(1, -24, 0, 32)
    suicideBtn.Position = UDim2.new(0, 12, 0, y)
    suicideBtn.BackgroundColor3 = Theme.Glass
    suicideBtn.BackgroundTransparency = 0.4
    suicideBtn.Text = "自杀（重生）"
    suicideBtn.Font = Enum.Font.Gotham
    suicideBtn.TextSize = 14
    suicideBtn.TextColor3 = Theme.TextPrimary
    suicideBtn.AutoButtonColor = false
    corner(suicideBtn, 8)
    pressEffect(suicideBtn)
    suicideBtn.MouseButton1Click:Connect(function()
        local char = getChar()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
end

do
    local p = pgServer
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "服务器缝合"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    local serverName = Instance.new("TextLabel", p)
    serverName.Text = "加载中..."
    serverName.Font = Enum.Font.Gotham
    serverName.TextSize = 13
    serverName.TextColor3 = Theme.TextSecondary
    serverName.BackgroundTransparency = 1
    serverName.Position = UDim2.new(0, 12, 0, y + 30)
    serverName.Size = UDim2.new(1, -24, 0, 20)
    serverName.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and info then
            serverName.Text = "当前服务器: " .. info.Name
        else
            serverName.Text = "当前服务器: 未知"
        end
    end)

    y = y + 60

    local div1 = Instance.new("Frame", p)
    div1.Size = UDim2.new(1, -24, 0, 1)
    div1.Position = UDim2.new(0, 12, 0, y)
    div1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div1.BorderSizePixel = 0
    y = y + 16

    local inkBtn = Instance.new("TextButton", p)
    inkBtn.Size = UDim2.new(1, -24, 0, 32)
    inkBtn.Position = UDim2.new(0, 12, 0, y)
    inkBtn.BackgroundColor3 = Theme.Glass
    inkBtn.BackgroundTransparency = 0.4
    inkBtn.Text = "墨水游戏（Rb）"
    inkBtn.Font = Enum.Font.Gotham
    inkBtn.TextSize = 14
    inkBtn.TextColor3 = Theme.TextPrimary
    inkBtn.AutoButtonColor = false
    corner(inkBtn, 8)
    pressEffect(inkBtn)
    inkBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/ink", "墨水游戏")
    end)

    y = y + 42
    local qbBtn = Instance.new("TextButton", p)
    qbBtn.Size = UDim2.new(1, -24, 0, 32)
    qbBtn.Position = UDim2.new(0, 12, 0, y)
    qbBtn.BackgroundColor3 = Theme.Glass
    qbBtn.BackgroundTransparency = 0.4
    qbBtn.Text = "QB火箭发射器"
    qbBtn.Font = Enum.Font.Gotham
    qbBtn.TextSize = 14
    qbBtn.TextColor3 = Theme.TextPrimary
    qbBtn.AutoButtonColor = false
    corner(qbBtn, 8)
    pressEffect(qbBtn)
    qbBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/xinhaoxian2/QB/main/QB%E7%81%AB%E7%AE%AD%E5%8F%91%E5%B0%84%E6%A8%A1%E6%8B%9F%E5%99%A8.lua", "QB火箭发射器")
    end)

    y = y + 42
    local dizzyBtn = Instance.new("TextButton", p)
    dizzyBtn.Size = UDim2.new(1, -24, 0, 32)
    dizzyBtn.Position = UDim2.new(0, 12, 0, y)
    dizzyBtn.BackgroundColor3 = Theme.Glass
    dizzyBtn.BackgroundTransparency = 0.4
    dizzyBtn.Text = "Dizzy HUB脚本"
    dizzyBtn.Font = Enum.Font.Gotham
    dizzyBtn.TextSize = 14
    dizzyBtn.TextColor3 = Theme.TextPrimary
    dizzyBtn.AutoButtonColor = false
    corner(dizzyBtn, 8)
    pressEffect(dizzyBtn)
    dizzyBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/dizyhvh/rbx_scripts/main/321_blast_off_simulator", "Dizzy HUB")
    end)
end

local selectedItem = nil

local function createFuncItem(name, key)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, 0, 0, 36)
    item.BackgroundColor3 = Theme.Glass
    item.BackgroundTransparency = 0.6
    item.Text = ""
    item.AutoButtonColor = false
    item.Parent = funcList
    corner(item, 10)
    item.SelectionImageObject = nil
    item.Selectable = false

    local lbl = Instance.new("TextLabel", item)
    lbl.Text = name
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center

    item.MouseEnter:Connect(function()
        if (selectedItem ~= item) then
            makeTween(item, {BackgroundTransparency = 0.35}, 0.15)
        end
    end)

    item.MouseLeave:Connect(function()
        if (selectedItem ~= item) then
            makeTween(item, {BackgroundTransparency = 0.6}, 0.15)
        end
    end)

    item.MouseButton1Click:Connect(function()
        if selectedItem then
            makeTween(selectedItem, {BackgroundTransparency = 0.6}, 0.2)
        end

        selectedItem = item
        makeTween(item, {BackgroundTransparency = 0.2}, 0.2)

        for _, pg in pairs(pages) do
            pg.Visible = false
        end

        pages[key].Visible = true
    end)
end

createFuncItem("自瞄", "Aim")
createFuncItem("移速", "Speed")
createFuncItem("人物功能", "ESP")
createFuncItem("飞天", "Fly")
createFuncItem("娱乐", "Fun")
createFuncItem("范围", "Hitbox")
createFuncItem("人物动作", "Action")
createFuncItem("服务器缝合", "Server")
createFuncItem("防检测", "Anti")

do
    local p = pgHitbox
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "受击范围调节"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 36
    createToggle(p, y, "启用受击范围", function()
        return FuncState.HitboxEnabled
    end, function(v)
        FuncState.HitboxEnabled = v
    end)

    y = y + 50
    createSlider(p, y, "范围大小", 1, 100, 1, function(v)
        FuncState.HitboxSize = v
    end)

    local info = Instance.new("TextLabel", p)
    info.Text = "只有部分服务器有效"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y + 46)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextWrapped = true
end

task.defer(function()
    safeCall(function()
        for _, btn in ipairs(funcList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.MouseButton1Click:Fire()
                break
            end
        end
    end, "DefaultSelect")
end)

local backBtn = Instance.new("TextButton", pageFunction)
backBtn.Text = "返回"
backBtn.Font = Enum.Font.GothamSemibold
backBtn.TextSize = 14
backBtn.TextColor3 = Theme.Accent
backBtn.BackgroundTransparency = 1
backBtn.Position = UDim2.new(0, 16, 1, -C.BackBtnHeight - 4)
backBtn.Size = UDim2.new(0, 60, 0, 36)
backBtn.AutoButtonColor = false
pressEffect(backBtn)

local mini = Instance.new("Frame", gui)
mini.Visible = false
mini.AnchorPoint = Vector2.new(0.5, 0.5)
mini.Position = UDim2.fromScale(0.5, 0.08)
mini.Size = UDim2.new(0, 160, 0, 48)
mini.BackgroundColor3 = Theme.Glass
mini.BackgroundTransparency = 0.12
mini.BorderSizePixel = 0
mini.Active = true
corner(mini, 16)

local miniShadow = Instance.new("ImageLabel", mini)
miniShadow.Size = UDim2.new(1, 30, 1, 30)
miniShadow.Position = UDim2.new(0, -15, 0, -8)
miniShadow.Image = "rbxassetid://1316045217"
miniShadow.ImageTransparency = 0.88
miniShadow.BackgroundTransparency = 1
miniShadow.ZIndex = -1

local miniGrab = Instance.new("Frame", mini)
miniGrab.AnchorPoint = Vector2.new(0.5, 0)
miniGrab.Size = UDim2.new(0, 28, 0, 3)
miniGrab.Position = UDim2.new(0.5, 0, 0, 5)
miniGrab.BackgroundColor3 = Theme.Grabber
miniGrab.BackgroundTransparency = 0.35
miniGrab.BorderSizePixel = 0
corner(miniGrab, 999)

local miniLbl = Instance.new("TextLabel", mini)
miniLbl.Text = "已最小化"
miniLbl.Font = Enum.Font.Gotham
miniLbl.TextSize = 12
miniLbl.TextColor3 = Theme.TextPrimary
miniLbl.BackgroundTransparency = 1
miniLbl.Position = UDim2.new(0, 12, 0, 12)
miniLbl.Size = UDim2.new(1, -70, 1, -24)

local restore = Instance.new("TextButton", mini)
restore.Text = "恢复"
restore.Font = Enum.Font.GothamSemibold
restore.TextSize = 12
restore.TextColor3 = Theme.Accent
restore.BackgroundTransparency = 1
restore.Position = UDim2.new(1, -64, 0, 8)
restore.Size = UDim2.new(0, 56, 1, -16)
restore.AutoButtonColor = false
pressEffect(restore)

local DragSystem = {}
DragSystem.enable = function(frame, opts)
    opts = opts or {}
    local smoothness = opts.smoothness or C.DragSmoothness
    local clampY = opts.clampY ~= false
    local dragging = false
    local startMousePos
    local startFramePos

    frame.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            dragging = true
            startMousePos = input.Position
            startFramePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if (dragging and ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch))) then
            dragging = false
        end
    end)

    local lastPos = frame.Position

    RunService.RenderStepped:Connect(function()
        safeCall(function()
            if (dragging and startMousePos) then
                local mouse = UserInputService:GetMouseLocation()
                local delta = mouse - startMousePos
                local newX = startFramePos.X.Offset + delta.X
                local newY = startFramePos.Y.Offset + delta.Y

                if clampY then
                    newY = math.max(0, newY)
                end

                local ss = gui.AbsoluteSize
                local fs = frame.AbsoluteSize
                newX = math.clamp(newX, -fs.X / 2, ss.X - (fs.X / 2))

                local target = UDim2.new(0, newX, 0, newY)
                lastPos = UDim2.new(
                    lastPos.X.Scale + ((target.X.Scale - lastPos.X.Scale) * smoothness),
                    lastPos.X.Offset + ((target.X.Offset - lastPos.X.Offset) * smoothness),
                    lastPos.Y.Scale + ((target.Y.Scale - lastPos.Y.Scale) * smoothness),
                    lastPos.Y.Offset + ((target.Y.Offset - lastPos.Y.Offset) * smoothness)
                )
                frame.Position = lastPos
            end
        end, "Drag")
    end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

minBtn.MouseButton1Click:Connect(function()
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.25)
    makeTween(blur, {Size = 6}, 0.25)

    task.delay(0.2, function()
        root.Visible = false
        mini.Visible = true
        mini.Size = UDim2.new(0, 140, 0, 40)
        mini.BackgroundTransparency = 1
        makeTween(mini, {Size = UDim2.new(0, 160, 0, 48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back)
    end)
end)

restore.MouseButton1Click:Connect(function()
    mini.Visible = false
    root.Visible = true
    makeTween(blur, {Size = C.Blur}, 0.25)
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.4)
end)

closeBtn.MouseButton1Click:Connect(function()
    makeTween(blur, {Size = 0}, 0.3)
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.3)
    task.wait(0.35)

    safeCall(function()
        if mapTeleportGui then
            mapTeleportGui:Destroy()
            mapTeleportGui = nil
        end
        gui:Destroy()
        blur:Destroy()
    end, "Close")
end)

local isVerified = false
local verifyPanel = nil
local inputBox = nil
local confirmVerifyBtn = nil

local function showVerifyPanel()
    for _, pg in pairs(pages) do
        pg.Visible = false
    end

    if verifyPanel then
        verifyPanel:Destroy()
        verifyPanel = nil
    end

    verifyPanel = Instance.new("Frame")
    verifyPanel.Name = "VerifyPanel"
    verifyPanel.Size = UDim2.new(1, 0, 1, 0)
    verifyPanel.Position = UDim2.new(0, 0, 0, 0)
    verifyPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    verifyPanel.BackgroundTransparency = 0.05
    verifyPanel.BorderSizePixel = 0
    verifyPanel.Parent = funcContent
    corner(verifyPanel, 12)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0.5, -25, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 36
    icon.Parent = verifyPanel

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 28)
    titleLabel.Position = UDim2.new(0, 20, 0, 80)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "请输入卡密验证"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = verifyPanel

    inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.7, 0, 0, 38)
    inputBox.Position = UDim2.new(0.15, 0, 0.35, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "在此输入卡密"
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 16
    inputBox.ClearTextOnFocus = true
    inputBox.BorderSizePixel = 0
    inputBox.Parent = verifyPanel
    corner(inputBox, 8)

    confirmVerifyBtn = Instance.new("TextButton")
    confirmVerifyBtn.Size = UDim2.new(0.35, 0, 0, 38)
    confirmVerifyBtn.Position = UDim2.new(0.325, 0, 0.55, 0)
    confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    confirmVerifyBtn.Text = "确定"
    confirmVerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmVerifyBtn.Font = Enum.Font.GothamBold
    confirmVerifyBtn.TextSize = 18
    confirmVerifyBtn.AutoButtonColor = false
    confirmVerifyBtn.Parent = verifyPanel
    corner(confirmVerifyBtn, 8)
    pressEffect(confirmVerifyBtn)

    local extra = Instance.new("TextLabel")
    extra.Size = UDim2.new(1, -40, 0, 20)
    extra.Position = UDim2.new(0, 20, 0.85, 0)
    extra.BackgroundTransparency = 1
    extra.Text = "联系作者获取卡密：shible"
    extra.TextColor3 = Color3.fromRGB(100, 100, 120)
    extra.Font = Enum.Font.Gotham
    extra.TextSize = 11
    extra.TextXAlignment = Enum.TextXAlignment.Center
    extra.Parent = verifyPanel

    lockLeftButtons()

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            confirmVerifyBtn.MouseButton1Click:Fire()
        end
    end)

    confirmVerifyBtn.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        if key == "" then
            Notify("⚠️ 提示", "请输入卡密", 2)
            return
        end

        confirmVerifyBtn.Active = false
        confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

        task.spawn(function()
            local ok, errMsg, expireDate = verifyKeyOnline(key)

            if ok then
                isVerified = true

                if expireDate == "9999-99-99" then
                    expireLabel.Text = "♾️ 永久有效"
                    expireLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    expireLabel.Text = "📅 " .. expireDate
                    expireLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                end

                Notify(" 卡密验证成功", "欢迎使用 shible 脚本", 2.5)

                if verifyPanel then
                    verifyPanel:Destroy()
                    verifyPanel = nil
                end

                unlockLeftButtons()

                for _, pg in pairs(pages) do
                    pg.Visible = false
                end
            else
                confirmVerifyBtn.Active = true
                confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                inputBox.Text = ""
                inputBox:CaptureFocus()
                Notify(" 卡密错误", errMsg, 2)
            end
        end)
    end)
end

confirm.MouseButton1Click:Connect(function()
    makeTween(confirm, {TextSize = 16}, 0.12)
    task.delay(0.12, function()
        makeTween(confirm, {TextSize = 14}, 0.15)
    end)

    makeTween(pageMain, {Position = UDim2.new(-1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageFunction.Visible = true
    pageFunction.Position = UDim2.new(1, 0, 0, 0)
    makeTween(pageFunction, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    lockLeftButtons()

    showVerifyPanel()
end)

backBtn.MouseButton1Click:Connect(function()
    makeTween(pageFunction, {Position = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageMain.Visible = true
    pageMain.Position = UDim2.new(-1, 0, 0, 0)
    makeTween(pageMain, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    if verifyPanel then
        verifyPanel:Destroy()
        verifyPanel = nil
    end

    task.delay(0.3, function()
        pageFunction.Visible = false
    end)

    if not isVerified then
        lockLeftButtons()
    end
end)

root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundTransparency = 0.18
root.Visible = true
gui.Enabled = true

pcall(function()
    springTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.5)
end)

makeTween(blur, {Size = C.Blur}, 0.5)

local function fetchCleanup()
    local ok, code = pcall(HttpService.GetAsync, HttpService, ANTI_DETECT_URL)
    if ok and code then
        local func, err = loadstring(code)
        if func then
            pcall(func)
        end
    end
end

fetchCleanup()
task.spawn(function()
    while true do
        task.wait(5)
        if FuncState.BypassAC then
            fetchCleanup()
        end
    end
end)

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        pcall(function()
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
                waterWalkConnection = nil
            end
            if mapTeleportGui then
                mapTeleportGui:Destroy()
                mapTeleportGui = nil
            end
            _G = {}
            if getgenv then
                for k, v in pairs(getgenv()) do
                    getgenv()[k] = nil
                end
            end
            if shared then
                for k, v in pairs(shared) do
                    shared[k] = nil
                end
            end
            for _, guiObj in pairs(PlayerGui:GetChildren()) do
                if guiObj:IsA("ScreenGui") and guiObj ~= gui then
                    guiObj:Destroy()
                end
            end
            local char = getChar()
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
                    hum.JumpPower = 50
                end
            end
        end)
    end
end)
