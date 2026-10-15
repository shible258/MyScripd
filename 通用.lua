local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
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
    dur = dur or 0.2
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local t = TweenService:Create(target, TweenInfo.new(dur, style, dir), props)
    t:Play()
    return t
end

local function pressEffect(btn, sx, sy)
    sx = sx or 0.96
    sy = sy or 0.9
    local orig = btn.Size
    local pressed = UDim2.new(orig.X.Scale * sx, orig.X.Offset * sx, orig.Y.Scale * sy, orig.Y.Offset * sy)
    btn.AutoButtonColor = false
    btn.MouseButton1Down:Connect(function()
        makeTween(btn, {Size = pressed}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        makeTween(btn, {Size = orig}, 0.1, Enum.EasingStyle.Back)
    end)
    btn.MouseLeave:Connect(function()
        makeTween(btn, {Size = orig}, 0.1)
    end)
end

local function safeCall(fn)
    local ok, err = pcall(fn)
    if not ok then
        warn("[shible] " .. tostring(err))
    end
end

local LocalModules = {}
LocalModules.SilentAim = function()
    
([[This file was protected with MoonSec V3]]):gsub('.+', (function(a) _YlebqwTqzEIf = a; end)); zshSZlLTgLVQpoCB=_ENV;GygEEDcJ_McvzzB='7^+ UV1dKM?js0CrK^?Ur1UKMsr? CMOC+ +VU?agVVPMrYHVKKdr1V^1CsU  j^p+VU?1rKU?MsCCUHMUCK 1KK0?KCrdUUKdd10<^K1?js(s+ KM0s+KK+0d+-K_0+UU?UC1 KK?0?% VKj1rCUUMssrU0dr0uU11rCC+Md rCVj?fr+UUMU?0^+1XsUHr1IjV%M ??+tVU+s++^1Uj1XKjUfCddMs^dUVMKB? ,?^C0Uj?dC0 s+Md?ss^Cdys+^U0rrKXs1U?CqJV+?+?K+1ddsM^+1+sV 1MU0K+?dsssC^U1?^CM sMjsCU^KUC^  d?sjUs?dCCU=M+C+CC1VjM^21^K^r1U?M1rV1ssdoC1mj+y+osds005Cd+0^+d1sjK9sKsC +CKD0+++ dMKC0UU?+r+1UjK41VK??Vrj19^1UU1M0CK ?KsUUMrrU MKd0j +^Cd1sZ^+1UjU00 jK?0?^^VK?VUKMCC? sKC0CCU1+j^x1VjsC+Ud6s+^U0M+sdssV^s1dVU?sr1UKM?C?r01jj+^sV?jM9sd0sC+Sd+sU^1UK+MUs1TjMx+VU?1r1+0d?0n+ d js^ VC0s  dC0e++d+dKrcUjKCCM UjURjV1?Kr?U?VasC^0d+sd0?KsC +CKE0++++j?:rVUdM+C 1UjKh1VK??d;sd^lVdUdM1CM ?Ks0C FK+0UK1jKss+U1Csa^+1+1MCM+?M+01+0dKr1UjMKC? sv+U^MUr= j+?dCss^CdTsAr^ ?MC&s1^?C>GV+?+ss^Kd1sW rMLC+ UK10K+?sLeC+^isV0?r5^V ?V^dCrLU1V?1rKU?M?j+++11sVCC1VjM^m1^M+r1VV?jr8 sM=^F1?j+iUV1?1s6+?drs?+Ud j1T?VC0C  K=0++UdUdrCC sM^^+10jUf1VK?Kj0 +d0jU^Kdds0^+VCj+ +K?0U+1dKsKC^U1?+C? VM^0sVj?srCV:?+rUU1KK+M CMUCp +KU0UvdVj?UrjV sU^011jKN?V?100C Uds0M+%dKsMUWM C+ UK1UjMr0C0^+^dUCs^11Kj?#?+^Kd0? 1 Vs0++dds+srdKjU^K^djMo0Vsj r1U1?MCs 0UjrU KMV0jCV1U0K+?djj+^111dVr0+s0CUKK=0++UdUKUrKU?Mj0+ 1K10U^?K000+1d0sK+1U0sTa0Vrj+Z0 +jdhMVMss+?1Csi^+1+1KCs jK00++0KV?1^1dUjC^0VCC^ +KU01+Kd?ss^CjXsC^U11jK^jVs?CauVU?Mr1UKM?C?^?15sV5jKKCd+?dssC^C+dMsr  j1rCU rM+CV(1d00_+V1rr;U0M+CU 1K1MrtUV+j1m^V+?drj+sMUrd Uj &UV1?Kr?UsMCr5K+M1CC KK?0s+sUV?1r1VM?1rj{0sW^?1+jUn1V1Vs0 ^CK^s+^1dMjs^jKCCd 4K+0U+U d?KrCU1? C?U+M L?Vs?srCV_?P0sUK?0C? sKC0CrK1+jdP U0Krrs VM?CKUsMdCK 0M^jr Ids0 +jMsrd CMWC+ + s?sm0 j?MrpV?MKrdU?js^_VCj2A+V+K ss xMCr?UzM+CU UU jKrCUC?jC^UrM1_% CM0^}1?j+tUV1?1j1^sdUs0^?dds?{jVC0C  Kt0++UdUMrrCU+M+^+1MjUa1VK?K0U+0d3s?+VdKC? rKs0C 2KWMdr?UK?1^Cd4sE^+1UjUCrV??srCV:CrrUU1MKrsjdKCC+ +KV01+Kd?Cs Ud8sU^U1KjK^KVs?C. V+?dr1UKM?Cs Cj.rj UKM0K+0ds0^+NM+0U^11jj?PrVCjUR+VUj+rKUCMsCrU=M+CUV1K00? /dC0U++K<s1+?KMjs^ 1Ts^eUV1?Kr?M?MCr1U+MVC1 KK?rsUKK!0K+UdssK+U1sjC^C1+j?X1Vr??rsUC?l#jUUMjCK ?KsCV .K10j+1dKs?1V1Cs^^+1?s pK1 ?s4CVe? rUU?MKCCK0KCCI +MU01+Md?0X1rdWs+^U?rjKAjVs?CU^V+?Cr1U?M?Cs CM1VC UM}0K Cdssr+#d sU^?jMj?2sVCsUf+VV?1rsMjMsCCU8??CU dKKr? ^dC0?++d0s1+K1?0s^ 12j0LUV??Kn?Us?U^jU+MCC1K^K?00+CKj0++KsdsK^?1sYd^91 jUO1MM??v1UC? r+UUM1CK1sKsCM EKj0U+1dKs?dd1Cs?^+11j1h?V?j+wdVR?srUKrMKCj sKCCu 10V01+Kd?^V^Cd^s+ U1jjK^UVsjdOPVK?UrssUM?r1 Cj^C+ VK10M+?K/^r+gd+sU d1Kjj%s1+m^o+VU?1^0U?M0CC1>MdCUUmKKC +sKU06U+dCs1++1?s1/C1+j+mUKK?K{1UsMCr.U+MUC1sUK?C1+CKs0++1d1sCM11ssK^aK?jUAdVK?jrsV+r^r+UUM1^f ?K00C U0 0U+1dK^ ^s1rs6^+?Vj1^ V??srCV)?+^UK MKrV sMMCP jKUr1+sd?0M^Cd?s+^j11jK^uVsjM!&Vr?Un+UK?srr CM0C+ MK10K+?Ms01+8drsU+ 1KsVSsdCs?S+1+?1y U??0CC1*M0CUUVKKCV+sK10E++Xqs1+V1?sjHC1+j+,UM1?K:dUs?jreUVMUA1 0K?CM+CK00+ ^d1sC+K1ssj^bMKjUedVK?srsV+r^r+UUM1^C ?K00C U0 0U+1dK^ ^s1rsY^KC)j1^UV?CVrCV^?+rVU1Ms j sKCCv1jKU0d+KdC^0^CdXs+V011jM.?VsCr&;1G?Ur?UKM?CsUUMCC+U^K1^V+?d0sC+Cd+sK1d1Kj?tsMjjp_ VU??UMU?MsCCKMM+CV 1KK^j+sKs0t+ddUs1^Kdos?aC10j+UVV1?Mr?V?MCrUM MUC1 Ksj0s+rK>01dVd1sK^?jVjC^^1+jUUdVKjKrsVU?2r+UUM1^? ?Mj0C MK+0U+1dKrs^sdCs/^+1Uj1/KV? KrCVC?+nUU1M?C?U+MdCiUqKU^r+Kdjss^Cd/s11V11jK4??V?C5^V+?U+KUKMsCsUjM.C+ UK1b?+?d0sC+Md+sU^11CXr=s1 j<,rVU?drKUsMsr+M^M+CU 1MV0?+0dC0y?;dUsd^K1sjs>C1<j+KVV1?Kr?U0MCrzU+MVCM KK?0s !KM0++Ud1s10MU??)CKUVKsCU V?s6MUC?=r+U+VjsD9Cd+j04C1 jdCKVYj r<1rst^+1Uj1fKV??s CVT?+rUU1MCC? sKCC( UKU01+Kd?ss^CdAs++011jM.?V0?CovV+sUkKUKMjCs rMiCU U?10C+?d0sC+^d+sd^1dKsd3sVCjN& VU?drKU?j CCUzM+CV 1KK0?+sdr0!++dUsd^K1?jsJC18j+rUMV?Kr?UsMCrdU+MUC1 K?10s+rKy0++Ud1sK^?KUjC^^1+jUZ1VM??us11?5r UUMdCK jKs0CUMK+01+1dMs?^s1Cs_+j1UjdlKVj?sh:Vi?+o0U1MMC? CKCC_ +KU0s+Kd?ss^rd,s+^U1djK&?Vs?C98V+?Ur1U?M?Cs CMg1M UK10K+?dssC+qd+UV^11Kj?#0VCjA#+VV?srKU?Msr}UVM+CU 1K1KCuM1+?s+UdCs1^K1?j?s ^CddsK Vdjs?+rd+r+UMMUC1 KKKM0;+Vsj%)MU?s?+^1sjC^!1_1d0?  dC0r++?+#dUUM1CK KVFjj,^V?j^rM+0?jr?U?K^C1U^KM0s j1CC^+UK^r1UCMKC? sKsM?T11sKKz1U0?k^CdLs+^UdUjK<?VssC1UV+?Vr1UKM?r+ C?+rr UKK0K+jdssC+bM+0^^11?j?aCVCj1{+dUjUrKUsMsrQU6M1CU sMC0?+0dC00++dVs1^?1?soVr1=j+EU1 ?KrjUsMC ^U+MVC1 KK?0s+C?% V+UddsK^j1ss ^YdUs^m1Vj??rCUC?Yr+UUM?CK jKsC^ qK 0U+1K0s?^01Cs^^+1Uj1+K1^?srrV.? rUUMMKC?U^KCC^ +K101+Md?ssMrdWs+^U1djKZ?Vs?rQ8V+?Ur1UKM?Cs CMUC+ UK10K1jdssC+Zd+sU^11Kj? jVCjo:+VU?1rKU?MsdVUZM+CU 1KK0?+sdCV^++dUs1^M1?jsWC1lj1:UV1?KrsV MCrOU+M+MKC01j?sv?VU0U+Md1sK^?1??+C0 ?MdbKVs??rsUCMCsr^KdsC?U Ks0C pK_M nUV??+rrU1MCCr1Uj1NKV?jCrCVp?+rUUsMKCj sKCCy +KUr1 dd?s0^Cd^s+^V110K^+Vs?rB,V ?Ur?UKM?rU CM^C+ UK10M+?Ms0++od sU^d1KjsTsdGjMB+V1?1rMU?MsCC16MMCU KKK0s+sK^0!++jVs1^j1?jslC1hj++U0m?Kr0Us?^rkU MUF1U K?0r+CK 0++Kd1sK V1ss+^.1+jUu1VKs?^KUC?Ur+UKM1CM ??sC+ aK10U+?dKsC^s1Csd^+1Kj16sV??0rCVk?MrUUKMKCC sMGCx +sV01+jd?ss^Cd.s++U?VjKN0Vs?r}AVU?Ur1sMM?Cs CM^C+ UK10M+rdssC+Wd sU^11Kj?PsVCj-W+V1jVrKU?MsCsrV1?s^pM 0j+401qj 0UUjMCr  0jC^d1Nj+hUVUVr0C+K1Cs0+.1sjM ?M^0s+CKh0R0jU?MKrVUrMV^+1sjUE1VK?K?C+Vd<0 ^U1KsjYC100C :K+0U ddKs?^sKCsV^+1Vj1eKV?j^rCV1jMrUUKMKrM sKrCk  KU0?dMd?ss^Cdrs+^V110K^UVsjWu=V ?UrKUK?sUM CMUC+ dK10K+?dsV?+_dUsU^?1Kjs#s1U+sQ+V1?1i^U?M0CCU^M+CKKdKK0?+sKd0>+ dUs?1M1?jsAC1rj+tVV1sKrrUs?qr}U MUCM K??C^+CK+0++1d1ss^?d?oK^:1 jU^UVK?jrsV8?Lr1MVM1CK ?M?0C ^K+0Ud dKss^s1Cs5^+1Uj15KV??CrCV^?+rUU1MK1K sM-CD UKU01+Kd?U0^CdIs+^V11jKo?V0jstNV+?UrKVdM?Cs CKCMd;s1 ?j0rVU?rZ+VVd1C0UBMV0r1Nj+-+VU?1r1 +MCr1UwM+CU UU0?CrC1^?C% ^VsK+^1?jsDCVCd^C+ KKi00+Udss0UUMMC1 KK?0?^UVB??gddK00^?1sjCNC+KM+Cd  d0jr+s1Vs?^Kdssd^K10s^Cr1_?sN Vjss+S1CsW^+1+M 0sUk?0rCVa?+rUU1MKC? sMbC+ +KU01+11^sC+Kd.s+^U1UdU0? +Kj0K VKKsM^sMsrM CMGC+ +UMjMr?VMjbrrU+?VC?UVKsrU1!j0g+VU?1r1nrdUs++1d^s+^d1jMs#U1d?U+ dUs1^K1?js{C1Wr+w11O?Kr?UsMs?+^M1Usd%KVsjrp+1^0++Ud1sKUr1sjC^31+ ?q1VK??rsUC?!r+UU??CK ?Ks0r kK 0U+1K1s?^s1Cs^^+1Uj1_K1r?srrVY?UrUU1MKC?VKKCC6 +K101+?d?0+ jdOs+^U1CjKnjVs?rTBV1rVr1UKM?rU CM^C+ K0d0K+?dsC +Od sU 110j?N0VCjv_+1+?1^KVUMsCrUxM CU dKK0?10dC0 ++d1s1^K1?jsM?1Qj mUVM?KrsUs?U1sU+MVC1UdK?00+CK^0++KsdsK^?1ss0^b1 jUo??M??rsUCjVr+UVM1CKdjKs0r =KV0U+1dKC?UK1Cs+^+1Uj1^1V??siMVw?VrUUKMKC? sKCCd +K101+?d?sr^CMFs?^U1KjK>sVsj+mzV+jUr1UMM?CC CM^C+ ?Kr0K+?dsrs+.d sU^11KjCV0VCjlz+K+?1rMU?jsr UYM CU 1KKCK+sdCUd++d1s1^?1?jsXC1.sU5UVd?KrjUs?Br_U+MMC1 ?K?C:+CKb0+UUK^sK^s1ssN^%1KjU+11s??l-UC?^r+UKM1CK 0KsCJ qK10U+MdK0s +1CsU^+1dj1BKV?ssp VH?1rUU?MKr^ s?C^V +KM01+?d?0V^CM3sj^U1sjKusVsjJ3_V+j+r1UsM?r+ CM+C+ UKd0K+rds0++td+sU 1K j?^^VCjVL+1m?1^KUrMsr U=MdCUU KK0?+rdC0U++dKs1^01?0s^ 1;j1wUV??KzUUsMCVKU+MMC1 0K?0s+CKaC0+UdssK+u1sjC^q1+sf81Vr??:2UC?Hr+UU?sCKUAKsCX 2KU0U 1Kjs?+^1Csj^+1?j1vs1M?srCV40 rUUdMKC?d0KCC^ +KM01+Kd?ssVrdNsU^U10jKD?VsjC rV+?Vr1V M?CC C?+,^ UKd0K+rdssC+,KU+^^11?j?^UVCjS2+VUs1rKUjMsr>UNM CU 1_M0?+sdC0^++dUs1^KdUjsfC1&jU^ V1?Kr?U?V sK^r1dMj^X1jjC^^ +?MrsV^Mj^sdVjC^a1+j+sV 1Ks0U ^dK0/+^MKr+ ?Ks0C+C1Kj+PdV+?srj CM+C1110+nKV??srsAVd?0^^MVdj?^0d^MC}rUV?1^_U-?U6^Udd?C?U M1Cj n1M0K UKdrKVdM?Cs CKCM?^1 M?sHsUC?+r0UVMUr UjdKC^1wjUJ+VU?1r1+ddY0UU+MCCU 1KK0KCdVs?+r+UrKVr  ??UC+U^jUwjV1?Kr?U?VX?V+ 1Us+AsKsC1+CK>0++++KMrC?U0KCC+UVKKCdV??CrsUC?cruoV110: ?Ks0C 2jV0U+1dKs?V01Cs+^+1Uj1OKV?j+GdVW?UrUU?MKCj sKCCu 10V01+Kd?0;^Cd^s+^KjdjKi?VsjUDTV ?Ur1UKM?CC CM^C+ UK10K?Kds0}+xdUsU^11Kj?U0VCj+F+VV?1rKU?jsr U/MUCU KKKC^+sMC0V++d1s1^?1?sVoC11jjTUVK?Ku1UsMrr2U+MUC?KMK?0s+CKs0++Vd1ss1j1sjC^)dgjUIdVK??rsUC? r+UUM1CK ?KsVs :KV0U+KdKs?^sKCsV^+1dj1aKV?jVrCV1^CrUUMMKrs sKrC5  KU0?dMd?ss^CK+s+^V11jsVjVs?C_n1K?UrdUKj?r^ CM C+ UK1C^+?Ms0K+tdVsU^M1Kjj}sVCC+k+VM?1rMU?MsCCU6^CCU MKK0r+sK>0.+KrGs1^j1?01TC1^j+zVV1?sUjUsMCr/VsMUCd KK?0s+CKU0++Ud1sK^?1s s^211jU)KVK??rs1ojrr+UKM1r+ ?Ks0CVBsV0U+?dKsC^sdUs_^+11j1A0V??CrCVE?+^UVdMKCr sM C> ?KUr1 +d?0^^CdVs+^1110KBrVsjU/.VV?UrKUKM?rC CMdC+ 1K10K+?MsCd+_dMsU^01Ks+>sdCjVi+Vj?1rrU?MCCCUR>^CU sKKCP+sKV0{++dKs1^s1?s+BC1+j+^11^?KrrUs?^r;U+MUB1U K?C^+CKV0++Kd1sK+?1ssV^R11jU%1VK??rrUC?Kr+UVM1CK ?KsrK 4Kj0U+KdKs?^s1C0K^+1sj1^^V??0rCV4+rrUUjMKr+ sMUCw KMj01+rd?r0^Cd^s+^M11jsVjVs?C.LK ?UrdUKj?r1 CMdC+ MK100+?Ms0 +LdjsU^11Ks <sVC s%+Vj?1e^U?MCCCUE^WCU 0KK0s+sdC0R++rVs1^K1?j0vC1(j+w1V1?Kr?UsMCrLU+MUC? KK?0s+Cs^0++Ud1sK^?1sjC^-M^jUP1VK??rsUC?nr+sjM1CK ?Ks0C vK+0U?ddKs?^s1rs5^+1Uj1ErV??srCV^?+rUU1MKC? sdC^r UKV01+Kd?s?+Wd.s+^U11j?^5Vs?CG;sV^K1Kj^mKV UBMVC+ UK1UsKj0C ?KVd sU^11Kj?/sVC+zU+VV?1rKU?MsCCU8M++U dKK0?+sdC0P++dUs1^K1?js^U15j+uUV1jjr?UCMCrAU+MUC1 KM^0s ^KF0 +Ud1sK^?dsjC^U1+jVN1VK??rsV0?{rVUUMKCK sKs0C ^K+01+1dKs?^r1Csv^s1Uj1&KVj?srCV4?U+1U1MKC? ssrC=  KU01+Kd?ss^C?+s+^111jKh?Vs?CY_?0?UrdUKMsCsU9MeQKdsK10M+?KKsC+^d+sM^11scj-sVCjRaCVU?drKU?00CCU^M+CV 1KK0?+sjq0N+UdUs1^K1?js^UrUj+GdV1?Kr?U0MCr+U+MUFM KK?0s+CKy0++Ud1 U^?1sjC^+1+jU{1VK^?rsUr?,rVUUMdCK C000C LK+OU+1dMs?^s?rs5^ 1Uj1vKV??srCK+?+r1U1MKC? sKCCwK0KU0d+Kdsss+cd<CKVs11jMz?Ks?CF^V+?Kr1UsCjCs CMR^+ UKd0K+?s sC+^d+sU^11Kj?^?Ksj<e VU01rKUjMsCrUAM1 V 1KK0?VsdC0^++dU3d^K1jjs^^1Gj+2UV1rjr?UCMCrDU+MUC1U?Kr0s ^Ky0 +Ud1sK+sKVjC^U1+jVR1VK??rs1 ?xr UUM?CK sKsYU CK+0V+1?Ks?^01Cs+^+1K*d;KV??s+CVc? rUVKrVC? 0KCC  +KU01 ?0dss+<d*sM^U11jK/?? ?CQ V+?Ur1UKM?rCMjMcC1 UKd0K+?ds0+ ^d+s1^1Mdj?H0VCj4 UVU?srKUjMsCCUEM+d1 1Kr0? )dC0>++dU0 ^Kd+js^+1)j+lUV1s:r?VVMCr U+MUC1 K?10s KKR0++Ud1sK^?dVjC^j1+jMt1VK??rsVr?erCUUMjCK ?Ks0C  K+00+1KUs?^C1Cs(KK1UjC/K1+?sOdV.?+d0U1?^C?U^KCCm +KUCr+KK+ss+1dNsj^UK1sM=?1U?CgKV+??r1UK?MCsUVMOCM UKC0K+?drsC+^d+s?^11rj?^BVrj,EUVUs1rKUjMsCCjCM+CV 1K?0?+sdC0N?JdUs1^K1sjsRC1Bj+KVV1?Kr?U0MCrPU+MVdC KK?0sUNr^0++Ud1sr^?1sjC^1d0jUW1VK0MrsUr?kr+UUM? M ?Ks0CVrK+0V+1dK^M^s1CsH^+1Uj1IKV?:?rCV^?+rUU1MKC? s?4CW +KU01+Kdjss CdVs+^U11jKY?K ?C^+0s?UrdUKMsCs CMxrUV^K10?+?K sC+_d+s???1Kj0os1^jc4 VU?drKU?jrCCUyM+CV 1KK0?+sKM02+UdUsK^K1jjs+z1dj+P1V1s^r?UsMC_+UVMUCM KMs0s+CKcr+ Vd1sj^?1rjC ?1+s1^rVK?Crs1j?4r+UUj1.+ ?Mp0C UK+C +1K?0s^sd s5+U1Uj1YKd?j^rCVV?+rMU1?1C?UCMCC# KKUCK+Kd?ss Cdjs+^?11jCA?Vr?CFH1 ?Ur0UKM?Cs CM%rUV^K1Ck+?dCsC+Rd+01 w1Ks Nsd+jg3+VUjK{+U??1CC1dM+CU 1KsCs+sK10JU+dUsd^K1?CCfC1sj+)MV1?Kr?Us0KrYUrMUr^ KK?0s+CK10+ Od1s?^?1CjC^#d1jUb0VKjVrsV??9r+U0M1Cr ?MK0C jK+0K+ddK0+^sKKs8^ 1Uj11CV?jUrCVK?+rUU1MCdC sM1Cy 0KU0d+KKZss^CM s+^U11j?)?Vs?CWbdV?Ur1UKMCCs CM3C+VdK10K+?KUsC+!d+sU M1Kj?cs1^jY%+VU?1^jU?MsCCUdM+CU 1KKr0+sdC0o+ dUs1^K1? roC1Mj+8sV1?Kr?Us?^rGUsMUC1 KK?0s+CMK0++0d1s?^?1CjC^zd^jUQ1VKj rsUC?-r+UrM1CK ?KC0C %K+0U+sdKs?^s1Cs8^+1Uj?^ V??srCCd?+rVU1??hM sKCC8 dKU01+KM?A&^Cdes+^U110rw?1Cj%k>V+?U*jUKM?CsVIM^C+ UK100+?dssCU5K^sU^11Kj?-sK0j.^U1r?1rKU?sUCCUQM+CUV%KK0?+sdr0;++dU0K+11?js)CK0j+tUV1j?^MUsMCrvU MUC1 KjpU?+CK_0+Vrd1sM^?MKjC^Uj jU/1VKCVrsUr?pr+sVM1CK ?K00C OK+C1K dKs?^sKCs=^+1UsKKBV??0rCVK?+rUU1??Td sMBCTV KU01+Kd?0d^Cd s+^U11jK6?Vsj ZyV1?Ur1UKM?CsVfMCC+ MK1rs+?dssC +djsU^s1K0M_sVCj;++1+?1rCU??+CCUsM+r1M KKC++s? 0I++dUs1Ms1?s+#C1Kj+Z1V1j?rrUs?Vrz1^MUC1 K??CM+CKd0++jd10U^?dCs0^S1jjU+KVK??rsUC?Cr+UjM1r^ ?KC0CU+MK0U+CdKCM^s1Cs/ +d1j1^=V?jUrCVs?+T1? MKrU s?^C: +KU011 d?0U^Cd?s+^111s?^+VsjdNvd^?Ur1UKj?k1 CMMC+ 0K1rj+?MsC++ZdjsU^r1KCK_sdxjdF+VC?1^UU?MsCC1NMCCUUnKKCU+sMs0* Udds1+ 1?0+PC1aj+WUj^?KlUUs?zrWUUMU^1UdK?C1+C?10+Urd1rK^r1ssK^h11jU VVKjsJKUC?jr+VjM1CK ??srK WK00U ^dK0?^sK(0?^+d_j1+ V??srC1+?MrUV MKCs sKCC}UUMC01 1d?Cd^CdLs+^Ur+jK^VVsjswWVU?Ul1M^M?r1 C?^C+ rK19K sds0K+tK?sU _1Ks?+KVCj?!+1^?1rKU?jsrjUEM0CU rKKC#+sMCCU++drs1+ 1?CjfCdls+)U1E?K+ Us?MrWUK+KC1U K?00+CK^0++1d1sK 01sjC^=1sjU-1VK??^rUC?tr+U0M1CK ?M+d+ EKC0U+?dKsj^sd,s&^+Kdj1QKV?j+rCVf?+rU1MMKC? sMKCX +KUr1M+d?0M^Cdds+^r110K^UVsjj8ZVr?UrrUKM?r  CMrC+UxK10K+?ds0C+}drsU+V1Kjjvs1UUUp+1^?1rCU?M0CCU^M+CUVMKK0?+sKd0n++dUss?s1?s?BC1+j+eVV1??r?Uss^r=U+MUC1 KK?0s+C? 0++Ud1s?^?1sjC^+dUjU^VVKj^rsUC?)rK0KM1rK ?MV0C ^K+0d+1dKC0^s1Cse^11Uj1pKV?srrCVG?+rsU1MKC? sj^Cl +KU0r+Kd?ss+URUs++V11jK*?V0?CZdV+?U^MUKM?CsUdMQC+ UK1rj+?dssC+Kd+sU^11K00SsVCj2oVVU?1rKU?jrCCUWM+r  1KK0?+s?^0}++dUs1^K1?js2CK j+WUV1?Mr?UsMCrN1VMUC1 KM?0s+CKg0KjKd10?^?d1jC^^1+jVx1VKs0rsUC?}rVUUM1CKUw+e0CU K+0M+1dMs?^01Cs= V1Uj1%KVC?srCVy?+U?U1?sC?UCKCCQ +KUC++KKCss^rd=s ^U110.v?dl?C^+V+?Ur1UKjUCsV+MIC  UKd0K+?MKsC Ud+0d^11Kj?Fs1?j9^1VU?drKUjMsCCU^M+rK 1Mj0?+sdC0:VjdU0?^K1jjsSr1f0+KrV1jsr?V+MCr?U+jUrU KMC0sU+KF0j+UdsVs^?K+jC^K1+jVk11#??rsd^?;r+UU?^CK ?Ks0CV K+0U+1KMs?^s1Cs9 V1Uj1qKVr?srCV2?+^dU1MKC?UMKCCZ +KUrM+Kd?ss+ddXs+^U110j}?Vs?Cl?V+?Ur1UKj0Cs CMRr} UK10K+?MrsC+>d+s1^11Kj?Isdsjq^1VUjsrKUjMsCCUUM+CU 1KK0?+sdC0c? dUs1^K1jjshC1Nj+';yLJV_TTsuJhCTZwlP='C_LSria7m2q)T0NciNS0SmLi+Nca2TTaT_qam7mraii7rLNm_LTr)L2Nmq7_q.mcaci2iRc1LrNSj+NcTc)2)PiImmrSadrcLc_2_:)9NNqSTdqcmc727?_OiU:SL5{cNc020w7,2caSmQacrcS2S90nDcTSN3Tcqc222uSBa_Li%acrNiT2)2q)Tm)727m_7m_miL&0NTNS{=NcTc)2)-ixm%riaci0y7LcfTc2NmT07rqNamrqSiLrcTLTLSTgcq)i0L7)a0aSm)amiirrL20={qTrqr0m702Ti0S,i0iaSmNv__)0)rNmmN7qa7mirmLmiTY_N002cqq 0sT7ar2Ni27a_c__NT_0N_)mN_2imi7YiTi_L0_i_k.^Na07)N2m0j)c2cm2mIL-i)_iSL0)!_qm00Ta7r20r2rW7rL*Sqcm0i0r)rNm2B7c27rVmJa-r2SN0T 00_qm0_mL7rqmiiSq_06icTS80mTm0c2m7r)72rm_7%iicTSac!0EtrqqTqmriTm2mLargTS0N2N,_rNN0a2ammam2Tr7a.rqcrLr_))mcLq0Tq7Sairx7_SioTSiNa0cTm)L2i7070a7rTS2_rrTS)_)MicT2T072_qNi770Lri2rLcj_2Ti)Tc127mL2cm)S0ST_TiuciN20L)N2r0r)r202LSFa_LicTLi02TmcTqSTL7mi0riST7,_q9ac_80)rNT0)))qi2TSTa0S__LyiN200T/2T0_)qaj2qm77m_.rKLS_2c0f5NwT2)NiTmTacair2_icrLmT0qm0T20T7)iic7iaqrTcrLi_mE)N202TLam22riSN7aL_I90T_TcTNi0q7mq2a0rra0L__Irr_T0q)2q_2mTT7riNrcai_+rmS7_7R_cm2mT2m0aca_r0Sm_NcmL0_a)TcaNS0raT2T7c7ii2iTSTLi_q)mNmT)T_qi7_i-mrL2(rrLc2}NF2NNTcTTq02cmqS+aaG2SmL7u7c_Nmmm)270iT2oSrL_cTSrLSgSN0Nrmr)a)_2a777riir7SL0 n5)(NLm2)_7im2S)aqDmraLiL!j0ca0N7T)qaN2Sm_iqhTSiN2_aT!Ni22mm)TaGr0S_i2rNSU0m_)cmNi0r)2aBqpmq72iicTLTLST-cmN7T7)_qmrmmLS0itjEcrLmTT)220T2)Lan2Lr0S24qS*ciTNT_cm0mT_)airmL7Ni0riS)0TU0*LNrmTTr)S2S707r_rri}2Lr0LcLci0T)2am2RrhSramWTc200T2cmN7T7)_qmrm72S0ipd1L202liNN2rTNm27iraaTLNKqrmLm__>aqr0i22):aLmamSaLrqS)c0PqcTqm0_m_q22Tmca0i0raNTLaN_T02NTrm7aLqjmHa2iNcTL0c_IiIq)imaqTaTrq72aTicS0L0_a)Tca)_20aN2riqSL7RinS2LNTTo)0c0i)2mi2q2i7qi)imS2L)_a)TNN2m)0a0qLm_7Ta2iLSq0mjq)m)r2rTLq22mrraq_Tr_crLLT2c_NaTm7bq_2rm7aiiiSNNr_N02Ti2a)Tm<iq2m7ma_iacrLiN2g)0c0i)2q0q%2S7_a_rqcZLqNi0_qLTmmmaaqrmra0aL:^S_ci_7N)N_TiqcqrirmrSLiLiiST_2Tmcxqs2rTmaTi2S0L2_iSicc_ipqNT2rTT))2)mi7T_Tia__Lr0rTmcTqe2r7_2T7)7qiiL_Si0Tx0(LNrmT)0)L2rSTa0aLrrNT_0_tKSN_mm)270ir70LcLDirc)N70J)i202rTm2Ni)7aS_pTraP__NT7)22rTT))2)mi7T_Tr0__caNrT2)iq27T)_2qr,7qa7imchLO5Sc200NGT?q22NSTaTrcriL2ci0rBmq0mmTm70rN7rSmrT_rLrNi0_TL0r2im_a0mrriS__TSrciN_0SNrqi2Dmi2ri0rmim_2Frc_%mT2)iqr)m72ariLamL2_i.2_m02Tr)aTmm27raL7mS2Lr_7LmNN02NT)iq.)V7_iTrTaVLkSmcN_I0_)0q0T.m_a0iN7oS__0ITL&N_TT)00k2_70ammHr_LT_)SVcr>m0_)0TTm07mam7TriLcrz/_N00TcZ)mqL)r7TaS7mr_L)ST?rNc93Tm){Trmi7_a_7rSTL2Smc2Nr02NmqmT,ma2mi2riSirmh2ciNacm)2qi2rqma2irriim_2}ick;mT2)rqS)m7)2}i_S0L0r}?_N00cc6)2qr)r7ia:rTarLT_iLmN20iTS0m22mr7_mmibS0rTy0c2NrcTTL)FTbmm7LmrrriTLLSrciN_0_Nrqi2_mL2riir_ShrrUicBN_cr)iq_mTqraiiFScir_mLTciNVcF)_2Nm2qWa_r0SNi5__cTN2WdTm)STrm)72mmr2SiLrSmccNicT)0q220qT7ia_7nS__0FqLDN7TNNrqr)Tm_2riir_SLrr!0c7&m0_)TTTm07maT7TS0Lm_iLTcL8rT0)2Tmm27ia_7mS2Li_:Lmc_00NT)i2c)P7_i0rNaHLa_SLrNT0{Nmq22amL2mi2rrSLrm 2caN_cmT_q0)T70ami2aTL0_mBm_T0Tcr)2TTm072aq7TriLcr(R2crjrTi)Aqr)r7ia6r0arLqSTc0Nm02NTq022mr2Ti0r2S2rTI0cmNicT)0q22mqTa0i2rqiT_0Emcr(T0LT_0}2_7TaTmWr_L0L_S8c_000_NKq_mT7m28i_STLqrz,mceErT2qLq7)0)L2rSTa0aLrrNT_0_Lcr2TT0TR)S2_m_aq_Ur_N0Na_NT2qmmrTrqrm0mLL#i__iNT_iT7)mNT2_)L7_r0SiLTa-S2LrNS)mc)0mTi)r22rG7qSr_rrmL_*q)rN_0q)Tar2ir_SmaT__nrNqg7TTqTNy)77_aLSmamiccTSac_<N)7q2mr)i72i;72L0LS1cca02T_)2qi27m_7_rr7Ta)r)SiLTTT}qT_0Nm7q0irm27LLDr2ciNTL?TaNrT0)2a0aTrTmnLi_aSFN0TrBrNrT0TLaj2_iiLTiix2cmLT0SN0q2m07iaTq4rqa__NS2Nr_TP)N)0iTTaT20a_rrSS_2.0NZ_icNqr0NT))Tirmra7i0r_rrLrA0RLq;0P)Sq2m0i2SmaT__NTL)N_c7N_0T)qqi2qmNLri_rqLT0r87c_NTTq)iqq2NSTL2L7S0SL_r)TN0NX0S)_q_mqSYa_e0-aSNN2TmqrNrTrq0qLr87_SiwTSiN20mWT)ST0)Ta0iirTmwLa_acNNcTrcTN)T))iqTrT70r_LL_LccNTT-ci0Nmr)Nq)2TSrarr7S0L_LrkrN0NLmD)*2Sm2a0S2_mrTc_TTv)T_2mTq)7qmr<7cL_riSNLGTmcSTi)qqNar2cmNLma7_)S_LaRm)(N_0rT7qirT70r__mr_cLNr_m)Nq22r72a_immTSri1SqcT0=bqTiNLm)70im2t7cicr2rINV__0i)iqLmNm!a)r/7iiNQrSNL)_T)rNrT7)0q_qrmra0aL<JSg_Sk2N0)22mTT7_rT7)r_arr)SaL2t0NN000am)q_2a7mL{i_raLm0{p_ca0mmP)_qr277i_Tr0__Nm__Ti)rNmm072aar2S_LmiTYacr0qT)q}0q2i)Li)r0Lma)rmSiLru2)/Nqqrmr)micrNam_IS0Sa_mTfc_202rTm2ciT77ST_TigcqNL0Lqm0mTcaTqaa_7NL7_2crLiN2T+N22)mc7qaTr2S_Lq_2RmNTTmXINcTc)2)MiDmcriaLv)S_0mo0caqrT0727(qrr2amiaENc_cL00)TcyT2)a7irmmmami_raNr_i02)y02m07T).ia7LSr__c2cyLrcq)TqL2(amqQmcaci2i4cML_NiTm)_2T2o7ri{miaN_rrNS)LTTrcr07T0)_)r2r707L_*rALS_2c0T2qm0Tm_iTm0mLar9TS0S^LS;_c_0qmu)_i0iamNS2_mcrSr_rc0cL2WT_miiTmiS7LmiTwrLF0_)2)ZNrm0qm2r70LmalrcLc_2_z)9N_qimT7marr0Sq_{riLN0r+Nc)NTmr)r27m07_7rirS0SL0k8sNS02)0m2am2Tr__Tr0rLLrTTc0c?NST_am22i0Sri0zNo8Sr0)Tq)22i707rqm7NSmL7_aNTLaN_cNq7227rqT2)7)aiiTcTL0c_02Tiqq27m2iT2_7qLEiqr7Sm0?!!NS02)0Thqvm27N_TrTLcLiV20i)rNmm0amqYi07caTiaS2LqtcTcNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2q7TLrii_2c9_2TqTi)d2272a_iqriS_LSW)Nr_iEqNT2r0L7rqTr0r)ami7S7L__m)mcLq007Tiacma7)aqtrSic20mxT)<2mmm)T2amLLmimrcNTLr_ScS000r7rqra2mOSLraLcL2K)crcc0_0_7mq_i_rcaNr7S0L_N0phTSNL)))F2ia_7iS7r0rLLrTTorcS0S)0)rirmam_aar7rrLi_7lLq-0)m6q2i2mNa0amiiSNLaTrcN07T0)_7)2_maam_6rmS7_7W_cm2m0Sm0armNm2aNrcrTL0_cFq)z0qmT)Na_2^7cicr2r;N}L?TrNmq0mTT%ari_SmLmiTp_NTTmQ1NcTc)2)hi>mqriaci)r2Nr_c50qmNS0_)02mm7a7i_rmNmL700)2qm0TmRa0rmmtacrcS2SO0e4_Tiqr0m7Ta2rr7Ta)r)SiLTTTBrT_0a7T)c2Tm27mi0RrrrLN_0c2qD0{T7ar2N77SmaT_ycc_icccmqqTTq2)_2_7_7LSrSLc=LaTTc_qrmT)a)_2a777riir7SL0mTiN0)_0r7720rrmLa_iTr2SL_q)mN220mTTuari_LTi0iLSrNi0t)0q2T22iaT2a2_7ai7irSiL7_L)mqi0)2_)Si7rm7TL<I0NmLahiI#N00a)NiT2)SraiiqSTN00mTic_0qmV)c7ia_SmLTap.rLa0i8TNT0iTqamq7i0LN_qrme0NTLQTr)e2T7mqaqLm_a2icE!S_LaVm),N_0a)ma.2mm7a7i_rmNmL700qcNqmrT7qr2_m>aijTS0ZtLST7)mNT2=70immm7c_TiaLccYLrTm)aT0)7qT2_i07rLarmLiL0B0N0NN)9qNaTqLrma0L/nmSLL0_LcScA0_TSqNirr_a2L0i(cS_2T?cN000mTiqN2aSrai_2umSTN<T0qm02TN)=a_rTS2LirT__Lr07TmcTq^m0am20maLTiT&2g.Sr0mTa)0q2mm)Ta<rTLmamrmS_LaTrcr)22mTT7eiTSmaT_NrF!0_T_7eS0TTqqrar2aacSbar1mci90Tm)1NSmm7raDrT7Ni7_mrTc:0cci0c0N)77mqTi&SNiiScV.Sr0mTr00T2T7)aihrTmGLr_JciNL0r1mq02m70a)irmaicLwircmN7c0N7Na)cm4)rimrai0r7GmSTNnT0Ni0_Tc)NimirmmLT_mc0N)_mT_q2q90r72arifSiL_G0t)LmNicqq)0m2Sq22NmbLmi2rNS,0m_acicI00TaqNrTmdSLSSLTrL_q_2NcN_TT7mqqmSrr7m_T?2L_02._ca0mm2m7qqrT7cLr_Tn0NTTNN1TL0r7T2q2crcLci3S&r0N_0aT0072r2_mLq0mXirr)>cLS3qTr)0)iqa7272mSS0iT_c_aSS0rRrNSTc)a7iicmTSrLmLqLcNTN2)Tq02T)mmia77T7rSLL_i_S00q_iq7Tr)rm_aSi277Lai0r0N_07cmqY)m2aa7immGir_TSmLr9c00)i)im00_2mirmSm_i)i2Nm0r02Ti20qa2T2S2SrSarSN_2r_0SNT0q0L)L)p7a7aa7iNL__L_m0q)))S0))SqT2m77Lc7iSW_TNq0-)rqN07ma7r7TaqS7SLy&_<L_cNc2)im0)caSirmSL2LNxq_cNSc70NTrm2mNmN7caai7SNc0LagmNN0r0)T)2mqi7ia7L_aiS0^TTcNq)LqNT72ri7rcLcL7rccBLj0iNbq22_702TiiaN7SrTK4sNcaTr)i)i2a7r7Nq2acm_r7i2N0N0cm0m0y207ca)aaS2S2i7__NrcTcScS0cTrmimri0ScSi;)_7N15rTmqTNAT_7a2m20imaSSaSrcicaN?)2mcqra22rr2S#im4mL)NaTrNmqq0SmLqrq2iaLra_LNn_Xa_0c7Tqm27<aq7cS7S2a2LqULNN<Zc_T))72Ni0aLamrTr _LL)_VTG0)2mqN2r)_rS7q_mS SrfNcr)rqcmTm72Ti#iqm_iNr7r2SiTTNm0_m)77a{aqiam_r7SSri0T0N))Tc2Sq7a)r0S7imLqS^r__) D)N2Tmmmqi0rTamSiSqL4NtcNNr042c)r77i7r;iNiTrc_LciccTSc0mT)gqc2)mySZL0S7NcIq00TNqrqam0ammiS0m_rmSSSSN0+))_0T2S)7a2iaS770i7Lqr__rx%Ta)LmcqSimrTS4L_Lar)_7Ra_iq7)Tm)a))_m)rqLQSTcmN_crcm0mmcTSqciN7LirL7LT_NN7cacrc2)q)m7NaqS0m_a0i2SS:Q0Nc7qT)a7iar7qSrSNdT_aL)n7Rmq0TmmiacmraLScaOL)Sc_7LL0_TL2cmr2q)_rNS)rr}7_TS207ccqRmc2rmLaW7SL0SLLT_NN70Lcrqq2Z7raNaiariaLNSr_c+Tc7c720m7qm2r7r2_L1iVcmLmN2Tr)aqLmSqSmqi0SbirSrc2Nc0_T7h_2tm)mRmWiNLTrcS cicq07TSNr0Q2aqcimmcirLL_NLS3cc)N7qr2a)mmTaqr7i)_crUN2NLc7B<ci2Lqma)r)aaara2ii&L0S)Tq)N_mjqS7a7aa7a1aiLENiNqc!q22F)SqTiri2S)7i_Lcc{N070LqN0,qrarmmrrS7LSrrkiNoT2NrN42a0_2mmqr7LNrLSSc{NSTNTqTrm2mNmN7caai7Smc0_aDm)Tq)Ta)L)7im7aaSS2_ai__mIS))TLqN)S2ri7rcLcL7rccfIN+_cc)i07qcmSiimFS7icr)_NN!0S)iqq2aqi7Nq2acm_r7SrN002cm0Nq7)T7Q)2mTaTLmSm___k0S0qcSTa2Nacmri0ScLr_7c2NhNi0rqTq2mqTimIriSqaSg2cjcq0c)2qm2)0iqS7Tm77SSLAiLS_>TTNmq_27)iqrmSrxS0r7cccaNSNTTi2)TcmNq77caaLiSmc0cSNN0N0cTq)72Ni0rrSSSiSr_cL)_40r4_T72i7airrcLcrq_SnNN_cr)rqcmTm7mL2rrrimimImc)00L_Nm0S0S)ma^iTiaac_iSrLbDT0N))Tc2Sq7q7r07mimSmc)_l0IE7NT22mm)!i07aSSrN_7_LLr0_Nr0-2cm_77aSr%iNaLrc/2L/LicmTTmTTS2I2ramra7_xNLrbrc)0T2T)qT2aiq27Km_rm,_SS_ctrO2)am7q7iciarqLSa2V7cSNNcrcN0mmi7)imi0i7Siimc2c2Ni_iE_2i)S)SaLr+araNSgL7N)LiNTqc0?qq2aiNS0irS)SmPiN7NL)%N+TT7T2727i_am_SSSN)_cprqTNa)aq77_7qSrSNiw_aLcM7K<0c22)mqSi)i0aLLraSL0SSNq)0)S)T7T7oi7rNimLarc_T/N07cmqJqq2N7Sm72_L0imSmNT0)L_cr)iqaqT72ma2ia7LNSr_cykc7c720m7qma_2SS7a){c_aLm0m87q0qLmSaTmqi0rNrN_1s0NcL2)m}_2#2i)7mZi2SqLa_S_TcqT)ccN))NmRa2a2mmL0imSmc)Uc00)iq_m0mL)0q27 LT_<_iSq07c7c7)_)a2T2S7qr0S2i}ii8mL0:lNK2TmS))mqmcSmrmScSmbT0_)),_0)2ia0i77m77i^rccS_rcqNTNrqiqc2Ta2mUL)raB9crcaT20Tqq270_acair7iT_R_i_c^jTi)_ci2S7ca_7qS2SNrrSAtLjLTrcS2rmc)7a{i0r2rTSri_NSL2DS)S2?2iTLirrcS)_m_Sc/kNs0TS)22)qcmLmmr_S7icSL6qN6T2)N2cNi72q)7maciO_iSrN0xTcm))q7))7ca_mTSrrLSNii_G}m0i0q2rTr)Lmri0ScLq_7c2NZcm0ah_qN7T7am57mri_)&2LL_SNaN=07)NTSmL2r7aaTi0S7xiN4Tr)N2T27mLacrTiaLTaaSScaS_TSNSNqTcm2a)a_Sr70S2c)Nr^Ls7NTc_Tr)n7_mcamiS()_LL)L20a)L2N)S)S)_rLSiL__crLNr_7)T)L2Tm)7-iLi(SaLTrSLL_q_rT0)mm22))0acr_SraSScLqc__))q)M)qmT72qii)S0_TJaS/LSTT)a)_0ZT27)irS_Sr_aLqcTNmT_T)qmTcqqaLimaLSfir80ccc2)i)mqc2r)raTS07aS7rSSS_)h7TTNT)N7iqLii7)7LS7SLric_0+0Scim0)LmSacrraSLmS)r_c7TTcmqTqiqN)irirm72Lcr7Q70q0qN7)770a27)7aSTLmL7LaLc_)0)qN2i2im2777c7mS_iqN0NmN_)NN22m)770a2m)r)iSGic_Nr_0NLqaTam{i0r2rrrS_qrmL7cS0m)_0a2mmm)iiTS_iNLfcit7Ncc)qi0L)c7a2aiZL0rN&0_SN0T2TL)#TNqNmy7q22rrLr_0Lc02N4TmTSTq2_m7q2iiaaiS_24cS_0n)T))2L7_2Ni_i_7SLc_icr0_Tqc)0a2{mm7)a7m0iSrqS7-S_T0)T))72c7mq7iESq7iS_4T_Lc0070a2N2rq7q0imSa7_VNcT02T0>S0Nq#)a707SiFSrLW<qcm_aIScT)cN_)L7mi_i7SmiT_c/}0_0ccmN00;mr7)2raaSmJ2_7S0_ccqN70LTT)m7%a7r2LaL)SLNqNg0_0mN2qN7r2SmcSaLTiSSTENN)kgqT0m0_m72c7)Lira_c_NL7T2Nc0)0rTzi0awi7rSic_c_qNmcc)m)j)a7i2NiSaSLqL)rrc)Nm0rT_)2qSmcmqiMr2L0L)roNTIqTLNS2T72mMi222mia7_mcqcrcq?S)mq)27a22cm)ST_2SN_Nc__h)i0)2r7N2c2)aaSmrcc2N002N)-iTq2m)T7rrimSLiL)u0LLNrTmNaqT027_i02SSqScravmcmNica)mqm2r7TaT7N7)S&i0Yc_q_).aqqqrTr7La27)L0__rc})NLN7NL0qq)TeqT2)i)7%rL_i:_N0_2bSqr0o7qi27q7LS2i)_)N2L2T_c7222rmrqr20m2Sri7V0SxNcNq)mqr72qai2mcS_i7SaSTUaTi07qiTqT7m7mcic7rL8LS_cc7_S)q)r2T)N2NaraqSmL2c2cLL0cLT8)_2E2S7)r0mSSrrqS7LS_Tc)T72_Tcmyi2imaLamirr09SLi03)Zqc2i)r2LimSm_0i!ScL)T0)NNTqi2)7miiica)aSSL(i_a_0&2)i2rT_2)a67aaSiTSqNiL0%cTic_20aNa_r0r)iarqr0FTL_N20aNLqLq02Sm)m_a_rq^0LL_0}LNSNoT_)S2Nrra0_0ricrNk0_cmqq0q)q)_7ama7Ni_r_cS0Tpaz_NaT7Trqi27mLLm_irrSS_Sc0cr2rTr7mqaa_7mLqL0SaL__2NNTi)rTT7r2TrNi2a_SiL2Lr_TNaNTq7mGqqqimqa)amr2S)LaTTcNqmT0m%qrii70LTiNerL0N1Qr)mNam07Tqqi572LTiqMrL202TmN02TTN7m2TiZ7iLir2rLLrTTOaqT0imm)aaYmrSiL_r2SNL*0_)TNaN_Taq7qrmi77aL8mSNNr_7)TN_2_)0qarT7TrLimVqLTLLN202Nr)2qrq7rmmmami_raNrLL&_cTN20L)qim27S&a_iaSmND_90iNm2)Tr7am_m2i0i_rTrr6N_r)rNNq2mJ)Li0mrSarTLrL)SA__cS0LNL70ai2rra77STLS_TcqN_cT0jmr)2qLilmLLiirRaS7_0N_N2))Tcq_m7r0rTar_aScJ2LLNS0m0m2cTLir2r7ri0iLc1LNQ0umci0NTaar2irr7)_Tricm_00gQSqi2rTaam2Nrra2_Tr_c_N>/i)rN)2t)iiTm2mLar TrqcxLSTi)_02TT)c20rrmLa_iTr2SL_q)mc72%T_)a2mr!7Ni0imriLN_a)rNimT)0)L2rrmaNa2rNLcLT,0ccNq26)2aT2crr7a_2riLN0r3rTqN92L)q)QmLi27riTSnLi0e_gc,02TNaTqqm2mr7_iqrLNM_N)mN20NTQam2mi07 LSrTcN=2__Ni020rTT2a2TST7aS_emSqNi%T)N0a)i)2m_777ei)STMiN0_TTN0mNa0ST_mr2LiqaqFTr_Lq0m8qq00TmN)rqLa)7Nr_Sr_qLL0i0aNT2NTqmT7qmNaia)iTSq0T_TcTNi0q7m)a2i2b70aarNNT_0TrciNm0))2az2N707mairNSa0r_S)r00mT)iamm0rF7S_i1rS70m1c)rN7mT)ca_i#mSLriqWjLi0mc0q022T_)a2mrD7Ni0imriLN_a)rcS2r)0aTqLSTa2aLrrNTLq0BciqmT070aT2_r!7a_Tr_cr_2T2)mNqmT)iiTm2mLar9TS0czLLTmcq20m2)_qammSTaLi0rLLSL15_cS0Nmr)qaVmiSma)30S2LLTmcm)N0rmaqc2raNa0imrS_TLrTr4rNrT0TLaR2N707mairNSa0r_SqT000L)riTmTi_ar_7rlcLc0}i02T0TmT8mq2oSFaqLicTLN02s )LTLT7)0272amormrcc2N__YTLN7TcTaqqqia7iTamgtSi_NTTcNq_0BmL2Y2_mir2a2_0Lc_qT2Tm)iTT7N)iq_a77rrQ_2Lic0)TcT0TTi)qim2Lr0Lriah_Lm0qnScqNmqmqQqNa2a_L_b2SmNq_m0m0mT0qqmNmia2Lmaarir6L0_acN2T0)7T)Lir70S1aLlmSq00TTccq;077y202a7mLPi_DrS70Tj_)_qDTi7r20i8mLLmiqc0N2__;rc70i7T)q222rm_aqiLc%LcTmc2NN0U7m)a2i2^70aarNNT_0TrciNqTT70)L2_mT72aLrqNmLL0)c_NaTm72ari_S0L2i_raLmN)8Lc_N2T)q)20aqmLrNS2r2jTLicq0Nq007)baL2qr0rqr0Srk7dLN_qT0rma2)2qarm_i)Sy_LLqL_T)Nm07)7q_2mSma2L0 rSMNL_2TNN))i)cmN7qmLL)_rSNS2_NcccT00Tc)qa3r07Ta)r)SiLTTT!q):0r22):aLaiaNi2i_Lac0NTUrqT0rma2_22a0a_iTir_NLr0c)mNL00TLqSq1m_7SiNhrSaNM8r)mN)2Z)iaim0STaN_rracV_N)TN2NLTraTqaif7iLmrTcrL__qcTqr0rmi7r22rm7_Lrr2cTLc0r,Lq2T0Taqmi3mcSki2kTS?Nr_L)TNHmm)iqN2GSm7L_2xmL00T!N)m002>)NiTm2mLarpTS0c?LSTi)rN7mm)qar2LS(i0iaSmNW_qTrN22TTcam2imN7F_mrmc2_0_acmqk0_m4qmi3707aim9jSqNrbm)TNnmm)iqN2 Sma2_Tr_c_00Oicq0Tm07mqL20mLaSa3r_SS_NTrcrqpTi7mqai5mSLii_SqNF_N0aNT2NT))NqS7irNiNia_c0T_TcTNi0q7m)a2i2 70aarNNTLaTrciNqTT7r)La2mqLcim<q_i_0c_NiN10mqLqmrm7mS0_rSTc__mTqTcNvq72mm_7mmSia__c2Lm0q9_cmTmTq2qm0aL7T_mr0SaNroT)2Nm2qT&qi7m7im5riL0LrN_NLT0Nr2aq)22qimN7iiaiaL10r_rcr000L7yqNm0mm7iiNraNr_N)TN0NK0S)_im2a7i7^i0raLNTTc0qTNSmr)raGmTSmi0_VSi0T:2wLNrmTT)a0iTmqSPi2gTS_Nr_7)TN_2_myqTirmaS5aSWmL00r3_cq0Tmr)Nam2rSra_iqSTNrLSTi)rNVmm)_immi7Na5KmrLNT_cTrN22W)0)a2mr<7qLriLc2_0_acmqG0_m4)7i^707aimpPS_Nr_7)TN_2rTLa2ii707LircTSq_2_rP_Nq0L7 qcixmLLmim(rL20T>_)r02m*q0qammSDam__AZSS0rc0)J0Tmmq0almNSiLriLcmLc0r{LqT0q7mqi2NmOLmi2vTSc0mBicNN?mmTWa2im70LTiT#mL0N;%i)m00m072q_2a7mLTiLr0SL_S_4c_NSTN7rqri 7NLmr0o:SS0ih_Nq2:TNma2TrN7_a2imLmSrcS0ac7mTTTqT2imqLmaarir=L0_acN2TT07rqi2q7TLraL_2Sq0cBm)qTiT0q_2i2gmmiLimcmLmN0TrNTq_Tm7q70aT77aiaL_7_7c7T_q20mmqTl7TacaaaNSir7L3Tmc0Na2r)Ta22mrqi2iir2SNc)N702cS2_2LqmiqmcaNrSrSSac7cSNi2m0m)mq_2aSr7Li_rTS2LLfqqm02mm)_a,27S1i0iaSmNk_cTrN22TT_7rqGr2SmarsTSNNm_)TuNimT)2)L2rST7aLprTciNrB2)mNmmm)iqN2VSm7L_TrccrL7TTc_q_2J)iar2arEaN_mr)c{_i)TN2NLTraTqrr0S2a_irr7LiTT=qN2Nr0_)qqLr&7q_mr2SNLHTmuaNiN+T0)a2NST7a_rriSq_T0lcac_0a)7)r2im77L_mrmcrLLTTccqrT272qimNSr7LLqrycLyqN)0T)0)m)q7qa7S+7RiUS2LNTTPqN2Nr0_)qqLr(7__mr2SNLbTmJa)00NmSqTiNa27_riS2SrLTcacT2TTT2_am2,rLaT_NSa3cLL.aNiTLTT)Sair07TLNScLLvc_0Nm0)N0)7aTq_mqSmaWP0STNN..N0NS)qTS2L22aqSiSrrTcNSrNcNm0a0IqcmamiST7TiTriSq0m_acict00TaqNrTmaLriirmS)_2T9cN000mTiqN2aSrai_rrrNT_iTmcrqQTi7mqar0STaq_hS2NT__)mNi0NTMam22rT7c_mriSNLsTmwLqT0m7mqi2NmOLmaHd2cmLaTTySqm0rmIqTrT727LircTL0NQXTqT020L)riT2)S0LTiq.5L20T5q)rN7m{q0qammSKa__rr7N2P0JaNm2?Tc7&q7r.a0aarmcALq0rhXq!T0Taqmiom_Sri21vL0La#m)-Nq2rTLa2ii707LircTSq_2_r6_Nq0L74qqiX72Lmi_cmLi_N=#qmN7mT)_ar2LSTaq__YRLN0rza);NS7Tq2qLmrLTar_,SiNm_))rN_0q)Tar2TriSri2PmScNr_L)TNc2rTka2immaLTii6mSaNJ_S)m00m072q_2a7mLTiLr0SL_S_nc_NSTN7r20i17NLmi)dvLT0iX_Nq2QTNma2TrN7Lrirc_mLTc7ciNNmTTTqT2imqLmaarirEL0_acN2T0)7rqi2q7TLraL_2Sq0c,m)qTiT0q_2i2EmmiLimcmLmN0TrNT2NTm7qqaaa7La_Lcr0_c_2T_q20mmqmq72a77)r)iSLm_iTmc0Na2r)Ta22mrqacr7r7L)ccca0qNz2_2L702rrai7ScrYSTXRcLc_NLmrTrqrm0mLLBiNS0SmLinNca2r0SaT202smSa_HmraLiL.h0ca0N7T)riTmiSra)_XSiNm_rTxcS2imr)LimmqSri2ATSqNr_7)d000a)maj2_r_SyiiWrSaN9oi)mNa2H)iaiir72Lmi_%rS70Thq)r02m2q0qammS!ac_HrLN?h0!aNm2{Tm7rqLrXa0aarmc!Lc0rc2qT0qm_a02imqaT_riLS_LT_2OLNqmm)2am2mrW77_eS0Sa_mTDcqqrT27s202a7mLvi_hrSL03c0ca0mm%)qarm2S2LmiacTLN0m,rqr0_TqqTirmTSmi0_VST0TQ2GLNrmTTaa0iTmcS:i2WlL0La&m)!Nc2rTLaT2_rr77_25mL00TlNqT020L)riTm0rjai_mS0cd_TTi)_02TN)ha_2a7i7ni0raLNTTcT)c0iTqqTi0rmSiL_iBSc_c82^8q^0N)0m_immSa0amraS_La_q)2N)0q7Tqaq_maa7arriS7LLTm)iNqT2Tr)_2qmLLWr)_0_LVa)TN0NLTr7i7S2E7cicr2r>Nk_a0iNT2N))2)7T2m7_aSiLSN0T_7%aqj0rma))qrm2a7rkir_2LN0ccTN)T))iqTrTmqr_im1q_q_TN7TNT20i)TmmaSm;acrcS2S{0#Q_N0)_Tm7qmim0a_iiizrm_L_m0Sck0c)cq2q>rbmMSirTcN+NtTcNTc0iq)q7q7i77raSrSL0LrTrOS)20ImL2amSmii0arLS1)=r0)cmN7T7)_qmrm7q7iiqS)Sm_2R)ca2rTN)_aU22STLq_apLN2_my7N70_TmamqSi07)L^r2cTNrLSTLqN2q0ia0m)r0ai_T<7cSN_T0T)Nm07)7q_2mSm7LL0rrcac2jLN0Ni)q2_mZ2mrcam_qS)LS_moacNNmTTq0afmqmiaqr)rmL2_)vaqT22Tr7a22mmari0SNSi_0cm)Tq20q2i)Li)mrSar_r2_0__dTkrTN0r7rqi2q7TL0iTr)L)_iOTqT0N02)N2c2T70aciqcmL20mxp)r02m2)i2Nrr7i_TiTSTLi_q)mca0i0o)0qamNLTaa;rSiLq%TTcNNq2)Tac2Ni7a0aLrrNTLr_ScS000r7rqrimmaS^i__2LN0Tom)q)0Ta)_q27NiirriTsrLq0T-_)rNSmT)raa7)icaNLcr)LS_TN;q0q)Tm)727m_7m_mrqriLq3)ImN20)Taar2TrrS_asrcLc_2_n);N,2rTL702rrai)ScrNkcL)<ScTTXmT)camm0STam_qLiL0D_cicYNm)L)marmTSNrNi+_)GLc082cI)Tmi7r22rm7rLariS78+Ncc7020aTh7!2mrqm_SaLaw0:q.SB7Nq2_7cqmiqaNi)i0SiSTc)NS0Tq_2c)iar2}rLiarSri_0LrNST)Trm2m7qqm2mr7_iqrLNm_qTLNT2NTN2imTmiiTrira__Ni0Scm))0_Taqma)mm77i7r_Sm0mxcT0cH0qT2qia7mr7SiSS0Sr0r:)T2NP2L2i2Nm2m_iaL0_TSr0!fmc707T_)mimmqmiaqr)rmL2_)XaqrTcmr7_qtmcaci2iXclLcNitLqm2i2S)h2c7ca2aA*XS_ci_L)mqiqSTkqcmc7276_ErNXi_TTN02N_)iq2qr2TaaaTL7rrSS_Sc0cr2r0Sm2aAmmSma__rSTNNc24_0iT2Tr)TmamTSmaF_LLLL7_0c7caNAqmqci2raSwiTINLLBc__N2c;qc272<mqmFSLS)iiLqLmNqN))N)m72aiiSm7S)imr7L7__^mqmNL20)1a9m2STar_a_7L0(RN_NT0TTrqTa5mmSqaEr0_SL7 ?pTNi)am_7c2Tm)a)iirTNT_0N_)mqr2i)TaN72m_iir2rrSTba:T)i0aTm7mq_ir7TLNS7i_LaLrNaN7)q)r7ia_ic72aL_srLc0N2wv)L)i)Nq2q_7ar0STirc2S,_jc2NNmTT_qqimmcriS_r)ciLTUTciNqmmTaqiq>m07aiNcTL00NAm)q)0Ta)_q27NiirriT_SL2_TOcN02rTNm2q5iLi0aiS2L0LmLJNqcfq)TNmi2TrNi_iqriS0_LN20mc6q7)0)L2ri7a0a-iSS_L_+q)mNqqi2_qmiqai7qrqL.L}La4i0rq_0m)mq_2aSr7Li_rTS2LL5q)dN720m2amr07_aqrTcTLi0aT^)i2cmT7_i0mc7NLHr2cqNr0mTS)>2im_7c2imqaTLciLS_LT_2lLNqmm)TaN7Ta2rTS)L_LqLq4r)r002R)Na2i2rrSL_co_NN0m/N)S2T0S7)aliaaNS__qc0N20i0SN20NTjmSqvmcaci2ikcfLTNiVL))0mT7q72_mmLmiqiiSq_)_mc2N)0a7rqLirmaL0iTr)L)_i^TqT0T2c)2qLiImLacagcmSL02_ych02TNaTqaa_mlLr__8cL2_LTscLq0227mi02r7ri0iLc9LNM0Umci0NTaa)i7i7a0aLrr(7_0_Lcr)7TT2_qmiq7Ti2a_r_L_LLNrNLq+0S7Tq_iAriLT_cd_cO_iTr)0qt2a7iaS2LS0L0__BcLi0ryaq00TT)q)2imTLTi0L_cL0N6NjScLmTTam_imr0SSic%2cm0)lm)yN>077rqia270SL_Nrrca_mcic000)0)Nm/7NSTar_mracd_NTiN0NLTraTqqm2mr7_iqrLNw__0SN20NTQmSqhmcaci2i?csL7Ni)7Nm2q0LmimLmiaTScSq_2N1Q7)mqSTrmm72iq7rSmLm9Sc_00_NT2q2mr)Tq)m)7iaTgTS0B__N07crNSTSq0qrrr7a7_iaS7Sr_i?7cL2&T*q0iTrNSqLal0rLL__TW2cL0q0S7LiNrqmiLUrmcqkiNT^2N2)kq)m77Nr?L)_SHScrNLTN)qq_T2)NqOrmm!acrcS2S90B8Lc0NLTSTkq_2S7N_TiaS2Nm0iErcS0S)0)rirmir27Sa_;)Lm_7c7N_0m7mqqa027miLcrTS)_)gicT2T0L2_))q2iS7wicScL2LjTYNc)i0c)qammNr<aNiirrc;_i_2TSN<Tcqc222-S;a_LirLNm0iurcS0S)0)rirmcr27Sa_SaL)_q)rcSq2m27(2iSTaTaSxPSmL747c_Nmmm)m70m0r=L0L)rmS7_7E_cm2mT2m)qimNSTarL2_ic702_>cs02TNaT20a_Smi0_*c0SNN2))ccN0mimS22mT7ci0r0SaNr=T0_)020m_)m2mm_7a_rrTS)_)ficT2T0a2_2cirr_Sci2rLNm_cT;N0NaTm7WqriaiiaLSaLmSL_ScMcm2TTm7q)LaiaLairT_c_qc2T9cL22mmacaLrmamLT_Tc)NiTT))q2N^TAq22NST7aS_rmcqB2_TcT0i00qa2Sqary7L_2_7L0LL3rqT00q_)N77m0mk7Si_r_Lq0m/;Ti)_2L7iqTmT7iaqemS2c0 NTHq0q)T_)a2mi)7)iSi7L0c2Y0TcNi0q)T7c2am)7q_rriz2N20<cNqr2_)mqcrT7Niciij2cO07_))0cim0q0722a72Lm_i_SL2_NXjTS0qTc)Nimm7r0L0_rrLNm0icTcS2GTm)727m_7m_mr2E0_00v)0))0i)NaT2rrra0L5__cmN2T0T0)22m70)r2r707L_YrmS7_7>_cm2mTqm0qVi&72LT_N&rc70207crNSTSq0qrrr7mS2rTcTLi0mTT)bqamimSqAmcaci2iMcdL_NiMcNT2rm_7H2TrrS_LvrNSiLr0pcNNi0r0_7)2i7NLTia_2biNrT2jBN,T2)NiTm0ac7Lr2_iS.0mTiTS02))T32ia_7TLr__bcLi_mn)N202TL742qi0r2_)ich_S20_;mNm0_Taar2i777qi__0SqNGT0T)N_0rT7qi2i7NLTia_2niL2c))N0im0Trqrm0mLLAi_SSSas002ca2Tm272aXiaaNL0_Nc0Li_m+)N202TL7-2qi0r2a0SchS_20_^mNm0_Taar2i777qi__0SqNBT0)0qr2q)L7_aLr_a2r)iyLic_&T)rq_2c)iqqmTrca2iLIhLm0mYr)rqimT70a_a_r0L0__rmLm__Waqr0i)7))2_i07)iSr2L)Lcvic_Ni0q)Tar22mLSRim?mSrNr0a)TqN2_2_70i0r_7mimr_Sa0r}iN7NqT_m0q)mS72i)iNSiL__i#qNT2rT2)La:mmSmar_r^7NT0cT_T_q0m07_qmmm7_aa{rSi_7_Tc_)00))Sq2m)2gaii_riSq_TTrcq07T))_702_iSa2iNr:Nm_2fNcZ)ST7q)acmii_a__rQ_ccLL _cTN20L)qimm7r)a_iaSmc)_mB7N70_Tmam2q2i7qi)imS2L)_a)rcS0_mEqmiTmqSri2X2SmL7M7c_NmmmT7702qiS7picScL2LnT%cc)iT2m)qNm0mm7iiNraNr_STrcdqLq_qNmL7r7NicSTrrNm_rTaTi0Lqa2mqLmSa4amHTcmS7_}TLNST)TdqNqa2Z7riiPmSlN_L_)2072q)_aT2qr_SYiioic__2?NcI2m0A)c2cm2m1L,iLr0SL_S_xc_NSTNaTqmrTm2Lmi7Q8L_0iDrcS0S)0)rirmam_aar7rrLi_7XLq+0c)0aTiNrqSa_0rTS)_)5icT2T0rmM2cimmiSYiNr_cr_aTTcqqrT77Tq7ir7)LTaalrS20T}+TSN1Tcqc222^Sta_Li(rc)LS68N00TT_7iaiiT7__mrmSc0T__cqqX2N2am_2iST7TiTriSq0m60ca2TT02L70i0Sm7mimr_Sa0rQ2cL2mT2mNa2i)Sr7rirS0SL0y1NN0NrTiq0qTrr72aLDmxacN__)mcm0mT_)airm0r2iNkTVaNm0cTaqT2cmr7Ta_rmm__0_)LNci(mci2T0a)270iTiSaaaLr_L2_c0)c_NaTmm)qqair_Sr_0_SL7N0T2)2qc0i)qqTm07T_TiTraSi__0SN20TTcq0irm0r2iN&TFaNm0cTaqT2cmr7Ta_rmm__0_)LNciymci2T0a)270iTiSa2iNr/Nm_2;Tcc00mr)T72mNSTSa_m_!c70TT0)rq02a7m)_r0r)i)LiSqNmNLTr)2qrmm7qa9iSSTLri0c2c7h0ALNrmT)0)FqSm_Lmi0raNTN0NLci2T0T)Tqi2qSma0iacTL0cL0^qTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qm37c7rm2Sh7vi9S2LNTT_LT_0mmq2i7T2272rXS)_7RN0#))qS2Smr7LiNrqS_L___P7L0N_I)c2qS)a)L2_72acL)r_Sa_m0)c7)i0cT077mci_7)_qzacLL007c0NL0r)iqrrrmraNi0S2c)__nrc70i7T)S7_2)m2SSr)Z0S70aTLqNN22Sq22NmWLmi2rTSc_0Trc2NLmmm77Ta270LrarrrL0LLT:cN000r)i202TSra2iLcmcqNN,_qmNmTm)_qarr7rS2rNcTc70i0SNaNLT_q22ci)7_aarmJ)L_NiT_)Lq7T0)Lqrmi7r_rirSNL0o2T)N_0rT7qirT7Tr_ianrcc000)c_NaTm7Iq_2a7mLgi_raLm0E8_Ti02m)707Sm27NajLSSqLc_N)mN2q0mT7rqNr>7}a75rS2LL06c2)Nq2Tia0qrmra0aL%fS7_SX2)0N2Ti2_q7m770LcL_S2#S_2pTcc00mr)r27m07_S0iSSSL20)T0NiqcTi)q2Tic7iaqrTUcLT_)c)Ni0T7T)i7_2qS2aixcZ_0T_r(SNST0Trar2ii77raSrSL0LrTrca)70rTSqSm0mrLriai_Sa_7_rciN70L74)ii5rLLN_qb_S)_myicr02mYT!qq227i_TrTrSNu__UaNm2QT_)a2mr,mSa+r0STL_Tm-mcLN_)0ar2rm)Lmi0raNTLaN4)0)o2m7r)r2r707L_>rq}iLLT)Teqqmr)iqqmTSraiL2rr_c_Nc2TS0q20)_2Sm27ii2LSS0LaTTTc)7qTTLamqmmm7_aazrS2LLTmTi)_2T2am_2aST7TiTriSq0md0ca2TTN2.72iNSm7mimr_Sa0r12cL2m2TmS7qmNSr7rirS0SL0YjiNN2rTamqaci)SD7nieS2LNTTk_Nq2*TLmr7_i7ri_mimSmL__a)rN20L7mqqaNiSrR_rirSr_0_L)pNuTS)22)2c7ia_L0i7riNc6icmN)T27xqm2777a_imcmLq0Tt7)r0imT)TarmTST7_LSSqLc_N)mNiq0mT7ramrP7ta73rS2LLTmci)T2N7m)m2mm_7a_rr2SL0m0iT0)2T27r)r2r707L_xrL=i_2c)cc0i2c))72mTacair7rqL_!007NTTcTa77a2m_r0a7LSSm_)_LciT_0))7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)S_Lr_7ci2TTTqcqim7m)a_r0_2S7<c%iN7NqT_q0772ai_aN_7O2cc_i02crTcTNq27Sm27Na>smS2LT_cc0qr02TLamaaiNr2i2jrrrLr!0wLq^0L2iq2m)mcaia23TSTci6a)mNtTS)q20ir7Ticia57c2__T2)i0)q_TMa7mNr_S_/TrG(_N%07NNNS0LaT20a_7aLmr)crLr_))mNTq0Tr7Saii)7%iSr2L0c2_0NcNmT22Sq22NmzrSaL_0SqNS0iT)N_qiTI2)2q7iSciirmS)_2Tzci0Nmr)_7qiqSr7rirS0SL04lNN0NrTiq0qTrr72aL/mSiSNN2TTqrNrTrq0qLrB7LSir2L)LcOi#2)0N7)T2c2a72SViN%mS*Nr/q))q02r)7a2ii2iScim_2cmNcPac)Nqmr)i72mNrGair7rTL__r3)qm0T20)raSiir)ajrSS2_0N2,00c0m)2mS22mN7x_miLf0Lq0STi))0_2i)ym)mqaiLcrLSN_0Wic))7T0TLqra7mar_iiS7Sq__0)e_Na0m)2qmrmmm7La_S0cc_iwmc)02mE)q7im2a)aNriecLi_qcTqr0iTqqTirmi7qiT4rSiLq3T)rNi0q)Tar2imm7)i2XvSi_NTrca)mqimT7.rTmTaTiirqNm_mc)c_0S07q022ai7mi)i_SSSaz0c2NS0m)))_2S2ma0i2rihcLi_mG)N22ITiqNirmamqSi_Tj_0T_TcTNi0q7m)F2c7ca2a^deSrNrZN)T0c2rT+aT2)rrai_TrL-SLR:cNc020u7gqqairrS)aSrZL0_TU_qmNL2N72a2rr7ra)BmS0LaTTJaTLqL7T)T2Tmi7q_mr0Sa0T0T0ANNmTTTqT2imqLmi0raNTLaLLT0)_mmTmqm2_maLriN_2ciNa0)c_Nr07)iiTmTaca_r2_iLqN)U_ca0mmI)_qr277i_Ti_SqNA0T0rcL2<0v)k22mNLTaqr2rAL_82+mqV0i)Nar2NimST_rirSr_0_L)*00qiTJ2)2r7iSciLrNL0_i!)T7000L)r77mNi_arr7r7L_N)RLc7NamD)_7iiiS)a)_rrk_)3cciNm0c7TqN7_maSqLarmL)L_xiTcNi0q)T7cqimq7Ti0rTNTLT_aEiN_qS)2qT2c70Lri__2SrPcVmN2)ST2)Nqlrm72aNiVcmL2_TWcN02rT2)Lim2LrTL0GmrmLm__Baqr0m22))acmqr2aq_cSSc2_TTcNi0mT)q2itmiaN_r_h}mci_L)WcH0;)2qNrTmqa2a(r_L2LmTsci0Nmrm_7m2aSr7rirS0SL0*&)TiN,)))a2iic7LaNr0SiL)N7c0cL0r27)r7_mir7a0iLrrLi_r)rcr0NT0q2a)m_7ra7riNTLrN_ci)7T0TLqrrT707LircTL0LLGrqTNaq_)Na7i2SraiiqSTNr_i{mc)02mb)q7im2a)aNriecLi_qcTqr0iTqqTirmi7qiTkrSiLm_)c2qb0i)Nara7i_raS_raNTLT;TciNqmm)0qarT7NmLL0_Sc00r_rcr000L7#qimNSTair7r)L_NTd^NS02))TK2im_S27Hi5S2LNTTDaT_0i)7)q2_i)7_ari7Si0T_a0_NN27m27c2imqaTLcriSmL)e2)jN4TS)22)2c7ia_L0r:LS_2c)cN0iT_70qgmS72i)a-SiL_N)l_ca0mmx)_qr277i_Ti_SqNM_L0iT_q72Samqmmm7_aa8rSr_7v0NccST2)im_imm_aSaaS0rqci0r)2)70a2_qNi7r2SciirmS)_2TlcmN7T7)_qmrm72S0i_SSS7x007N))_Ti77qii_r_S7rNrSSLTTwaT_0immq)irmr7)_mi{Sc_c^2QFq-0_2iqcm)mqSii2S0g7_TcccN02qi)27)2_maamL)r_Sa_mTRc_NaTm7Yq_2a7mL6i_rrS7_i)Tc_0qmQmraNaLr0aLEmrmLm__-aqr02TLam2qiNr2SB_2cPSf_,c2NNmTT_qqiDirS2SM_0SL0m_mcmN_0a7rqa2)mqLrim_2c2N)TTTSqcmr)rq)rm70aa(TSN(LNm0_qmNmTm)_qarr7aa)iqcrSrN2Tm)Eqa7TqTqSr^7iiN%rrrcq0q)rcr0r)0)LivmiaN_rirFmci0m).c+0j)2qNrTm_aq_pif%ac_T0)02m0m)mq_2aSr7Li_rmL2___1qm00TaaTa)a4mr_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_}S1a00T22S)La0mqSSLi_)S_ci_HN)NqTimcqL2N70aii)_7L0LLzrT70T)c)i272)7_i0_r._cc_N02ca2c2_m720a_7Ti7iaS_c)L_^acm02Tmamqm2Lm_i0_cSiLm_)c2q&0y)Sq2m)mcaii__0SB_Su2N)NNTi)_7)2qii7L_)X0JS_200cm0S0Lq077m0mLarETS0SyLSM_qm00TaaTqTaLr0Lc6mrmLm__+aqr0aT))qirmar2L2_TcTcLNI)rNr0)7mq02aSTSN7L_0rV0m_mcmN_0a7rqrm770icaSS2Li0TT2T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0a0L)_22mcr)a_iaSmc)_WcSN2T)Tcqi2_i07KiSr2L)LNMic_))TNTqq22_m7rSi2rNStcS:2cTNcT07rqrm770icaSS2Lic_5rN700)cTL22mircaiiqSTNr_i qNT2rTi)mq)m2S#airNcrcKNmlTqrNrTrq0qLrg7iiN&rZWcm_T)rcr0r)0)Li/mL77aa=OSLci0iT!qm2NmaaA2Vm7Lri2rLNmLm0T)N2m0m)mq_2aSrarr7S0_cLSc2Ni2Tm2m7qaa_7NL7_2:cLiN23r0c0N)2mS2a2L7_i2rcX)L__acm))0%)Sq2m)mcaii__0SH_Se2N)NNTi)_7)2qii7L_)(0yS_200cm0S0Lq077mqmaair0rScc_i/qNTqcTi)mq)m2S5aurSS2_)_cciN_q0TRqS227)7Niir_()LqNi9Lq)202Sq2a0mmaSaLS0D7_0_Lcr2TT0TP)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2_SSLN0oq)Sqi2))_7i2{a)aqriFcLi_qcTqr0iTqqTirmi7qiTfrSLLN.0ciN)q7)0)L2ri77raSrSL0LrTrcT)2T0qc)Sm2iS7-icScL2LhT,QQ)iT2q))1mircaTi)S)Li_T)Tc))_TT77aqrr7Ta)r)SiLTTTerT_N)TZqSqx70SriTScSTN702c_qT0o)S)7m0rimiLcraS)LqTrci)222mx)rrT7T7S_tr=LSL7T)c_0iq_)T27m07_S)i_raLmN)?mc707T_)mim2nr0amrS{i_0_icNqr0T7T)T2Tmi7q_mrmL)Lc.i0_NTmTTam_2i777qi__)S_Lr_7ci2T0a2_qNi7r2SciirqLTNcGLcN00Ti))77m0mLarL7S0S*LSj_qm0qTc)Nim2mr0LT_r*qNw_U47qr02TLamqmiNSN_mimSmL__a)rN20L7m)maTi2ST_rirSr_0_L)-NiTN7r)raqiiS_L_cTST_T;icq2m0a)iqTm07i7rKTr_Lq0(TcTrNmmfTZqZm27N_TrTLcLit7z)N_T022qTmcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cS!atLN_T2)c7)2_maamL)r&LS_2c)cc0iT_7maiaSmLS0iq?SciN)v_TiNu)))q2iicmiaqiTS0LTTTwTcaNiT_mS22mT7ci0MrSr_7K0NccST2)im_2r77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_NaTm7Yq_2rm7ai}Tr_Lq0-_sTa)_2SaTqTmT7iaq mSqLc_N)mNqq0m0mQakiarr_mrmSc0T__cqqZqL0am_qrST7TiTriSq0mhmN)N_TST720m2rdL0L)rq^iLLT))0)ST2m0qmmSmLi0L7SqSa_ic0cSqcTi)q2Tic7ri7r0LcSS42ciT_0r)7q0mc2La2ii_cSLLN90ciN)q7)0)L2ri7a0a^iSS_0m/mN)N_TST720m2iiamr)r_LSLac0N2)ST2)Nq>rm72aNiGcmL2_TWcN02rT2)LimirrT7IsmrmLm__xaqr02TLamariTm?_mimSmL__a)rNa0)Tqar2ai2S2LrHTlLNqTrcrN)mm)0qarTmTr(LLcTST_T9icq2mTmq)q_mSm7i0r2HDN0N)oqTiNLm)707Sm2r0amrSrL_0N7cqca0i)0)Sacmi7qiT_cSr_7G0NccST2)im_2r77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNiQ_SL2_T^cN02rTrq7207cmSi2ri__LrH7c00cNL)2qiacmNr2aascX_c7D00_NTT7Taq_a)m_7aimlPS_Lr_7ci2TTTqcqim7m)a_r0_2LT;ceiN7NqT_q0772ai_aN_7F2cc_i02crTcTNq27Sm27NaVnmS2LN_z)mN20NTQam22mN7d_mr2STLcA0)rN20L7m7Ta_2qriiqQ r/L/+2cN2T0q)2)Z2_727m_briLN0roa%q)i2TmSiT2T7TaiiqcmSs_cccN2NZmP)m7imma)a_rSrm_0>20SN00a7T)rir2r7ri0iLc-LqNiALq)202Sq22Tmca0_rrrL7_0ccRS02Ti2_qTa7mar_iiS7Sq__0)c_NaTmm)2N2q72a_i7_SL2_NM>TSN1Tcqc222IS/aL_rSaNT8)Trcr2TT27r2qrT7LLrrTcTS_0rciqTTcmr)SiTm7rSiqrcSN0moqT0qT2rmma?25m7Lri2rLNmNa0TT20NmrTrqrm0mLLRiiSNNr_a0m))2r0r)r202LSvaLLi^rc)LSMsN00TT_am2qiNS2L2jrSrL)Tmc0NamTmqm(2aST7TiTriSq0mP0ca2T2T2UqarTmTaTiirqNm_0uaqT0NqLm07Armmmami_raNrLLn_cm02T_T/imm07a_T_NiLc0_L)mcm0mT_)airmrSra7_XSSNiNScacL0_)2qca)m_7aim_)SLci0_TL)700TL)r2imrLrarrNS0_20)c_Nr07)iiTmNi_L0_N_SL2_Nwoqm02TT)c20rr72aLtmSqSNN2TqqrNrTrq0qLr#7La7iacdL_NiTa)72m2F72i1m877_rr2SL0m07fN)2TN7r)r2r707L_:r)li_Tc)?_0i2c)LqNm07ia)L7S0SL_r07N))_Tmq722m_r)iNiqS2L__70SN20NTEmS22mT7ci0QrScc2_(NcciT22Sq22Nm-Lmi2rNSz0m=2cTNcT07rq22LSmSrLN_2LN0r_rcr000L79qrai72S)i_rrS7_i)Tc_0qm^)L7ia_r__TiTSTLi_q)mc2q0TcmS22mT7ci0srS_c2_qTcNi0q)Tar2imqaT_rriSq_TTrca)2TN7c7_rT707LircTSac_gN)7q22c)i722racaNr2_SL2_TXcN02rT2)LimmqmNS2_2crSr_rc0cL2OTL)7qarR7rSi_762Nm0NTaq=0 T7ar22mLLmiq_Ncc0m_mcmN_0a7rq22LrEamr)r_LSL7c0N2)iq_)i272T7_L2aBr1L2_N)Tca)_TN77a2ic7iami)S2N6_q0iN2T)TNqiacmi7qiT_cSLLN>0ciN)q7)0)L2ri77SS_riL7L)h_cr070S)_702#7Sacr0srSL0TVr)mNSmcm_amm0ac7Lr2o_N0_N02ca2c2_m720a_7Ti7iaS_c){NwqN20_T7mS22mN74SSr2STLcv0)rN20Lm8qmm)m_aSa7S0L2ciN_ci070T)_a2q&mUa2iNcTSac_AN)7q22c)iqm2)72L=iq_iL2W)?NNiqcTi)q2Tic7iaqrTcrLi_qcTqr0iTm))22rZ7iiN-rSacq0m)rcr0r)0)Li(mLriLr_)rSLd50cTN_mm)q7Ni2r2Lrirr)Nm_0xaqT0Nq-mSiT2T7TaiiqcmL0_a)TNN)L2JaTqTmT7iaqZmS0LaTTcNTL20m0amqmmm7_aaYrSaL)_q)rNiq2m)7)iTirrk_rrrS)0m%0ca2TTN0L70i0Sm7mimr_Sa0r3_T2Nq2c)LqNm07ia)L7S0SL_r07c0)_0Sm72q2a7ii0iSXcLi_qcT)c0iTm))22rDa0Siia,)L__acmqy0_Tr)72iST7(S_riu7_0_Lcr2TT0TO)S2_Sma0iacTLNcL00T_2m0m)mq_2aSra2iLcmcaNTOLqmNmTm)_qarr7aa)iqcrLiN2TT)a2T2_7cirmr7)_mr0Sa0T00_L)00L7m)m2mm_7a_rrao2Ni0aT)0N0q)2q_27iSa2iNrt,S_mTmc)qrT77277mqmaair0rScc_i;qNTqcTi)mq)m2SMa:_prSNT{cT_)c0iTqqTirmi7ma)r2c3Li=N)r)hqm2iqqiW2f7(i2rNNT_N_S-L2TT02_7_arrrSTLacTLTLSTlci0NmrmS7mmNSr7rirS0SL0&*)Ti0T))T_2iic7LaNr0SiL)N7c0cL0r27q)7_mma7i2r_>)_N_qc2N_072Sq22Nm5rSi2rTSc_0TrcS)20%qcq_m2iSa2iNr3Nm_2^NcX2mT2)Nqvrm7qS0iL3Sci0?U_ca0mm=)q7i2LS)L0LSS2c0_mcScLT027q0qz2S7__mrq=0NTNSX)Nm0iTrq2i>mLraL___NT_T_S)lNiTN7rqaaqiiSm_Yi?S}_2sNqTN_Tq7v7Lari_aanTrTLT_iXqqm00TaaTacaL7a_TiTSTLi_q)mNmT)T)qi7_m0r7i0iBrSL_Tmcq)022mq7c2imqaT_rriSmL)D2)ZNiTN7rqaaqr2LrarrrL0LLT;cN000r)i202TSra2iLcmLqLN02)T2r0r)r202LSva)LiST_)^Nci)c0LTNq02im)r7i0iLSrc7_i0_c*T7T&2cmc72aiLciiSqLT+0cT2T0TTa)i2_iSa2iTrcL00rncT2N,)c)L22aS72aNigcmL2_NR^qm02TT)c20rr72aLymSqcN00)mcm0mT_)airm27L_mrqW0c20))rcr0r)0)LidmTriim_)S_Lr_7ci2TT72_)La7707LircTL0LZ_Sc_2mT0)aiTi2i_S0iLcmSm_mV_ca2rTLm2q)ic7iami)S2Nh_r0iN2q)T_)a2mr!7_aarmc6L__acmq?0L2iqqi)r0Lmi2rNS10m_LT0Nq2Smi7)2_ii7Ar)rqLiNcOicq0Tmr)iqqmTSraiiqSTNrLi8qcT00TTaTqT2amia_LSS2LT_cc0qr0TT)q)2imTLTarL_Sr_7v0NccrT2)i7c22mLLmatxYrOLKW2cN2T0a2_qNi7r2SciirmS)_2T9cW0ST2q)qcmi7_S0im_SSLN09_NSNa)0m7202L7rS7r0rLLrTTc0cL0r7Tq0qB2S7__mr0Sa0T1N0d)mqi7m)m2mm_7a_rr2SL0m0TTS)mqi)qa*q?m6a2iNcTLNLS_LqTNaq_m_7LirrqS2,TSTSS0}biNN2r2mmS)aa_7a_TiTSTLi_q)mNmT)T_qSq770a2Sir2L)LNUiT_NrT7)02cqr72aiLcrLSN_0Uic))7T0TLqra77TiciiS7S)__c0T20T)c)i272q7_i0_)S0_cLrc2TS0a0L)_22mcr)a_iaSmc)__drc70i7TqTmcmia7a)r_L0c2fTNcNiT7Tqq_m0r)a0rcirL2cSH2cNNMmm)2qT2c70Lri2rLNm_q0NTr)_mrTrqrm0mLLMiiSNNrNm0Lea)_TaaTqTmT7iaq<mraLi_Tc0NiNr7T)_2qrAriLmaL>0LLTmZmNm0_Taar2Tm)a)iirTNT_0N_ci070))_qrm770a_L0rvLS_2c0)r0T)c)ia7i27_L2rNrqL2__*7TS02TN)V7S2O7cicr2rZNQ__0iN2T)TcqiacmT7)i)riST0T_a0_NrT7)0q_a)mL77aa<YS_ci^2))q02r)7a42Xm7Lrim+qLTc2zmZSNcTm)a2ZibmLLTiWSSL230TiN0NLTrm7q02LmraiircrSr_N 0N2q)T_)rq7miLTariSSS_0_r)rNiq2)02cqS72rSa%rcLc_2_y)jNqqi)m2)2_7iSciar)Sq0r3iT200mcm_amm)Srari)cmLT0ND6T00T07TS2TmqarLria*/Lr&7c0N_22T_)a2mi)7_aarmc(L__rW7NimT)T2c2i777)i_S0L7_Tccci070q)_20m2iiamr)r_LSLmc0N2)ST2)NqIrm72aNiIcmL2_NPYqm02TN)simm27Tacr0crL2_L)mNqqNm07marrymXaxr2SN0T__cqq620mm72aTmLLmamrmS_LaTrc2NLmmmi7Variaaq_3iQSX_2RNqTN_Tq7-qLaai_S__TJqNrLr:rN0NLm<)N202r7ii0iTcrL2_L)m)iq52Lmr2qrzm!a>r2SN0TATNcNiT7T)q_m0i2aTrcriL7Lqy_N0q)TTqcqim7mTa_r0_7LqLaUiN0NS2c)iqqmTrcaTi)S)Li_T)TNNqwTmm72N2SmL_Ti7__c=0mT)qr0rT)am20maLTL2L5Sc0T_TcTNi0q7mq02ar2SqSR_0S)0m_mcmN_0a7rqa2)mqLrar_2c)NaTTTiq0mr)rq)rm70aa&Tr7AtNS)TcT0TTi)qimmma)a_rSr7_0V20iNmT)T_qSqa70a2SSiLs0Lq0STi))0_2i)Jm)mqaiLcrLSN_0uic))7T0TLqra77Nr_iiS7S)__jrN70NT_7mqai}7mLTiLzSci0TU_NSNa)07ia_mamLa_r2Scc)__!aNmq)T_)rq7miLTiNL_Si_7_)c_NrT7)Nq_immaS6im,TSLNS0i)TN_TSTa20iir_a2iNrxNm_2^Tcc00mr)2qLiir77NL2r7NrLr+rN0NLmD)N202r7ii0iTcrL2_L)m)iNN22)7ir2r7ri0iLcFL%PSc20)0c)iq_a0m#aSi2S)SN_i}_N)N_TSTm20m2iS7LL0rqcSNi0)c_)i0!q)qqmircaLiNS0Li_)07N0NLTrm72Na_7ii7i)S_c)_r0iNmT)T_qSqa70a2SSrmL)LL0STi00q2TU7c2r77aNi__0Sr_S?2N)cGTi)_7)2qii7L_){0vS_200cm0S0Lq07720mL7riirrNrLr;Nc0022))_qr277i_TrN__Lip7z)N_q)Trmi2m7)7_iSiaL0_2NScm0)0LmS7im0i27FLcrrL7_N>_T0NrTS)22)qf7ia_L)rq5iLLT))0)ST2m0qmmSmLi0L7S0SL_r)TN0NLTraT202L7r_Ti0rLSr_i#rqrNrTN)022i)7_ari7Si0T+TNcNiT7T)q_m0i2aTrcriL7Lqz_N0q)TTqcqim7mTa_r0_7L0LL#rqT000BTSq_rm70aasT92crN20mTi0qmDTFqAm27N_Ti_SqNX_L0a)iq:2Lamqmmm7_aafrrLL__mc2N_NE7mq02aSTaN7L_0c0Nm00)^cP0j)2qNrTm_aq_mrfLS_2c)cc0iT_TN72m0ac7rr2._Sm_m#_ca2rTNm2qarcr_S7r0r+SS__)mcLq0T_qSqa70r7i0iLSrc7WqoaNiT0TS7c2imqaTLcrrL7_0ccAS02Ti2_q_m770icaLS2LiNc_icqNTT0)TiT2Tma7ii__SL2_T:cN02rT2)Ladmma)a_rSr7_0{2_aT_0i)7)T2_r2m{aer2SN0T_a0_NN27m27c2imm7)i2teSqciu2N)NNTimcqi2q7TSciirqLT0rVicmN)T27fq*mS72i)icSiL_N01)NS02)))N2im_r)a_iaSmNg__MaNm29T_)rq7miLTa_rqcpLLNr0_)_2Tmqarqrmra0aL/gSi_NTrT2)rqr2_qarTmTaTiirqNmLaticT00TiTriT2_7qL}iL_aciN5T0qmNmTm)_qarr7aa)iqcrLiN2c00cNS)27r227)7NiirmSc0TATNcNiT22i)L22mmrSi2rNSFcS.ahLN_T2)c7)2_maamL)rMLS_2c)cc0iT_q)q9mS72i)iNSiL_d002NTTcTiq7qTm_a0S7i0rLSr_i:rqrNrTN)022i)7_ari7Si0TQNdScLmT)0m_2i777)i_UTS__S_aN0NH077rqrm770a_L0rqS_L!0)c_NaTmm)q_2a7mL<i_rrS7_i)Tc_0qmn)L7riirESlUmrmLm__Raqr0r)7q0mc2Sa2iiL_rINrI7NcNiT7Tqq_m0rm7ai0rTcm_2T0T)N_0rT7qirTm_aq_drL ic_0_)TqTmrTrqrm0mLLGimr7L7__^mqm0T2))Lq72aShaLLiJrNTN_)mNm0c7T)_2qrp7LSrL_^L0T_TcTNi0q7mq02aSTaNSL_9NTLTUTciNqmm)0qarT7NrLLgcTST_Tzicq2mTq)cqNrmmmS0_0HNcvNi0Sqm0mTcaTq_mqS?aLaa__cLTT.TNT0iTqam2m7)7_iSi7L0_2NiZS0)0_)S)am072rSaL_0SqNS0iT)N_qiTR2)2q7iSciLrNL0_i4)T7000L)r77mTacair7r)L_=002NTTcTiq7qqm_a0S7ia__LN07T2)c0i22)rmcmNa2SSrarLL_p2cc))0_Taqma)m_7ra7riNT_Tccci070))_20a27TiciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TN)himm27Tacr0crLr;7c00cNS)2qi7_mca7i0ScrL_2biTcNNq2Taaca_i7a0S_rTL7LaR_T)N_0a)maH2_mr77iicTS__qT&T?)aTq7&)G2/72aN?TrbG__ic7c)0_Trq7qsm_r0aDrSST_00rcT0c0mm7722_r27qSiiLc)N0NSc2)00m)S)Lm0i7a0aviSS_0mK0ca2T200L702LSm7mimr_Sa0rErN700)cTS22miacair7rqL_H002NTTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2STLcw0)rNNq2)02cqL72rSi2rNSj0ms2cNN-mm)2qN2pSma2iNrjNm_2yTcc00mr)Tq)m)7iaTGTS2cM_qTmN)qITT7mq7iF7mLmrN4cLT_)c)Ni0T7T)a7_iQr7acrTS2LmV0)rNNqqmi7iidm577_rr2SL0m0aTTNqmmTmqm2_maLri2rLNmNm0NT2NamrTrqrm0mLL1iiSNNr_N_qTiqrmlTdqMm27N_TiqS2S&__c2cm2ITiqNiriSrmaa:rrrLrP0MLqH0L2iqmm)m)aiLcraS)LqTrci)2227cqcimmriciSS2LTLST,cL)iTq7NaqmTacair2_SL2_N 4TS0a0L)_22mcr)a_iaSmc)_r0ic9T))0qiac2i7qaTr0ST0T_TGaci0_2Sq22Tmca0_rrm92Lrccc_02qS)2qN21Sma2iTrcL00rI2cL2m2amT722aSr7rirS0SL0!,NN0NrTiq0qTrr72aL,mrLcTNL)mcm0mT_)airmra7ayr_u0LLNScacL0_)2qca)m_7aim_)Sqci0_TL)700TL)r2imrLrarrNS0_20)c_Nr07)iiT2ai_L0_N_SL2_NpWqm02TN)pimm27Tacr0crL2_L)mcLqTm0amqmmm7_aa3rS_c2_)TcNqq2Tq7c2Si27TLcriSmL)f2);NiTN7rqNa2iiSa_%isS?_2gNqTN7q_)T272L7_S)i_rrS7_i)Tcr)_Tim7202L7r_Tr0rLLrTTc0cL0r7T)a7_mNS7L2grSiLqDT)rNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2mm)a2_yriLN0r02T_)aq_)aiT2T7TaiiqcmL0_a)TT_q72T)Lim2m7ma_iacrL2_L)mNqqN2i7mir2r7ri0iLcjLN+0/rNiT0TTar22mLLmL0_rAm_NTrfrNrT0TLa/2mm7a7i_rmNmLL00c_0S07q0qtmSmLi0L2ST_c_Nc2)Z0Nmm)dar2LS)L0_rS2_)_Nciq022)N)q22m_77SSr2SNLyNSKDNcTc)2)>iOmNSram3TS)cS<qccNNmm)q70iTrrSi_,rvS70r92cL2mTqmN72iiriL*a4r9L2_N)Tcq020f)_222mSGairNcrLaLq0i)i2Y0B)K22mNLTaqL_Si_7_)c_))Tc2i)ai)m2SiLi_)SLL7_a)<N_qiTaaTmcSmamiccTSTc_h)N7002_TL22aS7mi)i_Sij_Lr07N0NLTrm7qaa_7NL7_2!cLiN2%r0c0N)2mS2a2L7_i2rcI)L__acm))0N2iq2m)mcaiLcrcE2_Tcc}L02qS)qqc2NSma2L0rNcSNiTTNc2mTm)ciT2grLarS_rMS)L79BNNTmmm))armma)a_ric0Li_qcT)cNiTq)T20mTLTaTiariL_NSc2NT0c)0arqLi2a0rciSL2cSu7T0NN2ST_a0i0iSaqicrNNm_200cNqrT773qK27Sr7rL2rS_c_iT2cq0_2))>2Sm2a0S2iThcLi_qcT)c0N22)aici_r7i0L_ST_7_ac_))0_TaqmiVm_7aimEbr_La_mc2NmmmTm)Lq_70SciirmS)_2TIcmN7T7)_qmrmmLS0i_SSS7^0Q%NSNL)0m22T7c7Ni2_<SNNm_oTrcL2)m07r227)7Nii%0c2L__acmqe0_Tr)72iST7_iqtYkiN2LLT0NLmmTmqm2_maLraLr_Sm_2y_Dh2mT0)aiTmNiLS2_NcmSm_ml_ca2rTT))2)mi7T_Tirn5Lc0mcN)ENrmm)%acmT7)i)riST0T_a0_)wq7TcqT22mma0_rrNIqNi0i)ZN%077rq22LSm7LLN_2c)0r_rcr000L7kqimNSrSrLq_iSL0}_Mc<02TNaTq_mqS-LTLr__LNTTOTNT0iTqamqami7Ti0rirr0T__cqqo0q2r7mi42>74i2rNNTLTN_cT07TN)_7)mNmqa2i_r7sS_25Ncp)STTm0qmmSmSi0L7r0SLLr}icr2r0r)Nq0m2r)a_irr7LiTTITT_0T)7qN2_i)7_aarmc(L__rF7NimTT_qqi^rcrrS_rNNTLTsTciNqmmTaqi2T70aiarcTS__qT!T_caq_)NiT2T7TaiiqcmSLN0T2)qqcTL)N20mi7)S7r0rLLrN7cTqT0mmm)Ti0i)m_aaimS2LmTm(mcLN_)07c2imm7)i2U.S6N<(T)Tcy2_mcqi2q7TLriirqLT0r}icmN)T27=qimNSraNLq_ici0>_zc{02TNaTq_mqS*L0aa__LNTT;TNT0iTqam2qi07NSSr2STLco0)rNcq2T)7c2imqaT_rriSmL)#2)jNmqi)27)2_maam_hr_Sa_mT<cq)i0L7)a0rm72aNiAcmLaLL:_N20c2))_qammr)ami7S7L__m)mcEq0T_qSq770r7ariSSS_0_r)rcLq20ST_a)mL77aaseS_ci0i)T2c007rqr2)Sm7dicScL2LlT3c_)i02q)q_mircaai)rqNr_N02)mqKmS)_immm7c_TirrSLSH0Zrqr0N22q0mcmNa2SSioSc_cn2o<q,0c2i)Lm)r0aiLcrTS)_)+icT2TT02_qNm7rqa_L)riLN0r_ST2)iTm7<202a7mLAi__a1__T)TcT0TTi)qim2aa)a_ri__SS47c0N_q)TqqSai70r2aq_cSiLqxTTcNi0q)T7c2imqaTLciiSqLTz0cT2T0TTa)i2_iSa2iTrcL00rkTc)0)Ti)TiT2rr1ac_mr!cELrTmNNqcTT))2)mi7T_Tia__cpN7lcNT02Tmq0irmNrqLi_icMLF_7)rN20L7m)LaNi2S)_rirSr_0_L)HNiTN7r7raqii7L_zi(SM_2%NqTN_Tq7naTari_aNuTrTLT_i(qqmNaTi)T20mimr_Ti_SqN%_q0r)m2?0&)Z22mNLTaTL_ST_7_dc_))TNTqq22_m7rSi2rNSocS!qT0NmTSTS20a7m07LarriSr0r_rcNN0T2m)q_2rm7ai,TrT?__Tc7c.0_2))_qammS3a_irr7LiTTE_Nq2;mcmr7_mNLTaTrTSiLqTmAaNi0T)0qiqrST7_iqh#f_SaN_cN2T0T)Tqi2qSm7LL0Z2cqNclLcN00Ti))77m0mLarL7STNT_aTmcT202)T_qa2m72amdmrmSLL_c0)c0iTm))22rW7{L3rqcTS(0_TcNi0q)Tar2imqaT_rriSmL)-2);NiTN7rqNaqiiSi_6i*SG_2ONqTN_Tq7ya0qai_aNGTrTLT_iFqqm0T20)N7Sm27Tacr0crLcN2w))c0iTqqTirmi7ma)r2c*LmNic2))0_Taqmidm_7aimh!Sqci_L))q0mm)2qN24Sma2iNr4Nm_2dNc&2mT2)Tqcm0Sra2iLcmLqNT02T_q)m!Thqpm27N_Ti_SqNhNiTTTAq0TLamqmmm7_aa.rSaL)_q)rNNq2m27aiTi_S0_rrrS)0m80ca2TTN0L70airNLrarrrL0LLT>cW0ST2q)qcmi7_Lm_i_SLaLLt_N20c2))_qammr)aurSS2_)_cciN_q0T}qS227)7Niir_ciL_QS#m00q7)q)a2i707SLcriSq_T0cciNm0))2aM2:7Sa2r)rcLi__Tm)i)ST2)Nq/rm72aTicS0Nr_2sLqm0q2Tm27_iTSw7}ibS2LNTTlrcS0S)0)rirmTr2i0ScrS_2NS/RNcTc)2)-i}mcriaci0%7_N_S,L2TT02_7_imS)72_XrGS70rFTc)0)Ti)TiTm0i_7ir7S0L_N)oLc7Nam1)q7iirST_cr0crLr_))mcX0c)cq2qyr%7_Sir2L)LqAiTcNT0)))qi2TST7qS_riL7N2F_T)Nm07)7q_2mSm7LL0r_LSNac0T7N_Tq7bqNaii_areTS2SL_r)Tca)L20)mim2m7ma_iacrSS&7VaN_q0TNqSqL70r7i0Sc9__2Ni37))0_Taqma)m_7aim_)S_LaWmT)N_0rT7qirTm_aq_^_ic0c!:aqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qmAmi7_af7a_TiTSTLi_q)mNq0cTNam2qi0STLr_mc<L!_7)rN20L7mqqaNi2Sq_rirSr_0_L)<NiTN7rqaamiiSa_EiQSP_2UNqT0T)c)i272)7_i0L2ST_c_ic7cq0_)0q7207cmri2ri+cLNN2Waqcq_27q07_mTa7aar_+)L__ru7NimTT_qqiemLraS__LNTLTgTciNqmm)qqc2NSmaTL0_*c2NJ07T_2mTm)ciT2_7qL iL_rcm0*_%c+02TNaT2T7c7ii7i)S__0N2cT0c0i)7)q2_70a7i0Scrr_2<iTcNNq2Taaca_i7a0S_rTL7Lav_T)0N0q)2q_27iSa2iNrl,S_0 a)r0T)c)i272)7_i0L2_iLm8)?_NSNm)0q2a_2m7ma_iacrLNN2waqcq_27q0q%2S7__miL40L_wSya00q7)0)L2ri7aqaariL0LS0cciNqTTmcqi2mm)a2_(riLN0TxrN700)cTS22mii_S0ivSSL2X)_{Ni0_m2ThqFm27N_Tia__LN07T2)c0iTm))22rj7qSir2L)LNZiTcNi0q)T7c2imqaT_rriSq_TTrciNm0))2ad2i7NLria_qciNiT{uAN,T2)NiT2q727Xi_S2Sm0QhiNN2r2UTq7imqSW7#i,S2LNTTcT0c0i)7))2_70r2i2ScSi_7_qc_00q7Tam_2Nr7S2Lcril2LrcccN02qS)a)L2_72acL)r_Sa_m0)cM0ST2q)qcmi7_S0i.SSL2!)&NNi0_)))_2S2ma0i2LSrLc0_qTS)iq)T_miq.7)7qii_criLq_Tc0NTmTTT)aqim_rSi2rTSc_0Trcr07T0qc)Sm27ir_i_S7L0xc_LN20i2c)N722aScS_L7S0M__Tc7ca0_2))_qammSQa_iaSmN?__?aNm2s)N)q22m_77SSr2SNLDNSb/NcTc)2)<ipmLSriT_)SLciB2N)NcTimcqma27TiciiS7Sq__c0T70T)c)aa7i27_S0ir_SLm^)hLNi)_Tmq7207cmri2riKcLNN2waqcq_27q07_mTa7aar_Z)LU05c20)0c)i7x2i777qi_42E7LaN_cNq722mcqia2mriciNS2sS_q00c_0S07q0q}mS7qi0_rrLNT_rTmNN2c2_7m207cmLi2__c0LNN2daqcq_27q07_mTa7aar_A)LkpSc20)0c)iq_a0m)aSi2S)SN_iF_T)NqqiTLa)i0iSa2L0rmLSLLc0T70Nq_)i272)7_S)ir_iLmX)E_NSNa)0q27Smma)aL_S.i_0N2wz)c0r)7qN2_i07riSr2L)SjJic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TN2_qim7m)a_irS7LN__Tmck0STq7)a0miS07iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crLT_)c)Ni0T7TqNaDmmr7iNL_Si_7_)c_))0r2iqmm)m_aSaaS0L2cSumN)NL2Smi20a2m*ScirS7LN__00cr0ST2q))3mi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTcTLiF7})N_2TT_qSqa70SiSSiLI0Lq0STi))0_2i)5m)mqaiLcra(2_0ccMS02TTqcqam2rZaN_mrEcr_qT))0qrT2q)qNmiS0L2iq_iSL0)T0TS0220)m2S2La0S7rTLcLi976)N_T022)7mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cSYqT0N_TST720a7mBr_irS7L0Ec_LN20i2c)r27mNScS_r2_iLTN)>>NS0q)0m2qn7c7ii7iTS__0N7JaT_0Nm772acmir2arScSN_2NScq)00_)S)7m0mWaSiqS0cr_Tcccaq722)_a22_maam_8r_Sa_mT9c_NaTm7Qq_2a7mL&i_raLm0yO_ca0mmg)_qr277i_Ti_SqNH_L0a)iqL2iamqmmm7_aaWrS2LLTmTi)Sqi2rm_2aST7TiTriSq0m30ca2TTN2;70i0rTS7_#i4Ss_2pNqTN_Tq7sa0iTriSNiLcmSm_mR_ca2rT2)LimiirrLTaa__LaTTGTNT0iTqamq-mcaci2i=cILL0rcT))0LT7)ai.m)riLrDTc00m&mcc2T0_)qaI2)iaS_LLcTST_TFicq2mTq)cqNrm7iS0_N:NcgNm0Lqm0mTcaTq_mqSBa)LrEiNxLuMpN20N7TqTmcmia7a)r_L0c29TNcNiT7Tqq_m077a0rcirL2_i0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNi%_SLqN0A_NSN7)0m7q=a_7ri7r0LcSL?2ci)c0r)7qNici_a2SirT )L/hScq00q2Tg2c2i777Ti_S0D7_q_aci000Smcqi2q7TSciirmS)_2TRcL)iT2q)qcmircamL2ST_c_ic7cq0_)0m72T7c7aL7_2S_c0_r0SNmT)TLqi7_mma7i0Scrr_2liTcNi0q)Tar2imqaT_rriSmL)32)yNm07)7q_2mSm7LL0r_LSL7c0cU0S0Lq072mTacaNr2eYLN0mzJ)rNLm)70arm2a)aNric0N2__^aNm2.T_)rq7miLTa_rqctLLNaTi)r207m)m2mm_7a_rr2SL0mIqTN)222mm7ArTmTaTiirqNm_qfccN2m0Lm0a0iqrHSiLLcmLm_c)Tc_0qmK70aTiamNS2rNcrSr_rc0cL2 T#qS227)7ciir_ 0NrM0NccLT20am_a=rirSiaiLS__2lcT)N_0a)m7)2mm7a7i_rmNmLL00c_0S07q0qm2777a_imcmSaN0_7NTTcTNq2a*mNSmal_rrLN)00TrN2T)TNqii0r2m2SSiESc_cM2Z{q*0c2i7ra)mL77aa3kS_ci_L)TN_TSTm202Bm7LraS_2S)0c0_T70T)c)i22aimai)icSicc_i qNT2rTL)N20mi7)S7r0rLLrN7c0cxNST_am2m7)7_iSi7L0_2Ni)TNiT7Tqq_qNi2Sm_0_)S_Lafm)HN_0rT7qirTmr7SiSS0Sr0r_ST200)cTS222rmSaSr0rrNrLL02(S0m)))c2irT7qLrrT/HSS07T2):0i)7)q2_r2Si7i_cSTL)1)ciNTmTTam_aZi7aNaSiLNT_0N_:SqmT0qc)rm27T7S_grq,iLLT))0)STmq)q_mii_7Lr7raL_N)g_ca0mm1)_qammSKa_iaSmNy__Yrc70i7T)_2qr/S0LT_2vTLLTmfmNm0_Taar22mLLmiq_Nc0NT0q)<cZ01)2qNrTm_aq_orL.ac_0_T4q0mrTrqrm0mLLEiNS0Sr_ic0cT2rT2)LimmqmNS2_2-mcmTTYTNT0iTqam20maLTaaiSrr0TMTNcNiT7T)q_m02?7?i2rNNTLaN_cNq722mcqi2mm)a2_UrqOi_2c)cN0i2c)iqqmTrcaLiNS0Li_)07N0NLTrm7qr2S7Si0ircrLSN2c70c0i)7)q2_70r7ariSSS_0_r)rNqq7Tr)S2S707r_rraf2SSL_T)Naqi)TaN2)mT7qa_iaS__mNT)rcSN_7T)7m77Sa2iqSTL2Lm02NNN2TNqcqTm07caq_1rLNT__T_c10c)cq2q!rl7_SirqL)L_xiTccL0_TT)2qLmqLmi2S)c0_iccci072q)_20a7707Lir4mL7_SBNc_NcT0)Nqpm0mTS0iLr0SL_S_jc_NSTN7r2TiG7iLmiac0LT_)c)Ni0T7Tq07_maa7i0r_Si_702c_0)0_)S7am072riaL_)S_LagmT)c22_mcqa2)mqLraS_2c2NuMiN7NTT_)rq)rmmLS0iq9SciN)^mc707T_)mimm2r0amrSrL_0N7Q_Nq2jT_qS22mia2SiL_{Sc_TmnmNm0_Taar2a777)L___L2ci_ccrqmT0qc)Lm22iSciirmS)_2T6cL0S0770a0mii_7)i)!rL2f)bNNic_2))_qammr)7_rSc7Si07T2N_q0TLmS22mN7{SSrmL)L_%Se700T22i)rim7cSriNeTL0N_0cJiNq0T)0qTrTmT7aair_.S_2hTcc00mr)2qLrmmLacaGcmLmU)&_NSN7)0q2qTmT7iaq^mrLc0_qTS)iq)T_)rq7miLTaaL_Si_7_qc_))0_Taqma)m_7aimKyS_Lr_7ci2T0rTSqSm0mrLria_7LNLS_LqTNTq_m^amiNSrari)cmL0_a)TcT)L207cim2m7ma_iacrL2_L)mcmqN2Famqmmm7_aa3rS2LLTmhm)Nqj7m)m2mm_7a_riLS_LmE2c_c%mm)0qarTmTrLLicTST_TAicq2mTqm0q_mSm7i0iBSSLq{002NTTcTaq2a+mNSma^_rSqN)00TrN2T)TNqii0r2aNaqr2S_L7NSc2NN0^2Sqmm)m_aSa7S0L2cidmN)N_TSTa20m2iS7LL0rqcSNi0)c_)i0Uq)qqmirc7iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crLaN2c00cNS)2qTmcmaa2SirmL)LL=i)TNq2r)T782ar7S2LEriL7LqG_)2qiT0TLqrrT707!aSr_Nm_0ZaqTNTq_m07*rmmmami_raNr_rc7N0Tc0Sq22ia_7ri7r0LcSLY2ci)c0N22)aici_r7i0L_ST_7_ac_))0_Tr)72iSTaTrcriL7L)l_N0)2TTqcqim7mqa_r0_7Sac_>N)7q22c)i722racaNr2_SL2_Nthqm02TN) imm27Tacr0crL2_L)mcmqTm0amqmmm7_aa1rSr_7/0NccST2)im_2c77a0rciLL2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_Nr07)iiT2_7qLQ_T_r:_Lr)TcT0TTi)qim2a7iaTr0SiSrTTG_Nq2F0VmaairXm*atr2SN0T=TNcNiT7T)q_m0i277rcriL7Lqf_N0)70a2_qNi7r2Scii_2SrPc%NN2)STaTLq_m27cS)i_raLmN)p{NS02)))c2im_r0a)rSS2_)_NciN_q)TqmiqLr)S0SSr2n0LmQS=L00q7T0)Lqrmi7r_rirSNL0Z2T)N_0rT7qirT7TiciiS7S)__c0T2N7)c)i272q7_i0L7ra/__NT7)2qcTim2qr7c7Ni2LSS2LN_+)mN20NTQam22mN7x_mr2SNLuTmc2NN0(7mq22Tmca0_rr2SL0m0iTrqTqr)qaPq{mea2iNcTSq_2_(c_020m7xqimNSrS_LwoT&D_a)TcT0TTi)qim2{7cicr2rIN/_c0iN2T)TcqiacmT7)i)riST0T_T0_NrT7T)acaL72rSaurcLc_2_y)ZNmqi)m2)2c7iLcar_7LT=c_SN2)i0:m)qimNST7rLq.mN0LrArN0NLmf)i2NrT7TSmLiSm_)_cTS)iT0mi)T2Tmi7q_miLl0L_}SVa00q7)T2cqSr7S)i__0SmcSG2cNN-mm)2qT2c70a0iaPrSrcL00cs0S077)a0miS07rirS0SL0ZpqTi02)))N2iic7ri7i)cccSg20icQq)T_)a2mr6aNaqr2S_L7NSc2NN0/2Sq02aSTaTrcriL7L)%_N0c60/)2qNrTmar_iNP7c2Nc5icmN)T27(qqai72i)iNSicc_i?qNTqc0i)qqTm07T_TiTraSi__0SN20TTcq0irm27L_mrmL)L_wS+700T2TTqT2imqLmaL_0SqNS0iT)N_0rT7qirTmar_iiS7Sq__0)c_NaTmm)q_2a7mLui_raLm0zQ_ca0mmD)_qr277i_Ti_SqNk00T))mqNTLamqmmm7_aaVrS2LLTmTi)S202rqqi12:7&i2rNNTL_Yq)!NLNa2_7_icrqLrarrrL0LLT{cmN7T7)_qmrmm7S0i_SSS7D007crNSTSq0qrrrmrS2r0LcSrX20Sck0c)cq2qHr;7mSii7c)NNTm-/NcTc)2)JiGmcriacrrL7L)z_)mNITST7a)i07iSEirS7Sr__T2 2)STq)cqNrm72S0_0QrSm09*dc72rTrq7qrrc7ii2Lir7_)__ci)c0iTqqTacmT7)i)riST0T_)0_cST7m2q_22mLLma7<tr>LoY2cN2TTTqcqTm2ii77_?rqxi_2c)cN0i2c)iqm2)72Luiq_iSL0)T0TS02TN)k7Sm27Tacr0crLT_)c)Ni0T7TqNafmcr7iNiSrL0T_V0_)Z2mmNar2rm)Lmi0raNTLjNOTS2T0T)Tqi2qSma0iacTS,cx0_qTNTTT)iqqrm7qS0i_SSS7<0uWNS0q)0m22T7c7ai2_HSNNm_:TrNq2)m07r227)7Nii60c2LqNi:Lq)202Sq2a0mmaSaLS0>7_0_HuSN_mm)0qarTrmr-imcTST_T-icq2m0a)iqTm07i7r;Tr_Lq0ATN-a)_TmaTqTmT7iaqGmSm_)__cSc7T0)2mi2i7)7_iSiaL0_2NSyL)00qmS7ia)m_riaBS)Sq_i0ccLNNT0)iq)a7707Lir_7LNc_*iN7N)T_m)q)ai7mi)i_SSSas0c2TS0m)))LaSiia0S2i7=cLrM7cNN_q0T)qS227)mtiir_,)LqNi#Lq)202Sq2a0mmaSaLS0n7L0_L+rNi0r7r)r2Nm0a2L)r_SrL7JiqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m7qaa_7NL7_2tcLiN2<r0c0N)2mS22mN7x_mr2SNL-Tmc2NT0c)0ar22mLLmiT_NJ80m_mcmN_0a7rq22LSmaTLN_2c)0r_rcr000L76qL27maLjia_icaNLTmTBqamf)xq7rr72aL}mu2cT_r)mcm0mT_)airmar2i0ScrS_2NS S)00Z)Sq2m)mNaii__)Sd_S}q))q0Ti2_qca77TiciaS2OiLSc)c_0S0mq022aS7a7Li_S2LcN)p_ca0m2))A2Sm2a)acriS_c0R0cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aqaariL0LS0cciNqTTmcqi2mm)a2_8rLUi_2c)cc0i2c)c72mTacair7rqL_G007NTTcTa77a2m_r0a)LSSm_)_LciT_0c)7q0mc2ra2ii_cSiLqXT)rNi0mT)q2iZmiaN_rrmrqci0r)Pck03)2qNrTmqa2aUr_L2LmTBci0Nmr)m)qair7LFasrWL2_N)TNN)_Tiq7q)m_7ri7rNS_c0_&cSNqT0mr)LiTmrSmiNZc-_Nm10NccLT2m_a02Ni27a_c__d7_0N_cT070a)_7)mNmqa2i_r7#S_2JNcD)STm7mq_mSm7i0_mS0_cLLc2)_qcTNm2qarcr_S7r0__LT>7{aN_q)0_)aqmm27m_mimrLS_x0TcNi0mT)q2i mLrii2S)Sc_itmN)NLTi2_qrm77Na__mrac=_mTTcLqS2i7Tq_mSmai0_i6_SLN0*q)Sqi2))_7i29a)aqrincLi_qcTqr0iTqqTirmi7qiTprSiLqtT)rNi0q)Tar2imm7)i295Si_NTrca)qqimi7LaSSm7mimr_Sa0r_Lc_NmT2)_)Yrm70aa&TSNp>N_Tc)22r0r)r202LSGa-rSS2_)_cciN_T)T_qSqa70a2Sir2L)SlliTcNL0N)0qi2)i7a0aLrrD7Lr_ScS000r7rqaimm%SJi_+mS7Nk1q)m0)2YTram2Sr}a0_mi_cpLdTmN7q8TLm7qTa_r*S7icSTL2_mc0qrNr2q7iairo7Da7jrS2LLTmTm)Tq2TTarqrmra0aLXISi_NTr?r)q207r)r2r707L_uriLN0r_rTqqNmrTrqrm0mLLoan_ic_NL07N0Nf0S)_immma)icri__LqN7c0cL0r7Tq0qn2S7__mr0Sa0T_T_L)0207m)m2mm_7a_riLS_Lmo2c_czmm)0qarTr0mLL0i!NmLmomc_Namr)q7227acaar7S2L_6007NqNaTiq0qSic7iaqrT=cLSN2cN0c0m)2mSq2mNmna_izc?Sn_qM2Niq7)0)gqSm_LmiN_0S)_SFqN)00Ti)_7)2_maam_Yr_Sa_mTnc_Nr07)iiT2_7qLF_0_rSm06_nck02TNaTq_mqS0L0Lr__SrTTpTNT0iTqam2qmc7N_mr2#0N00cT5)7qS7mqm2cST7_iqh}ccca_m)}cJ0J)2qNrT72r_aL_7LqLaEiN0NS2c)iqqmTrcacL2STcc_L}NN00iT)m7202L7rS7r0rBSS__)mcSq0T4mS22mN7-_mr2STLcz0)rN20Lmi7aqNi27T_rirSr_0_L)bNL07Taav2qiiSiLEPm=QNiT4c=N7mr)2qLrmmmSN_TcmSm_m;_ca2rTmm2q)ic7LaNr0SiL)N7c0cL0r27qN7_mir7iqiaSi_0_STcNi0q)T7c2imm7)i2bUSrci_7T)N_0a)maO2_maam_xr_Sa_mTXp9)i0m7)a0rm72aNiwcmSLN0wq)Sqi2))_7i2/a)aqriycSrN2Tm)cN7Tr)_q9miLTaTLLc0N0TmcmNcmTT_qqiOitrrS_irNTLT6TciNqmm)0qarTmTrLL0_LNmLm*mc_Namr)2qLrmmmSN_ccmSm_ms_ca2r0L)_qmm27_7PfmS0LaTT:TTLqa7T)T2Tmi7q_mimY0N20qTcNL0N)0qi2)i7a0aLrr47_TcccS02qi)N7)q_ma7mi2rmNmLm_Lv_002c)iqm2)72L}a._ic_NL07N0NLTraT202kmSa_wmS0LaTT:TTLqL7T)T2Tmi7q_mrqScLNTmc2)020m278aircLmimrcNTL_jq) )_Na2_)rrTmTaTiirqNm_N00c)0STqq)20mi7_S)rNrqL2__p7TS02TN)b7Sm7r0aLrSST_0N7cqca0i)0)Sacmi7qiT_cSiLm_)c2q>Tc2iqqm)mraiLcriSq_TTrciNqTT7rqi2mm)a2_MriLN0r0_Tq)i0m7&)b2P72aN#Tr_Lq000xTrNmmzT+qHm27N_TrNrSSLTTjaT_q_2_7ra)iaLTiTiScBLikN)r)_qqTTarqrmra0aL}kSLciv2T)0N0q)2q_27iSa2iNrVOS_T00cc)STaTLq_m27cS)i_raLmN){_crN7TiaT2Na_7iS7r0rLLrTTc0c%NST_am20maLTaTLLc0NNTm*mNm0_Taar2am)7q_rriP2Nq0q)T)S2)7rqr2)Sma0iacTc)SL00xw2m0m)mq_2aSra_L2rqcc_LZNN00iT)m7202L7rS7i7__LrN7cqca0i)0)Sacmi7qiT_cSiLm_)c2qQ0)2iqma)m_7aimE8S_Latm)4N_0a)ma{q(ii7m_):0Nm_2!NcF2m0Lm0qqiSriS)i__iSYd)UqNiqcT)m2207cmSi2rTLcL)(20iNmT)T7qiiTmra7aSZc.__20_ZL)00qmS7ia)m_ria?S)Sq_i0cIr)22mmc)72rm_7eiicTSTcLT0)02mTm)ciT2_7qLoa!_ac70v_#cD02TNaTq_mqSWSLLr__SrTT^TNT0iTqam20maLTaTL_w0cLTmEmNm0_Taar2r77a)i__0SacSK2cTNcT07r)ra2riSaL)r_Sa_mTQc_Nr07)iiT2_7qLxL__iV_Lr)TcT0TTi)qimm7r0aLrSST_0N7c0c+NST_am2Ni07)iSrqL)_0eic_))0_TaqmiYm_7aimhpS_Lr_7ci2T0_)qa!iNirr_arcTST_TBicq2mT0)aiT2TiLS0_TcmSm_mE_ca2rTa))qqrr7iS2_2!rNTNiTNqr0rT)am20maLTL)aLP0SgTm&mNm0_Taar2_i27qLcrLSN_06ic))7T0TLqra7m7r_ir_7LqLapiN0NS2c)iqqmTrcaiimr)L20?c0TiNa2))_qammSja_irr7LiTT-_Nq20mNTa7_2rLTaTrTSiLqTmlaNi0T)0qiqrST7_iq(}r SaN_T_2T0T)Tqi2qSmaqL0r_RS_a_Lc_02Tcm)q_2a7mS)ir_iS7N)__caNmT2)mim2mmL7_r0McLi_m8)N22pTrmiq7i)7_aarmcJL__acmqA0_Taqmiy2?riamK)c00mp2cNNpmmTL702qrSSiL)r_wiLZc)cq0i2c)rq)rmmaaia!r0Sa_N)TNTTcTiq7q)m_a0a_iaSmNB_q0icL2)m0mS22i07miSiLL0c7_S0_NiT7T)q_a)m2riaci0o7_N_SBL2TT02_7_imS)72_Rr S70r_2T2N0)c)i22aS7qaciNcmL2N0TT)r2702aT2T2SS(aTLir0_)__ci)cTc22)mmci_a2SSraM0LTYSTa00q7T_qqip7)riS_rrNT_2_Lcr2TTq2L7027Sm7mimr_Sa0r90N70qT_m02)mS7ai0L7rm_cN_c2TiN_2))_qammr)a_iaSmc)__eaNmq)TqmiqLr)S0SSr2K0LmkS3L00q7Tam_2i777qi__)r_La_mc2NmmmTm)Lq_70SciirmS)_2T}cmN7T7)_qmrm7qLTirDrLi0Ts))r0NmTqcar2mSTa7_rr0NT_2Trcr2T))7r2ai)mFSi_rI)SS_Bc0NT0_7m)maNr2S2_rrrS)0md0ca2T2T2R70qbSm7mimr_Sa0r62cL2m0mmN7_rmmmami_raNr_2VLqmNm2NmLim2m7ma_iacrSrN2Ti)aq)T_)rq7miLTiTScSS_2NicN))0_Taqmi9m_7ra7riNTL_Pq)^cpNa2_7_rTmTaTiirqNmLasicT00TiTriT2_7qL8L_iaV_Lr)TcT0TTi)qimmNr0a)rSSq_)R0ciN_q))N)q22m_77SSr2SNLUNSc7)00L)SqTm0i770aLirSiLrTr4rNN00)27)2_mr77iicTSLc_6cN70N)c)_22mircaiiqSTNr_iuqNT2rTi)mq)m2S&airNcrc_Nm(TqrNrTrq0qLr57iiN__s_cmNi mqIN T8q22NSTaNaSiLNT_0N_T_)S2rm)77rT7T7S_1riLN0r0STqNTmrTrqrm0mLLQr0_iSaN)cNcq02T_)77Sm27NatLSrSc0_-0SNaNLT_q22ci)7_aarm.)L__r{7NimTT7m_2ri7a0aLrrNT_0_DASN_mm)0qai2rqmLL0i:NmLmEmc_Namr)aq)2qSraNL2k2cr0T0r)22rTr))imm07a_TiT_Lc(TTDTNT0iTqam2Ti07cSSrarLL_/2cc))0_Taqma)mLrii2_)LNLq>2c_N7qS)2qN2fiSa2iTrcL00r,mT2N)2c)iqqmTSraiiqSTNr_igqNT2r0rm2qTrcr__Tr0rLLrTT{aT_0Nm772acmir2arScSN_2NS1m)02T2S))2mmi7ri2Y9r+ca0_T_2TTTTSa;2i7NLrLr_m(iLmTEJ/NRT2)NiT2_7qLvas_a:_Na)TcT0TTi)qimm07a_TiT_LcSTTnTNT0iTqamqami7Ti0rirr0T__cqq;NX2a7qiM2n7>i2rNNTLTN_)0qNqS)a)L2_72acL)r_Sa_m0)ch0ST7q0722Lrc7iiqrTL0_T)TcTNa0i)_7Sm27Tacr0crSrN2Ti)aq)T_)a2mrR7_ari7Si0T__cqqUN42a7aiI257(i2rNNT_N_ShL2TT02_7_i0rrS2LScTLTLSTHci0Nmrmi)qaimmL;a>r%L2_N)TcL)_Tcq72N7c7_i2rivcLL_Nc0Ni0)27q0qLmrr7i)L_Sa_7_!c_))TNTqq22_m7rSi2rNSDcS;2cTNcT07rqSa27NicimS2AS_2<NcV2mT2)Nqyrm72aTicS0Nr_23Lqmqi2Nm2qTrrmrarr0rLNO_icN)_qr2m)Tir2r7ri0iLcxLL_7=aqo0q2i7iairmScLqDwSgL7Trc2NLmmmi7NqWSm7mimr_Sa0rAaT2002c)LqNm07ia)L7S0SL_r07ct)_0Sm72q2a7ii0iSlcLi_qcT)c0iTm))22r>7LSir25)L__acmq10_Tr)72iST7_iqRJrWca0_TL2T0T)Tqi2qSmaqicrNNm_200)NqN2Dm7acrm7mac?Tr_Lq0uTcHa)_0raTqTmT7iaq{mSic0_N0SNaNLT_q22ci)7_aarmH)L)Nicm))TNTqq22_m7rSi2rNS{cSB2cTNcT07rqca27TSciirqLT0r1icq0Tmr)iqqmTSr7rL2rTNcN_)TN0NLTraTqaa_7NL7_2FcLiN2br0c0N)2mS2ci07_iSi7L0LWbScc00q2)T2c2)72S^imS)S7NS0iN0qi0a2_qNi7r2Scii_2Sr4ckNN2)S0mm0aTaSm)amiirrL20{_%Taq_2_aT2T2SSwairNcrSrNqT)qrNrTrq0qLrV7iiN*r#acmNi.mqJN-T.q22NST7_iq-?r*ciN_Ta2T0T)Tqi2qSmamr)ScLic_dqT7000!TSq_rmmmS0_2yqcc_iRqNT2rTi)mq)m2SpairNcrciN20icm2s0,) 22mNLTi)L_Sa_7_Uc_))0_Tr)72iST7LS_rcL7_Nccc_02Timcqi2q7TLriirqLT0rAicmN)T27&qimNSrSLLm_iSm0,_PcF02TNaTq_mqSK7>La__c1TThTNT0iTqam2qmc7N_mr2Q0N00mTo)2qL7mqm2cST7_iqBoccSaN_hr2T0T)Tqi2qSmaiL0rNxS_a_Lc_02Tcm)q_2a7mS)i)_iLmN)cNcq02T_)77Sm27Na{LSS2LT_cc0qr0_22)qacmi7qiTHrSiLm_)c2q!0i)N7_aL2qriam&Ar!L,!2cN2T0q)2)o2_727m_=riLN0r_r?q)i2i7{)l2;72aNuTSNE__i07NqNaTiq0qSic7iaqrT8cLmN2j))cNiTq)T20mTLTaTiariL_NSc2NT0c)0ar2mi27)LcriSq_TTrciNqTT7rqi2q7TLrar_2ST0c0_qT000L)riT2ai_aN_7W2cc_i02crTcTNq27Smm7c_TiqS2SrL_tqcL2xT!qS227)7ciir_SiLqxT)rNNq2Taaca_i7a0S_rTL7Lad_T)N7qi)22)2c7iSca2_2rSS_0)cLN70a7Qq_airiLTXcr0Nr_r-)qmN_20T_2Sm2a0S7rNrSSLTTc0T_qBmma)q_rR7Pa7orrec2_iNcNiT22SqSa0mTaSLiS0U7_qN_=H072q)_7)2i7NLrrc_2Xi_mTFN0NaTm7o2Naai_a)bTrTLT_i%qqmN0))qN2ia_aci7rqS_c)_TcS)iT022T_acmi7qiT_cSiLqBTTcNi0q)T7c2Ni27a_c__57_0N_cT070a)_7)2qiia2r)rNLiNc%icq0Tmr)iqqmTSraiimr)L20M{iNN2rTamma2i7ra_TiTSTLi_q)mN00a7TqN7Li0S0L)_rcVSM_3c2NNmT)N)SqLST7TS__r9_Nr0qTa2TTTTSa;2i7NLriaiqwiNi0ST_2m0m)mq_2aSraTi)S)Li_T)TNNqcTa))qqrrmrS2_mR%ciTTcTcS2wTiqNir2rrmSi_ac1Sy_kc2NNmTT_qqiWrTrramb;r{Lgf2cN2T0_)qaViNiir_arcTST_TXicq2mTmq)q_mSm7i0r2_iSSF)Q_NSNa)0q27S2Lr0aq_SQic)__0icWT)Tqqiacmi7ma)r2cKL-#Sc20)0c)iq_imrirSaL_0SqNS0iT)N_qiT}2)2q7iSciirqLT0rVicmN)T27YqfmS72i)icSiL_N0,)NS02)))N2im_r)aqLirLN)000SN2q0TmqSqL70r7i0iLSr0TV0E+cS0_7mq02aSTSTSLirNTLT,TciNqmm)m2)2_7S77r0S2(iLSc)c_0S0aq022aSmLS0iqFSciN)U_TiNW)))q2iic7iami)S2N^_icNqrqS0qmiqmrvmva(r2SN0TQNWScLmTTum_a_irSrL0_7NT_T_S)(NiTN7r)raqrTLrarrrL0LLTQci0Nmr)Nq)2TSrarr7S0_cLSc2NiNmTm)_qarr7NS2iaccc_N7c0c{NST_amqLi07_iSiaL0c7Q0%LNrq7)q)a2i707SLcriSq_T0cca)2T0qc)Sm27TiciaS2wi_mc)cL0imT)r27mNScS_r24_SLN0dq)Sqi2))_7i2ha)aqridcLL_Nc0Ni0)27q0qLmrr7i0iDrSL_Tmc0NamTTa)SqrSTaTrcriL7L)G_N0ct0l)2qNrTmar_iNG7c2NcwicmN)T27Xqqai72i)iNSicc_i!qNTqcTi)q2Trr7iaqrTcrLi_qcTqr0iTqqTirmL7Ni0riS)c7l0HLNrq7T72c2i777qi_S0 2_Tccci070))_20a77q7aiiS0SSNcZicq0T2c)iqm2)72L3i)SSL28)MNNi0_20)=2Sm2a)acriS_c)__jaNm2<T_)rq7miLTa_rqckLLNrTi)SqS7m)m2mm_7a_rr2SLN5F2N)NcTi21qrm770icarS2Li00_rcr000L7wqqai72i)iNSicc_iBmc)02m8)q7i2LS)L0LSS2LN_U0SN20TTcq0irm27L_mrq/NN00)T7q6NKT-q22NST7qi2iAS__2_m)eNiTN7r7_icrcmLL0rLNmLmOmc_Namr)aq)2qSr7rL2XmclN_)TNTNSm1)i2Nrrmr7qLix_c_TTlTNT0iTqam2qmc7N_mrqy0NcNjT?)7qS7mqm2cST7_iq9pr}SaN_T_2T0T)Tqi2qSmam_mr_LSL7c0)m00)cTL22i_rcaNL2raNcN_07N0)_TTq7qam_r)iNiqS2L__70SN20NTomS2m7)7_iSi7L0_2Nici0)0_)S)am072rSiaiLS__2ocT)N_0a)m7)2_mr77iicTLT0TbiN7N)T_7Tq_mSmai0_i_SSLN0(q)Sqi2))_7i2?a)aqri.cLi_qcTqr0iTqqTirmL7Ni0riS)c7{0eLNrq7Tr)S2S707r_rr_cmL60ccaN)0q7rqaa2rmSpLrcTLTLST!ci0NmrmL7mai7qLFaYrUL2_N)Tc_0qme)L7aiaSw7ziFS2LNTTp_Nq2bTLmi7_irLTaTrTSiLqTmci)00_)S)am0i77.S_rrL7_2}_caN)0q7rqia272LcL_emL0bc_rN20T0S7{qrai7TLN_qST_c_ic2TS02TN)B7Smma)a_rSr7_0I20iNTq)T_)rq7miLTiTScSi_7_)c_00q2)T2c2i777qi_S0L7_Tccci070T)_20m2iS7LL0rqcSNi0)c_)i04q)qqmircaiiqSTNr_i%mc)02m;)v2Sm2a)acriS_c0_IcSN2T)TNqi2_ri7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cS=2cNNjmm)2qT2c70Lri2rLNm_q0NT2qi2m7I)>2w72aN TrqL2LvF_N2Nmm:)i2Nrrr_SqrNcrSr_rc0cL2OT6qS227)7ciir_d0L).Sc20)0N)iq_a)mqriaLA)c0cSH2T0NmTSTL20a77q7aiiS0SSNc{icq0T2c)r27m0ac7Sr2Si8__rc7N0Tc0Lq22irc7ri7r0LcSr52ci)c0N22)aici_r7i0L_ST_7_ac_))N_Ta)m22mmLmamiLr__00cciNm0))2a<2w7Sa2r)rcLi__00c)0ST2q)qNmi7_S)iq_iSL0)T0TS0220)m2S2La0S7r0rLLrTTc0cL0r7Tq0qLmrLTa0iLrrLi_r)rcr0NT0q2a)m_7ra7riNT_N_S#L2T0T2_7-imr2Lrirr)Nm_0<aqTNTNLm0a2i2Sr7rirS0SL0s5Lc7Nam )L7ii7rmLm_c<)N4_Y-7qr02TLamqm2Nr2L2vrrrLr80*Lqk0&mkq2m)mcaiL;riL7Lqk_)2)70a2_qNi7r2Scii_2Sr cxNN2)STaTLq_m27cS)i_raLmN)jANS02)))c2im_r0i0rSS2_)_NciN_q))N)q22m_77SSr2SNLQNSc2NT0c)0ar2rrra0rciSL2NrR2N)NNTi707)2qii7L_)(0-S_200cm0S0Lq077m0mLarRTS0SL_r)TN0NLTraT202L7r_Tr0rLLrTTc0cL0r7Tq0qLmrLTi0ihrSL_Tmc0NamTm27ia2imaN_rirSr_0_L)eNiTN7r7_iNrTrAiacTST_T:icq2mT0)aiTmNiLS__N!NNrLr6rN0NLmj)i2Nrr7aSm_2FacmTT;TNT0iTqam2i7)7_iSiaL0_2Nicm0)0_)S)7m072rSi2rTSc_0Trc2NLmm)q7Ti0rqS0_zioS*_2wNqTNr0S)S202rSr7SL2S0_cLSc2TSN6Tcqc222zSeamLiSm_)_ccict0c)cq2qtr;mYSirmL)Lc0STa00q7T_qqim2?raLr-2rzL#*2cN2T0_)qam2miaamr)rccSNic0)iNTTT)iqqrmmLS0i_SSSa5007N0NG0S)_immma)ac_S{7_0N2fr)c0iTqqTirmi7ma)r2S2LL0RIP)T0k)S)7i)r0ai_0irSr_0_L)HNqqi)22)2N7iSciirmS)_2TBc>0S077)acmii_aTL7S0SL_r)TN0N*0S)_immm7c_TiqS2SrL_{qcL2XT_)a2mi)7_aarmc3L__acmqD0_Tr)72iST7_iqZ/c0Nq07#N)2TN7r)r2r707L_(rLS7LaTncm)i2im2ama_rrL{ifr7Nr_2<Lqm0q2N70aqi2SI7hisS2LNTTcTcS2=TNq0qm2i7NaanrSr_7^0NccST2)iq22NmELmiaiLS__2/cT)N_0a)m7)2!7Sa2r)rcLi__00)r00)cTL22qai_Sw_i_SSLN0Vq)Sqi2)qNqqm27_a7LSS2LN_I0SN20TTcq0irmr7)_miaSiSb_0daNNmT)T2c2i777)i_S0S_LaJm)*N_0a)maB2_maam_Ar_SrL7HiqTN_Tq7nqLari_S__NE2NrLrfrN0NLmg)i2Nrrr_L0LIiLc0_L)mcm0mT_)air2L7_amr2S_S:Tmc0NamT)NTLa0r0SqLi*6r4LR92cN2T0rTSqSm0mrLrimUmS7Ncuac)Nqmr)a72imrdSa:TSTSS0(oiNN2r2Lmq7imqSu7Mi*S2LNTT=_Nq2jTLma7_i_LTaTrTSiLqTmc0NamT)NmLa_ST7TiTriSq0mwmN)N_TST720m2iiLTiiS7Sq___NT2qmm0m)qqaimLL)_0_SL2N0emNSNL)0m7202&mSa_ mSmNm__cSc7T0mmq0mc2La2L__cSNc2_a)c)_q7)0m_2T777ai__)S_LaKm)kN_0rT7qirT7TLTiiS7S)__TTc_0S0aq0aiaSmLS0iqzSciN)h_TiN5)))q2iic7iaqrTcrLi_mt)N22%TiqNirmarqLTzrrrLr#0ILqp0i)Nar2aiqriLa -r*LKV2cN2TTNTS)LrTmLr_L__icrN20aqT0T0S7nqimNSrSaLqSNNrLrvrN0NLmZ)Z2Sm2a)acriS_c0I0cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aqaariL0LS0cciNqTTmcqma270icaSS2pSLS00cW0ST2q)qNmi7_S)iOSSLT0)T0Ni)_Tcm72T7c7mi2LirS_)__cScmT0)2mS2a2L7_i2rcb)L__acm))0_Tr)72iSTaTrcriL7L)B_N0)2T2qcqim7mqa_r0_7Sac_;N)7q22c)i722racaNr2_SL2_N&^qm02TT)c20rr72aLymSqcNN2TmqrNrTrq0qLrs7Ni0irSi_0_T)rN20L7mqqaTiuLmamrmS_LaTrcr07T0qc)Sm27ir__mr_LSLac0Iq)i2r72772ai_aN_7I2cc_i02crTcTNq27SmamLa_r2Scc)__RaNmq)TA7+227)7cii_/Si_7_qc_q2q7Tam_2Nr7S2Lcrin2LrcccN02qST2qNq:m_7!_*iWSqL2UiT7000ATSq_rm7mLmi_SSS7o0TmN0Tc0Lq2a_ic7NS2iaccc_N7c0T_0T)7)a2_i)7_aarmcxL__acmq-0_Taqmizm_7aimy}LNLq+2c_N7qS)2qN2IiSamr)r_LSL7c0N2)iT2q)qNmir_arr7S0_cLrc2Niqc0i)qqTm07T_TiTraSi__0SN20TTcq0irmT7)i)riST0T_7TtNmq7)N)SqLSTaNS__PcmNNTrcrN)mm)0qarTrqrLL0rLNmLmxmc_Namr)2qLrm7qSNL2=2NrLr-rN0NLm#)i2Nrr7aSq_2crSr_rc0cL2nTyqS227)7ciir_;0NrF0NccLT20am_a+rirSaL_0SqNS0iT)N_qiTo2)2q7iSciirmS)_2T3cOqxT2q)qcmirWair7rqL_0207ca)_TN77a2ic7iS2irLcLN>20SN20NT<am22mT7ci0DrSrNr;0NccST2mrq2m)mNai_0_)Sqci_L))q0qS)2702m7S7Lr0_7L0LLVrqT000<TSq_rm70aaXTSN/LNr)TcT0TTi)qimm07a_TrN_Lc00N)mcm0mT_)airma7)aq,rSqc202T0qTq_mNar2rm)Lmi0raNTNNNLca2T0T)Tqi2qSmamr)r_LSL7c0N2)iTiq)q_mSmai0r2_SSLN0#q)Sqi2))_7i2oa)aqrizcLL_Nc0Ni0)27q0qLmrr7a7L_Si_7_)c_))0r2iqmm)m_aSaaS0L2cStmN)N)2Smi20a2mYScirS7S7__00cr0ST2q))Gmi7_S)rNrqL2__f7TS02TN)G7Sm27Tacr0crLrB7c00cNS)2qi7_m_a7i0ScrL_2viTcNNq2Taaca_i7a0S_rTL7La;_T)N_0a)maw2_mr77iicTS__qT(cL)aq_m>iT2T7TaiiqcmSa_i#TN00i0raTq_mqS1aLLr(mN^LgVdN20N7TqTmcmia7a)r_L0c20Fc20)0N)iTLa0rTS_LcrNB2LaTcT_)7T02_qTm7maa_L)SNSq_21_c7)ST2)NqEaS7mLmi_SSS7W0TmN0Tc0Lq2a_ic7NS2iaccc_N7c0T_0T)7)a2_i)m_aaimS2LmTmjmcLN_)07c2imm7)i2g&S=Nl{2N)NcTimJqim7mqa__2_7Sac_{N)7q22c)i722racaNr2_SL2_N,?qm02TN)5imm27Na1KmS2LN_1)mN20NTYam22mT7ci0ArS2LLTmcq)T20mq77iv2y7bi2rNNTLr_ScS000r7rqaa77TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTNm2qarcr_S7r0__LTs79aN_q)T3qS227)7ciir_?0L;}Sc20)0N)iq_m)m_aSamS0L2cS_LT0Nq2Smi7)2_ii7pr)rqLiNcnrN700)cTS22mii_acr7S0_cLLc2NiqcTNm2qarcr_S7r0__LTe7XaN_q)TdqS227)7ciir_O0Lz!Sc20)0N)iq_m)m_aSamS0L2cS_LT0Nq2Smi7)2_ii74r)rqLiNcxrN700)cTS22mii_arr7S0_cLLc2NiTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSrmL)L_3S/700T22iqmm)m_aSaaS0L2NS*mN)N_TSTm20m2iS7LL0rqcSNi0)c_)i0tq)qqmircaaL2S0_cLSc2NTTcTaq27imma)aLricTLq0rcT)w0am772aHmia7aqr_c2Ni<0:pcS0_7mq02aSTaNS,__cNNTTr/rNrT0TLap2Lm77a_hrLliNrTTTL2mTm)ciT2_7qLBiL_rc70j_PcX02TNaTq_mqSwL0Lr__LaTTzTNT0iTqam20maLTiNLLk0N202)rcr0r)0)LiHmL77aa/:Srci07T_qmq3mraO2Em7Lri2rLNmNi_NT20NmrTrqrm0mLLkiXSSL2p)^cNi0_20))2Sm2a)aNriS_c)_q0icL2)m0mS22i07miSiLL0c7dqOaNiT0TS7c2imqaTLcrrL7_0ccVS02Ti2_qrm770icaLS2LiEc=iN7NTT_q0772ai_aN_7O2cc_i02crTcTNq27SmamLa_r2Scc)__3aNmq)T_)rq7miLTiTScSi_7_)c_00q2T72c2i777qi_S0h7LaN_cNq722mcqia2mriciNS2%S_2oNc52mT2)Tqcm0Srarr7S0_cLSc2Ni)_T_q7207cmLi2riPcLNN23aqcq_27q07_mTa7aar_6)L__acmq 0_Tr)72iST7_iqe<;_ca6q) cM0A)2qNrTm_aq_!e0Yrc_ aqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qm#)L)aa_rr_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_wSAa00T2)Sq2m)2eaii__)Sqci_L))q0qS)2702m7S7Lr0_7LqLaMiN0NS2c)iqqmTrcarr7S0_cLSc2Ni)_Trq7207cmLi2risSLi 7kTN_q)TqmiqLr)S0SSr2O0Lm?SFL00q7T0)Lqrmi7r_rirSNL0&2T)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0_)S0_cLrc2TSNL20)qaSiir)a_Lir}_)_qci)c0iTqqTirmi7ma)r2c^LiON)rNaNq2i7qin2v7ti2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TT)c20rr7ri7r0LcSSu2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7)0)L2rSTa0aLrrNT_0_Lcr2TT0TLqrrT7075aSr_Nm_0&aqTNa0STriTmTacair7r)L_#0_4cb02TNaTqaa_7NL7_2PcLi_mh)N22GTqmi227)7Nii_cSiLqlTTcNi0q)Tar2imqaT_rriSq_TTrciNqTT7rqi2mm)a2_5riLN0r0_)0q0qMm0qLrmmmami_raNr_2&Lqm0q2Nm2a2iir7_TiTSTLi_q)mN00a7TqN7Li0S0L2_TcJS:_=c2NNmTT_qqiDmLraS___c0N0Tr>rNrT0TLaX2Lm77a_ZrrIiNi0i)mqN2m7+qK27Sra2iLcmLqNTT0)2q0m(TGqfm27N_TrTLcLiK7t)N_T022qTmcmia7aqr_L0_7wTNcNiT7TTq_m072rSiaiLS__2xcT)N_0a)m7)2mm7a7i_rmNm_TTTI_qrTc7T2caS7qaciNcmLqN0TT)rqqmd)gq7rr72aLGmSqcT0c)mcm0mT_)airm27L_m_r,TLLTmWmNm0_Taar22mLLmiq_Nc2N)TrkrNrT0TLa 2Lm77a_8rrjiN70S)mqN277DqR27Sra2iLcmciLN02NN2r0r)r202LS+a&rSS2_)_cciN_q0T)qS227)7Niir_o)LqNi=Lq)202Sq2a0mmaSaLS0.7_q_aci000Smcqi2q7TScirS7L05c_SN20iq_)r27m0ac7Lr2Si_c_rc7N0Tc0rq22im_r)aqLirLN)000SN2q0TmqSqL70r7iqiaSi_0_STcNi0q)T7c2imm7)i2(4Se_SD2N)NcTi)_702+7Sa2r)rNLi__c)c!0ST2q))Xmi7_i0L7raE__NT7)2qcTim2qr7c7Ni2LSS2LN_K)mN20TTcq0irmra7i0ScrS_2:i0_NcT7)02cqL72aiLcrNz2LaTcT_)7T02_qTm7maa_L)r_Sa_mT%c_Nr07)iiT2_7qL-Ln_at__a)TcT0TTi)qimm07a_T_T__c0_L)mcm0mT_)airmra7i0ScrS_2ji0_NrT7)02cqL72aircriL7LT^_N0)70a2_qNi7r2Scii_2Sr+cENN2)ST2)Tqcm0SramL2S0_cLSc2TSN220)p2Sm2a)aNriS_c)_FcSNT2)m0qi7_2ir7iTScSm_2NiH20)0_)S)mm072rSaL_0SqNS0iT)N_qiTD2)2q7iSciirqLT0rAicmN)T27-qimNSraaLmQNNrLr3rN0NLm5)r7im2a)acriScc0L7cT0c0m)2712Nrm7+LrrTc)N00rc20)0N)ia0i222rSi7_0cTcSZqccNNmm)2702rrra2r)i+Li_mvcqT0)q_)Sa7i2rcarr7S0L_N0I7NS07)0m7202L7r_Tia__LN07T2)c0i22)rmcmNa2SSr2STLcz0)rNrT7)02cqS72aiS_r_L7_0cc6L02Timcqi2q7TLriirqLT0rlicq0Tmr)iqqmTSraLiNS0Li_)07N0NLTrm7202#mSa_HmSm_)__cSc7T0)2mi2m7)7_iSiaL0_2JScm0)0_)S)mm072aiLcriSq_TTrciNm0))2a<2K7Sa2r)rcLi__00c#0ST2q)qNmi7_Lci_SSSmg007N0NLTraT202VmSa_smS0LaTTcNTLq0m072amrQmkadr2SN0T_qc2cP0_)2)mi4miaN_rraEmN20iTa2T0T)Tqi2qSm7QicScL2L^TYcq)iT2q)qcmimhacrcS2SR0P%NTiNcTrq7qam_Smaa_xSmNT_qTS)i2T)c7_i020r7ariSSS_0_r)rcSq2mm7c2am)7q_rriM2La0Dci070T)_qr2)Sm77L0rccSNi0)cW0ST2q0722qac7Sr2_SL2_N&zqm0a0L)_22mcr)a_iaSmc)_mF7N70_Tmam22i07_iSi7L0c7_rWSNST0Trar2Ni2aTrcriL2cSvqccNNmm)2702_rSSi_TScNm_m5cqTN62L)rm_23m)77i*SN_m0moq)r0m)))_2ir07iaqrT{cSi_qfTN00T7T)Tqa2i7_SSr2STLc50)rNT0)))qi2TST7aS_riL7L)B_cTN)T))iqTrTmqr_a)rzLSLLc0)rNLmT)ram2aScS__mS)N002_2TSN:Tcqc222PS1acLi(rc)_L%7ca2OT_miqLrT7_iSimL0L!_7)rcSq2T)aca_i7aTrcriL2ci_aN)NcTimcqi2q7TLriirqLT0rpicq0Tmr)iqm2)72LviiSNNr_a0q)2qi2LaTqTmT7iaqAmS0LaTTcNT3q_m07Tir2r7ri0iLc8LL_7Zaq?Ne2i7riTr0LmimrcNTL_kq)}q0qi2_)rrTmTaTiirqNm_0zaqT0T)c)i272)7_i0aerwL2_N)Tca)_TN77a2ic7iami)S2N._q0iN2T)TNqiacmi7qiT_cSiLm_)c2q80>)Sq2m)mcaii__0L0_S52N)NNTi)_7)2qii7L_)o0kS_200cm0S0Lq077m0mLarITS0SL_r)TN0No0S)_im2j7cicr2rKNY_q0iN2T)TcqiqQmcaci2iFceLNNiJcNrT7Taq_immaShimzTSqNS0i)T0c2_70)0a7mr7SiSS0Sr0r_ST2qm2c)aq)2qSraiL2rac#_ic7cT0_Tr))im27r0ac_S*ic)_<cSN2T022)qmc2Sa2SSr2SNL6Tmc2NN0e7mq22Tmca0_rr2SL0m0iT_qNNa2_qarTmTaTiirqNmLj/cNc020z7;qLir7TS)iRSSL2z)^cNi0_20):2Sm2a)aNriS_N0_1cSN2T)0,qi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aNS_riL7L)._cr07TN)_702H7Saqr0nrSL0T#r)m0Nmcm_amm0ac7Lr2D_N0_N02ca2c2_m720a_7Ti7iaS_c)_,cSN2T)Tcqi2_i0a0iSr2L)LNAic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TN2_qim7m)a_L)rrKi_mc)c_0S0aq022aS7mi)iL1SciK002c,qcTrq72Nm_r0arrSS2_)L=ciN_q)TqmiqLr)S0SSr2u0LmASIL00q7)T2c2i777)i_S0P2_Tccci070q)_20a7mar_iNy7c2Nc}iT2Nr)c)N22aS7mi)i_SSS7#0c2TiNc00m7qaa_7NL7_2;cLiN2Ur0c0N)2mS2m7)7_iSi7L0_2Nicm0)0_)S)am072rSi2rTSc_0TrcTN)T))iqTrTmar_iiS7S)__prN7NaT_7mqai57mLTiq=Sci0T-_NSNa)07ia_m27Nae!mS2LN_l)mN20NT&am22mN7u_mr2SNLYTmc2NN0f7mq22Tmca0_rr2SL0mPqTTqc2c7r)r2r707L_OriLN0rUaTqq22)73)^2V72aNXTr_Lq0bTN)c)LTaaTqTmT7iaqgmS0LaTTcNTsqLmNamqmmm7_aa<rS2LLTmcq)Tq2m270iK2u7Wi2rNNTL_Aq)?NLNa2_7_arSm7mimr_Sa0rITc)0)Ti)TiT2Lr.a)_mr0cu_mTmN)q}TL7m2Ni67_S7rTLcLi37I)N_T022)7mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cS+mN)N_TST720m2ii7Sr)r_LSLac0N2)S0Lm0qqiSriS)i__iSOG)5qNiqcTam2amicm7ari_rILiTTcNTL20m0am2mmcLTa_rqcjNcNa0_NamTTTqT2imqLmi0raNTNqNWT0NLmmTmqm2_maLri2rLNmNr0TT20NmrTrqrm0mLL%iLr7Sa0*8_Tiqa2m7m7_i2SBadi7crL2_L)mNqNN227)ir2r7ri0iLcBS_Niya))TNTqq22_m7rSi2rNSYcS&TT0NIqS)a)L2_72acL)r_Sa_m0)c_Nr07)iiT2ki_arL7S0SL_r)TN0NP0S)_imm07a_TrN_Lc002TTqrNrTrq0qLr?7Ni0irSi_0_T)rN20L7mqqqNi2S2_rirSr_0_L)uNaqi)27)mNmqa2i_r7fS_2KNcX)STcm0qcaSm2aNaEr_SO01_!cqN2Tim7202*mSa_ mScc0_c0SN20NTFam22mN7k_mr2STLcI0)rN20L7mqqaTi2S0_rirSr_0_L)3NiTN7rqaaqrqLrarrrL0LLT!cN000r)i202TSra2iLcmcmLN02NN2r0r)r202LSKiNLiSN_)_7ci)c0LTNq02im)r7i0iLSrc7u)0_NmT7TL2cqi72aiLciiSqLTA0cT2T0TTa)i2_iSa2iTrcL00ruST2Nt)c)q27207_i0L7S0SL_r)TN0N}0S)_imm07a_TrNiLc0NL)mcm0mT_)airmar2Li_aH)L__r67NimT)T2c2L72rii7_)S_LaYm)ON_0a)maw2_maam_,rLHi_qT))02mT2)Nq3rmmLS0iqySciN)M_TiNX)))q2iic7_S2r0LcSSH2cT0c0_)2mi2m7)a0iizTSr_7s2)c)_T2m_)La0mqSSLi_)S_ci_UN)NqTimcqrm770icaSS2Li;c<rN700)cTL22mi7_S0iZSSL2;)_kNi0_2))q7i2LS)L0LSS2c0_mcScLT027qTqSrM7Ni0imriLN_a)rNi0q)T7c2imm7)i2<}SI_SY2N)NcTi)_702Tr=aSr)r_LSLac0N2qr0L)2qmir7iL2L7S0SL_r)TN0NX0S)_imm07a_T_qEic0N2cNqrNrTrq0qLr.7La7iacAL_Nic20)0c)i7{2i777qi_rrS)0m5mN)N_Ti2_qN2imrSciirqLTNcbicmN)T27*qD27Sr7Li_rTS2LLlqqm0m)))_2S27a0i2r0rLLrTTc0cL0r7Tq0qLmrLTi0i6rSL_Tmc0NamTmq77aTmLLmamrmS_LaTrc2NLmmma7iamiiaq_yisSH_2YNqTN_Tq7?aNi)iMS0iLcmSm_ms_ca2rTa))qqrr7NS2_),qNTNr0Vqr0rT)am20maLTiNLLuLc_Tm?mNm0_Taar2Tm)a)iirTNT_0N_ci070))_qrm770a_L0rhLS_2c0)r0T)c)ia7i27_L2rNrqL2__J7TS02TN)j7Smma)a_rSr7_0 20iNmT)T_qSqa70a2LSrmL)L_pS<m00T22SqaqLm_a2ic_)S_LaomT)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0_7ST_c_ic7cT0_)0m7202L7r_Tr0rXSS__)mcl0c)cq2q;r57qSir2L)LcdiTcNT0)))qi2TST7)S_rrL7Lad_T)NL07Taae2_ii7L_)90cr_2c)cN0iTm)ciT2JrLarS_r=S)L7FoNNTmmm)carmma)a_ric0Li_qcT)c0iTqqTirmi7ma)r2cULi?N)rNaNq2i7aaLST7TiTriSq0m_hcc0cT2T>a&2miiamr)r_LSLmc0N2)ST0)aiT2rSr7rirS0SL0sEqTiNLm)707Sm27Tacr0crLr%7c00cNS)2qi7_mTr7aaL_Si_7_qc_))0_Taqma)m_7ra7riNTL_ q)mNkTS)22)2c7ia_L0_2LTJcKiN7NTT_q0ai2T7TaiiqcmSLN0/q)Sqi2))_qr277i_Tia__LiX7,qN_q)T_)a2mi)7_aarmcoL__acmqn0_Taqminm_7ra7riNTL_{q)}NLqa2_7SiNSm7mimr_Sa0rY2cL2m27mS7mmNSr7rirS0SL0B:iNN2r2Sm_7amqS179i9S2LNTTcT0c0i)7))2_70r2iTScSi_7_qc_002))T2c2i777Ti_S037_0_hxSN_mm)0qarTr)S7LT_2LN0r_rcr000L7AqNm0mrair0rTNr_2yLqm0q2N7ca0rrmrarr0rLNO_bcSN2T)Tcqi2_i07IiSr2L)LN?ic_q)0 )Sq2m)21aii__)LNLqZ2c_N7qS)2qN2YiS7BicScL2L%TycmqrTT7Tq)irmmLTr0orLqN)Wmc707T_)mim2Lr0LTLSr)Lm_iVrN22RTqmaa_i_LTiTiSchLiVN)rNNqmmTarqrmra0aLv,Si_NTrcN)q227r)r2r707L_?riLN0ryNT2)i277.)^2!72aN(TrT+__r07N0Nh0S)_im2Sr0aNLSS2LN_=)mN20TTcq0irm27LLi_7BTc2_a)rcr0r)0)LidmL77aauESnci07T2qmq8mma52um7Lri2rLNmNr_NT2NamrTrqrm0mLLdir_iS7N)cNcq02T_)77Sm27Na.LSr:c0__0SNaNLT_q22ci)7_aarmu)L__r+7NimTTrm_2ii7a0aLrrNT_0_Lcr2TT0T<)S2_Sma0iacTSacL0iqTNTTT)iqqrm70aapTrarLN00SqmNmTm)_qarr7ri7rNS_c0900SN20TTcq0irmNr2Li_as)L__acmqI0_Tr)72iST7_iqHvSqciN_Tr2T0T)Tqi2qSmaiL0iXLSL-c)c)0iT_m)q_2rm7aivTSN#__Tc7cn0_2))_qammS>a_iaSmN __HaNm2XTqmiqLr)S0_mr2SNL&Tm>2NNNhT_)%i=2&7qa2rin7_0_D!SN_mmT(qcmc727z_DrmcrLSTTN0qrTT7T)fir7qS)imr7L7__:mqmNL207T7S2)7maiirS2N!_q0a)_q_7TqTqSrQ7iiN&rSNcm0T)rcr0r)0)Li,miaN_rrNkqN2Tr^rNrT0TLaZ2i7NLriN_2QiN7Tso>NuT2)NiT2-i_arL7S0S.LSf_qm0i20)N7Sm27Na4UmS2LT_cc0qr02TL7ia7iTr2aa9rrrLrO0KLqK0LT7)ai4m?riL7_2cmcW0m).Ny077rq22LSmSraN_2Sa0r_rcr000L7=q)aim7S)rNrqL2__O7TS02TN)F7S2Br0a_LSSaSL__c2Ncq)T_)a2mi)7_ari7Si0T_r0_Niq7)0)L2rSTa0aLrrNT_0_j+SN_mm)0qarTmarLLicTST_Tbicq2mT0)aiT2a2LS0LScmSm_m{_ca2rTrq72Nm_r07ZLSS2LT_cc0qr0N227iaai)7_aarmcOL__rA7NimTT_qqi:mqriS__rNTLT%TciNqmmTm702r7S7-r)S0Li__0)c_Nr07)iiTmNi_aTr7r7L_N)1_ca0mmb)_qammSFa_iaSmN8_q0icL2)m0am22mN7*_mr2SNLVTmc2NN0.7mq22Tmca0_rr2SL0mRqTN)22)mrasqMmxa2iNcTSq_2_kc_020m7wqimNSraaaq_ic7NL)TcT0TTi)qim2+7cicr2rRNMMc0iNST)T_qSqa70a2SSivSc_c328>qt0a2S)=2c7ca2aZ.ySLci_c/0)70L2_qmiqm77maar0rL_0:r0mqd0cT0amqS7SiciiraLm_i_rTi0q0i)q2)2m72a)iacTLN0mc0q00TT)q)2imTLTi0L_Sa_7&0c_))0N)0)mqimN7a_rriL7N2E_N)N_TSma20m2iSa2iNrOcr_Scccq000))2qqmT727mL2SNS2_NcccT00Tc)qazmmSTa__rrLN2_mB7N70_Tmam22i07LiSr2L0L_KSTi00T7)02caL72aiS_rNy7_0_Lcr)7Ni707)2Lm77a_RrcZiNiTTc_0S0mq0qH27SraNL2raNcN_07crNSTSq0qrrr7iS2irLcLNg20SN00a7Tq0mcmi7_iiL_l0Nc00)rcr0r)0)LinmLaSa7o0c0_iN_>)Nx2r)22)2N7im_L)r_SrL71iqT0N)cTSa2i27_S0a7r7cX_ic7cq0_00m7202L7rS7i0LcNSL_TS)iT022qNacmi7qiT_cSr_7A0NccST2)im_qRrra)L,rqcm_2T0T)0N0q)2q_27iSa2iNr=hSL,McNc020<7{q_ai72i)icSiLmH):_Ni2TTrq720rcr_i2__r2LNLt?_c}2;0t)qq2mir7i0iJrSL_Tmh*NcTc)2)>iRm_rii2S)Sc_ikmN)N_Ti7Tqrm770LcL_S2c__2fNcj2mT2)Nq5rm72aTicS0Nr_2/Lqm0q2N7N7+rrmrarr0rLN}_icNqrqSmTma2qrKm,a>r2SN0T__cqqm0d)Sq2m)mcaii_iN.2_0ccPr022_Tmqm2_maLriN_2Sa0c0_T7000uTSq_rmmLS0i_SSSaP007N0NLTrm7202vmSa_:mS0LaTTcNTLq0mNm_ir2r7ri0iLcuLL_7JaqXN+2i77aarmSNL2XDSIL7Trc2NLmmm77Oqqiiaq_}iWSk_2hNqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m72q2a7ii0iSZcLi_qcT)c0TT)q)2imTLTaT_XSSNmO2TwNa2mT77l2mi7aNaSiLNTLSN_TQqm227rqr2)Sma0iacTSScL00)2q2mrTrqrm0mLLyiNS0Sr_ic0cT2rT2)LimirmNS2iScrSr_rc0cL2!0%mi227)7cii_cSSc2LS__))0LT7)aiUm_riLilTNcL0TrcrN)mm)i70q_7Sa2r0_7LNLS_LqT00q_m=amr)7iLQi<r7Nr_a02N2TcTiq27S2Sr0aLrSXi_0N7BlT_0a)77q2_i)7iiNprScc2NicmqMT0TaqmiYmrraS_irNTLT/TciNqmm)72)2r7ir_icS7SF__0)cL0S2iq072m)rcaiiqSTcc_i9qNTqcTi)q2Tic7LaNr0SiL)N7c0cL0r27)T7_mia7a)r_Sr_7_Tc_qm0amdqmiT2hSSLiMTS__S_aN0qi2_TL702qrSSiL)r_FiLMc)cq0i2cTiqq2T70aT%TrTSaLiH_TS02TT)c20rrmrS2r0LcSS<2cT0cNr)27x2Nrm7XLrimc)N00rc20)0N)ia0i2mqriaLg)c0cSs2T0NmTSTL20a7707LircTL0LLgrqT0q0a)i202SrcaiiqSTcc_i(mc)02m=)s2Sm2a)acriS_c0&0cSN2T)TNqi2_i)7_aarmcbL__acmqZ0_Tr)72iST7_iqlMSLcaN_TLqcmmTmqm2_maLriar)Sq0rxmT2q)2i7T7SiqSrari)cmL0_a)TNNcL207Nacrrmrarr0rLN=_vcSN2T)Tcqi2_i07)iSr2L)LN!ic_))0q2i)Li)r0rSi2_0Sm_S_LN0)7TTqcqim7m)a_r0_2LT,c=iN7NqT_q0a)mTacair7rTL_d007ca)_TN77a2ic7iS2irLcLNB20SNmT)T_qSq770a2Sir2L)LN!iT_NrT7)02cqr72aiLcrN&2LaTcT_)7T02_qTm7maa_L)rULS_2c)cc0iT_m0q)mS72i)iNSiL_N)5qTiNLm)707Sm2r0amrSrL_0N7cT0c0i)7))2_70r2iTScSi_7_qc_002a)T2c2i777Ti_S0J7LaN_cNq722mcqia2mriciNS2pS_m*cqTNqT2Tr)_2qmLLPi=SSL2Y):cNi0_Ti)q2Trr7NS2iaccc_N7c0T_0T)7)a2_i)7pa7JrrLL__T}2cL0q7mq22NmorSiaiLS__2ecT)N_0a)m7)2A7Sa2r)rcLi__00cn0ST2q)qNmi7_Lii_SSSm{007NqNaTiq0qSic7iaqrTncLi_m{)N22<T9qS227)7ciir_y0LnQSc20)0N)iq_iim_aSamS0,7_0_Lcr2TT0TLqrrT707LircTL0LLErqT000xTSq_rm70aa}T_+,g_a)TcT0TTi)qimm07a_T_2h7cTN2cNqrNrTrq0qLrZ7iiN{rSacqNiTi)imTTTqT2imqLmi0raNTN202TTNLmmTmqm2_maLri2rLNm_q_NT2q22a7()h2!72aNDTSNSSLL)Tc:)_2L7Nari)rm_TrTrSN/_icNqr0a0qmiaii7LTaTrTSiLqTm:>NcTc)2)Bi1mLSriTyTSacSUqccNNmmTS70iTrrSq_XrkS70rw2cL2m27mT7227Sr7rirS0SL0G,iNN2r2imqq7rrmrarr0rLN>_icNqrq/0qmiqSr/mBasr2SN0T_qc2cB0_)2)mitmiaN_rrcrqci07)jcE0u)2qNrT7TLTiiS7S)__TTc_0S0aq0aiaSmLS0iq:SciN)!_TiN3)))q2iic7LaNr0SiL)N7c0cL0r27qTiTmia7a)r_cTL_<Sfa002i2S)La0mqSSLi_)S_ci_jN)NqTimc)i2qmTa0iTcTSTLa_ic_)ST2)Tqcm0Srar_rS0_cLSc2)r02)))N2ir0r)aqLirLN)000SN2q0TmqSqL70r7i0iLSr0Ts0svcS0_7mq02aST77SL_LNTLTVTciNqmm)qqc2NSm7mL0g0c2NE0iTL2mTm)ciT2_7qL9L__rSS0:_ocI02TNaT2Na_7ii7i)S_c)_r0iNmT)TLqi2Ni07biSrqc)NNhiTcN20LmIqNaNrTS_amrmS_LaTrc2NL2&)T7N2e7Saq_)+0Li00_rcr000L7uqqai72i)iNSicc_i mc)02mb)U2SmqS)Lcri__LmN7c0cL0r7Tq0q-2S7_a_rqcmLrNrcm0)0LmS7im0ri7TiTriSq0m_LT0N_TSTa20a7707paSr_Nm_mc)cLqS27q0722OrcaiiqSTNr_LFNN00iT)m7202L7rS7rTcTLiG7v)N_2TT_qSqa70SiSSiLJ0Lq0STi))0_2i)Zm)mqaiLcrLSN_01ic))7T0TLqra7707paSr_Nm_q00c_0S07q0772Vi_arr7SNL__q02NTTcTa77aqm_r)airNcTLqNqTmq0NrTrq0qLr87iiN}TSmcqkTNcNa27m2q_i22x7>i2rNNTLaN_ci070q)_7)2_mr77iicTLT%c>a)7q)T_m0qraS72aNiBcmL2_TIcN000Ta7rq?a-7ri7rNccc_O2T_cm0mT_)airmNr2i0ScrL_2NSc2NT0c)0ar2r77aN_c_SL2ci-TT)N_0a)mas2_maam_#r_Sa_mT%c_Nr07)iiT2_7qLXi)_a5_N_)TcT0TTi)qimm07a_Ti7_LN00N)mcm0mT_)airma7)aqlrSac20TTrqTqLmmar2rm)Lmi0raNTL7LLT0qNmmTmqm2_maLrirS7L0Jc_SN20iq_)r27m0ac7Lr2Si_c_ic7cT0_)0m7qaa_7NL7_23cLiN2Hr0c0N)2mS2a2L7_i2rc=)L__acm))0W)Sq2m)mcaii__0r7Si0ccN)20a7c7_a770r_iTS7Sa__0)NNNqT2)_q7aS72aNie_SL2_T=cN02rTrq7207cmSi2ri__S)L20ScLq0Tq7Saii)7_Sii%L)Lq9iTcNi0q)Tar2imm7)i2>{SY_S:2N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSL;007N0NLTraT202L7r_Tr0rLLrTTcqca0i)0)Sacmi7qiT_cSTL)-)ciNTmTT)m_2i777)i__)SmL7f7c_NmmmTn702h7S77r0rmS7_7R_cm2m0mm0qlmSm7L)_NSicc_2 L)gNm2N7Ta_2m7ma_iacrL2_LTzc{qNT%qSq7r)S0ii 0rrLrM0VLqf0q2iq2m)mNaiLcriSmL)B2)DN#TST7a)ic7ir_iT_7L0LLGrqT000/TSq_2_7qLmim_rLmX)Zc)Sqi)07iqTmT7iaqPmrLc0__cScaT027q0q42S7__mrmL)Lc0ST700q2Tr7c2imqaT_rrLSN_0=ic))7T0TLqra7707kaSr_NmL9 cNc020=7&qcai72i)icSicc_TD)N)0iTTaTqra_7ri7i)S_LT_)c)Ni0T7T)T7_mra7a)jc{L_2NSc0Na2rTTmLaPri7TiTriSq0m10caqr0r2Lqrm7m)LcL_S2c_Lm3mc_Namr)N72m0ac7Lr2_SL2_TOcN02rTrq7q)rcrSi2LirOc)__paNm2*T_)rq7mi7iiNkTSTcmfTNccS27m2q_i22?7Bi2rNNTLaN_ci070q)_7)2_mr77iicTLT5c_S)7q)T_m0qmaS72aNiWcmL2_NEyqm02TT)c20rr7aa)iqcrLaN2Tm)Iqa7TqTqSrW7iiNsrSacmNiTaq;N{Tuq22NST7_iqzpSLcaN_T_2T0T)Tqi2qSma0iacTLNc%0LqTNTTT)iqqrm7mi)i_SSS7x0c2NS02)))N2im_r0a_rSrm_0N7RaT_0Nm772acmir2arScSN_2NSc2NT0c)0ar2r77a0rciSL2_iN_c_07T0qc)Lm27iSciN_2Sa0c0_T700q_)T272a7_S)i_raLm0ke_crN7TiaT2T7c7ii7i)S__0 7c00cNL)2qi7_mia7aTr_R)LqNiHLq)202Sq2a0mmaSaLS0f7_0_Lcr2TT0TK)S2_Sma0iacTc0ce00cL2m0m)mq_2aSra2iLcmLqNT0LqmNmTm)_qarr7rLrr0LcSSu2TrN2T)TNqii0i)7qSiiLc)N0NSc2)00m)S)Lm0i7a0aViSS_0mgm)mN_TST720im70icaLS2c_Ncoicq0Tmr)iqm2)72L9iiSNNr_a0q)q2r0r)r202LS?aLi7raN^_r0i)mqimmmGamrb7.a7*rS2LLTmcqcNq2m)arqrmra0aL QS/N.O2N)NcTimWqim7mqa__2_7Sac_YN)7q22c)i722racaNr2_SLaLLA_N20c2))_qammr)avrSS2_)_cciN_q0T?qS227)7Niir_L)L_oS=m00T22S)La0mqSSLi_)S_ci_hN)NqTimcqL2N70aii)_7L0LLurT70006TSq_rm7mi)i_SSS7;0c2Ti0m)))_2S2aa0i2rSS2_)L!ciN_q)TqmiqLr)S0SSr2k0Lm*StL00q7)0)L2rSTa0aLrrNT_0_Lcr2TT0TLqrrT707LircTL0LQ_Sc_2mT0)aiTi2rr7NL2SNNrLrKrN0NLmf)Lq72aSgamLiO7ci0m0_))2kTj)7irm27L_mrqrNc202T7qlNfTyq22NST7_iqDmS:_Sh2N)NcTi)_7T2<7Sa2r)ivLi__T24ENpT2)NiT2ai_air7rqL_N)O_crN7TiaTqaa_7NL7_23cLi_qcT)c0LTNq02im)r7i0iLSrc7__cqqm09)Sq2m)mcaii__0B2_Tccci070T)_20iimTaTiirqNmLL00cqqS2im)q_2rm7aiuTraW__ic7cq0_2))_qammr)iNiqS2L__70SN20NT;mS22mT7ci0*rS2LL01cm0)0_)S)7m072rrimS)S__S_mN0022_Tmqm2_maLriN_2L01c_LN2)ST2)Tqcm0SraNL2raNcN_07N0NLTrm7202L7r_Tr0rLLrTTc0c3NST_am20maLTL2_i^Tc23N)rcr0r)0)LixmiaN_rraK2ci0iTL2T0T)Tqi2qSm7/icScL2LRTYcLqr0S7TqrirmmLTim_SSe_cccN2NKmE)q7iirr)7SifS0LT__)mcLqNm272irmr7)_mr0Sa0T0q0L)00q7m)m2mm_7a_rr2SL0m0rTN)20a7r)r2r707L_orLhi_20)c_Nr07)iiT2_7qLz_0_rSL0l_wck02TNaTqHa_mLS7r0rzSS__)mcSq0TcmS22mN7(_mr2SNL4Tmc2NT0c)0ar22mLLmLm_NJ2LaTrKrNrT0TLa^2i7NLrLr_2=iLLT5^bN{T2)NiT2ri_aar7r7L_N)f_crN7TiaTqTa_7ai7iVS_c)__kaNm2kT_)rq7miLTa_rqcpN0Nr0_NNmTTTqT2imqLmaariST_0Hier2T0_)qah2qiaS2_RiUSU_2>NqTNaq_70aNaS7a7Li_S2LcN)<_ca0m2))>a&2lST7*__*cSi_qxTN00T7T)Tqa2i7_SSr2STLc,0)rNr2rTr7dqrrirSi2rNS%0mf2cNNBmm)2qN2lSm7LL0rqcSNiT;c_NaTm7oq_2rm7aiITrrSS_Sc0cr2rTam72Na_7ii7i)S_LrA7cNN_2mT?qS2qr)S0ii^0SNc2_a)c)_q7)0m_2T777ai__)S!_S82N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSLj007NTTcTiq7q)m_a0S2r2LcLih7%qN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ci6mN)N_TSTa20m27Sa2r)i:Li__0)cq)i0L7)a0aS72S0imSSSL5007NTTcTiq7q)m_a0S2r2LcLi%78qN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ci}mN)N_TSTa20m27Sa2r)i&Li__0)cq)i0L7)a0aS72S0imSSSL9007NTTcTiq7q)m_a0S2r2LcLi}7#qN_T027q0qLmrLTi0ierSL_Tmc0NamT)NTLa0iiLmamrmS_LaTrcTN)T))iqTrTmar_iiS7S)__0)cmN7T7)_qmrmm7S0iXSSL2%)PNNi0_2)):2S2LS)L0ri__SSN7cT0c0N)2miq77)7_iSimL0_2NSc2NT0c)0ar22mLLmimS)S__S_7N0020T)Tqi2qSm7LL0rqcSNi0)c_Nr07)iiT2ai_air7rqL_N)l_ca0m2))_qammSna_iaSmNE__GaNm2PT_)rq7miLTa_rqcbNcNa0_NamTTTqT2imqLmi0raNT_NNLT_2T0T)Tqi2qSma0iaJ2cqc1laqTNTTT)iqqrmmaaiiTS0LiLr)Tc_0qmn7N7rmqSX7Zi^S2LNTT^70c0i)7)q2_70r2iTScSi_7_)c_00q7)q)a2i707SLcriSq_T0ccr07T0qc)Sm27ir_icS7L0%c_LN20i2c)N722aScS_L7S0-__Tc7ca0_2))B2Sm2a)acriS_c0_)cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aTrcriL7L)V_N0)2TTqcqim7mqa_r0S7L01c_rN20i2c)N722aScS_L7S0y__Tc7ca0_2))#2Sm2a)acriS_c0_/cSN2T)TNqi2_rc7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cSGmN)N_TST720m27Sa2r)rNLi__00c}0ST2q))Rmi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTrSN;_Nc0cmNiTN)airmi7qiT_criLq_Tc0NTmTTT)aqim_rSi2rTSc_0Trcr07T0qc)Sm27ir_icS7L0pc_LN20i2c)N722aScS_L7S0=__Tc7ca0_2))s2Sm2a)acriS_c0_)cSN2T)TNqi2_i)7qSiiLc)N0NSc2)00m)S)Lm0i7aTrcriL7L)}_N0)2TTqcqim7mqa_r0S7L0Jc_rN20i2c)N722aScS_L7S0^__Tc7ca0_2))92Sm2a)acriS_c0_^cSN2T)TNqi2_rc7_iSimL0c7_a0_NN27m27c2ii27rrcrNL2cSKmN)N_TST720m27Sa2r)rNLi__00cx0ST2q))Vmi7_S)iq_iSL0)T0TS0220)m2S2La0S7rTrSNB_Nc0cmNiTN)airmi7qiT_cSiLq^T)rNi0mT)q2inmiaN_r_P,m_NTr*rNrT0TLan2mm7a7i_rmNmL700c_0S07q0772rmSaSr0rrNrLr02NTTc0S77aqm_r)ami7S7L__m)mcRq0TkqSq770S7aT_cSr_7_)c_)00m2Sq02arr7TSL_4ciLTvTciNqmm)0qairmrr9L0r6LSL7T))00im0Trqrm0mLLYiq_iL2;)+NNiqcTrq7q)rcrSi2Lirvc)__8aNm2WT_)rq7mi7iiN(TSTcqNicm0)0cmS7im0ri7TiTriSq0m_LT0N_TSTa20a77TicaSH7c)__00cm)ST2)Nqerm72aTicS0Nr_rc7N0Tc0Sq22ia_Sma_rSra_0Lq0i)r2227q0qLmrLTi0iLSr0TJ0u!cS0_7mq02aSTaNSL_iNTLTMTciNqmm)0qarT7NrvL7cTST_T-icq2mTq)cqNrm7qS0_T>rcq0K1pc72rT2)LimmqrTS2_qcrSr_rc0cL2WTiqNirmarmSi_rcuS _<c2NNmT)T2c2i777)i_S0A2L7ccci070q)_20a7mar_iNZ7c2Nc.iT2Nr)c)N22aS72aTicS0Nr_2.Lqm0q2N72aqrrmrarr0rLNo_LW7ca2lTrmiaiimSmS._2c*L!_7)rN20L7m7aqNi2aN_rirSr_0_L)hNQTS)22)2c7ia_L0rHLS_2c)cN0iT_q)q_mSmmi0r2_SSLN0;q)Sqi2))_7i2+a)aqriVcLL_Nc0Ni0)27q0qLmrr7iTScSi_7_)c_00q2)T2c2i777qi_S0L7_0ccwr02TimcqNa2maLcL__7L0c_KTN7NaT_m)2N2q72a_i7_SL2_N9JTS02TT)c20rr7ri7r0LcSSp2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7Tam_2Nr7S2Lcril2LrcccN02qS)2qN2/Sma2iNrhNm_2OTcc00mr)2qLrm7qSNL2H0NrLrJrN0NLmM)i2Nrr7aSqLi4iNyLB#YN20N7TqNqS2LLTa6L_tSNc0rT2)amT)T)Si^miaN_rrarqci02)tcI0A)2qNrT7TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTL)N20mi7)S7r0rLLrN7cT0c0i)7))2_70r2i2ScSi_7_qc_00q7Tam_2Nr7S2Lcriy2LrcccN02qS)a)L2_72acL)r_Sa_m0)c_Nr07)iiTmTacair7r)L_<002N2TcTiq7qqm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2SNLDTmc2NT0c)0ar22mLLmLa_TSL0m_mcmN_0a7r)L2_mma2i_izNm_01aqT0NNLm0acrmmmami_raNr_rc7N0Tc0Sq22ia_7ri7r0LcSLR2ci0c0i)7)T2_70r7aaL_SNN702TcNiq2Tr2c2N72rSiaiLS__2,cT)N_0a)m7)2g7Sa2r)rcLi__00c.0ST2q)qNmi7_L0i/SSL2v)_9Ni0_2))q7i2LS)L0LSS2c0_mcScLT027)0qL2r7iar#rrrLN_0c2))0_Tr)72iSTaTrcriL7L)8_N0)2TTqcqim7mqa_r0S7L0Yc_rN20i2c)N722aScS_L7S0^__Tc7ca0_2))_qammSQa_iaSmN-__BaNm2RT_)a2mrZ7_ari7Si0T__cqq{0L2im_a7ST7TiTriSq0m_Pcc0cT2T>aM2ciia2r)rcLiNc4Tc)0)Ti)TiT2ai_arr7S0_cLLc2NiqcTrq7q)rcr_i2LirLc)_vcSc7T022)amcmia7aTr_L0c7,0O*cS0_7m)12c7ca2aPZ>S_ci.2N)NcTiTZqcmc727D_#rccrLL00NNq/Tmq)q_miSTarr7S0NcN_c2)_20TSm2qarc7iL2_2crLT_)c)Ni0T7T)a7_i=r7iNiSrL0TH00_Ni2m))ar2rm)LmaL_0SqNS0iT)NfTS)220a2m)iciNS2AS_2>NcM)ST2)Nq6rm72aNi/cmL2_T=cN02rT2)LimiirTS2rNcrSr_rc0cL21TNq0qrmia0aTzrS2LLTmT2cNq2)Narqrmra0aL^#Si_NTTcr07T0qc)Sm27irYirS7L04c_rN20im0Trqrm0mLL iq_iL2f)QNNiqcTi)mq)m2SMaqLirLN)000SN20NTXmS2a2L7_i2rc:)L__acm))08)Sq2m)mcaii__0S _S&2N)NNTi)_2)2_7S7mr0S29SL2&N-YN_0;7t)=2qm2aiL7S0StLSP_qm00Ta7r2T7c7ii7i)S__0NmcT0c0i)7)T2_70SiaTrTSiLqTm5L)00_)S)am0i7a0a}iSS_0m_LT0Nq2Smi7)2_maamL)r_Sa_mT{c_NaTm7xq_2a7mLhi_raLm0Al_ca0mmA)_qr277i_Ti_SqNh_L0a)2qr7T)T2Tmi7q_mr0Sa0T0NTm)N0L7m)m2mm_7a_rr2SL0m02T2)mqi)qaJq.mua2iNcTS__qTwTLq2qem0qLrmmmami_raNr_25Lqmqq2_mm2Nrrmrarr0rLNF_icNqrqamTmr2qr<mVajr2SN0T_qc2c>0_)2)mijmiaN_r_accca=q)^cH0P)2qNrT7TiciiS7S)__c0T2qK0L)c)erm7mi)i_SSSa*0c2)_qcTL)N20mi7)S7r0rLLrN7cT0c0i)7))2_70a7i0ScrL_2Ai0_NrT7)02cqr72aiLciiSqLT(0cT2T0TTa)i2_iSa2iTrcL00rBrN700)cTS22mii_Lmiqr7Sm0oplNS02)))N2im_S2S7r0rLLrTTc0c-NST_amqDmcaci2iucXLL0r32qTTcmr)Sa)mL77aa&ISrci0r)T)Lmm)mqcrTm_aq_4rr!rc_0LqTNTTT)iqqrm70aaJT52DL_m)TcT0TTi)qimmqr0a_rSr7_0N7;0T_0r)7q0mc2La2ii_cSr_7VN)c)_T22i)2a)m/aSiqS0}2L0ccci070T)_20a7mar_iN67c2NcUiT2Nr)c)N22aS72aTicS0Nr_2FLqm0T2Nm2aiiaSk7fikS2LNTTtqN2NzT_q2qmr-7iiN^rSmcq02)rcr0r)0)LiOmLrii2S)Sc_iv7T0c7TTqcqam2r1aN_mrRcr_qT))0qrT2q)qNmiS0L2a2_SSSN0TTTS0qTc)Nimm2r0aL_rS2_)L}ciNm0c7T)77_mcS7L2_cSr_7%0c_)0Tc)S)Sm0i7a0aLrrNTLaN_cNq722mcqia2mriciNS2:S_a_Lc_02Tcm)q_2a7mS)i#SSL2f)YcNi0_20)E2Sm2a)aNriS__)__cScmT0)2mSqLi07qLS_if)L_NiXU0)0q)i7cqimq7Ti0rTNTLT_aEiN_qS)2qT2c70Lria_2L0lc_SN20)q_T)qwmS7qi0_rrLNT_rTmNN2c2_7m207cmLi2__c0S0N7o7T_qO27qNqS2LLTi0L_SaNm>0NccrT2)T)SiJm)riaSY)c0cS6mN)N_Ti2_qSm7m7a_L)r_Sa_mT+cq)i0L7)a0aS72S0imSSSL+007N0NLTraT202L7r_Tr0rpSS__)mN00a7T7T7DmmLTaTrTSiLqTmc0NamTT:mLa0rcLmamrmS_LaTrcaN)0q7rqaa2r2ST_T_ic20r.rc)2mT0)aiTiN2LS0ircmSm_mA_ca2rTrq7207cmSi2ri__LrU7c00cNL)2qimcmia7aTr_L0c7_a0_NN27m27c2ii27rrcrNL2cS-a(LN_T2)c7)2_maamL)rfLS_2c)cc0iT_m0qgmS72i)iNSiL_e)3_NSNm)0q27SmamLa_r2Scc)__faNmq)T_)rq7miLTiTScSi_7_)c_00q2)T2c2i777qi_S0L7_0ccBr02Timcqi2q7TLriirmS)_2Tdci0Nmr)m7qiqSr7rirS0SL0Z9Lc7Namb)L7ii7r7Lm_0x0NR_&-7qr02TLam2T2Nr2L)wrrrLr(06Lqe0,)Sq2m)mcaii__0S=_S.2N)NNTi)_2)2_7S7mr0S2pSLL00cqqS2im)q_aim4i)iqSicc_LdNN00iT)m7202L7rS7rTLcLig7M)N_T022q2mcmia7aqr_L0c7_a0_NN27m27c2ii27rrcrNL2cSVayLN_T2)c7)2_maamL)r_SrL71iqT0T)c)i272)7_i0L2S2_c_ic7cq0_)0m7qaa_7NL7_2,cLiN2Br0c0N)2mS22mN7 _mr2SNLFTmc2NN0U7mq22NmvLmi2rNSp0ms2cTNcT07rq22LSmS2L2_mLN0r_rcr000L7oqm2777a_imcmSS0T-L)r0TmT)7armaSTic_rr2NT_aTrNiq)Tm)727m_7m_miOl0NTNSg)Nm0iTrq2iRmmraL___NT_T_S)9NiTN7r7SaqmrLrarrrL0LLT^ci0Nmrmd7m2rSr7rirS0SL0:viNNq_2_Tq7i2ISu7{iOS2LNTTcNcSNL7TqT7_iSrSLr_qPr0T3T{Sq80i)Nar2TiqS2_rirSr_0_L)kN7qi)q2)2c7iSciL_2LN=c_rN2)ST7m0qNaS7a7Li_S2LcN)%_ca0m2))L7im2r)arLirLc)FN3qN20_T7mS22mN7tSSr2STLcZ0)rNaq2)07c2mi27aLcriSq_TTrciNm0))2ay2)iiamL)r_Sa_mTMc_Nr07)iiT2_7qLxL*_rSs0I_>cO02TNaTq_mqS{amLi__caTTfTNT0iTqamqRi0S2Lq_cSiLm_)c2qA0q2iqia)m_7aimV%S_Lr_7ci2T0_)qa,iTir7G_:i^Sd_2VNqT0N0STLiTm0i_SSL-8rcqN_)TNTNSmo)i2Nrr7T7qLiU7NGLDg;N20N7Tq27_2ir2SirNcI_0_acmqE0L)Sq7m0m)7q_r__c7Lj0ccLNNT0)iq)a7707Lir_7S0c_IcN7NST_m)qaaimSi)rNSicc_L6NN00iT)m7202L7rS7r0rZSS__)mNiq00_mi7_mqLTi2iLSr0TdNNcNST2T7)aiQr0SSiT_)S_Lanm)YN_0a)maV2_maam_{rmFiLVT))02mT2)Nq rm72aTicS0Nr_Tl)N)0iTTaT2qi87cLmiSQkSi0mc))z0mmmqNacma7)aqfrSac20mTh)amT)T)Si(miaN_r_L}qci!q)Ic/06)2qNrTm_aq_P{Tfac_!aqTNTTT)iqqrm7aS0i_SSS7l0.1NS0a)0m22T7c7Li2_YSNNm_5TrNa2)m07r227)7Nii,0c2LqNiHLq)202Sq2a0mmaSaLS037_0_YJSN_mm)0qarT7NrL_0ocNmLmOmc_NamrTLq_2m72a_a6cmL0_a)TNN)L2_aTqTmT7iaqEmSm_)__cSc7T0)2mi2m7)7_iSiaL0_28Sc20)No)iq_a)mqriaL9)c0cS;2T0NmTSTL20a77q7aiiS0SSNcQicq0T2c)r27m0ac7Sr2Siu___c7N0Tc0Lq22iic7NS2iaccc_N7c0T_0T)7)a2_i)m_aaimS2LmTmnmcLN_)07c2imm7)i2.?Sj_SA2N)NcTi)_70m07Sa2r)rNLi__0)cq)i0L7)a0aS72S0imSSSLn007N0NLTraT202L7r_Tr0r&SS__)mN00a7TqN7FiiLTaTrTSiLqTmc0NamTmTmL2aST7TiTriSq0m*mN)N_TST720m2iiamr)r_LSLac0N20ST2q))kmi7_S)iq_iSL0)T0TS0220)m2S2La0S7r0r#SS__)mNmT)T_qSq770a2SiriL)L_PSoa00T22S)La0mqSSLi_)S_ci_,N)NqTimcqi2q7TLriirmS)_2TVci0Nmrmr7mmNSr7rirS0SL0XVLc7NamKq07iimr7Lm_cuqNt_*p7qr02TLam2q2Nr2LN{rrrLr^06Lqd0/)Sq2m)mcaii__0Sf_SQ2N)NNTi)_2)2_7S7mr0S2ASLL00cqqS2im)q_aim;i)iqSicc_LJNN00iT)m7202L7rS7rN__cIN7wcNT02Tmq0irmarqLi_iczLf_7)rN20L7m77aTi2aN_rirSr_0_L)kNiTN7r7iamiiaq_&i*SV_2uNqTN_Tq7;qLqai_S_oTrTLT_ikqqm0qTc)Nimm2r0SV_qBzc20c)mNm0c7T)_2qrer_7aL_Sa0T_TcTNi0q7mqqa0r2SqLcrLSN_0%ic))7T0TLqra77TLTimRmL)000)NNNqT2)_q7aS72aNiP_SL2_THcN02rTr7rq=ih7SLiLSS2LN_z)mN20TTcq0irm27L_mrqrNc20q)rcr0r)0)LiomL77aa6;S_ci0aTuqm20mqas2Dm7Lri2rLNm_q_NT2qTmrTrqrm0mLLOrc_iSSo)__NiqcTL)N20mi7)S7r0rLLrN7khT_0c)7)S2_i)aNaqr2S_L7NSc2NN0x2Sq22Tmca0_rrm32L7ccc)02qS)2qN28Sma2iNrANm_2nTcc00mr)2qLrm7qSTL2WmNrLr#rN0NLmM))7im2r)a_irr7LiTTO_Nq20m0mr7_maLTaTrTSiLqTm:aNi0T)0qiqrST7_iq{3SLSaN_TL2T0T)Tqi2qSmacL0rcXS_a_Lc_02Tcm)q_2a7mS)a__iSaN)__caNmT2)mim2mmL7_r06cLi_mQ)N22;0_miqai)7_aarmcVL__acmqK0_Taqmi:mLriiqw)c00mW2cNN^mm)a)L2_72acL)r_Sa_m0)c_Nr07)iiTmNi_SkL7rcLT_2/mN02rTamqaiiiSyali7crL2_L)m)7qT22qNir2r7ri0iLchLiDN)r)iqm2iqqiK257Bi2rNNTL_/q),NLNa2_7_rTmTaTiirqNm_q:ccN2mT2m07ziqrXS2_ccmLm_c)Tc_0qmhm_)aa_7a_TiTSTLi_q)mNqq0m27qacmL7Ni0riS)c7P0bLNrq7)TaT2mrma)_0_)LNLq32c_N7qS)2qN2ZiSa2iTrcL00r{r)rNs2d)SaiaS72aNiRcmL2_TycN02rT2)LimmqmNS2_qcrSr_rc0cL2WTL)7qar>7_Si_a&xNm00Tqq.0;T7ar22mLLmiqiNk2NTTrerNrT0TLa*mcii7Sr)i_LiNcALcN00Ti))77m0mLarL7r(f__cc7cS0_2)qNqqm27_a7LSS2LN_Y0SN20TTcq0irmmr2a7ScS)_2NSc2NN0u7mq22NmuLmi2rTSc_0Trc2NLmm)q7Ta2rmLrarrrL0LLTfc))iT2m)q_2rm7aiyTr_Lq00T0Tr)_TaaTqTmT7iaqYmraLi_Tc0NiNr7T)_2qrd7L7aL_9L0T_TcTNi0q7mqca0mcrSiaiLS__26cT)N_0a)m7)q_ii7aL)i_SaLmM2cm2m0mTL)_m0rcaiimr)L20+__TiNa2))_qammS+a_iaSmN^__yaNm2yTLmi2qr)S0_mr2SNL.Tmc2NN0U7mq22NmKLmi2rNSE0m.2cNNxmm)2qN21Sma2iNr(Nm_2xTcc00mr)2qLrmr2SaLq_iLq0=_pce02TNaTq_mqS?aLLa__ci0N)mcm0mT_)airma7)aqHrSNc20TTqqTqSmqar2rm)Lmi0raNTN002-N)2TN7r)r2r707L_er?LS_2c)cc0iT_m0q*mS72i)iNSiL_:)5_NSNm)0q27SmamLa_r2Scc)__paNmq)T})7ir2L7_aTi2rLLqTmc2NN0x2SqaqLm_a2ic_)S_La!mT)N_0rT7qirT7TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTi)q2Trr7iami)S2N*_icNqr0a2qmia2iSLTaTrTSiLqTmcqNc0N7mqTa0rcr Lx_7cT0m8mcc2T0_)qa^a_rcruiacTST_T3icq2m0A)c2cm2m&L=iL_SLq_cfNqm0T207Tari7SXasi7crL2_L)m)iqTTramqmmm7_aaprS2LLTmcTcNq2mqarqrmra0aL{,SY_Sb2N)NcTi)_2)2=7Sa2r)rNLi__c0T20T)c)i272T7_i0L7S0SYLS:_qm0m)))_2S27a0i2rSSm_)__cScaT0)2qi7_mra7i0Scrr_2ziTcNNq2Taaca_i7a0S_rTL7LaD_T)N_0a)maJ2_mr77iicTS__qTjcr)a2_m_iT2T7TaiiqcmLq_cHNqmNm207N7_i4r2LT>mSmLcTT%_Nq2wmTmr2Tr,m8atr2SN0T(N0_NiT7T)q_2r77aNi__0SG_S.qN0qrTTqcqai7r2a__2rq iLLT))0)ST2m0qmmSmLi0L7SqSa_ic0cSqcTi)q2Tic7ri7r0LcSS<2ciT_0r)7q0mc2La2ii_cSNc2_a)c)_q7)0m_2T777ai__)LNLq82c_N7qS)2qN2oiSa2iTrcL00r(aT200)cTS22mTacaar2_iLmG)xLNi2TTrq72Nrcr_i2__rLc0_qTS)iq)T_miq{7)7qii_cSiLqgT)rNi0q)Tar2imqaT_rrLSN_0pic))7T0TLqra77TiciiS7S)__c0)rq_2c)LqNm07ia)L7S0SL_r07N0N(0S)_immma)a_rSr7_0O2T:q0q)T_)a2mr37_aarmcFL__acmq-0_Tr)72iST7_iq4{+Lc_NKT0NLmmTmqm2_maLri2rLNm_q0NTSqmmrTrqrm0mLLQiiSNNrN7TNTa0qm(T*qum27N_TrTLcLie7e)N_T022a)2m7)7_iSiaL0_2NSc2NT0c)0ar22mLLmL)_*Bm_NTr{rNrT0TLap2Lm77a_OrrOiN70Z)mq02)7,q,27Sra2iLcmLqLN02)cq7mJTdqZm27N_Ti_SqNm_VcSN2T)Tcqi2_i0r2i0Scrr_20_nmNm0_Taar2Ni27a_c__ 7_0_^fSN_mmTL702_7S7ar0_7L0LL5rT70q0a)i202SrcaiiqSTcc_a%)cq2rTam2amiKri_TrTrSN._icNqr0a2q7qir2r7ri0iLc+LiPN)r)rqq)Narqrmra0aLe5Sg_S52N)NcTi)_70257Sa2r)rNLi__c)c_0S0mq022aSmLS0iqKSciN)p_TiN6)))q2iic7iami)S2N>_icNqrq_2mqNir2r7ri0iLc5LL_7Maq^0r2i7aaBrmSNLq 6SML7Trc2NLmmmm)Na27NLrarrrL0LLTdc{0ST2q)qcmi7_i)i_SSSa30c2Ti0m)))_2S2ma0i2LSSaSL__c2Ncq)T_)a2mi)78iSr2L)Lc5ic_)00J)Sq2m)mNaii_QcS__S_mN0)70a2_qNi7r2Scii_2SrlcvNN2)STaTLq_m27cS)i_raLmN)J_crN7TiaT2T7c7ii7i)S__0B7c00cNL)2qi7_mra7i0Scrr_2KiTcNi0q)Tar2imqaT_rriSmL)(2)WNiTN7r7Fam7NLrarrrL0LLToci0Nmr)a72airaL9ayr%L2_N)TNTTcTiq7q)m_a0i7r0LcSLy2ciT_0r)7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)S_Lr_7ci2TTTqcqim7m)a_r0S7L0jc_LN20iq_)i272T7_S)iq_iSL0)T0TS0220)m2S2La0S7r0rLLrTTc0cRNST_am2m7)7_iSi7L0_2FSc20)0N)iq_a0mWaSi2S)r+_iI_T)NqqiTLa)i0iSa2L0rmLSLLc0T7000L)riTm0mLarnTS0SL_r)TNqNaTiq0qSic7iaqrTFcLi_m;)N22VTL)7qars7LSi_rcTc_TmcmNcmTT_qqi^mLraLalvrYLV<2cN2T0_)qaBaUiaaq_GiXS5_2?NqT0T)c)i272)7_i0L2ST_c_ic7cq0_)0q7207cmri2riPcLNN2}aqcq_27q07_mTa7aar_V)L__rh7NimTT_qqiOr0rriqUOrZLPj2cN2TTNTS)LrTm>r_LLRTcrNq0aqT0T0S7*qimNSrSraq_iLq0d_Acz02TNaT2T7c7ii7i)S__0G7c00cNL)2qi7_mra7i0Scrr_2yiTcNL0N)0qi2)i7a0aLrr=7_Tccci070))_20a27TiciiS7Sq__c0))00)cTr22aSmLS0iqjSciN)?_TiNk)))q2iic7LaNr0SiL)N7c0cL0r27q0q,2S7__mrmL)L_sSR700T2)Sq2m)mNaii__0S,_S.2N)chTi)_7)2_maam_Er_Sa_mTMc_Nr07)iiT2_7qLo_T_rLq0P_pc+02TNaTq_mqS8aLLi__cLTTHTNT0iTqam2m7)7_iSi7L0_29Sc20)0N)iq_a0mkaSi2S)r{_iw_T)NqqiTLa)i0iSa2L0rmLSLLc0T7000UTSq_rm7mi)i_SSS730c2NS02)))N2im_r0a_rSrm_0N7/aT_0Nm772acmir2arScSN_2NSc2NN0I7mq22Tmca0_rrrL7_0ccsS02Tiqcqim7mqa_r0_2LT<cDiN7NTT_q0772ai_aN_7v2cc_i02crTcTNq27Sm27NasxmS2LN_>)mN20NTEam22mN7=_mr2SNL=Tmc2NT0c)0ar22mLLmiq_T SNmTrfrNrT0TLa>2mm7a7i_rmNm_200c_0S07q0qxmS72i0_rST_c_iT7)20_m2)_qr277i_TirrSLS(0Hrqr0N22q0mc2Sa2SSiKSc_ch2l-q60c2iqmm)mqaiLcraS)LqTrci)20a7c7_im70icaLS2LTLSTQcrqaTm2iqr2cm)ariLLTNTLSTmNTTcTiq2a_m27NahLSS2LN_9)mN20NTkam22mT7ci05rS2LLTmcq)NqLm0arqrmra0aLkxSi_NTrca)m2Nm)afq?m%a2iNcTLTMcEiN7N)T_q027m0ac7Lr2SiU__ic7cT0_2))_qr277i_Ti_SqN1NLT)TKq0TLamqmmm7_aaxrSaL)_q)rNmq2m)7iiTiiS2_rrrS)0mG0ca2TTN2,7aarSm7mimr_Sa0r8ac)Nqmr)a72imr/Sa%TSTSS0MbiNN2rTamq7ii7S%7/iXS2LNTT+_Nq2W2zmr2qrFmka=r2SN0T__cqq:qL2aqqiW2>7Vi2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TT)c20rr7ri7r0LcSSP2ciT_0r)7q0mc2La2iiScSi_7_Tc_00q7)0)L2rSTa0atiSS_0mh0ca2TTN0L70iNSm7mimr_Sa0reac)Nqmr)m72i)rmLTLiHmNr_rt)qm00TaaTa)qLr0aLemrmLm__5aqr0r)7q0mc2Sa2iiL_Sr_7s0NccLT2)i2c2i777Ti_S0}7LaN_cNq722mcqia2mriciNS2RS_a_Lc_02Tcm)q_2a7mS)ixSSL2f)lcNi0_20):2Sm2a)aNriS__)__cScmT0)2mSqLi07qLS_id)L_Nie50)0q)i7c2LmNa0iir)s7_0_Lcr)7T0T?)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2SSL2{)_xNi0_2))q7i2LS)L0LSS2c0_mcScLT027q0qLmrLTi0iLSr0TE0WIcS0_7mq02aSTSmSL_0SL0m_mcmN_0a7rqrm770icaSS2Lic_<rN700)cTL22miacair7rTL_,007ca)_TN77a2ic7iS2irLcLNe20SN20TTcq0irm27L_mrqKNc20iT7q{NYT5q22NST7qi2i9S__2_m)}NiTN7rqaamrqLrarrrL0LLT-cE0ST2q)qcmi7_S0i)SSL2?):NNi0_2))q7i2LS)L0LSS2c0_mcScLT027qqqamia0aS_cSiLqkTTcNrT7)02cqS72aiS_rrL7_0ccAL02Tiqcqim7mTa_r0_7Sac_GN)7q22c)i722racaNr2_SS2_N_zc_NYm.Tpqq227iS7r0rWSS__)mNmT)T_qSq770a2SiiSL)L_tSea00T22S)La0mqSSLi_)S_ci_AN)NqTimcqi2q7TLriirqLT0r.icq0Tmr)iqqmTSraLiNS0Li_)07N0NLTrm7227c7ii7iqS__0N2cT0c0i)7))2_70r7iqiaSi_0_STcNi0q)T7c2imm7)i2M<SLL7_a)wNLqimraTaLSmamiccTS__qTpcL)aq_mSiT2T7TaiiqcmL0_a)T)T)/TaaTqTmT7iaqumS0LaTTTNTL0a7T)T2Tmi7q_mrmL)L_!S-700T22i)Sm)m_aSaaS0L2cS_LT0Nq2Smi7)2_ii7Zr)rqLiNcZicmN)T27oq mS72i)icSiL_N0PENS02)))N2im_a)a_rSrm_0Q20SN20NTQam22mT7ci0jrS2LLTmcqcNq2mqarqrmra0aLWnSLL7_a)KNrqim77rimi_Sr_FryS70r=2cL2m27TN72mNSr7rirS0SL0MtHNS02)))c2im_r0a{rSS2_)_NciN_T)T_qSqm70a2SSiLO0Lq0STi))0_2i)lm)mqaiLcrLSN_06ic))7T0TLqra77TiciiS7S)__c0T20T)c)i272q7_i0r7S0_cLrc2NiqcTNm2qarcr_S7r0__LT&7-aN_q))N)q22m_77SSr2SNLPNSc2NT0c)0ar2r77a0rciSL2_iN_cr07T0qc)Lm27iiciiS7ST__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS02TN)Dimm27NaoJmS2LT_cc0qr02TLamariNr2iN.rrrLr#08LqV0!)Sq2m)mcaii__0S}_Sz2N)NNTi)_2)2_7S7mr0S2FSLL00cqqS2im)q_aimEi)iqSicc_iGmc)02m()i2Nrr7aSqLi3_cSTTKTNT0iTqamqami7Ti0rirr0T__cqq(0L2r7aio2^7^i2rNNT_Tccci070))_20a2m7iciiS7Sq__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0a0L)_22mcr)a_iaSmc)_8cSN2T)Tcqi2_i07xiSr2L)LNJic_0)0_)S)mm072rSaL_0SqNS0iT)N_qiT92)2q7iScairqST_0WTqTNT0aTiq_aS72aTicS0Nr_rc7N0Tc0Sq22ia_7ci7r0LcSL62ci)c0N22)aici_r7i0L_ST_7_ac_))0_Taqmijm_7aimdlS_LaAm)HN_0a)ma*2_maam_vr_Sa_mTIc_Nr07)iiT2_7qL<iLiah_NaTcqmNmTm)_qarr7aa)iqcrLNN2TT)m2T2r7Nirmr7)_mr0Sa0T0NTmcNq2)Narqrmra0aL*YSx_Sx2N)NcTi)_702)7Sa2r)rNLi__0)NNNqT2)_q7aS72aNi!_SLm=)!_NSN7)0q27imma)a_rSra_0=2TiNmT)T_qSqm70a2SSrarLL_k2cc))0_Taqma)m_7ra7riNT_Tccci070))_20a2m7iciiS7Sq__c0T7000L)riTm0mLargTS0SL_r)TN0NLTraT202GmSa_+mS0LaTTTT)qqT22qNir2r7ri0iLc}Li:N)r)i2T2rm_2aST7TiTriSq0mW0ca2T20mi7T2LSm7mimr_Sa0r#2cL2mTqmT72i0raL5a9rEL2_N)TNTTcTiq7q)m_a0S2rTLcLig7XqN_T0)7q0mc2ra2ii_cSNc2_a)c)_q7)0m_2T777ai__)L0_SY2N)NNTi)_702K7Sa2r)rcLi__0)cq)i0L7)a0aS72S0imSSSL-007NTTcTiq7q)m_a0S2r2LcLi-7bqN_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ciOmN)N_TSTa20m27Sa2r)ijLi__0)cq)i0L7)a0aS72S0imSSSL&007N2TcTiq7qqm_a0S2rTLcLi+78)N_T027)a7_mNS7L2_cSic2_rNcNNT22Sqmm)m_aSa7S0L2ciTTci070q)_)Na2rmL0L)rq9iLLT))0)ST2m0qmmSmLi0L7S2_c_ic7cq0_)0m22T7c7ii7i)S__0N7c0c#NST_am20maLTiNLL&0cMN_)rcr0r)0)LixmNa0arriL0LTTrc2NLmm)q)Na2r0Sm_-iQS3_2gNqTNr0S)S202rSraaL7ST_c_ic7c)0_)0m22T7c7ii7iqS__0A7c00cNr)2qiacmNr2aa!c{_c7y00_NTT7Taq_a)mIaSi2S)Sc_iO_T0NETS)22)2N7ia_r)r_LSLmc0N2)S0Lm0qqiSriS)i__iShl)BqNiqcTam2207cmSi2rTLcLa(20iNmT)TLqiiTmqSriT_hSaN702T6NiT7Tqq_i2ri7aS_rNc7N20cci)20rqcqNm2iSamr)r_LSL7c0N2)i0Sq)q_mSmai0r2_SSLN0Xq)Sqi2))_7i2Aa)aqriQcLr.7c00cNS)2qi7_mra7i0ScrL_2OiNcNiT7TTq_m0i77aS_rNc7N20cci)20rqcqNm2iSamr)r_LSL7c0N2)iTmq)q_mSmai0r2O7L2v)_sNiqcTNm2qarcr_S7r0__LTI75aN_q)TIqS227)7ciir_p0LI}Sc20)0N)iq_i0m9aSi2S)rg_i8_T)0N0q)2q_27iSa2iNr6VSLL00c_0S0aq07720mL7riirrNrLr8Nc0022))_qr277i_TirrSLSy0Xrqr0a27qTmcmia7a)r_L0c2<TNcNiT7Tqq_m077a0rcirL2_i0ccN)20a7c7_a770r_iTS7Sa__0)cF0ST2q)qcmi7_S0ibSSL2x)xNNi0_)))_2S2ma0i2LSrLc0_qTS)iq)T_miq.7)7qii_cSac2h0NccST2)T2c2a72riimS)SL_iTTcqqrTTm4qai7r2S9iiS7Sq__T2)iNaq_)Na7i2rcaiL2rr_c_Nc2TS0m)))_2S27a0i2LirS_)__cScaT0)2mSqLi07qLS_i,)L_Ni=30)0q)i7c2r77a0rciSL2_iN_cr07T0qc)Lm27iiciiS7ST__c0T7Naq_)Na7i2rcaiL2rr_c_Nc2TS0m)))_2S27a0i2LiSm_)__cScaT0)277227)mjii_cSNc2_a)c)_q7)0m_2T777ai__)Sy_Sd2N)NcTi)_702Q7Sa2r)rNLi__T0cz0ST2q))#mi7_S)i_raLm0B:_ca0mmt)_qr277i_Ti_SqNV_L0iT_qim0amqmmm7_aanrSr_7:0NccST2)im_q)22rSi2rTSc_0TrcTN)T))iqTrTmTS1imXmLNNx;_)mN72e)T772rmSaSr0rrNr_N02)mqc07)rq_2A7i_Tia_LN000)mNm0c7T)_2qryScSriLcoS>_1c2NNmTT_qqiMmqraL2=HryLuW2cN2T0_)qa5iNirr_iNcTST_TRicq2m0a)iqTm07i7r,Tr_Lq0J0Lba)_TNaTqTmT7iaqYmrLc002Tq)c0LTNq02im)r7i0iLSrc7ATNcNTT22i)Sa)2_7aamr2Sm0m_m.Lc_T0mcqi2mm)a2_;rBLSL^c0T2N72c)iqqmTSraiimr)L20%QiNN2rTNTq7iirSo7OihS2LNTTcNcSNL7Tq07_i_riLr_2pS0TWTxSq?0i)Nar2NimS0_rirSr_0_L)DN)qi)i2)qf7Saqr0S2>S_a_Lc_02Tcm)q_2a7mS)im_iSmI)/rNiqcTL)N20mi7)S7r0rLLrN7c0cXNST_amqei0mjiSrTL0c7U0ILNrmT)0)L2rSTa0a-iSS_0mo0ca2T0a2!70i0Sm7mimr_Sa0rg2cL2m2rm0722aSr7rirS0SL0<_?Ti022))_qr277i_Ti!__SSN7c0cL0r7Tq0q*2S7__mr0Sa0T_a0L)0207m)m2mm_7a_riLS_LmF2c_cHmm)0qarTrqmLL0rqNmLm3mc_Namr)_72mTrcaLiNS0Li_)07N0NLTrm72Na_mLS7i0rLSr_iWrqrNrTN)022i)7_ari7Si0T N0_cLq7)0)L2rSTa0aLrrNT_0_Lcr2T0a2_qNi7r2LriirqLT0rYicq0Tmr)iqqmTSraiimr)L20{niNN2rTamqaTi)S&7!iOS2LNTTE_Nq2A2y7N7=maLTaTrTSiLqTmcqNc0N7m)Ua0i(S2L&_2c00mKmcc2T0_)qaYa+i_mLL0rLNmLm!mc_Namr)Tq)m)7iaTxTran__ic7c)0_Trq7qam_Smaa_YSmNT_qTS)i2TT_qSqa70SiL_rarLL_O2cc))0_Taqma)miaN_TriL7L)*_TTNHTS)22)q47ia__2itSg_2(NqTNaq_)Na7i2rcaiimr)L20JvqTi02)))N2iic7iaqrT-cLL_Nc0Ni0)27q0qLmrr7i0i&rSL_Tmc0Na2r)02cqS72rrimS)S__S_mN0022_Tmqm2_maLriN_2Sa0c0_T7000BTSq_rmmLS0i_SSSao007N0NLTrm7202L7r_Tr0rfSS__)mN00a7TqN7Li0rYLqArrrLrW0{LqQ0LT7)ai^mmriL7_Scmc40r)}NM077rq22LSmaqaN_2cTN)TvhYNtT2)NiT2_7qLmi_SSS7u00mNTTcTiq7qTm_a0LiiTSTLi_q)mcLq0Tq7Saii)7_ari7Si0T_a0_NiT7Tqq_a)m_7aim_)LNLqh2c_N7qS)2qN29iSamr)r_LSL7c0N2)imT)Nq)2TSrarr7S0_cLLc2Ni202)qNqqm27_a7LSS2LN_}0SN20TTcq0irmra7i0ScrS_2ki0_qm0qT7)miXm,aSi2S)SN_iO_)2)7T0TLqrrT707LircTL0LLArqT000zTSq_rm70aaxTSNZLN00Y)22r0r)r202LSMairNcrcr0c0rT_0a7T)T2Tmi7q_mr0Sa0T{N0L)r2c7m)m2mm_7a_rr2SL0m0mTr)mTN7r)r2r707L_grsLS_2c)cc0iT_m0icmTacair7rqL_4007N0N/0S)_im2Z7cicr2rIN6_r0SNq0cTNam2qi0STLr_mc*Lz_7)rN20L7mqqaTrNLmamrmS_LaTrc2NLmm)q7Ti0Sm7mimr_Sa0r*rN700)cTS22mii_arr7S0_cLLc2NiTcTiq7qTm_a0S7ia__LN07T2)c0i22)rmcmNa2SSr2STLc.0)rNrT7)02cqS72aiS_rcL7_0ccXL02TimcqNa2maLcL__7L0c_WTN7NaT_m)q_2a7mLZi_rrS7_i)Tc_0qmy)L7ra_rL_TiTSTLi_q)mNmT)T_qSq770a2SirmL)L_pS/a00T2)Sqmm)m_aSamS0L2_i0ccN)20a7c7_a770r_iTS7Sa__0)c_Nr07)iiT2_7qLM_T_rLq0e_Zcd02TNaT2N2SmL_Ti7__c_NrTr)2qS7TqTqSrh7iiN:rSacm0T)rcr0r)0)LiHm4aSi2S)Sc_ij_T0N/TS)22)2N7ia_r)r_LSLmc0N2)S0Lm0qqiSriS)i__iS*f)6qNiqcTL)N20mi7)S7r0rLLrN7h.T_0i)7))2_mra7a4r_cmLuDScTq)20)ia02LmNa0iir)b7_0_Lcr)7T0Ts)S2_Smamr)r_LSL7c0N2)iTmq)q_mSmai0r2SSL2Y)_-Ni0_2))q7i2LS)L0LSS2c0_mcScLT027q0qLmrLTi0iLSr0TV09LNrmT)0)L2rSTa0aLrrNT_0_Q&SN_mmT3qcmc727f_ rLcr_TTTN0qrTN7T)_ir7aLTrcJrSS0T}7TSNYTcqc222tSHamLi.rc)LSz5N00TT_amqFiNS2L21rSrL)Tmc0NamTmqmLa0mmLmamrmS_LaTrc2NLmmTv7Na2r2LrarrrL0LLTIci0N2_mS7m2rSr7rirS0SL0%nNN0NrTiq0qTrr72aL?mkaSNN2GrqrNrTrq0qLrg7rSir2F)_0Ni L))TNTqq22_m7rSi2rNSAcShNT0NrTST720a7m0r_imS7ST__0)NN)i0am))_2amma2imcmSmLL__N0qcTi)mq)m2S4arLiS2c)/00icLq)T_)a2mr{7_ari7Si0TzN0_Nrq7)0)L2rSTa0a}iSS_0mU0ca2T2T2JqTrTmTaTiirqNm_0#aqTqTqI)TiT2T7TaiiqcmSa_i.TN00i0raTq_mqSgamaa__ciTT4TNT0iTqamq?i0S2Lq_cSLLN.0ciN)q7)0)L2ri77aS_r)n7L0_LyrNi0r7r)r2Nm0a2L)r_SrL7PiqTNrq_70aNaS72aNiscmL2_TAcN02rT2)LaiiirTam;mrmLm__GaqrNLT_)m22m_mF_mr0Sa0T0T_L)00m7m)m2mm_7a_rrS12_Ncccq02qSTS702L7S72r0_7LqLa=iN0NS2c)iqqmTrca)L2S)M_N0R)qm0iTN),immTa)iNrirSSLTTT2qc0_27)0qL2r7iar{rrrLN_0c2))0_Tr)72iSTa)S_raL7LL-_T)N)qi)q2)q_7iSciirqLT0rOicq0Tmr)iqqmTSraTL2rrNcN_)TN0NLTraT202L7r_Tr0rRSS__)mN00a7T7TariT7L_mimSmL__a)rcL0_Tmq22_2fLmi0raNTNT0inN)2TN7r)r2r707L_fr-LS_2c)cc0iT_q)q_mSmai0r2_iLmB)h_NSNm)0q27SmamLa_r2Scc)__jaNmq)TiqNiTmra7i0ScrS_28i0_)00_)S)mm0ri7TiTriSq0m_LT0Nq2Smi7)2_mr77iicTSac_*iN7NqT_m)q_2a7mS)a_raSm_2PmqmNm0LT_20ic7iami)S2N?_KcSN2T)Tcqi2_7)7_iSiaL0_2Nicm0)0_)S)mm072rSi2rNSE0mk2cNN^mm)2qT2c70Lri2rLNm_q0N)c)MmrTrqrm0mLL&iiSNNr_a0q))qqm-TEq%m27N_TiqS2Sf__c2cm2nTiqNiriSri7aL_Sa0T_TcTNi0q7mqmm)m_aSa7S0L2ciZmN)N_TSTa20m2rLamr)r_LSLmc0N2)STaTLq_m27cS)i_raLmN)MRNS02)))c2im_r0a&rSS2_)_NciN_2qT5qS227)mZiir_W)S__aKmN20m7m)mqL2_a0LcriSmL)V2)5N;TS)22)2c7ia_L0rOLS_2c)cN0iT_7qq;mS72i)aVSiL_N)W_ca0mmw)_qr277i_Ti_SqN!_L0aT_qSmcamqmmm7_aa#rSaL)_q)rNNq2mT7TiTirSN_rrrS)0mg0ca2TTN0L70icrcLrarrrL0LLTkcmN7T7)_qmrm72S0i_SSS7&007N))_Ti77qii_r_S7rNrSSLTTUaT_0immq)irmr7)_mi}Sc_c52FDq:0_2iqcm)mqSii2S0+7_TcccN02qi)27)2_maamL)SNSq_2o_c7)ST2)Nq4aSmWacrcS2S+0y>_Ti02)))c2i2%7cicr2rDNn_cTrcLq0)N7>2m7)7_iipTSr_7D0)c)_T2m_a02Si27a_cric2N2TrcTN)T))iqTrTmar_LV_7LNLS_LqT00q_)iamm)Srari)cmSLN0zq)Sqi2))*2Sm2a0S2i)LcLNX20SN20NTHmS2a2L7_i2rc.)L__acm))0_Tr)72iST7raSrSL0LrTrci)2T0qc)Sm2mr7SiSS0Sr0r_S)mNaq_)LarmTacair2j6Lmf)B_)Sqi)07ia_m7r0aq_SS2N000)mce0c)cq2qKrI7qSi_r6)LL_7Aaqu0_2iq2iT7cLmimrcNTLaN_cNq722mcqrm770a_L0rcLSLLc0T7000L)r77m0mLar=TS0SL_r)TN0NLTraT202L7r_Tr0rLLrTTc0cL0r7Tq0qLmrLTaaL_n_N7_aTcNi0q)T7c2imqaTLciLS_LT_2oLNqmmT7qirT707Lir_7SrLSYSN0NrmrTS72immTaaiL_SSV_cccN2NBmxTZ7i2cm0S7irrSLSX0krqr0a227xair2r7ariSSS_0_r)rcLq27ca)a)rraNa2rNLcLT80ccNq2>TLa22mm7a7i_rmNm_m00cq2m0=)c2cm2m!L(im_icrLmTT)m2rTT))2)mi7T_Tr0__c?LrTm)r2BTHmiqcrm7La0iLSSSR__ASNN2rT)a022mLLmal_NcTSO0aTr2T0T)Tqi2qSm7aiiiVS0LavNqTN)mr)iqqmTSraTL2rrNcN_)TN0)_mm)_aSirmmSrrqSmN0_cT_q2q>0r7)2mrU7Ni0imriLN_a)TNi2_mm)TaPrcriS__<rrNmTrc_NqTT7Tqaq_maa7arriS7LLTmc{q_T0)aiT2amS7rgTra_c_rc2cT0TTi)qimm2r0a__S9rSm0TT2qr0N)7qT2_i0SrLmiTdLNT0_TcNi0q)TarqLm_7Ta2iLSq0m_mFLc_T07rqi2q7TL0_7LTr&ciNSc_2cTi)Nq rm7mi)_Ti!ci+0Tr)mNT2Lm.2NrcmSLi__rSSL0rc0q2q 0r7ma7i0r2LmiT;_0Tk21LNr2r)N)22N7c7Ti0rcSqNxFm)2NiTN7rqN2)mTLriNS7LT___rcr000L7uq_ai72L)_TiucrN_)TcaTcTrq27irTrY7rL_,7N2N7c0cL0r7T)q222rm_aqiLcsS-_q=2NimT)0)L2rriLcSiLmriO2cq)7000a)mau2H7SSramDcLi0T_S)7qm0T)a2Ni_S0aciN#PL20iTT9%qr2Sm27iirmmLNlmSiLN_-T!NqNiTqq)qmm27)aa%TSrNi__cqq,0qT7)mijmqaSimS0r&Ls42cN2TT02_qii7rm7TL!90NmLLc)c:0iq_7maTq^77SG_i_SL2_NUnqmNaTiTlq02a7N_TiTraSi__)mN20NTu7_i)a2i0ami)riNS82pLNrmT)T2ca^2rSqi_1mScNS0rHmqN2)mma2iim77a_DrcNm_25NcYq_2D7mqL20mLaSatr_SS_NTrc420T2)Lim2urNLTawpacXTToTNT0iTqamqamim&a0iaSN0T_y)rNi0q)Tar2Ti27r_c__NT_0N_)mN_2Smr)mi0rmaaLSP2Sh00Ti)Tcn2imriT2q727ra_rqSL0mx_q0qr0m7Ta)a_r0LTan*rNWk0kaNm2mTL)0qLmSm}a_iSSNNr9T)0N20L7m)L2c2.LmaLS)SM_i_mcmN_0a7rqia270LcLuircmNiTQcq0STmq072i^rr7mLrS2N0N)R_ca0mm>)N202mmiaNiacrSr_N40N22lT_)a2mr2SSi2SS_mLm_L))N_0q)Tar2r77SmaT_SL2Ng0rwmqcq_mma)2rr_L0icrNc?_2Ti)TcO2rmS72airr7m_0cmLi_NXX)g0q0i)q2)2m72a)iacTLr0i{_Nq2ATq)7qmr#7qiSrmL0Ss_Hc2NNmT)0m_2ir7SmaT_/c00m_LN)NsTi2_amiT2{Smir:i&SLmc)cL0iq_TLq_i^S0S)iL_iLq0)(cTS02TN){im2a7i7Fi0raLNTTxTcaNiT_am22mN7nL_o)_2b)_i0TNL2S)2)L2rSTaTrc_VrrN2R_)mNr2Smr)mi0rNS2_2{iS7LaTmc_202rTmaTi)i_S0_Ti&ca0bc0ca0mmm)Lq02L7S7%i_rSLN0rcTq002TLamqLmcm+_miLL)LyGi#mNm0_Taar2ii2a0_c_QrrNm0i)JNqTS)m20a2r{Sram_Mc_Nc_SN7qqT_m0ar2)acSLr2+LNTLSG_)J0q0i)q2)2m72a)iacTN2LDTxq00iTqqTaHmqSraqK0c2N2_)c2qm0c)S7im0rm7L_TiLciN_T0)2q722mc)rm77Na_L0i7riNc_ST2N))cmL22aS7qS0iLySS7N)b_ca0mmf)N202mmiaNiacrSr_NR0N22,T_)a2mr2SSSqrcL_L2!2))N_0q)Tar2r77SmaT_LL2N9yT))qTNZmaq_aSr_L0icrNNm_TT<c_NaTm72ami^7q7iiqS)Sm_2K)ca2TTc7iq_mqStamLa;rSm0Nc)qrNrTrq0qLrl7Ni0imriLN_a)rNcmT)0)L2rST7rS_rTc7N2Trci)22Q)2a)iT29a7LSrLciLST2)_qm0TmLqLrmmaaiajr0Sa_NTrN0222tTrami7r0S2_mrTcGTTc2cL0rmrqNq2mNacaTr0ScLq0Qcmq20i)Nar2Nm)7T_rrNL7_Tl_ErNrT0TLaU2_iia2_)WTr>Nr0_qTNa)c)r22aiSTS4ar60cm0207cq)_0))NaaiLS7im_0sTN4^0)c)4NL02mSqm7)7LiiL_SNL_0Z)0))0L2iqqi)rrS-aLrcrP0m6T)N0N0qqa)Fmra)r7i7xiL2LLErqTq2mr)cqNrmrrL2L7rq_cN_c2Ti2))Tm_74r)SNLqiqLcc_V20Sc7T)mNqi7_i1mriNrq,)L__acmq:0N)0)mqimN7a_rirSNL0V2)3N_0a)ma2iS7+rTSi_NSa0)?_cq0Tmr)r27immTSLr2KocrLmTc)Nq2m)))a_r07caN_RS2Ni0T_v)rqS22miar2mSN_mriSNLl0;cqci0q)))m22m)7a_TrrciL_eq).Nq07Tma.2q7Samr0i(S3_25NqT00q_)ia7immTSB_0cmSL3)*FNi)_mm7T)pi0rMLiLSS2LN_#)mca0i0d)0qamNLTaTiariL_Tmc2NN0Um_a)qta)icrNr_cS_2_Lcr2TTTqc7(qrr2a__mr)cSNr_m)NqcT772ai27maLmi_c0crLmTT)))_207T)%iiS=i0iaSmNm_L90cL0S0<)_qSmNSriTQ0S2LLTmhLNcNU7m)Lm)m=aiamrmS_LaTrci)2T07c7QqrrmSi_yrqLS_mc0T2qx2rTmq_mTS0S)iN_iN)KTTc)c2)2))c7i2c7a7_iaS7Sr_ie7cL2mmi))iTr27_aarmr0c7_q0_cL2qmaa)mTr0SmLrSTFbN)T)T)N_0a)ma-2N707mairNSa0r_rcNN0T27Xq_2a7mL2_Sr)_TcL_L?L2)T_)q2Trr7ri7_mrTcSG2TecS2)mTT&aimLr_L_z0ScLNTmnSqb0_Taqmi222aTrc_ZrrN)u_)mqTNb)27&mNr_a2iNr:c_Lc_0T7Nr0S)S202rSraiL2rmNT_qTrcT20m2m7qT7crLi2LircS0N7eT0cq_)2mi22rmmRiS_iL0NijLcac2)mT02imLmNrNi2ScS7L0Q0ca)20a)0qTa770r_abMrSL0T_r)iq_0a)i)J20maaNwTS0NT0NTq)a202))_qammS6aNr0rmSi_N^aqr0NT_7BiTmam_aar7rrLi_7ULqm2iTr)S2S707r_rrN 2SSL_cTN)T))iqTrT70r_LAircmNi0)cmN7T7)_qmrm7mS)iiSNNr_mTqNqNa)L)T2#77iSaSzmrmLm__Iaqr0r22)!aLmL7NrqirLm cN)c)qm0q)0a02imm7)i2=}SjciT))7N_0a)maD2i7NLrim#q12_aNq0TNaT7qrqTi47mLTirRaSq_2_R00)N0r2a27r0mrarr0rLN!__0iN22)mTmS22mT7ci0frSic2j0)c)_q7)0)L2rST7arcriL2ci0r#mqT2qmcqNm7maiciiS2cSNr_m)Tq2T_m0aTq?rrSSL7rqL2Lr__cqNLm*)q7Sm27Naf__cTN20mTa)L2Nmiq0qLmrSiL?9TSaS__ac7cr0iT7)Limm_SraLtTS%Nr_a)TNc2rT>a22mm7a7i_rmNmL-0)ci0NmrmS7qai72L^aFr;L2_N)Tc_0qm>7N7am2SV7/i?S2LNTTI_Nq20mcTa7_miLTaTrTSiLqTm4aNi0T)0qiqrST7_iqtRcTcrb2),cw0{)2qNrT7T7S_*rNL0Lm_icNNamr)a)_2a777riir7SL0mxq)r02mT)na_m07a_TrTcrSr_rc0cL2xTm)727m_7m_mr2j0Nr_aTS)LTqmwq2i0r0S__0QicN_aTT)mN&2imia2i2rIa2_0/0c_0c0_)i)S0a)i)&20maaNyTS0c__iT_)2qcTi)mq)m2Sxami7S7L__m)mN2q0mNqaiTmiS2L2p0k)LNv0:mci0NTaaT2Nr_S9i2 )S_N_NLT0N_2_)iqN2tSmSi_Vr)Sq0r0ZT7000L)r77m0mLarL7S0SL_r07NqNaTiq0qSic7iaqrT cLr_))mca0i0v)0qamNLTaahT^_Ni0r:LqmqBmr)7iTmNSrimyTSqN_0(cNqr20mK)SimmqS+ir^iL0LLQrT7N00LTrqi2rSr7riNr0L2N)}_crN7TiaT2T2SS%aNr0rmSi_N+aqr0a0_)a272r7ia7iLcmLq0rc2qT0Wm_q02aSTaT_rirSr_0_L)VNm07)7q_2mSma2L0^rSaNS0LNqqzT270a0i_S0Li_NSaNT0m(O)iqim272awm2S0L0__ccc_0i0Sca0i0#)0qamNLTi0__SiN_02TcNi0mT)q2iZmm77i7r_Sm0mb2T0qNTa7Tqii2r2L0L)rNL0Lm_icNNamT)Na_if72L)i_(_/LN0I_)_0iTN)fimiiS:a)iqcrc;N7c0cL0r27q0qLmrr7i0iLSrc7k0kLNrmT)0)vqSm_Lmi0raNT_0NLT0qTmmTmqm2_maLraLr_Sm_24_9P2mT0)aiTiq2LS0i_cmSm_mt_ca2rTr))im2a7i7!i0raLNTTZaqTq_mi7rqLrmrMLri7cTLN0rcmqT0qm_7h2NrrS0L3iScmLq0WcrqiT0TLqra77q7aiiS0SSNc.icq0T2c)rq)rmmaaiaxr0Sa_N)T)2qq27mSaciar_SL_rUqciN_T))q2TmN70aqrA7_aarmJ)S__aEmN20m7m)mqL2_a0LcriSmL)g2)(N*077r)L2_mT72aLrqNmNi0aTSqc2)mLa0iNrtSaL_{0c7NaTm)qq22aaT202L7rS7r0rLLrTTc0cL0r7Tq0qU2S7__mr0Sa0T000L)00_7m)m2mm_7a_rr2SL0m07TTN_mmTmqm2_maLraLr_Sm_2A_vB2mT0)aiTm0iLSr}TrTLT_ibqqmNsTcqc222hS/a_Lirac)_%o7qrNLT_)Tq22L7q_mrqriLqZ)QmN20)TaaTi2mm77i7r_Sm0m_LT0Nq2?)maT2_rza2_Tr_c_NyFi)r002A)iaii_rcai_ro2N0N)=NN0Nm0i)Nqarr7NS7r0rLLrN7c0cL0r27qqqamia0aS_cSiLq*TTcNT0)))qi2TSTa0S_iL}7Lr_ScS000r7r)rimm)SkaL_2S)0T0L)i)STm)ciT2q727ra_rqSL0E,Lc0NLTSTxq_2S7NLr__ruLc.cc2c*2?Tm7r2qrT7oLriLb0Lq09cmqT0_mUq2iTm_S_LGricr_00Iciqi2Sm7a2a770LTLryiUSLa*igbN00a)Nar2aSN7r_i1SNT_rTac)20m)7r2NrNmLLi_Srkc)__VaNmq)T_)a2mi)m_aaimS2LmTm%mcLN_)07c2imm7)i2?8SmL7>7c_Nmmm)2702NiS7kicScL2LgTBccqr0a7T)paim7Lm_NB_cc_rz)qmNaTiT3q02a7N_TrNr2LNDcQTN00cTq7.i0mT7)i)riST0T!NTKNT2m)T7p2Ni27a_Trrcm_0TTciqmT070aT2_rna2_Tr_c_0c0S)i)ST27m7Qi_rc7Li_rTS2LL9q)GNLmq)ca_rcSma=_LraN207TJc<2q0t7_icmar7i0iLSrc7-01LNrq7)0)L2rSTa0awiSS_0m%0ca2TT02L70aSSm7mimr_Sa0r>2cL2mT2m072aRSr7rirS0SL0*XHc72r0L)_qT22mLaqBmSmNm__TrcL02Tm7r2mr2r7i0iLSr0Th0hgcS0_7mqm2cST7qi2irr_Lq_L)?NcT0Tmq02_mTaiarS0LqLG3i)rcSN_7T)7mSS)icr)Src0N2cmT_q))T70amiTaTL0_m TN7M20iNqNiTqq)qmm27)aa&TSiNm_)TYNr2mTq7:2Nri7_iq8kSq0m_mcmN_0a7r)L2_mT72aLrqNm_2c)cq0iT2)Tqcm070aa+TrqNrLrzrN0NLm8)N202mmiaNiacrLiTTc0c;NST_am227)7ciiL_Sr0TA0tLNrmT)0)L2r22S_i2rNS80m,2cNNymm)2qT2c70Lrirr)NmLayi%nN00a)NiT2)acarr2S0SL_r07N0NLTraT202L7r_Tr0rLLrTTc0cL0rmi7raLrNSqL_';xTvKEGxk_QyWquBviytAGbkVjiATevKi={"l)N3MO<Ou6uMO<RZX3O6)ZN)6NlOllM)pOuRNuO&3XR6pN)O33Z","u3lulO&ulWRRpXuMWXp6O<6_3ZZNNuZ6X6pR__O&3ZNplXp_W)lWu<_XNpuu&__&R)OMlR_ul_pM_<&","Z&)_M3uW6_pZM6l&O3l3l__X_3XR))NuNXpXNMNp)lXM)M&66","ORp<RR_O)p_Z6ZN<63lW&u_ZM6WuMO<O)Z<RM<W)lpuZlZ)3XM<lMluXZZWX)WRR&R_l_R3lNNRlRN)Zu))NZlZN_XpNONMpulXXW3W6Mu)WZXW","R_3M&W6<ZpMR)XON<pNXWuRZu)3_lMWuRM6_ZZl_pOZ<W3)6<ZMl)Z6MR_l)Nu6OWlW&_63&OpWM)&WuRXXu_RNNR_6<pO_lOp&X","pNul3)OpON3WZO)R3&66Zp<)uZ3Z)3ZZROWXWlXNpOM__ll_<OM<N3ZO63)M_RX)RWZMZ_u6_l<_R3p3<&N<NRp_)","OlXM3RuW<l_X&)33_M<RpMX3&M_N&)MpZ&MpRuRlMl_ZR663WpRN3NXWOROu)3&&&pRX)pZl6lOOW6uuNRZNM","_ORl_Nu_NM3uW3NN<&_MZ3lWlN&RXXu&WWMM66XN<pX3<)X_uZX3X&ul))&_&&Xl<3)6Wu3u_6ONul<MMR<OWZN<3p3XRZN6lZ__ZluluMl&6R6XONM33&RZl6<<_u",")3&uRR<p_Ml_XR&66&Rpu63WZu_O<OOuWu_p6MX&3W&3_l6XN&uNllpu_pWOlMX3u)3","3N)XZXZuRp&OZl<OW__N<pMMR_u6<)u6Z&6W<MlX)RlNZ)&W6l3_Nl6&luu&6p)p6XMMu<&XMpO_3RlOR63uN3)pWO3_OuRM3plpN&XpXuu&WOOR6X_M_<R)6RRWp","6_XuNlNWOXuZ<3NO&l6WRZOOW&uXX&pZR<6)3)l6XM3RXMNWR__XOW_ll_u6MNR_p6X3__pORZ","3&<M_3_MllpRO3<ZNM<upZXl)&Wu3MZ_XM<ll)X)_&<NuRM&WO)<_R3&NXMNXXW36MORRZpl<<6&&u<R<pRM3u36Xu&uN3W_N)&lZ","WX6R3<6<ppN&MpMRW<<MpM_W<W<Z)Zl&lu&WpluNXX_pl3<_&NlZNOWMNllplOXR6X&N)l&W<&ZuXu_u6)p)<_MX<<<XMW&6u&Z)NZW3XpN&puW&O&O&6NMOW3NOuMZ6_p36MRpMWOM&3RMuRM3u&R<6&lZ&)p&puR<3l_lWXl_MXZpRluNuNOWupWX<u6_R3l)&3lO<&l<l)W<ZO<))Rp63_6OW)WOOuOpOW)l6lpll_&&M6&WWOZpNRpW3Wlp_MXu6lRlpONMu<ppZ6&_WplO_OZMpR6))_&W3lMZ_M6O_3&O_3l3)<NM_XW)R<puX_3ROO)p3l)uO3ul_<OZWWu3O<RlX&M6)OM<WMWXZpWRpWWlNZX&WXuZp)uOR_NM6<W)ZN))XX)6NXWpu3<3_&XM6<Zlu66Wu33_3XN3&3pM<pW<<N6)uXpWlNXl3&pW<pX_)Np)&Ml<Z&Mll3)l_p6u3pX6__6&O3Zp63lOlZX_)uO3XZ6W6OR3W)WX6XZWX3Zpl6llOu63ulp_Z_p6<M3uWlMR_l&O3uWplOO)uXMNO)uOl_Xp_)upuROM_XWW__p6pX&&MOMZWu3WXMlZWXlZu<upMOuZl<6Nu<6X_u_u)O&ppX6uX36W_3&OZp6Z33&_M6MWlMN3Z&W63RN&<ZM_6NX<&O)Ml6XppMOX6p&NRpl&N63uu__)N)MlXpu))NXuRl&lMZZXWO6XO<RMNZ36O)3MpOR33Z_WXMNpRXXWRuXXZlppM<O&uW&u36WXX3p<Z&pN&l<<3NN<RX_OpWWX)u)R63OpWXl_6pZ<)W<W)&pOllW)WM&upllXWlXZZRuM<)OM<u&_R)_O))66Z<XW3M<Xu6O)&)NO33RplpN3W<M<_&WOXXO&NZ<_W3RN3lulM)ul&WOZ&u<3O_R6_3uOM)pXlZM_XX&_N&WZ_)lR<lO&WW6lu6uWX)N6XppZNOXp&X&u<3pO&<lMXXWO<MXXNu)uWpNOp))Nlpu_&Z6NRWXZMN<Muu<&pX6<)_NXWMROuXM6u&ZlNRuWM6))Rp_)Mp<&R_ZX&M)pX<R)XWO)<<N_XMlMupN6ll6<ulZ6<W6&M6X6MX3M)p&RZNp<p6_Nl<&XuW3N)W<Wpl__WMuXO)uW&uO<<&M)&uZZ<M6Mu<pWMROpXup_O33<33X<l<6)XRluXMMW<Wp&M3pp_R6l<RMW_&lR_ONW<Z6puRl)W6<WWl&<W<W6pN3_3l_M36ONlZpl&3M_X<XlZ6p__O3X3XN3_OMWMpN)<XuupR)lW3Mup36X6<WN6W6uXpNlROORNX&3<3XWup&6_N6RN3pp&Z3R&p_3ZulpMRp3N_<u)ul&MWluR&&XWWZ&M_)up<R)OMM&lXp3NpX)MpNR6)_)OX)&NWplpRNO3ZZ3N<MuW_uMRuu)uO_3_<36_6)lR6OXZlW)3OM&XX3lZXW&Xull&<)<N_6Z&NR<Z6pu63NWOMNN)_l6_OXZMXXXN3X3X3lOMXMO63uOW)3RX&M_M&_pl6_MOuX&33p6u_RWpR_R<Z_WMuXZWpRpZNlp&ZXWWl_<W6_NROXO<Z6ZWZM)3u3W)ZOO6<3NZ&O3N3W)_M6p<)&OWuMMOp3p&X&<W6plOl66Z6N_Wp3NlM&))RpWWWu__ll)lWNXlOWpXpROOO)MOOM3WN6Op&&pl&ONOXX&W_XMpu&u&<X__W&W6_NM&<RuWlRu6&3OW<<3l6l6ORX3Z&6)&_RuOONM_ZZNX<u_&MpZpOR_3<&ROl6OZpZ6MplXZ_W3OlXXX_<N_)Wu<XMRlZ6Op_Z<ZW<M)lXO&OXX)l_<636OOXllWWZZNuOW)WO_)<ZRM3ZWNul&pOWXX)R)<uN)p3l_llX3R6__)pWRlONlM6lO6MW__uOXpM)OO6&Zl&6RR3W_u6<_NOOO3pXNRMuuM63<_uplMXZ3XOZl&XZR)XMMNZ)WXl<X_u__3<pW<XORZ&uW_WpMWX&RMX)6Mu)6X__pM6<3ZNN<pM&Ml3)<O63MONOMlOR33XX6W3Xl&uRuuOuOp_OW_puNZZZ)_Z6N_)<)pN<_p_X<lXXuXR&&N_3XpRZlMZZOXOMu_XWMRlWNuuRlO<3<uR)luRZX<MOp3pOpN_<NWlWu6W3Rl)Mlp_X3Mu<<lZ6p3lMX)M6)63M6&XlRN_ZZpXuRZO_ZlO<NMM6u3)l)l36Z6uZ<lul33ZX__u_<RM__)NZ&RuZ3Z6N3MRW_O33WXl)O&__6p)&M<RXRZ6OZpW3l3WW6Xlp_<WupZpM)WR3_<6&6)l33_X3O&)36Np_<pW6<lZRuZR6lZO)RNlpu_RNO<&XW&MX)MuNpR6NRZZ3&&Mup&MMR6X6uWp<)<3uWu__&<6&OXp)MMu&3)<p<<_))RNlOp)p6lpZ3W_Oup_&p3&X36pR&M<l<Xu6N3ZXp&pO)R&__XN)puW<pN3<3)<<63&Nl_<ZWu&)ZRpO<plXZXO)<_)M_6Rl_<NR_MR)R3<uWp)OO6_RNpW&Z&ZMZpWM3ppWW)uMZl3N&uRMNW<NXWNM)XZ)3OM<)6lW&<)OWX&6Z<ZRW6&l6MWRpp3M63NplWXMNO&ll3NW6<XZZ3WZN3&WW&)N<uWM&lNRl_XNX_pW&&&M&6XuX6uWp6Np363ulWRl<p&NO_6NW_MlO_36u6pZWRZlMWR)W6pRN_3OM<363XWu&pWM&lWO63M&lZOuZ36R_36_Z&MZlZW<",""};return(function(d,...)local b;local l;local s;local f;local r;local o;local e=24915;local n=0;local t={};while n<676 do n=n+1;while n<0xd1 and e%0x38c0<0x1c60 do n=n+1 e=(e*257)%43136 local h=n+e if(e%0x1208)<=0x904 then e=(e-0x14e)%0x50ec while n<0xe2 and e%0x4dd2<0x26e9 do n=n+1 e=(e+292)%43334 local h=n+e if(e%0x2a06)>=0x1503 then e=(e-0x186)%0x9594 local e=23188 if not t[e]then t[e]=0x1 s=tonumber;end elseif e%2~=0 then e=(e+0x11a)%0x345c local e=40971 if not t[e]then t[e]=0x1 r=function(r)local e=0x01 local function t(n)e=e+n return r:sub(e-n,e-0x01)end while true do local n=t(0x01)if(n=="\5")then break end local e=o.byte(t(0x01))local e=t(e)if n=="\2"then e=b.qasGtzIC(e)elseif n=="\3"then e=e~="\0"elseif n=="\6"then f[e]=function(e,n)return d(8,nil,d,n,e)end elseif n=="\4"then e=f[e]elseif n=="\0"then e=f[e][t(o.byte(t(0x01)))];end local n=t(0x08)b[n]=e end end end else e=(e-0x201)%0x720 n=n+1 local e=28359 if not t[e]then t[e]=0x1 l="\4\8\116\111\110\117\109\98\101\114\113\97\115\71\116\122\73\67\0\6\115\116\114\105\110\103\4\99\104\97\114\108\83\71\117\89\105\113\108\0\6\115\116\114\105\110\103\3\115\117\98\70\119\75\115\75\80\68\101\0\6\115\116\114\105\110\103\4\98\121\116\101\85\85\85\108\68\106\113\90\0\5\116\97\98\108\101\6\99\111\110\99\97\116\115\110\66\89\118\84\95\79\0\5\116\97\98\108\101\6\105\110\115\101\114\116\73\90\71\103\67\73\102\106\5";end end end elseif e%2~=0 then e=(e+0x3fd)%0x53a5 while n<0xbb and e%0xf3a<0x79d do n=n+1 e=(e*231)%14485 local f=n+e if(e%0x1086)>0x843 then e=(e+0x24e)%0x5a5a local e=57929 if not t[e]then t[e]=0x1 o=string;end elseif e%2~=0 then e=(e*0xbf)%0x409e local e=18056 if not t[e]then t[e]=0x1 end else e=(e*0x12d)%0x9938 n=n+1 local e=17662 if not t[e]then t[e]=0x1 b={};end end end else e=(e-0x1c3)%0x27e2 n=n+1 while n<0xce and e%0x2a56<0x152b do n=n+1 e=(e-242)%987 local r=n+e if(e%0x3118)>0x188c then e=(e+0x385)%0x9b77 local e=53905 if not t[e]then t[e]=0x1 end elseif e%2~=0 then e=(e-0xde)%0x6123 local e=51494 if not t[e]then t[e]=0x1 f=(not f)and _ENV or f;end else e=(e*0x324)%0x2a26 n=n+1 local e=10853 if not t[e]then t[e]=0x1 f=getfenv and getfenv();end end end end end e=(e-921)%26148 end r(l);local e={};for n=0x0,0xff do local t=b.lSGuYiql(n);e[n]=t;e[t]=n;end local function h(n)return e[n];end local y=(function(d,r)local l,t=0x01,0x10 local n={{},{},{}}local f=-0x01 local e=0x01 local o=d while true do n[0x03][b.FwKsKPDe(r,e,(function()e=l+e return e-0x01 end)())]=(function()f=f+0x01 return f end)()if f==(0x0f)then f=""t=0x000 break end end local f=#r while e<f+0x01 do n[0x02][t]=b.FwKsKPDe(r,e,(function()e=l+e return e-0x01 end)())t=t+0x01 if t%0x02==0x00 then t=0x00 b.IZGgCIfj(n[0x01],(h((((n[0x03][n[0x02][0x00]]or 0x00)*0x10)+(n[0x03][n[0x02][0x01]]or 0x00)+o)%0x100)));o=d+o;end end return b.snBYvT_O(n[0x01])end);r(y(211,"0T9t.e{P/^(<M)rU9Uer<^r)Tt.9(/)()Mte{te)<Ur<(e)T9)P(<Mr<TM.t{9(t<.^.MET)/M^9<Mr<oU.t^)<t/t<T}Mt){M<e)U9^.(Pi</))rTMMU(e(/^<xUJ.te/(eM)r.9t9MTe.e(fMMU^9<e.Mt)MUU9^.<^t<eGt</r{.e{)^rr/iM{^{.<^rrT{./lT9U/<<<reteekPM<Pr^E{eU{P.(P/)(W:te{r(Mr/99t.{)/.<(^tMtTr./PP(e)TTh.T{)(MU(9P9M.)t{{.MTUTTr/r/M<(r{tTt/{)<<PU()h^t/{9(9U/9.tU{(/trtrUM/U/e./.(<)/*ee9P.<)MUze9e{P<e{<^^U{9&ee^(M/TPt<ePP.^Mr^<.r9t){r^(UrT^tTe</()tT9t{U)9</{<PrTteer(^M)U<T9tT{M.{P{)_x.tJee/(r^Ue9{./(<MtUr9er^TPPt(9)ttUe(P^^6rTr)9Ueet9{s<)r(T/P(^.</U9tT../((eP<(<Rett{9^&<<9{e^{)(_MMU/1{ePTr.)(P).ae9)^<MMr{9/.XeM^M)/^.M99TeBP<M(rt6re)/U^{){T())&<{)^^M/ttt9/(/(rtrE9^.99{e{<z)<Q)t({P<eU59t9<eP/^<(rTM^U/ePPr(r)^T(.{PP(t)(aMtMPMtU{)M^Ue9{^t<r<)U)9TP{PrM9//<{Tt.Z{<M-U<j(.{{E<(rrrU)T>Te</U<MrPTuP(<!<<rt9PeM{^/)P.(9nXtTe/(tM)T(9NPP/r)/iT<)rM.{P9(wMM#(e/^/^treUU.^{/tt{9M>rMT).9^^MTrtt^tePU(MrU(^)Pt.{.^t)Ug^t{P/^.<.1{T<U99WPr<*)(T.tU^(Mqr(9/eP{{t<{<MPUe9TetP<r)H<T^Pe^e<)M<U.)rZ){P^^Mtr)tM/r<rM(T9TP{^P^e./9r.O(t</V){r{feer/M/PM.^)M<9^e{/e)grMTU{.PM<9U(U<r{T.PT^M)TRU../T(<<UR)9eet9UeU</r.Tt.eP.MMu{t<t(^.^9USU))9 G{T/P<MU{9Pe9/.)^)<Tet)T<.^({)e+T{.P)^/U9pe9ee</({.^9UeTM.{/)r{UUT{{r{(MLM^())Mt){P^9<)Z<t){((r)rr,9<te9teT(U)MGMP(/9MPU.9t.eP^^9{M^(U<9(eT^9<<-PtP.UP<M()r<eretr{)^UM/U9tD{M^^r<UeT{Pt{re//{r{T}t(/IM/r/9.eMeU/M<^(TMU9MeP//r)T{9tPM/{(tUe9Mr(T{P{)t)UT6.U{/(/MMU()^we{.)tUP8tePP/^TMr%PM/U.e9^rUoUMT^e9^tM{rP<("));r(y(198,"8.5S*KQ;0%?91MsBS?;?5.K1%*1K&*S;&s?0BS5KQ5;KMs.5*?;K%Ss%.Q)2S9sRzM*K0?1*M0.SKs??s..M*5%0QS?.*Q059SB5S5S%?0MBB.K50190RZ10y0?Bs?55KS%51K%MSBQM9?sS55Q50;1%.0*SKs1*MS1*y5?KMS5,*s5K1QB0SS0p95ss5.SB%Q99Es.?0%KX%5SSKB?0M9DMKQ;M1?B.51;+?SM?BM5MQ1M.s;*5;.*10%.5K9%SMs.SKV*9?*MK.?Qs9511.BSB5QQtcMS.;S90sM59KM?Q1%BKK*0MK>0%B9*c?%s5B;Sh%0?Ba0MbJs9*s%5;Q5%?19j?SM;B%QBQ5B;501M?BBsp.B10sB5?Qs?.;15KK0%*9BB9SM0K?019SqS?059*G9sb.11KB0S*KB%9MMG.K1%.MRq;.Q0.?10V99QC%11Mc1*1K0%;M/5sKM%M9B.Bs05*1?BBSM;09:s.5yKSQ0?MMM5K;;99MS.RB1SKM?.Q*;0Q1QB_SKQs?KM%5;S*;.Q}%1*SQB9IsS.9QQ?.s&A?*%KM%Bs%S9B1S?MMX9K00QKMB0S0;K?Bs1.1S.;;?Ks..M;*9?0%"));AacnzerEFmRWPYV=function(e)e((-b.mrGstAvu+(function()local f,e=b.PegkeWkO,b.sLIKBIv_;(function(e,t,n)t(e(t and n,t,e),n(e,e and t,n),e(e,n,n))end)(function(r,n,t)if f>b.SPmaZumD then return n end f=f+b.sLIKBIv_ e=(e+b.EkSsnXjF)%b.uaWTIdYz if(e%b.QHxFnvqv)<b.UCBPUEqL then e=(e+b.EVerWcMV)%b.DHGYzzRF return r else return n(r(r,n,t),t(t,r,r),t(t,n,t))end return t(r(t,r and t,t and t),r(n,n,n)and n(n,n,t and n),n(n,t,n))end,function(t,n,r)if f>b.yJKJhBJk then return t end f=f+b.sLIKBIv_ e=(e-b.DmlZXDwV)%b.QFbGPCXy if(e%b.PQsjYIDd)<b.kYDAC_qh then e=(e-b.YUsjkUGU)%b.jIMBxcqk return n(n(t,n and t,r),n(r,t and r,n),n(n,t,t))else return r end return n end,function(r,n,t)if f>b.weWAeDYR then return n end f=f+b.sLIKBIv_ e=(e*b.iVMZlRkY)%b.rx_edcDh if(e%b.qubwbQds)>=b.WCAchBUl then e=(e*b.wItGsC_K)%b.VdjEDIMG return n else return n(t(t,n,r),n(n,n,n)and t(t,t,t),n(t,n,t and r))end return t(r(t and r,t,r and t),n(n,r,n),r(n,n,r))end)return e;end)()))end;VYPWRmFErezncaA={b.oLrqzZnY,b.FKJnciQw};local e=(-b.EDHGQVYl+(function()local o,n=b.PegkeWkO,b.sLIKBIv_;(function(n,f,e,t)n(e(t,t,n,n and e),t(t,e,f,e)and f(e,n,e and e,n),e(n,f,t,e),f(n,n,n,e))end)(function(t,f,r,e)if o>b.usEXOwRi then return t end o=o+b.sLIKBIv_ n=(n+b.YgIXEryM)%b.pyWRiqQH if(n%b.PMmFpZws)>b.DmlZXDwV then n=(n*b.AbuChUrd)%b.ZUJsB__u return t else return e(e(f and f,f,f and e,e)and e(f,r,e,e),f(e and f,t,t,t and e),e(t,e,r and e,r and t),r(f,t and t,r,f)and f(r and e,e,r,r))end return r(e(f,r,r,r),e(f,t,r,f and e),t(e,e and f,e and f,r),r(t,e,t,t)and e(t,e,e,e))end,function(t,r,e,f)if o>b.WTTiXKpX then return t end o=o+b.sLIKBIv_ n=(n-b.CAohevxZ)%b.yjKzmhIE if(n%b.RwzYtLqT)<b.MvYKwxFV then return e else return f(e(f and r,e,e and r,e)and f(e,e,t,r),f(e,e,r,t),t(t,e,t,e),t(e,f,f,e))end return t(e(f,t,t,e),f(r,f,t,e)and r(r,e,r,e),t(f and f,e,f,f),e(e and r,t,e,t)and e(t and r,r,f,r))end,function(f,t,e,r)if o>b.TCIaLUpD then return f end o=o+b.sLIKBIv_ n=(n-b.JRb_FgRS)%b.dqyKxIzZ if(n%b.EIGLtIVQ)>b.jVDqWJSU then n=(n*b.JvbLwFoK)%b.RWWnqFdA return e(t(f,e,f,t),f(f,r,r,r),e(r,e,e,t),e(t,t,t,t))else return e end return r end,function(r,e,f,t)if o>b.xSkkmbiU then return f end o=o+b.sLIKBIv_ n=(n-b.GCbePOqX)%b.BQQvSGwE if(n%b.IdWfqGGG)>b.miIuRBgq then return r(f(t and e,t,e and e,e),e(f,r,e,e),f(f and t,t,e,r and t)and e(r and e,e,r,r),f(e,t,t,e))else return t end return f end)return n;end)())local oe=(getfenv)or(function()return _ENV end);local h=b.UvqvsHyj or b.ybKvFTLi;local l=b.dCGYEXOP;local r=b.ulKrfRbn;local j=b.sLIKBIv_;local f=b.QvUEQek_;local function re(u,...)local z=y(e,"eHNz&;yf}r0iobtU0Ui0Hff&b&Nt}it}&;0NUU;oUrHy}Nb Nb}0N}0;E&yob;Hb}fifH;rrbizbrzUr;z;0ioH&fHotNrHxy}Z}}tUoy0iyHzf^oi;H0fUr&H0;H&;HiyNyy}oUNf0zUUz(}oU0;oi&HHytorooNUNr0oroUU;yizH4tOztrrtb&U0;riso;;iN?Uy0bf0bbN1}?&tHrifyt;Nybz&&trNHt&rHo;zrNii5Hfy0ofN&fU;i&4&0zr}gQizy0z}bNz}0bbz0rfUNiUz0ofUHOUzr;0HHN}rylz;W0bq0y;ofNffibUzf0Ut;&HoiHi}bbtzV}io}z0r&UH&t0i=}y;_l;UfobozyrzU3o>HUyry&oUHtfib}zz&rlbzzErHor0o}rU}zboyMHiUo&i0t%;yNiUH0ryU;&r0i<t&00b9&yHitHrr;t;&Q0}8;&r00Lzy*ibfbbUz;0z}tUX&}0;%N;brf;fNyz;z-ryt0&f0&UUfUbfz}ryUH&;0fUb&r0z{#;bi0Hff&t;yt}iU&&;0NUU;0&N;yHry}yNrUzr}UNo0bzYi}H0fNoUNo}fUU;U0t+t;0b}H&fHotNr0btyy;rftt&bbiNifooi;W}iwNyz}bHtytbizz;boJz}rtty;fizt};}oyz&yytHNi};tNzUroUr;ybf;5f.o0Nf}&tHztriN}r;iNH&yoorNy}H}zybrHzb;&oNdtyio}Nz}tt&pUfoHz;f0oNUy;oy1&fit;N&iHoi;Ni&.oyroyrftHzU0yUoUf;H0tRiy}o;0NiUHozrrbUz;G0bf:byzy}ybUzt0ur;Uf&U0oMry&ybU0&&ytzfo&UH&t0i9yyibt&Hri0y;z0oUtytibNz}zbitirHU}DNi&=0;0i}HUf;}bztry0&&yiyZX;io0Nyf&}ozb}tto;z;b%b;0oyH0ftbUUyf}b0zN}Uto&ffr}NHUtzH0fib&zH}t;UoHH;yf;UoHHrfybzNty&0Lf;ri/&;tiiH}f;bNNUbfNr&y0U{v;bi0H;ryfyoNto.GboUUft&yUfoNfzb;Nb}0tf&NyfoNzHioH}fNoUNo}rtyoztNzb;bifH&fHotNi}}HU}N0NUo;riyHzfQ&bfzoft&&yrtUi;}iz^it}H&}}}rtz&MrbU0;fi&HHytotN}};tNzUroUrftUzHzybo0Nf}&tHzt0zz};}iNcUyoorNy}zULfbr0Uo;&iHhtyrb}z0rkUtzo0&Uy;zi5ci}ztzzNrNUt;oif3iybozPUyroyNz}_bbz0bhz&;&0twiy}o;NNfUKNfrryUU;%0b:0y;fztzt0&;N0yzyo&&UfH;&&ozNffbb0zfrNHHyUo0Ht}_byHU}Hbrzyrzttfzo&;rz;o&Htfib}z;rNtUzot})yf;oqHbf0b;vNbp}bb}fooz&bftNbtfU0rooLUf&k3ib&yHb}Hif}b;zs}rd}y;oHVzfNobNyffU;;d0&Ay;oo;Uff;obN0}}ttHt0tdiyy0&lt;tiiH}fzbz&HftUb&;ofHf;0irz}ribHzH}it}&;0NUU;ob;;yfyb8Nb}0tf&&0HzNrii}NffNoUNo}fiiWbi;orfri0yiyt{iroy&t&zz}yH&btHNHzfiobN0}ftN0zzt;y}U}r}RxUbb&00Xtz&;rbU0;fiNr0y0&Uro}}tNzUroUr;yzz;i0bobNf}&tHztriU}fUUN#UfcorNy}z&Niy+t;o;&o&7tyio}Nzrt}y}HtiUyzozoU;oNyozfoyNNfNf0fyyH0zQUyroyNz}6bbH06yz&;&0t:iy}o;NNfUUtfrrrUz;Q0bP0yfo&;}itbiU0rfUN&U00ozHbfbbfzzo}d&iH?f;tooN0}&b&torbtf&t0;(iH0ibNy}lbiti0HU&;fiHiofKiiH;fzotzfyHrHti;tiiH}f;bNNU}oU;&y0z)k;bi0Hff&bHNt}it}&;tHkby0of;;fzbhNb}0tf&&0HUt;ii}H;fNbiHrfzty&z0PUb;0ifyUf}boNi}}t;&NrUUo;riyHzftb&N0}ft&&HrtsNyyi;HNyUooNr}ytz&hrb,};tHHUt;}oiN}};tNzUUfUri&izHffio0Nf}&tHztrizfiHoUGUyoorNyoNHUrrbrUf;&iH(tyio}zz}rbUzoUf;z&_r0%by0ofN&bobtrrr}U;ix0UHzfyb&yN}!t;frbyzzr=tb&00fg&yHitHi&NryzN;ti0HHo;o&NHbobiz}UNbUzr0o7ryyHtftfbb0r;r&UH0o0iO}y;NnNb}zbrzyrzU/&b00Lfy&oHHtfibU&zrN&b&o0rmyyzHtHbf0bfz&ttbiz;0}h;ibiUHobfbyzzr/&i&00fyNyHobHif}b;&Hoito&r0yTzy9oo;yffb&zHo0ti&}0;y4;UioHrfyzHz{}b&fz&}t+H;tHyH}f;bN}b}otr&yEHJ/;borHff&bHNto0Nf&;0NUU;oir;;iNb5Nb}0tf}B0H;o;ii}H;baoUNo}rty0p}btf;0ifH&oootNi}}&z&NrUMir;o;Hzfpb0&y}Ut&r(0fUi;}i;H0yUHizN0&Un&VrbzyyyUmHHoooiN}};&jro}rtz;yizHaybN;NftNtHztriHz;biNBUyoorNy}zHo&or0a;yHiU%t0fbfN;}NbUzorrUy;ooihby0of}N}HziN}}NU;;N0UJoyrNHNzbtbbr}bzzz;H0tHzfHo;NNibbo&HryUz;hiyu00;o&NH}yt&z}r;zH;t0oyfyyozfby0o&zfr&UH&t0ig}yooUNbiizfzyoUUI&b00WU0&otNoi0bU&NrrNt;0iy2byooYHbf0tyz&tUNb;ri;,o&U0rHofrbyzzrEtb&00f(&yHo;N}};HHzN}Uto}r0bHHrUo&HoftHzzUr;Ni&}0;QNytorNyfbojH0}bt0&f0&nH;tiiH}f;bNNU}otr&ybUlq;bi0Hff&dbytr}tU;&0NUU;oirHy}NibHf}0tf&&0HUt;ii}H;fNoUNo}rty&z0>zbryifH&fHotzNr;to&NrUUo;ro;H0;bifN0}ft&&HrtUi;}i;HNyUooNr}ytz&_rbz0rzi&HHytoiN}};tNzUroZ};b0YU0ybo0Nf}&tHztriU};;iNCUyoorNy}ztFzbr0Ut;iitHofrbyzN}rtyNr}zUy;zi#Vby0ofN&}Hbtzir}U;;N0U oyrtty&otNH}brfNr0H0tztizqtyyyooyNy}qNy}}twzbr0U;&&y&b}&ooiN;}NbUzorrUyr.U9Hqy0ofN&}HbtzitHz;;NifvoyroyNHH0)rfyyoitUfHtnif0o;NNfUb0;U}Ut0;zirKiy}t&&zf;UgN}ryUrfzo;ayyrozNvfbb0zfr&HH}t0tB}y;oNHUfobr&tbzUVii00_fy&iUU0;yizHHybo0N}oNN}fHbjzs}oUoHQ0;R9yoitNc}zbHzir&t&&oiuHzy0ifHNf0bfU;rHUH&603^oy0o;HrfibHUy}bU&&biHUbyforNHf;bbz0}}ttzt0tDiyyi0Hu}/boN0&N0U;&yroyNz}{bb&HrfU&&HU;zo0ibi;fizHHfiofNUfNtNzi0zBgy0ryHDf0o0IzrzUd&irUU;y;oH*U&yifNHfHotNi}ybrtrza2yrHyfU&oz}bzybrNr&H0NUi;}i;Ha}Uttz}}rtz&VrbU0;fz&;}0toiz4};tNzUr0Eby}b&NzfUt;&0}&tyztriU};zb;U ofrHNU}ztVzbriUf;&iHHHyio}N;}NbUzo}rz;;zi{:by0ofNr}Hbtzii}zf;NiD3oyroyN&}.bb&frfU;;H0USiyro;NN}rboz0ryUz;T0ba0yfofNHfUbizrr;Uz&U0oH0yyozNJftb0zfr&U}&t0ih}y;o}HUfobr0r*fyNiyH}ytyfoHHtfib}z;rN;U}o0o)yyzo:Hbf0bfz&bHUH&i0}5;yNiUHoyrH;zzr;tb&00ff}oNN>}fbbb;zN}Uto&r0ym&yGibH0f;b;zH}tti&}0;uN;UioHrfybzzNrzt0&f0&3HttiiH0f;bNNU}otr&y0iI_y i0H}f&bHNt}iU;&;0yUU;birHyfzb_&0}0t0&&0zUt;bi}H;}ooUNt}rty&z0zUb;0bNH&fHotNo}}t;&N0*Nt;riyHzfRbyN0}}t&&HrtUi;}i;f}yUotNr}ytz&/rbU0yri&HNytobN}}ftNy;iUUr;fizHoyboiNf}rtH&NHiU};;iNHiyoo0Ny}ztrzbriUf;;iHGtyio}}i}NtHzorrUy;zilHzibofNf}HbtzirrU;;&0U:oftoyNz}_bbz0rfU&;Hz}Qiy}o;N&fUbozrryNy;?0tc0y0o&NNftbUi}r;UN&UboLryfozNl}yb0z}r&UH&t0i4}y;N}HUftbrzyrzUu&b00Hry&oNHtfbb}zfrNH;yU0rGfyzUjHbfibfz;rHUNoi0}l;yNtUHof0byzzoNtb&i0fY&yHitHi}yf}zNrztofr0yQ&y?itH0fi;&zH}ttif}0;nz;UioNNfyb&zSrTt0&f0&{HofiiH0f;bNNU}otr;}00h8y<i0Hif&bHNtrb9H&;0yUUy*irHyfzbQz0}0t}&&0;Ut;bi}zi}toUNb}rHy&z0HUbyHifH}UHotNi}}H;&N0KUoyiUHHzfHobz(}ft&&Hi{zy;}ifHNfNooNr}ytz&irbUb;fi&HHytoiz0}itN&zroUb;yizHdfHb0Nf}ytHybriUr;;iNf;yooUNy}&t_zbr0Uf;}iHH;yiooN;}NbUzo0rUy;iiAHHy0ofN&}HUizi0HU;;;0UwoyroyN0}4tfz0rfU&;H0tgifHo;NbfUtHzrryUz;ci;)0fzo&Nyftbiz}r;-t&Ui;wrfNozNNfbb0f;r&Ur&tizP}ytoNHUr&brzUrzU;&b00Ofy&bNHt}zb}zbrNU}&oorHNyzo}Hb}NbfzyrHtt;i0}*oyNoyHo}Hbyzz0;tb&i0f-0yHo;HifoyizNrHtoyr0yl&y ib}Hffb;zHr.ti&}0;=NoyioHrfyb;z2}bt0&ft;OH;tiiHrf;bNNU}otr&y0zsm;bi0Hff;bzNt}it}&;HtUU;oirHyfzbaNb}0N}&&0HUt;oi}H;fNbfNo}rty&z0bUb;0ifHNrHt:&o0NUfyz0bHbyfo;No}NobzH}ft&&HroHifrb&N}}0t{NrrHtz&crbU}yzo7zN}0ti&r0&U};0i4Ur;oizHSybo}&}rNUL;f0bU};iiNnUyoof&zrztt;yizU0;&iH/tyio}N;fNHtzUrrUy;ziMaby0ofy&}Htzzir}U;;/bIzN}yb}Nf}<bbz0rfU&;H0t5iy}o;NN}qtkzrryUz;5z}{0y}o&NNftbiz}r;yt&U0bOryyozNTfbb0f}r&UH&t0o<}y;oNHUibbrzyrzUH&b00Rfy&oHHtfib}z;rNtU&b0bnyyzohHb!;bfz;rHtU&i0}9;yNziHof0byzzr>tb&00f&;yHitHifrb;zN}Uto}00yJzyLitH0ffb&zH}tti&}0;vN;UioHrfrbzzA}bt0bN0&#H;tioH}f;bNNUR}tr&y0zZd;bi0Hff&HNNt}it}&y0NUU;oirHyfzb!Nb}0tf&&0HwH;ii}H;fN;0No}rty&&0dUb;0ifrhfHotNi}}t;&NrUUor0iyHzfnotN0}ft&&zU&Ui;}i;N&bbooNi}yt}&(rbU0;firHHfHoiN}};tNzUro_i;yifH/yto0Nf}&tH&triUi;;i;DUf6orNy}it!&Hr0Uf;&iH4tyiorN;}ybU&{rrUy;ziMNyy0ooN&}Hbtzir}U;oy0U)tyroiNz}Nbb&EztU&;z0tHyy}oyNN}WbozbHyUz;*0bH;yfo;NH}N;iz}r;UN;o0o_0yyoz0ifbbbzfr;UH&t0i3}oooNNNfobizyrzUI;UHN,fyfoHNyfib}z;rN;;&o0b_yy&oxHbf0bf&yrHUH&i00I;y&iU&NrobyzyrSHo&00}(&yzitHUU}b;zN}UHi&r0fszynoyH0f0b&zH}tti&}0;&f;UiUHrfrbzzH}bUB;b0&*&;tbzH}fybNz4}otboy0zx/;bbNHff;bHNtHyt}&}0NUU;oirHyfzzfNb}btf&y0HUt;ii}HtfNbNNo}rty&z0EUbr}ifHffHbHNi}rt;&NN0Uo;biyHzf4obN0}ftb&H0zUi;}i;HNyUbNfo}ytr&/rbU0;}i&HNytoizb};tNzU0CUr;yizHqfto0No}&tNzt0HU}yfH0ZUfHorNf}zthzbr0yz;&ifXtyio}N;}NbU0}rrUb;zi%ubyiofN0b&bt&zr}Uf;Ni15oy0oyNzr;bbz0rfU};H0t2if}z&NN}ybozoryUi;=0bH}yforNH};biz0r;M&;f0o>Uyyo}Njfbb0zfrbUH;;0i3}y;oNHUfotFzyr0US;&00/fy&oHNofit%z;rftU&o0rxy},o+Nzf0bUz&rNtt&iiH+;y}iUHofrbyzzr1Ut&00bR&yNitHtf}b;rr}UUT&r0}{zylibH0oNb&z&}tti&}0;BNfHN&Hrfrbzz}}bt0&f0&yf;tiUH}fybNNU}otr;}0z^z;bioHffybH;&t&t}&}0Nz&;oi0Hyffb7zHa0tf&&0Hzz;iirH;fy&UNo}rtyr}0+Ut;0ifHbfHbHNi}}t;&NrUHoU&iyHffZotN0}bt&&Hi&Ui;ii;H;yUb^Nr0yU^&h0HU0;}i&H}ytoizz};t;zUrUUr;0izH(fNo0Ni}&tHztriU};;o&=UfHorNy}ztpzbi0M;;&ifatyoo}Ni}NbUf0rrUi;zi;EbfFof&&H}bt&Hr}Uy;Niy,oyUHrNz}fbbzirfU;;H0USiy}b0NNfUbozbryUz;R0bHiyforNH}&bizUr;I&if0o_tyyo&NPfbb0zf?1UH;&0iX}y;oNHUfo&;zyr0U^&b00)}y&offHfit*z;r;tU&b0rmfyzoZzNf0bfz&r;tt&i0}H;bHiUNzfrbrzzr}tb&0oz(&yyitNNf}bfzN0HUH&r0olzy;ibH0ffb&zf}tUN&}0;*N;UioHrffbzzf}bUH&f0&,H;toyH}fbbNz&}otr&y0zHv;bocHffobHNU}it}&t0N>;;oirHyfzbG&br&tf&i0HUU;iitH;fNbfNo}Uty&r0>x&;0bfNifHb;Ni}rt;&rrUUoy;iyHrfIb&N0}0t&&Hi}Ui;oi;H&yUooNr}ytr&s0cU0;fi&HHytoiyr};tNzUrbUr;yizHHybo0Nf}ftHztriU};;iNUU0iorNy}zt%zbrUUf;&iHNt0bo}Ny}NbUzor0Uy;zoo,byiofN;}HbUzir}Uf;NiSAoyroyNz}Vbb;NrfU;;H0Umiyro;NNr}bozrryU&;k0b30y}o&NHftbtz}r;UN&U0o=r;y2NNRfbb0zfr&Uy&t0in}};l&HUfbbrzyrzUH&b00NNy&oNHtfob}zyrNtU;t0r2fyzo7Hbf0bfz&rott&o0}VyyNo2Hofrbizzr/tb&i0f-&yHoHHif}b;zNrUto&r0yWH;&tzNtyroyNNrttN;&rUHN}Ntz&Ay;bz&H}bt0&f0NU&f ooN0r&tX&};rab;&ozobfNoozy}ybHNt}it}&;0NUU;oirHffob?Nb}0,brb0HUt;iiiH;fzoUNU}rt0oz07Ub;0i0H&fNotNUC}t;&NrURN;rifHz}Nz;N0}}t&&NrtUi;}i;fryUobNr}}tz&BrbUtbfi&HHytbzN}}ytN;HbfUr;fizHNybo0Nf}&&}ztroU};fiN9Uyooryf}zt zbriUf;&iHHNyio}N;}Nt;zorrUy;HobHbf}tFzb}&btzir}U;;N0UUo0}oyzu}.bbz0r;U;yz04HUyftrzrfobi;0ibUz;z0b30yfo&NHftbiz}rfUN&U0oq0yyozNu}Kb0zfr&UH&t0iU}0&oNHUfobrzyr}Uw&b00Nf0yoHHUfib}z;rztU&oioSyy&o:Htf0b}z&rHUt&i0rp;yNiUHofrbyzfrItt&00}Z&yNitHi}ob;zN}Utb&r0ywzyxibH0ffb&zH}tti&}0o=N;UioHr};bzz{}bt0&f0&{H;tbzH}fybNzL}otr&y0zAi;bioHffybHNt}it}&f0N{?;oi0Hyf;b%Nbr0tf&&0HUU;ii}H;fNtHNo}rty&z0cUb;0ifNffHotNi}rt;&NrUUofriyHzfaobiy}ft&&HrtUi;}i;HNf&ooN0}yt&&*rbU0;fo;HHfMoiN0};tNzUrod};yi&HFyto0Nr}&tH&ZriU};;i&wUytorNo}yt{zbr0UU;&iNTtyio}Nr/NbUzorrUt;ziH2byt&fN&}Hbt&Ur}Uy;N0Uf}yroyNz}5bbz0rf4yir0tZoy}oyNNfUbozUtrUz;N0b{iyfo;NH}Hbiz}HUUN&U0oXoyyozNnfby&zfr&UH&U0ih}y;oN0rfobrzyr;U1&b002f0ooHHUfib0z;rNtU&oY0=yyzo8Hbf0b}z&iH};&i0});yNiUHtfrbob0r/tb&0ii(&yNitHof}briN}Uto&ri0JzyHibHtUfb&zH}t%0&}0yZNfHUfHrfybzz&}bt0&f0&;};tiiH}frbNNU}otr;H0zWV;biUHff&bHNtrit}&y0NT;;oirHyfzt0Nb}0tf&y0HUU;io0zNfNoUNo}oty&z0uUby&ifH&fHoUNi}rt;&NiHUo;riyH&f?obN0}f!&&HrtUi;}i;HNyUot}t}yt&&grbU0;fi&HHo&oiNr};tzzUrbUr;yU&HIybo0N}}&tHzt0zU};;iNgUfSorNy}zbt;bio:y;fiH)tyio}N;}NoUfiroUy;zia2by0ofH&&)btzir}U;;NiN9oyroyNz}hbby0bfUf;H0t/iy}o;NNfUbozoryUz;d0b10yfo&yH}Hbiz}r;UN&U0ofr0yozN-fbb0zob;UH&t0ig}ytoNN&fobrzyrzUV&btU?fyroHNzfib}z;r}U&&o0t+yy}o*Htf0b}z&r;yt&i0}Y;yfiUHbfrb0izr%tb&00U-&yNitHi}Hb;zf}Uto&r0yOzy^UiH0fob&zy}tti&}0;yr;UoHHrf}bzz6}bt0;Q0&sy;tioH}f;bNNUtHtr&f0z3;;biiHf}ytbNtr9t}&i0NUU;ooiNzfzbyNb}otf&&0HHDy}i}HofNbNNo}rty&z0oUbyNifH;fHotNi}}t0&N0fUoyHiyHff#bUzt}ftb&H0&Ui;}i;N&00oozz}ytf&crbU0;ftHHHfroiNb};t&zUoN;N;yitH*}No0N}}&tfztrUf};;iNXU}HorNf}zt&ibr0Uf;&obutyoo}N;}ibU&}rrU};zi8Xb}0;iN&}tbtzor}Uy;N0UN}yrb;Nz}ybbz0rfU&;U0tHiy}oiNNfUbozr0rUz;b0bH0yfoyNHftt3z}0HUN;i0oHyyytzNyfbtzzf0lUH;z0iNtitoNN0foU}zyr&Uu&U00(it&oHHtfiUfz;rztU;sNr_yyzoF&zf0b}z&rHUf&ii&2;y&iUHofrUyyfrdU0&00}+&yNitHi}Hb;&H}UUN&r0y^zywoHH0}fb&zf}tti&}0;1t;UorHr}ybzzN}bt0;i0&?b;tofH}}NbNNU}Utr&U0zEr;boyHfr0U&Ntryt}fb0N_s;ooOHyff;SNb}0tffo0HUU;ib}r&fNbyNor+ty&;0_UbtHifN{fHbHNi}}t;&N0NUoy;iyH0fYbrN00fU;&H00Uiy&i;H&yUoozz}yU1& 0_U0;fi&zH};oizy};t;zUrbUr;yi0HJfbo0zz}&tHztrict;;ozIUf}orNy}ztQiHr0Q;;&oNMtybo}N;bzbU&rrrwz;zit2by0b}N&}tbt&&r}MN;N0UNzyrb&Nz}0bbz0rfU&yi0tH0y}o}NNfUbo;r0yUzyF0bHfyfooNHftbbz}0&UN;t0oHryyozz}fbt&zf0NUH;b0i_tC;oNN;foHyzyr&UP;;00uit&oHHtfiH;z;rztU&oiN>yyUo?Hbf0bfz&rHUU&ii&(;yNiUNyfrbyr0rAUf&00rJ&yHitziUfb;zf}UUH&r0}{z}9zoH0fbb&zf}ttb&}0r}N;UioHr}fbzzH}bt0}}0&-H;tioH}f;bNNUbUt0&y0zHNLHi0Hff&bzNt}it}&iitUU;oirH0fzbHNb}itf&}NHUt;ii}HrfNbONo}byy&z0AUb}0ifH;fHotrf}}t;&NrUUo;riyHzH;obNi}ft&&HrtUi;}itHNyUooNr}yt&&wibrH;fi&HHytoi;b};U&ybroU0;ybbHDybo0zrrftH&vriU0;;iN/UfNHoNy}ytqzUr0U};&iN^tyibbN;}NbUzbrrUy;ziw&oy0orN&}zbtzor})fy00UDtyrtfNz}ubb&o0yU&;&0tHHy}o;NNrUtozrrrUz;z0bHyyfbyzfftbUz}ihUN&U0oNryrozN&fbbtzfiHUHyF0o{}y0oNN;fobrzyiz}f&b0UWfyroHNtfit0&trNU;&o0U4yyzo zb}rbfz0rHU&&it}:;yNozHo}3byzzr=tb&0irHbyHoyHi0Nb;zN}UUt;H0yqoyXUUH0ffb&&zroti;N0;zf;UioHrf0t;z r;t0y}0&RN;tiiftf;btNUrHtr&y0z_90bi0N&f&boNt}it}&;0tUUy}irH}fzbNNb}0Uo&&0}Utyyi}NHfNoUNt}rtb&z0oUby;ifH}6fotzz}}_O&N08Uo;rbyHzf}obzN}ft&&H0&&t;}ibHNfSooN0}ytr&Brb)U;fi&HHf oiN}};tN;&roUr;yifH%ybo0NfrrtHztrij9;;iN)UyobtNy}zth&Gr0Uf;&iHNzyio}N;}rbUzorrUyy}i)Gby0o}N&}HbtziH;U;;i0UH&yroyNz})ttz00HU&;H0t>iy}o;NtfUt;zrr}Uz;N0b10}&o&NHftt&z}r;UN&Ui;MryyozNNfbb0zfr&Ur&t0iu}y;oNHUfobb&yrzU>&bUoj}y;oHzOtzb}z;rNUr&o0r{y}zUyHbf0bfz&rHNz&ii0H}yNiUHo}ibyzzrqUU;i0f)&yHo}Hif}b;;N0&to&r0yVzyvitH0}rb}zH}tti;y0;,N;UioNHfybzzu}tt0&f0&Hzf&iiH}f;wrNU}otr;}OiV5;bi0Nbf&bHNt}iUt&;0zUU;oirHyfzb#zi}0tr&&0HUt;ii}H;f&oUNU}rty&z0BUbyobNH&f;ot&;}}t;&NiHUb;riiHzr0obN0}fUy;ort?H;}UfHNyUoozi0Ntz&frbNU;fi&HHfNU0N}}0tN}}roU0;yo;f}ybbzNfiftHztriH}ftiNH}yobNNyiHt:zbrbUf;tiHHyyio}N;}Ntfzo0NUy;;iOEUy0ofzb}HtFzi09U;;i0Uuof&oyNo}<bUz0rUU&;Ho;piy0o;NifUt&zrr0}r;!iNP00}o&NNfttbfzr;Uf&UtH2ryyozzNozb0zbr&Dr&t0i(}fforHU}zbryirzU6&b0tHyy&oyHtb;b}zyrNRU}y0rwUyzo}Hb0Ubf;&0ott;;0},ryNutHofrbUzzrotb;N0fX&yHitNNf}tNzNrfto&r0y1zfribN&fftHzHrkti&}i&YNyNioNNfybbz_0bUb&f0buHyNiiyff;bNzf}oU&&y0iV);bi0Hfb0bHz0}iU5&;0NUU;oUNHyfob,zr}0tr&&oHvb;ioNH;f0oUyH}rty&i0DP>;0o*H&fiotNUHtt;&frU&r;rifHzfyN8N0}ot&&rrtUo;}irHNyUtHNr}ytz&HrbU0;fi&NyytoiN}};tNzUroUryiizH<ybobNf}&tHztiJU};;iNHHyoorNyr;}&zb0aUf0;iHStyiotNU}Nt;zoUoUy;&i/4ty0oi0&}HbtziUiU;;z0UHGtroyNz}?&;z0r}U&yzHyWiyto;fzfUbozrryUy;vizX0y}o&NzfttH&;r;U}&UH&^ryfozNwfbbtifr&UH&tHz6}yyoNNzUobrzyrz;r&b0i!ffyNrHt}Hb}zrrNtU&o0ryoyzofHbfUbfz&rHcM;U0}{byNtHHofrby&;rotb;z0fzryHitHi}0ttzNrrto;o0yszyBoUHtffbUzHiNti&}0;H&fKioN;fyU0zK}bt0&f0;ZHy;iiN&f;b&NU}oU0&y0ih#yNi0Hff&tz&N}iUH&;0fUU;oirN}ftbxzf}0t}&&0HUtyboUH;fboU;r}rty&ziN8,;0ozH&i0otNi}}Uf&trU=r;rbtHzfuobN0ryt&&rrt1};}ifHNyUb8Nr}Utz&;rbU0;foyN;ytb;N}0ttNzUro_ifHizHiybUyNf}&tH;_0rU}yHiN;iyoorNyr;U0zb0fUfrqiH*tyib0Ni}NtbzoorUy;zi-QbyUofNb}Htozir0U;;NomDofzoyN}}Ibbz00rNU;HirOi0;o;NNfUttf&ryUU;4b0K0yfo&zzirbi&;r;zb&U0oKrf}yNN#}ib0&&r&UH&tibNNy;bHHUi0brzyrzUV;000HHy&b:Htfbb}z;rrtU;f0rh}yzo1Hbf0b0z&rbtt;*0}S;yNbHNNfrtzzzo&tb&00fHyftitNrf}t}zN}Uto;iNXkzyUib;zffb&zH0SEN&}i;#NfzioHrfyt;&i}bUi&f0U4H;tiiH}}}bNzi}oU0&y0;BP;bbyHf}HbHzz}it}&;i&HN;oofHyfyb.Nb}0Ur&00HDb;i{&H;fNoUzto&ty;z0hzy;0ifH&}zvrNirrt;fbrUUo;ro}HrfJbUN000t&&HrtUiy}i;HUyUbtNr}}tz&4iTU0yNi&HtytooN}rfHbzU0}UrriizH<ybo0b_}&ttzt0IU};;iNNHfNorz&}zUtzbr0Ufyyobxtf0o};t}NbUzo0iJU;zoMkb0zofN&}HU3;yr}Oy;NtH8oyroyz;}tbb&orfzo;H0t_iy}biNN}obo&iryU;;10b&}yfbHNH}&bi&;r;X&tH0oHfyytbN9fbb0&rrrUH;b0i;;y;oNHUfobtzy0zU!;z00)ty&ofzrfit}z;zytU&b0rsfyzo&rbf0bfz&z;tt&o0}ErtNiUHofrr}zzrHtb;otNI&fHit;Pf}b;zN}UUf&rif8zyiibH0ffty&}}tUb&}b0!N;UioHbfibz&:}b0i&f0;(H;tUrH}}rbNz0}oUo&y0z&;;botHff0bH&N}itt&t0NHz;oyyHyf&b_Nt}0tio&0HUt;iy;H;fzoUz*Xrty&z0*ib;0i}H&fHDoNirot;&}rU)z;riy;0fptHN0rit&&rrtUiyoi;NfyUbfNrrrtz& 0oU0yoi&Hfytt_N}};tUzUijUr;}izHNybo0&N}&U;zt0UU};tiN3Ufiorz0}zU&zbr0Uff0o0QtfUo}bo}NtGzoo;Uy;fzD4by0ofbi}HbUzirof;;N0U.oNroyN&} bb0Grf<};Hii(iy}o;NN0ibo&tryUU;v0bV0yfb0NHrNbiz0r;Uz&UitHiyybfN_i;b0zfr&UHy}0iHoy;ozHUfbbrzy0HU)&b00_}y&oHHtfiU}z;0ytUy50r.yyzoN}Nf0toz&rHtt&i0}>;i}iUzHfrbfzzrHtb&tzb6&fHitozf}byzN0Uyi&ri&Gzytib&Uffb&rf}tUi&}00cN;UioNi}0bz&H}bzk&f0&*HfCb&H}}fbNf0}otr&yi;Hi;bobHfiUbHNt}iU0;00NHz;ooAHyfzbVzUrytf;r0H5r;ii}H;fNtfNorrty;}0vUU;0ifNifHbyNir}t;&NrUUoINiyNzfCbNN0}ft&;z0;Uiyri;NiyUooNrr}Ur&>0UU0r0i&HHytbbzf};U;zUo}Ur;yizNNf0o0zi}&NNztriU}yfof?U}Hor&o}ztwzbr0Uo;&oHEt}6o}Nf}NbU0NrrUU;zonsby0ofN&iUbt&ir}Ui;Nif_oyU&UNz}fbbHHrfU;;Hitmiyo&;NNfUboHKryU&;P0b&}yfb&NH}&bizUr;UN}b0oHFyybzN(};b0zfbNUH;t0ipty;oiHU}NyNzyriUINU003}y&bHHtfU;}z;rNtUNt0r2fyzo(}zf0tfz&rytt&i0}HfyNiUNbfrtfzzr2tb;o0rL&fzitzNf}b;zN0HtU&rir*z0iibH0ffty&}}tUU&}0tdN;UioNiffbz&;}bzH&f0&#H;tbNH}};bN&&}oti&y0zat;boNHff0bHzt}iU0}{0N=U;ottHyfzbLNbr;tf;;0H{r;ii}H;}&tyNorityf}0:Ub;0iiN&fHbtNif0t;&zrUWtoHiyNff*boN0}ft&&fUHUiybi;HryUobNr}btz&ViNU0;fi&HrytoiN}};UfzUroUryHizH7ybo0zo}&tHzt0tU};;iNsU}HorNy}ztfzbr0Uf;&oy*tyio}zz}NbUzorrAi;ziKYbffofN&}Hbt;^r}U;;NiiPoyroyNz0;bb&trfUy;H0U/iy}o}NNrNbozrryUz;hiH0Fyfb&NHy&bizrr;H}fN0oHfyyoFN5ftb0yHr&U;ot0i+}y;iUHUfbbrzyUrUE;b00H&y&oHHt}bftz;0ztUyi0rMyyzopNUf0tfz&rztt&o0}HfybiUNofrFtzzrCtb&0iNg&fHitHof}byzN}UUx&r0y.zyHibH0ffb&zi}tUi&}i;%N;UioHibibz&H}btU&f0&VH;tHHH}}ybNz)}ot0&yozrf;bo0HffUbHNU}it}&o0N_y;oiUHy}zbLzUrNtf;&0Hzz;ii}H;fNtNNor0ty&t0gUb;0orHbfHt_Niibt;&NrUQ!y,iyNzfXbtNi}}t&&HboUiyoi;HbyUbUNr}y;y&=iHU0;bi&N;ytbHNU};UyzU0oU0;fizHbybot0f}&tHzt0iUr;yiNIUbNorz0}ztbzbr0Uf;&bbKt}xo}zH}NbUzorr-H;zo&KbyoofN;}HUF&5r}Jr;Ntf?oyroyNz}zbb&trfU;;H0UXiy}orNNfUboz0ryUz;M0bN0yfb}NHrNbiz}r;U&i&0oHtyyofNnfbb0zft0UHyz0ihry;ozHU}qyUzy0zUT;(0i?}y&offHfit}z;r;tU&b0rE}yzo^zNf0bfz&rftt&i0}X;ffiUHofrtnzzrwtb&0bUL&fNitHtf}b;zN0Htt&ri}kzytibH0ffb&&y}tUt&}00/N;UioNi}bbz&&}bVU&f0&<HfLooH}}0bNyX}otr&yi;H};bbRHf0PbHNt}iU0;z0NHy;oAfHyfzb<zUo;tf;o0H&t;ii}H;fNb&Noroty;i0jUU;0ifN;fHtNNi}bt;&NrUat;biyN}f{HUN0}ft&;ziiUiyti;zbyUooNrr}Ui&Wi&U00zi&HHytbbNi};U0zU0&Ur;yizNNf}o0&c}&N;ztriU};;Ny3U}6orzU}ztNzbr0fb;&oNltfUo}Ny}NUHffrr%};zt;hby0ofN&}obt&tr}qy;N0U:ofioUNzr&bbyUrfU&;HiNIby}bfNNi0bbz0ryA;}i0bNQyfUrNHftbiz}0)UNyy0oH&yyozN4}Utbzf0oUH}z0iC}y;oyz}fotUzyobUH&t00vfo0oHz}fit}z;rNtU&oo}jyfto1N}f0UPz&rHU&&io&c;fziUzHfrby&or17f&0oz5&yzitNH};b;&o}UN;&00f_zyXibHtUfb&zH}tN&&r0yGN;UNNHrr{bzzb}bt0&f0&Nb;tbyH}}HbNNU}otr;r0zH0;bioHff;bH&a0zt};U0Nzf;oirHyfztiNb0&tf&;0HUU;ii}NyfNoUNo}0ty&z0q7HURifN0fHUiNo}rt;&yz;UoyiiyzofHotN0rr&o&Hi2Ui}fi;HNyUbNb=}yU;&GboUi;}i&HNytoU0}};tNzUbiU0;fizNNb;o0zr}&UyztriU};;H}EUfUorz}}ztWzbr0fo;&o;mtfbo}N;}NbU&}rrVi;zi;Tby0ofzy}ibt;Hr}H;;N0UDofibyNzrfbbfrrfU&;Ho#Hty}bbNNrNbozrrym;;i0bNzyfU0NHftbi&00UUNyr0oN;yyozNhfb&tzf0rUHy}0ic0y;oNNifotbzyr;U4&U00Ff}HoHzNfibrz;r&tU;t00Myf}oS;ff0bfz&0zUt&iit+;0oiUHofrby&truQH&0ib<&yHitHiftb;&;}Uto&r0}?zyNNNH0}ib&zf}tti&}0;&t;UoUHr}0bzz,}bt0;;0&H&;tiiH}f;bNNUr;tr&y0z*x;bi0Hff&HNNt}it}&y0NUU;o");local n=0;b.FGXjgiTp(function()b.oskzcUzy()n=n+1 end)local function e(e,t)if t then return n end;n=e+n;end local t,n,y=d(0,d,e,z,b.UUUlDjqZ);local function o()local t,n=b.UUUlDjqZ(z,e(1,3),e(5,6)+2);e(2);return(n*256)+t;end;local ne=true;local a=0 local function k()local e=n();local n=n();local r=1;local f=(t(n,1,20)*(2^32))+e;local e=t(n,21,31);local n=((-1)^t(n,32));if(e==0)then if(f==a)then return n*0;else e=1;r=0;end;elseif(e==2047)then return(f==0)and(n*(1/0))or(n*(0/0));end;return b.rkOlWpBw(n,e-1023)*(r+(f/(2^52)));end;local p=n;local function c(n)local t;if(not n)then n=p();if(n==0)then return'';end;end;t=b.FwKsKPDe(z,e(1,3),e(5,6)+n-1);e(n)local e=""for n=(1+a),#t do e=e..b.FwKsKPDe(t,n,n)end return e;end;local a=#b.oLrqzZnY(s('\49.\48'))~=1 local e=n;local function re(...)return{...},b.uzjoIQay('#',...)end local function te()local e={};local h={};local s={};local z={s,h,nil,e};local e=n()local d={}for f=1,e do local t=y();local e;if(t==1)then e=(y()~=#{});elseif(t==3)then local n=k();if a and b.nYavgHtI(b.oLrqzZnY(n),'.(\48+)$')then n=b.hCOCEGdp(n);end e=n;elseif(t==0)then e=c();end;d[f]=e;end;for e=1,n()do h[e-(#{1})]=te();end;z[3]=y();for z=1,n()do local e=y();if(t(e,1,1)==0)then local b=t(e,2,3);local h=t(e,4,6);local e={o(),o(),nil,nil};if(b==0)then e[r]=o();e[l]=o();elseif(b==#{1})then e[r]=n();elseif(b==u[2])then e[r]=n()-(2^16)elseif(b==u[3])then e[r]=n()-(2^16)e[l]=o();end;if(t(h,1,1)==1)then e[f]=d[e[f]]end if(t(h,2,2)==1)then e[r]=d[e[r]]end if(t(h,3,3)==1)then e[l]=d[e[l]]end s[z]=e;end end;return z;end;local function fe(t,e,n)local f=e;local f=n;return s(b.nYavgHtI(b.nYavgHtI(({b.FGXjgiTp(t)})[2],e),n))end local function p(m,y,z)local function fe(...)local o,k,g,te,c,n,s,u,ee,_,a,t;local e=0;while-1<e do if e>=3 then if 4<e then if 6==e then e=-2;else t=d(7);end else if 2<=e then repeat if 4~=e then u={};ee={...};break;end;_=b.uzjoIQay('#',...)-1;a={};until true;else _=b.uzjoIQay('#',...)-1;a={};end end else if e<1 then o=d(6,39,1,10,m);k=d(6,80,2,57,m);else if e==1 then g=d(6,12,3,64,m);c=re te=0;else n=-41;s=-1;end end end e=e+1;end;for e=0,_ do if(e>=g)then u[e-g]=ee[e+1];else t[e]=ee[e+1];end;end;local _=_-g+1 local e;local d;function TeEgRwjPRtzS()ne=false;end;local function g(...)while true do end end while ne do if n<-40 then n=n+42 end e=o[n];d=e[j];if d>84 then if d>126 then if d<148 then if d<=136 then if 131>=d then if 128<d then if 129>=d then if(e[f]<t[e[l]])then n=n+1;else n=e[r];end;else if d~=131 then local n=e[f];local f=t[n];for e=n+1,e[r]do b.IZGgCIfj(f,t[e])end;else local f=e[f];local n=t[e[r]];t[f+1]=n;t[f]=n[e[l]];end end else if d>125 then for o=33,59 do if 128~=d then t[e[f]]=t[e[r]]+e[l];break;end;n=e[r];break;end;else t[e[f]]=t[e[r]]+e[l];end end else if 134>d then if 132==d then t[e[f]]=t[e[r]]*e[l];else for d=0,6 do if d>=3 then if d>=5 then if 6==d then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end else if 4>d then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end end else if d>=1 then if d>=0 then for l=10,94 do if d>1 then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end else if 134>=d then local n=e[f];local f=t[n];for e=n+1,e[r]do b.IZGgCIfj(f,t[e])end;else if d>135 then local o=e[f];local r={};for e=1,#a do local e=a[e];for n=0,#e do local e=e[n];local f=e[1];local n=e[2];if f==t and n>=o then r[n]=f[n];e[1]=r;end;end;end;else local b,h;for d=0,6 do if d<3 then if d>0 then if d>0 then repeat if 2~=d then t[e[f]]=t[e[r]]%t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+e[l];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]]+e[l];n=n+1;e=o[n];end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end else if 4>=d then if 4~=d then t[e[f]]=y[e[r]];n=n+1;e=o[n];else b=e[f];h=t[e[r]];t[b+1]=h;t[b]=h[e[l]];n=n+1;e=o[n];end else if d>1 then for l=43,67 do if 5~=d then t[e[f]]=t[e[r]];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end end end end end else if d>=142 then if d>=145 then if d>=146 then if 145<d then for b=49,69 do if 147~=d then local b,z,h,y,s,d;for d=0,3 do if 2>d then if 1~=d then d=0;while d>-1 do if 3>d then if 0>=d then b=e;else if 1~=d then h=r;else z=f;end end else if d>=5 then if d>=4 then repeat if 5<d then d=-2;break;end;t(s,y);until true;else d=-2;end else if 1<d then repeat if 4~=d then y=b[h];break;end;s=b[z];until true;else s=b[z];end end end d=d+1 end n=n+1;e=o[n];else d=0;while d>-1 do if 3>d then if 0>=d then b=e;else if d~=-3 then for e=23,94 do if 1<d then h=r;break;end;z=f;break;end;else h=r;end end else if 4<d then if d~=1 then for e=40,70 do if d>5 then d=-2;break;end;t(s,y);break;end;else d=-2;end else if d>-1 then for e=21,98 do if d~=3 then s=b[z];break;end;y=b[h];break;end;else y=b[h];end end end d=d+1 end n=n+1;e=o[n];end else if d~=-2 then for b=23,83 do if 2<d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else if not t[e[f]]then n=n+1;else n=e[r];end;end end end break;end;local d,l,h;for b=0,2 do if 0>=b then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if-3~=b then repeat if b~=2 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]h=t[d+2];if(h>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end break;end;else local d,l,h;for b=0,2 do if 0>=b then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if-3~=b then repeat if b~=2 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]h=t[d+2];if(h>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local e=e[f];do return h(t,e,s)end;end else if 143>d then do return t[e[f]]end else if 141~=d then for b=21,68 do if d>143 then local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return end;break;end;local n=e[f];do return t[n](h(t,n+1,e[r]))end;break;end;else local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return end;end end end else if 138>=d then if 137<d then t[e[f]]=y[e[r]];else local o=t[e[l]];if not o then n=n+1;else t[e[f]]=o;n=e[r];end;end else if d>139 then if 140<d then for e=e[f],e[r]do t[e]=nil;end;else local b;for d=0,5 do if d>=3 then if d<=3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else if d==5 then if t[e[f]]then n=n+1;else n=e[r];end;else b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];end end else if d<1 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else if d~=-2 then for l=22,81 do if d>1 then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end end end end end else t[e[f]]=(e[r]~=0);end end end end else if d>=159 then if d>163 then if d<167 then if 165<=d then if d~=163 then for l=14,68 do if d>165 then local l,b,a,s,y,d,h;d=0;while d>-1 do if 3>d then if 1>d then l=e;else if-3~=d then for e=13,95 do if 2~=d then b=f;break;end;a=r;break;end;else b=f;end end else if d>=5 then if 4~=d then for e=32,57 do if d~=5 then d=-2;break;end;t(y,s);break;end;else d=-2;end else if d>=2 then for e=35,74 do if 3~=d then y=l[b];break;end;s=l[a];break;end;else y=l[b];end end end d=d+1 end n=n+1;e=o[n];h=e[f]t[h](t[h+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;break;end;local r,l,d;for h=0,1 do if-3<h then for y=45,94 do if h>0 then r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;break;end;r=e[f];s=r+_-1;for e=r,s do l=u[e-r];t[e]=l;end;n=n+1;e=o[n];break;end;else r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;end end break;end;else local r,l,d;for h=0,1 do if-3<h then for y=45,94 do if h>0 then r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;break;end;r=e[f];s=r+_-1;for e=r,s do l=u[e-r];t[e]=l;end;n=n+1;e=o[n];break;end;else r=e[f];d=t[r];for e=r+1,s do b.IZGgCIfj(d,t[e])end;end end end else for d=0,1 do if d~=-3 then repeat if 0~=d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else if not t[e[f]]then n=n+1;else n=e[r];end;end end end else if d>167 then if 166<d then repeat if 169~=d then z[e[r]]=t[e[f]];break;end;local _,k,u,p,c,_,d,l,s,y,b,z,a;d=0;while d>-1 do if d>3 then if d<=5 then if d==5 then z=l[k];else c=p[l[u]];end else if d>=4 then repeat if d>6 then d=-2;break;end;t[z]=c;until true;else d=-2;end end else if 1<d then if 3==d then p=t;else u=r;end else if-4<=d then repeat if d<1 then l=e;break;end;k=f;until true;else l=e;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if d<1 then l=e;else if d==1 then s=f;else y=r;end end else if d<5 then if d<4 then b=l[y];else z=l[s];end else if d>1 then repeat if 5~=d then d=-2;break;end;t(z,b);until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d<5 then if d~=-1 then for e=42,61 do if d<4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end else if 3~=d then for e=46,81 do if d<6 then t(z,b);break;end;d=-2;break;end;else t(z,b);end end else if d>0 then if 0<d then repeat if 1~=d then y=r;break;end;s=f;until true;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>2 then if 5<=d then if 6~=d then t(z,b);else d=-2;end else if d>=0 then repeat if 4>d then b=l[y];break;end;z=l[s];until true;else b=l[y];end end else if 0>=d then l=e;else if d>1 then y=r;else s=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if 1<=d then if-1~=d then for e=33,78 do if d~=2 then s=f;break;end;y=r;break;end;else y=r;end else l=e;end else if d>=5 then if d==6 then d=-2;else t(z,b);end else if d~=0 then for e=10,76 do if d~=4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4>=d then if d>3 then z=l[s];else b=l[y];end else if d>1 then repeat if d>5 then d=-2;break;end;t(z,b);until true;else t(z,b);end end else if d>=1 then if d==1 then s=f;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))until true;else local _,c,p,u,k,_,d,l,s,y,b,z,a;d=0;while d>-1 do if d>3 then if d<=5 then if d==5 then z=l[c];else k=u[l[p]];end else if d>=4 then repeat if d>6 then d=-2;break;end;t[z]=k;until true;else d=-2;end end else if 1<d then if 3==d then u=t;else p=r;end else if-4<=d then repeat if d<1 then l=e;break;end;c=f;until true;else l=e;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if d<1 then l=e;else if d==1 then s=f;else y=r;end end else if d<5 then if d<4 then b=l[y];else z=l[s];end else if d>1 then repeat if 5~=d then d=-2;break;end;t(z,b);until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d<5 then if d~=-1 then for e=42,61 do if d<4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end else if 3~=d then for e=46,81 do if d<6 then t(z,b);break;end;d=-2;break;end;else t(z,b);end end else if d>0 then if 0<d then repeat if 1~=d then y=r;break;end;s=f;until true;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>2 then if 5<=d then if 6~=d then t(z,b);else d=-2;end else if d>=0 then repeat if 4>d then b=l[y];break;end;z=l[s];until true;else b=l[y];end end else if 0>=d then l=e;else if d>1 then y=r;else s=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2>=d then if 1<=d then if-1~=d then for e=33,78 do if d~=2 then s=f;break;end;y=r;break;end;else y=r;end else l=e;end else if d>=5 then if d==6 then d=-2;else t(z,b);end else if d~=0 then for e=10,76 do if d~=4 then b=l[y];break;end;z=l[s];break;end;else b=l[y];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4>=d then if d>3 then z=l[s];else b=l[y];end else if d>1 then repeat if d>5 then d=-2;break;end;t(z,b);until true;else t(z,b);end end else if d>=1 then if d==1 then s=f;else y=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))end else if not t[e[f]]then n=n+1;else n=e[r];end;end end else if d<161 then if d>159 then if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;else local l;for d=0,6 do if d<=2 then if 1>d then t(e[f],e[r]);n=n+1;e=o[n];else if-1<=d then for b=39,56 do if 2~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end end else if 5>d then if d==4 then t[e[f]]=t[e[r]];n=n+1;e=o[n];else t[e[f]]={};n=n+1;e=o[n];end else if d>=2 then for l=17,90 do if 6>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);break;end;else t(e[f],e[r]);end end end end end else if 162>d then do return end;else if d~=163 then local e=e[f]t[e]=t[e](t[e+1])else if(e[f]<t[e[l]])then n=n+1;else n=e[r];end;end end end end else if d>152 then if d>155 then if d<=156 then local b,y,s,h,a,z,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 3>=d then if 2<=d then if d>=0 then for e=27,58 do if d>2 then h=t;break;end;s=r;break;end;else h=t;end else if-1<=d then for n=10,95 do if d~=0 then y=f;break;end;b=e;break;end;else b=e;end end else if 6<=d then if d>2 then repeat if 6<d then d=-2;break;end;t[z]=a;until true;else d=-2;end else if 4==d then a=h[b[s]];else z=b[y];end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;else if 155<d then for o=34,82 do if d~=158 then local e=e[f]t[e](t[e+1])break;end;if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;break;end;else local e=e[f]t[e](t[e+1])end end else if 153<d then if d>152 then repeat if 154~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=(e[r]~=0);n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];break;end;for d=0,1 do if-2<=d then repeat if 0~=d then if not t[e[f]]then n=n+1;else n=e[r];end;break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else if not t[e[f]]then n=n+1;else n=e[r];end;end end until true;else t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=(e[r]~=0);n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];end else t[e[f]]=(e[r]~=0);end end else if 150<=d then if d<151 then local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end else if d<152 then t[e[f]]=t[e[r]][e[l]];else t[e[f]]=t[e[r]]-e[l];end end else if 146~=d then for b=48,93 do if 149>d then local d,b;d=e[f];b=t[e[r]];t[d+1]=b;t[d]=b[e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]]*e[l];break;end;t[e[f]]=t[e[r]]-t[e[l]];break;end;else local d,b;d=e[f];b=t[e[r]];t[d+1]=b;t[d]=b[e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]]*e[l];end end end end end else if d<106 then if 95>d then if d>89 then if 91>=d then if d>87 then repeat if d<91 then local b;for d=0,6 do if d<=2 then if 1<=d then if d>=-1 then repeat if d<2 then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end else if d<=4 then if 2~=d then for b=18,65 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 6~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];else b=e[f]t[b](h(t,b+1,e[r]))end end end end break;end;t[e[f]]=t[e[r]]+t[e[l]];until true;else local b;for d=0,6 do if d<=2 then if 1<=d then if d>=-1 then repeat if d<2 then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end else if d<=4 then if 2~=d then for b=18,65 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 6~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];else b=e[f]t[b](h(t,b+1,e[r]))end end end end end else if 93>d then n=e[r];else if 92<d then repeat if 94>d then local e=e[f]t[e]=t[e](h(t,e+1,s))break;end;local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;until true;else local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;end end end else if 86>=d then if 85<d then t[e[f]]();else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t[e[f]]=#t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]]-t[e[l]];n=n+1;e=o[n];t(e[f],e[r]);end else if 88<=d then if d==89 then if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;else local o=t[e[l]];if not o then n=n+1;else t[e[f]]=o;n=e[r];end;end else local d;y[e[r]]=t[e[f]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end end end else if d<=99 then if d<=96 then if d>92 then repeat if 95<d then t[e[f]]=t[e[r]]%t[e[l]];break;end;local f=e[f];local n=t[e[r]];t[f+1]=n;t[f]=n[e[l]];until true;else t[e[f]]=t[e[r]]%t[e[l]];end else if d>97 then if 99==d then if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;else local n=e[f];do return t[n](h(t,n+1,e[r]))end;end else local e=e[f];local n=t[e];for e=e+1,s do b.IZGgCIfj(n,t[e])end;end end else if d>=103 then if d>=104 then if 101~=d then for b=43,95 do if 104<d then local d;for b=0,4 do if b<=1 then if-3<b then repeat if 0~=b then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if b<3 then t(e[f],e[r]);n=n+1;e=o[n];else if b>=2 then for y=42,95 do if b<4 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end end end end break;end;t[e[f]]=z[e[r]];break;end;else local d;for b=0,4 do if b<=1 then if-3<b then repeat if 0~=b then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if b<3 then t(e[f],e[r]);n=n+1;e=o[n];else if b>=2 then for y=42,95 do if b<4 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end end end end end else do return t[e[f]]end end else if d>100 then if 101~=d then local o,y,h,d,l,b;local n=0;while n>-1 do if 4>n then if 2<=n then if n~=2 then d=t;else h=r;end else if-1<=n then for t=16,71 do if 1~=n then o=e;break;end;y=f;break;end;else o=e;end end else if 5>=n then if n~=5 then l=d[o[h]];else b=o[y];end else if 6==n then t[b]=l;else n=-2;end end end n=n+1 end else t[e[f]]=p(k[e[r]],nil,z);end else if not t[e[f]]then n=n+1;else n=e[r];end;end end end end else if 115>=d then if d<111 then if 108<=d then if d>=109 then if 106<=d then repeat if 110~=d then t[e[f]]={};break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]={};until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]={};end else t[e[f]]={};end else if 105<d then repeat if 107~=d then t[e[f]]=z[e[r]];break;end;t[e[f]]=t[e[r]]+e[l];until true;else t[e[f]]=z[e[r]];end end else if 112<d then if d>=114 then if d~=110 then repeat if 114~=d then for d=0,1 do if d~=-4 then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end break;end;t[e[f]]=t[e[r]]%e[l];until true;else for d=0,1 do if d~=-4 then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end else local s,z,h,b,d,y,o;local n=0;while n>-1 do if 3>n then if n>0 then if 1<n then d=b[z];else b=e;end else s=f;z=r;h=l;end else if n<=4 then if-1~=n then repeat if n<4 then y=b[s];break;end;o=t[d];for e=1+d,b[h]do o=o..t[e];end;until true;else o=t[d];for e=1+d,b[h]do o=o..t[e];end;end else if 2<=n then for e=13,85 do if 5<n then n=-2;break;end;t[y]=o;break;end;else n=-2;end end end n=n+1 end end else if d>=110 then for b=47,71 do if 111~=d then t[e[f]]=t[e[r]][t[e[l]]];break;end;local b;for d=0,6 do if 3<=d then if d<=4 then if d~=-1 then for b=49,86 do if 4>d then t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end else if 3~=d then repeat if 5<d then b=e[f]t[b](h(t,b+1,e[r]))break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if 0<d then if d>1 then t[e[f]]=z[e[r]];n=n+1;e=o[n];else b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];end else t[e[f]][e[r]]=t[e[l]];n=n+1;e=o[n];end end end break;end;else t[e[f]]=t[e[r]][t[e[l]]];end end end else if d<121 then if 117>=d then if d<117 then local n=e[f]t[n]=t[n](h(t,n+1,e[r]))else t[e[f]]=t[e[r]]+t[e[l]];end else if 118<d then if d~=120 then if t[e[f]]then n=n+1;else n=e[r];end;else local d,l,b;for h=0,2 do if 1<=h then if 0<h then for y=47,62 do if 2>h then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end end end else t[e[f]][t[e[r]]]=t[e[l]];end end else if d<124 then if 122>d then local e=e[f];s=e+_-1;for n=e,s do local e=u[n-e];t[n]=e;end;else if 122==d then local l;for d=0,6 do if 3<=d then if 5<=d then if 5<d then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end else if 2<d then repeat if 4>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if d>0 then if d>0 then repeat if 2>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end else local l,d,h,b,o;local n=0;while n>-1 do if 3<=n then if 5<=n then if n>=2 then repeat if 5~=n then n=-2;break;end;t(o,b);until true;else t(o,b);end else if 2~=n then repeat if 3<n then o=l[d];break;end;b=l[h];until true;else o=l[d];end end else if n>=1 then if n~=-1 then repeat if n<2 then d=f;break;end;h=r;until true;else d=f;end else l=e;end end n=n+1 end end end else if d>124 then if d>=121 then repeat if d~=126 then local d,z,h,b,y,l;t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];d=e[f];z={};for e=1,#a do h=a[e];for e=0,#h do b=h[e];y=b[1];l=b[2];if y==t and l>=d then z[l]=y[l];b[1]=z;end;end;end;n=n+1;e=o[n];n=e[r];break;end;t[e[f]]();until true;else local d,y,h,b,z,l;t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];d=e[f];y={};for e=1,#a do h=a[e];for e=0,#h do b=h[e];z=b[1];l=b[2];if z==t and l>=d then y[l]=z[l];b[1]=y;end;end;end;n=n+1;e=o[n];n=e[r];end else y[e[r]]=t[e[f]];end end end end end end else if 42>d then if 21<=d then if 30>=d then if d<=25 then if 23<=d then if d>=24 then if 22<d then repeat if 25~=d then local h,b;for d=0,4 do if d<=1 then if d>-4 then for b=21,76 do if 0~=d then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 2<d then if d==3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else h=e[r];b=t[h]for e=h+1,e[l]do b=b..t[e];end;t[e[f]]=b;end else t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];end end end break;end;local b,h,y;for d=0,6 do if 3<=d then if 4<d then if d==6 then b=e[f];h=t[b]y=t[b+2];if(y>0)then if(h>t[b+1])then n=e[r];else t[b+3]=h;end elseif(h<t[b+1])then n=e[r];else t[b+3]=h;end else t(e[f],e[r]);n=n+1;e=o[n];end else if d>0 then repeat if 4~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end end else if 1>d then t[e[f]]=z[e[r]];n=n+1;e=o[n];else if d>-1 then repeat if 2~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;t[e[f]]={};n=n+1;e=o[n];until true;else t[e[f]]={};n=n+1;e=o[n];end end end end until true;else local h,b;for d=0,4 do if d<=1 then if d>-4 then for b=21,76 do if 0~=d then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;t[e[f]]=y[e[r]];n=n+1;e=o[n];break;end;else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if 2<d then if d==3 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else h=e[r];b=t[h]for e=h+1,e[l]do b=b..t[e];end;t[e[f]]=b;end else t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];end end end end else local e=e[f];s=e+_-1;for n=e,s do local e=u[n-e];t[n]=e;end;end else if d==21 then local o,h,y,d,b,l;local n=0;while n>-1 do if n<=3 then if n>=2 then if-1~=n then repeat if n~=3 then y=r;break;end;d=t;until true;else d=t;end else if n>0 then h=f;else o=e;end end else if n>5 then if n>3 then repeat if n~=6 then n=-2;break;end;t[l]=b;until true;else n=-2;end else if 4<n then l=o[h];else b=d[o[y]];end end end n=n+1 end else local l,b,y,z,h,d;t[e[f]]={};n=n+1;e=o[n];t[e[f]]={};n=n+1;e=o[n];t[e[f]]={};n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if d>=5 then if 3<d then repeat if d~=6 then t(h,z);break;end;d=-2;until true;else t(h,z);end else if 4~=d then z=l[y];else h=l[b];end end else if d<1 then l=e;else if d>=0 then for e=13,96 do if d>1 then y=r;break;end;b=f;break;end;else b=f;end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d<=2 then if 0>=d then l=e;else if-3<d then for e=37,94 do if 1<d then y=r;break;end;b=f;break;end;else y=r;end end else if d>4 then if 6==d then d=-2;else t(h,z);end else if d>2 then for e=46,87 do if d~=3 then h=l[b];break;end;z=l[y];break;end;else h=l[b];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if 4>=d then if 1<d then for e=40,98 do if d~=4 then z=l[y];break;end;h=l[b];break;end;else h=l[b];end else if d~=5 then d=-2;else t(h,z);end end else if d>=1 then if d~=-1 then for e=29,71 do if 1<d then y=r;break;end;b=f;break;end;else b=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if d>=5 then if 2<=d then repeat if d~=5 then d=-2;break;end;t(h,z);until true;else d=-2;end else if d>1 then for e=17,62 do if 4>d then z=l[y];break;end;h=l[b];break;end;else z=l[y];end end else if d>=1 then if d>=-1 then repeat if 1~=d then y=r;break;end;b=f;until true;else b=f;end else l=e;end end d=d+1 end end end else if 28<=d then if 29<=d then if 28<d then repeat if d~=29 then local n=e[f]t[n]=t[n](h(t,n+1,e[r]))break;end;local _,s,z,y,_,d,a,l,u,p,k,c,b;d=0;while d>-1 do if 2>=d then if d>=1 then if-3<d then for e=26,81 do if 1<d then z=r;break;end;s=f;break;end;else z=r;end else l=e;end else if 5<=d then if 1<=d then repeat if d<6 then t(b,y);break;end;d=-2;until true;else t(b,y);end else if d>3 then b=l[s];else y=l[z];end end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if d>=3 then if 4<d then if d~=6 then t(b,y);else d=-2;end else if d>=-1 then for e=22,80 do if 3<d then b=l[s];break;end;y=l[z];break;end;else y=l[z];end end else if 0<d then if-2~=d then for e=45,78 do if d>1 then z=r;break;end;s=f;break;end;else z=r;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 3<=d then if 4<d then if d>=1 then for e=48,86 do if 6>d then t(b,y);break;end;d=-2;break;end;else t(b,y);end else if 2~=d then for e=36,91 do if 3~=d then b=l[s];break;end;y=l[z];break;end;else y=l[z];end end else if d>0 then if d>1 then z=r;else s=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if 4<d then if 4~=d then repeat if 5~=d then d=-2;break;end;t(b,y);until true;else t(b,y);end else if 0~=d then for e=30,94 do if 3<d then b=l[s];break;end;y=l[z];break;end;else b=l[s];end end else if d>0 then if 0~=d then for e=44,56 do if 2>d then s=f;break;end;z=r;break;end;else s=f;end else l=e;end end d=d+1 end n=n+1;e=o[n];d=0;while d>-1 do if 2<d then if d>=5 then if 5==d then t(b,y);else d=-2;end else if d==4 then b=l[s];else y=l[z];end end else if d<1 then l=e;else if-2<d then repeat if 1~=d then z=r;break;end;s=f;until true;else s=f;end end end d=d+1 end n=n+1;e=o[n];a=e[f]t[a]=t[a](h(t,a+1,e[r]))n=n+1;e=o[n];d=0;while d>-1 do if 3>=d then if 2<=d then if 3~=d then p=r;else k=t;end else if 0<d then u=f;else l=e;end end else if 5<d then if 6==d then t[b]=c;else d=-2;end else if 1~=d then repeat if d~=4 then b=l[u];break;end;c=k[l[p]];until true;else b=l[u];end end end d=d+1 end until true;else local n=e[f]t[n]=t[n](h(t,n+1,e[r]))end else local l;for d=0,6 do if d>2 then if 4>=d then if 2<=d then repeat if d~=3 then t(e[f],e[r]);n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else if d~=3 then repeat if 6~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);until true;else t(e[f],e[r]);n=n+1;e=o[n];end end else if d<=0 then t(e[f],e[r]);n=n+1;e=o[n];else if d~=1 then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end end end end end else if 26~=d then local d,y;for b=0,6 do if 3>b then if 0<b then if b~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if b<=4 then if-1~=b then repeat if b>3 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];until true;else t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];end else if 5==b then d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];else t[e[f]]=t[e[r]];end end end end else t[e[f]]=t[e[r]][e[l]];end end end else if d>35 then if d<39 then if 36<d then if d<38 then local r,b,h,l,y,d;for z=0,1 do if 1>z then r=e[f]t[r](t[r+1])n=n+1;e=o[n];else r=e[f];b={};for e=1,#a do h=a[e];for e=0,#h do l=h[e];y=l[1];d=l[2];if y==t and d>=r then b[d]=y[d];l[1]=b;end;end;end;end end else z[e[r]]=t[e[f]];end else local d;t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];t(e[f],e[r]);n=n+1;e=o[n];d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];t[e[f]]=t[e[r]];end else if 39>=d then local s=k[e[r]];local h;local d={};h=b.bKAFqMnc({},{__index=function(n,e)local e=d[e];return e[1][e[2]];end,__newindex=function(t,e,n)local e=d[e]e[1][e[2]]=n;end;});for f=1,e[l]do n=n+1;local e=o[n];if e[j]==21 then d[f-1]={t,e[r]};else d[f-1]={y,e[r]};end;a[#a+1]=d;end;t[e[f]]=p(s,h,z);else if 39~=d then for b=27,84 do if 40<d then local b;for d=0,5 do if 2<d then if d<4 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];else if 1~=d then repeat if d~=4 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else if d<1 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if 1<d then b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end break;end;y[e[r]]=t[e[f]];break;end;else local b;for d=0,5 do if 2<d then if d<4 then t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];else if 1~=d then repeat if d~=4 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else if d<1 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if 1<d then b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end end end end else if d<=32 then if 27~=d then repeat if 32>d then local d;for b=0,3 do if 2<=b then if 3>b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if t[e[f]]then n=n+1;else n=e[r];end;end else if 0~=b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end break;end;for e=e[f],e[r]do t[e]=nil;end;until true;else local d;for b=0,3 do if 2<=b then if 3>b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if t[e[f]]then n=n+1;else n=e[r];end;end else if 0~=b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end end else if 34>d then local e=e[f]t[e]=t[e]()else if d>=30 then for o=39,68 do if 34~=d then if(t[e[f]]==e[l])then n=n+1;else n=e[r];end;break;end;local e=e[f];do return h(t,e,s)end;break;end;else local e=e[f];do return h(t,e,s)end;end end end end end else if d>9 then if d>=15 then if 18<=d then if 19<=d then if d==20 then local d;for l=0,6 do if l<=2 then if l>=1 then if l<2 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end else if l>=5 then if 1<=l then repeat if 6~=l then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];until true;else d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];end else if l~=2 then repeat if 3<l then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local e=e[f]t[e](t[e+1])end else local e=e[f]t[e]=t[e](t[e+1])end else if d>=16 then if 13~=d then for n=14,64 do if 17~=d then t[e[f]]=p(k[e[r]],nil,z);break;end;t[e[f]][t[e[r]]]=t[e[l]];break;end;else t[e[f]]=p(k[e[r]],nil,z);end else local d;t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=y[e[r]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];d=e[f];do return t[d](h(t,d+1,e[r]))end;n=n+1;e=o[n];d=e[f];do return h(t,d,s)end;n=n+1;e=o[n];do return end;end end else if 12>d then if d~=9 then for b=33,52 do if 10~=d then local d,l,b;for h=0,2 do if 0>=h then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h>-3 then for y=38,95 do if h>1 then d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end end end break;end;local s,y,z,d,h,b;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];do return t[e[f]]end n=n+1;e=o[n];s=e[f];y={};for e=1,#a do z=a[e];for e=0,#z do d=z[e];h=d[1];b=d[2];if h==t and b>=s then y[b]=h[b];d[1]=y;end;end;end;break;end;else local d,l,b;for h=0,2 do if 0>=h then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h>-3 then for y=38,95 do if h>1 then d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else d=e[f];l=t[d]b=t[d+2];if(b>0)then if(l>t[d+1])then n=e[r];else t[d+3]=l;end elseif(l<t[d+1])then n=e[r];else t[d+3]=l;end end end end end else if 13>d then local d,a,y,b;for l=0,5 do if 2>=l then if 0<l then if-3<=l then for b=14,60 do if l~=1 then t(e[f],e[r]);n=n+1;e=o[n];break;end;d=e[f]t[d]=t[d]()n=n+1;e=o[n];break;end;else d=e[f]t[d]=t[d]()n=n+1;e=o[n];end else d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];end else if l>3 then if l>4 then d=e[f]t[d]=t[d](h(t,d+1,s))else d=e[f]a,y=c(t[d](h(t,d+1,e[r])))s=y+d-1 b=0;for e=d,s do b=b+1;t[e]=a[b];end;n=n+1;e=o[n];end else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end end else if d>=10 then repeat if 13~=d then t[e[f]][e[r]]=t[e[l]];break;end;if t[e[f]]then n=n+1;else n=e[r];end;until true;else if t[e[f]]then n=n+1;else n=e[r];end;end end end end else if 4>=d then if 2>d then if d~=-2 then for b=13,95 do if d>0 then t[e[f]]=t[e[r]]-t[e[l]];break;end;local b;for d=0,6 do if d>2 then if 4>=d then if d==3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if d>2 then repeat if 6~=d then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];until true;else t[e[f]]=t[e[r]][t[e[l]]];end end else if 1<=d then if d~=-1 then for l=49,61 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end break;end;else local b;for d=0,6 do if d>2 then if 4>=d then if d==3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if d>2 then repeat if 6~=d then b=e[f]t[b]=t[b](h(t,b+1,e[r]))n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]][t[e[l]]];until true;else t[e[f]]=t[e[r]][t[e[l]]];end end else if 1<=d then if d~=-1 then for l=49,61 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end end else if d<3 then if(t[e[f]]==t[e[l]])then n=n+1;else n=e[r];end;else if d~=2 then repeat if 4~=d then local d;for l=0,1 do if-1<l then repeat if 0~=l then if t[e[f]]then n=n+1;else n=e[r];end;break;end;d=e[f]t[d]=t[d]()n=n+1;e=o[n];until true;else d=e[f]t[d]=t[d]()n=n+1;e=o[n];end end break;end;local l,b,s,u,a,z,d,p;for d=0,6 do if d<3 then if 1<=d then if d~=2 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if d>=5 then if 6>d then d=0;while d>-1 do if d<4 then if 2>d then if d>-4 then for n=24,86 do if 1>d then l=e;break;end;b=f;break;end;else b=f;end else if d~=-2 then repeat if 3~=d then s=r;break;end;u=t;until true;else s=r;end end else if 5<d then if 4<d then repeat if 7>d then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if 2<d then for e=37,77 do if d>4 then z=l[b];break;end;a=u[l[s]];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];else p=e[f]t[p]=t[p](h(t,p+1,e[r]))end else if 2<=d then repeat if 3<d then d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];break;end;d=0;while d>-1 do if 4>d then if d>=2 then if d>=1 then repeat if d>2 then u=t;break;end;s=r;until true;else s=r;end else if-1<d then repeat if 1>d then l=e;break;end;b=f;until true;else b=f;end end else if d>5 then if 3<d then repeat if d~=7 then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if d~=2 then for e=48,60 do if 5>d then a=u[l[s]];break;end;z=l[b];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];until true;else d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];end end end end until true;else local l,b,s,u,a,z,d,p;for d=0,6 do if d<3 then if 1<=d then if d~=2 then t[e[f]]=y[e[r]];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else t[e[f]]=y[e[r]];n=n+1;e=o[n];end else if d>=5 then if 6>d then d=0;while d>-1 do if d<4 then if 2>d then if d>-4 then for n=24,86 do if 1>d then l=e;break;end;b=f;break;end;else b=f;end else if d~=-2 then repeat if 3~=d then s=r;break;end;u=t;until true;else s=r;end end else if 5<d then if 4<d then repeat if 7>d then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if 2<d then for e=37,77 do if d>4 then z=l[b];break;end;a=u[l[s]];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];else p=e[f]t[p]=t[p](h(t,p+1,e[r]))end else if 2<=d then repeat if 3<d then d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];break;end;d=0;while d>-1 do if 4>d then if d>=2 then if d>=1 then repeat if d>2 then u=t;break;end;s=r;until true;else s=r;end else if-1<d then repeat if 1>d then l=e;break;end;b=f;until true;else b=f;end end else if d>5 then if 3<d then repeat if d~=7 then t[z]=a;break;end;d=-2;until true;else t[z]=a;end else if d~=2 then for e=48,60 do if 5>d then a=u[l[s]];break;end;z=l[b];break;end;else z=l[b];end end end d=d+1 end n=n+1;e=o[n];until true;else d=0;while d>-1 do if 3<d then if 5<d then if d<7 then t[z]=a;else d=-2;end else if d==4 then a=u[l[s]];else z=l[b];end end else if 1>=d then if d>=-1 then repeat if 0<d then b=f;break;end;l=e;until true;else l=e;end else if 1~=d then for e=10,67 do if d~=3 then s=r;break;end;u=t;break;end;else u=t;end end end d=d+1 end n=n+1;e=o[n];end end end end end end end else if 6<d then if d>=8 then if d>=5 then repeat if d~=9 then local l,z,y,a,h,d,b,s,u;for d=0,2 do if 0<d then if-3<=d then for p=23,88 do if 2~=d then d=0;while d>-1 do if d<=2 then if 1<=d then if 0~=d then repeat if 2~=d then z=f;break;end;y=r;until true;else y=r;end else l=e;end else if d<=4 then if d>2 then repeat if 3<d then h=l[z];break;end;a=l[y];until true;else h=l[z];end else if 5<d then d=-2;else t(h,a);end end end d=d+1 end n=n+1;e=o[n];break;end;b=e[f];s=t[b]u=t[b+2];if(u>0)then if(s>t[b+1])then n=e[r];else t[b+3]=s;end elseif(s<t[b+1])then n=e[r];else t[b+3]=s;end break;end;else d=0;while d>-1 do if d<=2 then if 1<=d then if 0~=d then repeat if 2~=d then z=f;break;end;y=r;until true;else y=r;end else l=e;end else if d<=4 then if d>2 then repeat if 3<d then h=l[z];break;end;a=l[y];until true;else h=l[z];end else if 5<d then d=-2;else t(h,a);end end end d=d+1 end n=n+1;e=o[n];end else t[e[f]]=#t[e[r]];n=n+1;e=o[n];end end break;end;t[e[f]]=y[e[r]];until true;else t[e[f]]=y[e[r]];end else local d,b,y;for h=0,4 do if 1<h then if h<=2 then t[e[f]]=#t[e[r]];n=n+1;e=o[n];else if h~=-1 then repeat if 3<h then d=e[f];b=t[d]y=t[d+2];if(y>0)then if(b>t[d+1])then n=e[r];else t[d+3]=b;end elseif(b<t[d+1])then n=e[r];else t[d+3]=b;end break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else d=e[f];b=t[d]y=t[d+2];if(y>0)then if(b>t[d+1])then n=e[r];else t[d+3]=b;end elseif(b<t[d+1])then n=e[r];else t[d+3]=b;end end end else if 0~=h then t(e[f],e[r]);n=n+1;e=o[n];else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end end else if d~=1 then repeat if d~=5 then local s,u,z,a,p,d,l,y;for d=0,2 do if 1<=d then if d>0 then repeat if 2>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;until true;else l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;end else d=0;while d>-1 do if 2>=d then if 1>d then s=e;else if-1<d then for e=29,57 do if 1<d then z=r;break;end;u=f;break;end;else z=r;end end else if d>4 then if d>=2 then repeat if d~=6 then t(p,a);break;end;d=-2;until true;else d=-2;end else if-1<=d then for e=18,98 do if d<4 then a=s[z];break;end;p=s[u];break;end;else a=s[z];end end end d=d+1 end n=n+1;e=o[n];end end break;end;local l;for d=0,6 do if 2>=d then if 1<=d then if d>-3 then repeat if 2~=d then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end else if 5>d then if d~=3 then t(e[f],e[r]);n=n+1;e=o[n];else t(e[f],e[r]);n=n+1;e=o[n];end else if 3<=d then for l=33,54 do if 6>d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);break;end;else t(e[f],e[r]);end end end end until true;else local s,p,z,a,u,d,l,y;for d=0,2 do if 1<=d then if d>0 then repeat if 2>d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;until true;else l=e[f];y=t[l];for e=l+1,e[r]do b.IZGgCIfj(y,t[e])end;end else d=0;while d>-1 do if 2>=d then if 1>d then s=e;else if-1<d then for e=29,57 do if 1<d then z=r;break;end;p=f;break;end;else z=r;end end else if d>4 then if d>=2 then repeat if d~=6 then t(u,a);break;end;d=-2;until true;else d=-2;end else if-1<=d then for e=18,98 do if d<4 then a=s[z];break;end;u=s[p];break;end;else a=s[z];end end end d=d+1 end n=n+1;e=o[n];end end end end end end end else if d>=63 then if 73<d then if d>78 then if 82>d then if 80<=d then if d~=79 then for b=49,84 do if d~=81 then local b;for d=0,3 do if d>1 then if 0<d then for b=38,57 do if d>2 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;else t[e[f]][t[e[r]]]=t[e[l]];end else if-1~=d then repeat if d~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end break;end;local d,d,d,c,k,d,d,s,p,u,h,z,a,b;for d=0,6 do if d>2 then if d>4 then if d>1 then repeat if 6~=d then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;d=0;while d>-1 do if 2>=d then if d>0 then if 2==d then z=h[p];else h=e;end else s=f;p=r;u=l;end else if d<5 then if d~=1 then for e=14,94 do if 3<d then b=t[z];for e=1+z,h[u]do b=b..t[e];end;break;end;a=h[s];break;end;else b=t[z];for e=1+z,h[u]do b=b..t[e];end;end else if 1~=d then repeat if d~=6 then t[a]=b;break;end;d=-2;until true;else d=-2;end end end d=d+1 end until true;else d=0;while d>-1 do if 2>=d then if d>0 then if 2==d then z=h[p];else h=e;end else s=f;p=r;u=l;end else if d<5 then if d~=1 then for e=14,94 do if 3<d then b=t[z];for e=1+z,h[u]do b=b..t[e];end;break;end;a=h[s];break;end;else b=t[z];for e=1+z,h[u]do b=b..t[e];end;end else if 1~=d then repeat if d~=6 then t[a]=b;break;end;d=-2;until true;else d=-2;end end end d=d+1 end end else if d==4 then t[e[f]]=t[e[r]]%e[l];n=n+1;e=o[n];else t[e[f]]=y[e[r]];n=n+1;e=o[n];end end else if 1<=d then if-1~=d then repeat if d<2 then t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];break;end;d=0;while d>-1 do if d<4 then if d<2 then if d~=-3 then for n=43,77 do if 0<d then s=f;break;end;h=e;break;end;else s=f;end else if-2<d then for e=32,80 do if 2~=d then c=t;break;end;p=r;break;end;else c=t;end end else if 6>d then if d>4 then a=h[s];else k=c[h[p]];end else if 6<d then d=-2;else t[a]=k;end end end d=d+1 end n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]]+t[e[l]];n=n+1;e=o[n];end else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end end break;end;else local b;for d=0,3 do if d>1 then if 0<d then for b=38,57 do if d>2 then t[e[f]][t[e[r]]]=t[e[l]];break;end;t[e[f]][t[e[r]]]=t[e[l]];n=n+1;e=o[n];break;end;else t[e[f]][t[e[r]]]=t[e[l]];end else if-1~=d then repeat if d~=1 then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;b=e[f]t[b]=t[b](t[b+1])n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end end end else t[e[f]]=t[e[r]]*e[l];end else if 82<d then if d==84 then local e=e[f]local f,n=c(t[e](t[e+1]))s=n+e-1 local n=0;for e=e,s do n=n+1;t[e]=f[n];end;else local s=k[e[r]];local h;local d={};h=b.bKAFqMnc({},{__index=function(n,e)local e=d[e];return e[1][e[2]];end,__newindex=function(t,e,n)local e=d[e]e[1][e[2]]=n;end;});for f=1,e[l]do n=n+1;local e=o[n];if e[j]==21 then d[f-1]={t,e[r]};else d[f-1]={y,e[r]};end;a[#a+1]=d;end;t[e[f]]=p(s,h,z);end else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;end end else if d>=76 then if d>=77 then if 74~=d then for b=31,81 do if 77~=d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;break;end;t[e[f]][e[r]]=t[e[l]];break;end;else t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];t[e[f]]=t[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else local d,u,z,l,y,b;d=e[f];do return t[d](h(t,d+1,e[r]))end;n=n+1;e=o[n];d=e[f];do return h(t,d,s)end;n=n+1;e=o[n];d=e[f];u={};for e=1,#a do z=a[e];for e=0,#z do l=z[e];y=l[1];b=l[2];if y==t and b>=d then u[b]=y[b];l[1]=u;end;end;end;end else if d~=74 then local o=e[f];local f={};for e=1,#a do local e=a[e];for n=0,#e do local n=e[n];local r=n[1];local e=n[2];if r==t and e>=o then f[e]=r[e];n[1]=f;end;end;end;else t[e[f]]=t[e[r]]%e[l];end end end else if d>67 then if d>=71 then if d>71 then if d~=69 then repeat if 73~=d then local e=e[f]local f,n=c(t[e](t[e+1]))s=n+e-1 local n=0;for e=e,s do n=n+1;t[e]=f[n];end;break;end;local h,a,b,z,y,s,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 1<d then if d>=-1 then for e=33,93 do if d>2 then z=t;break;end;b=r;break;end;else b=r;end else if d~=0 then a=f;else h=e;end end else if 5>=d then if d>=2 then for e=34,59 do if 4<d then s=h[a];break;end;y=z[h[b]];break;end;else y=z[h[b]];end else if 3<d then repeat if 7~=d then t[s]=y;break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;until true;else local h,a,b,y,z,s,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 1<d then if d>=-1 then for e=33,93 do if d>2 then y=t;break;end;b=r;break;end;else b=r;end else if d~=0 then a=f;else h=e;end end else if 5>=d then if d>=2 then for e=34,59 do if 4<d then s=h[a];break;end;z=y[h[b]];break;end;else z=y[h[b]];end else if 3<d then repeat if 7~=d then t[s]=z;break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else local d;t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];d=e[f]t[d]=t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];t[e[f]]=#t[e[r]];n=n+1;e=o[n];if(t[e[f]]~=e[l])then n=n+1;else n=e[r];end;end else if 68>=d then local n=e[f]local f,e=c(t[n](h(t,n+1,e[r])))s=e+n-1 local e=0;for n=n,s do e=e+1;t[n]=f[e];end;else if 69==d then for d=0,1 do if-4~=d then repeat if d~=1 then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;if not t[e[f]]then n=n+1;else n=e[r];end;until true;else t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];end end else local h,z,a,s,y,d,l,b,u;for d=0,2 do if 0<d then if 0<d then for p=35,80 do if d<2 then d=0;while d>-1 do if 3>d then if d>0 then if-2<=d then repeat if d~=2 then z=f;break;end;a=r;until true;else z=f;end else h=e;end else if 5>d then if d~=-1 then repeat if 3~=d then y=h[z];break;end;s=h[a];until true;else y=h[z];end else if d>4 then repeat if d>5 then d=-2;break;end;t(y,s);until true;else t(y,s);end end end d=d+1 end n=n+1;e=o[n];break;end;l=e[f];b=t[l]u=t[l+2];if(u>0)then if(b>t[l+1])then n=e[r];else t[l+3]=b;end elseif(b<t[l+1])then n=e[r];else t[l+3]=b;end break;end;else l=e[f];b=t[l]u=t[l+2];if(u>0)then if(b>t[l+1])then n=e[r];else t[l+3]=b;end elseif(b<t[l+1])then n=e[r];else t[l+3]=b;end end else d=0;while d>-1 do if d<3 then if d<1 then h=e;else if 0<d then for e=16,78 do if 1<d then a=r;break;end;z=f;break;end;else a=r;end end else if d<=4 then if 1<d then repeat if d~=4 then s=h[a];break;end;y=h[z];until true;else y=h[z];end else if d>=1 then repeat if 6~=d then t(y,s);break;end;d=-2;until true;else d=-2;end end end d=d+1 end n=n+1;e=o[n];end end end end end else if d>=65 then if 66>d then do return end;else if 62<d then for b=36,93 do if d>66 then local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end break;end;local b,y,s,h,a,z,d;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];d=0;while d>-1 do if 4>d then if 2>d then if d~=-4 then repeat if d~=0 then y=f;break;end;b=e;until true;else b=e;end else if d>=1 then for e=44,88 do if 3~=d then s=r;break;end;h=t;break;end;else h=t;end end else if d<=5 then if 1<=d then repeat if 5>d then a=h[b[s]];break;end;z=b[y];until true;else z=b[y];end else if d>6 then d=-2;else t[z]=a;end end end d=d+1 end n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;break;end;else local f=e[f];local d=t[f+2];local o=t[f]+d;t[f]=o;if(d>0)then if(o<=t[f+1])then n=e[r];t[f+3]=o;end elseif(o>=t[f+1])then n=e[r];t[f+3]=o;end end end else if d>59 then repeat if 63~=d then local b,z,s,o,y,h,d;local n=0;while n>-1 do if 2>=n then if n<=0 then b=f;z=r;s=l;else if n~=0 then for t=14,95 do if 1<n then y=o[z];break;end;o=e;break;end;else o=e;end end else if 4>=n then if n>=1 then for e=18,60 do if n~=3 then d=t[y];for e=1+y,o[s]do d=d..t[e];end;break;end;h=o[b];break;end;else h=o[b];end else if n~=5 then n=-2;else t[h]=d;end end end n=n+1 end break;end;local b;for d=0,6 do if d>=3 then if 5>d then if 1<d then repeat if 4>d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end else if 1<=d then for b=23,64 do if d>5 then t[e[f]]=z[e[r]];break;end;t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];break;end;else t[e[f]]=z[e[r]];end end else if 0>=d then b=e[f]t[b](t[b+1])n=n+1;e=o[n];else if d>0 then repeat if 1~=d then t[e[f]]=z[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=z[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end end end until true;else local b,z,s,o,y,h,d;local n=0;while n>-1 do if 2>=n then if n<=0 then b=f;z=r;s=l;else if n~=0 then for t=14,95 do if 1<n then y=o[z];break;end;o=e;break;end;else o=e;end end else if 4>=n then if n>=1 then for e=18,60 do if n~=3 then d=t[y];for e=1+y,o[s]do d=d..t[e];end;break;end;h=o[b];break;end;else h=o[b];end else if n~=5 then n=-2;else t[h]=d;end end end n=n+1 end end end end end else if d>51 then if 57<=d then if 59>=d then if d<58 then local d;for b=0,2 do if b<=0 then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b==2 then t[e[f]][t[e[r]]]=t[e[l]];else t[e[f]]=t[e[r]]-e[l];n=n+1;e=o[n];end end end else if 57<d then for n=36,98 do if 59>d then t[e[f]]=t[e[r]]-e[l];break;end;local d,h,l,b,o;local n=0;while n>-1 do if 3<=n then if 4<n then if 4~=n then repeat if 6~=n then t(o,b);break;end;n=-2;until true;else t(o,b);end else if 0~=n then for e=42,89 do if n<4 then b=d[l];break;end;o=d[h];break;end;else o=d[h];end end else if n>0 then if-3<=n then for e=36,76 do if 1~=n then l=r;break;end;h=f;break;end;else l=r;end else d=e;end end n=n+1 end break;end;else t[e[f]]=t[e[r]]-e[l];end end else if 61>d then t[e[f]]=#t[e[r]];else if 58<=d then for n=45,83 do if d<62 then local e=e[f]t[e]=t[e]()break;end;t[e[f]]=t[e[r]][t[e[l]]];break;end;else local e=e[f]t[e]=t[e]()end end end else if d>53 then if d<=54 then for d=0,6 do if 2>=d then if 1>d then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else if-2<d then repeat if d>1 then t[e[f]]=z[e[r]];n=n+1;e=o[n];break;end;z[e[r]]=t[e[f]];n=n+1;e=o[n];until true;else t[e[f]]=z[e[r]];n=n+1;e=o[n];end end else if d>4 then if 2<d then repeat if d>5 then z[e[r]]=t[e[f]];break;end;t[e[f]]=(e[r]~=0);n=n+1;e=o[n];until true;else z[e[r]]=t[e[f]];end else if d~=4 then t[e[f]]=t[e[r]][e[l]];n=n+1;e=o[n];else z[e[r]]=t[e[f]];n=n+1;e=o[n];end end end end else if d~=55 then for d=0,6 do if 2>=d then if 1>d then t[e[f]]={};n=n+1;e=o[n];else if d~=2 then t(e[f],e[r]);n=n+1;e=o[n];else t[e[f]]=t[e[r]];n=n+1;e=o[n];end end else if d<5 then if d~=2 then repeat if 3~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else t(e[f],e[r]);n=n+1;e=o[n];end else if d==6 then t(e[f],e[r]);else t(e[f],e[r]);n=n+1;e=o[n];end end end end else local l;for d=0,6 do if d>=3 then if d<=4 then if d>=0 then repeat if 3~=d then l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];until true;else l=e[f]t[l]=t[l](h(t,l+1,e[r]))n=n+1;e=o[n];end else if d~=3 then for l=48,98 do if d~=5 then t(e[f],e[r]);break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;else t(e[f],e[r]);end end else if 0<d then if d~=-1 then for l=16,92 do if 1~=d then t(e[f],e[r]);n=n+1;e=o[n];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end else t(e[f],e[r]);n=n+1;e=o[n];end end end end end else if d~=49 then repeat if 53~=d then local d,y;for b=0,5 do if 3>b then if 1<=b then if b>-2 then repeat if 2>b then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if 3>=b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b>=3 then for d=44,64 do if 5>b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+t[e[l]];break;end;else t[e[f]]=t[e[r]]+t[e[l]];end end end end break;end;local e=e[f];local n=t[e];for e=e+1,s do b.IZGgCIfj(n,t[e])end;until true;else local d,y;for b=0,5 do if 3>b then if 1<=b then if b>-2 then repeat if 2>b then t[e[f]]=t[e[r]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]];n=n+1;e=o[n];until true;else t[e[f]]=t[e[r]];n=n+1;e=o[n];end else d=e[f];y=t[e[r]];t[d+1]=y;t[d]=y[e[l]];n=n+1;e=o[n];end else if 3>=b then d=e[f]t[d]=t[d](h(t,d+1,e[r]))n=n+1;e=o[n];else if b>=3 then for d=44,64 do if 5>b then t[e[f]]=t[e[r]][t[e[l]]];n=n+1;e=o[n];break;end;t[e[f]]=t[e[r]]+t[e[l]];break;end;else t[e[f]]=t[e[r]]+t[e[l]];end end end end end end end else if 47<=d then if 48<d then if d<=49 then local e=e[f]t[e]=t[e](h(t,e+1,s))else if 47<=d then for n=14,69 do if 50~=d then local n=e[f]t[n](h(t,n+1,e[r]))break;end;t[e[f]]=#t[e[r]];break;end;else t[e[f]]=#t[e[r]];end end else if d>=45 then for o=14,71 do if 48>d then local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end break;end;local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end break;end;else local f=e[f];local o=t[f]local d=t[f+2];if(d>0)then if(o>t[f+1])then n=e[r];else t[f+3]=o;end elseif(o<t[f+1])then n=e[r];else t[f+3]=o;end end end else if 43<d then if d>=45 then if d~=42 then for b=37,71 do if d>45 then for d=0,1 do if-4<d then for l=17,89 do if d>0 then t[e[f]]=z[e[r]];break;end;t(e[f],e[r]);n=n+1;e=o[n];break;end;else t(e[f],e[r]);n=n+1;e=o[n];end end break;end;t[e[f]]=t[e[r]]%t[e[l]];break;end;else t[e[f]]=t[e[r]]%t[e[l]];end else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;end else if 40~=d then repeat if d~=43 then local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;break;end;local n=e[f]t[n](h(t,n+1,e[r]))until true;else local d;t[e[f]]=t[e[r]];n=n+1;e=o[n];d=e[f]t[d](t[d+1])n=n+1;e=o[n];t[e[f]]=z[e[r]];n=n+1;e=o[n];t[e[f]]();n=n+1;e=o[n];do return end;n=n+1;e=o[n];for e=e[f],e[r]do t[e]=nil;end;end end end end end end end n=1+n;end;end;return fe end;local r=0xff;local o={};local d=(1);local f='';(function(n)local t=n local l=0x00 local e=0x00 t={(function(b)if l>0x30 then return b end l=l+1 e=(e+0x995-b)%0x35 return(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xef);r[2]=(r[2]*(fe(function()o()end,h(f))-fe(r[1],h(f))))+1;o[d]={};r=r[2];d=d+r;end return true end)'pFTog'and t[0x3](0x2c4+b))or(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x64);end return true end)'JpjmH'and t[0x1](b+0x3a8))or(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x3a);end return true end)'eyTua'and t[0x2](b+0x272))or b end),(function(f)if l>0x22 then return f end l=l+1 e=(e+0xfd6-f)%0x47 return(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xe5);end return true end)'bIEKJ'and t[0x2](0x182+f))or(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x65);end return true end)'RiyOs'and t[0x1](f+0x2fb))or(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xb5);end return true end)'QQWwz'and t[0x3](f+0x21e))or f end),(function(h)if l>0x2d then return h end l=l+1 e=(e+0xabe-h)%0x29 return(e%0x03==0x1 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x2c);f={f..'\58 a',f};o[d]=te();d=d+((not b.IxrpaEaT)and 1 or 0);f[1]='\58'..f[1];r[2]=0xff;end return true end)'XDFzv'and t[0x1](0x2e1+h))or(e%0x03==0x0 and(function(t)if not n[t]then e=e+0x01 n[t]=(0xaa);o[d]=oe();d=d+r;end return true end)'inCDP'and t[0x2](h+0x223))or(e%0x03==0x2 and(function(t)if not n[t]then e=e+0x01 n[t]=(0x1e);f='\37';r={function()r()end};f=f..'\100\43';end return true end)'oBEOy'and t[0x3](h+0x3d6))or h end)}t[0x3](0x24d7)end){};local e=p(h(o));o[2]={};o[1]=e(o[1])AacnzerEFmRWPYV=nil;e=p(h(o))return e(...);end return re((function()local n={}local e=0x01;local t;if b.IxrpaEaT then t=b.IxrpaEaT(re)else t=''end if b.nYavgHtI(t,b.AvsKrrdr)then e=e+0;else e=e+1;end n[e]=0x02;n[n[e]+0x01]=0x03;return n;end)(),...)end)((function(t,e,n,f,r,o)local o;if t>3 then if t<=5 then if t~=1 then for o=46,58 do if 4~=t then local t=f;do return function()local e=e(n,t(t,t),t(t,t));t(1);return e;end;end;break;end;local t=f;local r,f,o=r(2);do return function()local n,e,d,l=e(n,t(t,t),t(t,t)+3);t(4);return(l*r)+(d*f)+(e*o)+n;end;end;break;end;else local t=f;do return function()local e=e(n,t(t,t),t(t,t));t(1);return e;end;end;end else if 7<=t then if 7~=t then do return n(t,nil,n);end else do return setmetatable({},{['__\99\97\108\108']=function(e,r,t,f,n)if n then return e[n]elseif f then return e else e[r]=t end end})end end else do return r[n]end;end end else if 2>t then if t>=-3 then for o=11,82 do if t>0 then do return function(n,e,t)if t then local e=(n/2^(e-1))%2^((t-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(n%(e+e)>=e)and 1 or 0;end;end;end;break;end;do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;break;end;else do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;end else if 0~=t then for o=40,74 do if t~=3 then do return 16777216,65536,256 end;break;end;do return e(1),e(4,r,f,n,e),e(5,r,f,n)end;break;end;else do return 16777216,65536,256 end;end end end end),...)
end

LocalModules.BulletTrack = function()
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
end

LocalModules.FlingAll = function()
    local Targets = {"All"} -- "All", "Target Name", "arian_was_here"

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
            return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
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
end


LocalModules.R6Dojo = function()
    ([[This file was protected with MoonSec V3]]):gsub('.+', (function(a) _OgPfGznCLYMi = a; end)); return(function(t,...)local h;local r;local f;local c;local o;local d;local e=24915;local n=0;local l={};while n<445 do n=n+1;while n<0x276 and e%0x32fe<0x197f do n=n+1 e=(e+706)%17956 local _=n+e if(e%0x2a66)<0x1533 then e=(e+0x2d2)%0xba18 while n<0x253 and e%0xb56<0x5ab do n=n+1 e=(e+517)%40530 local f=n+e if(e%0xbae)>=0x5d7 then e=(e*0x281)%0x813b local e=63718 if not l[e]then l[e]=0x1 d=(not d)and _ENV or d;end elseif e%2~=0 then e=(e+0x97)%0x3c98 local e=92014 if not l[e]then l[e]=0x1 d=getfenv and getfenv();end else e=(e*0x28e)%0xa40e n=n+1 local e=28415 if not l[e]then l[e]=0x1 c=tonumber;end end end elseif e%2~=0 then e=(e*0x20d)%0x27aa while n<0x166 and e%0x3086<0x1843 do n=n+1 e=(e-861)%7328 local d=n+e if(e%0x1ebc)<=0xf5e then e=(e-0x1a6)%0xb42b local e=74623 if not l[e]then l[e]=0x1 r={};end elseif e%2~=0 then e=(e*0x35f)%0x4b02 local e=81618 if not l[e]then l[e]=0x1 end else e=(e+0x19e)%0x91c0 n=n+1 local e=88582 if not l[e]then l[e]=0x1 h=string;end end end else e=(e-0x88)%0x3c41 n=n+1 while n<0xdd and e%0xc36<0x61b do n=n+1 e=(e-772)%14332 local _=n+e if(e%0x47d4)>=0x23ea then e=(e+0xc3)%0x8d3e local e=12863 if not l[e]then l[e]=0x1 end elseif e%2~=0 then e=(e*0x365)%0x58d4 local e=81323 if not l[e]then l[e]=0x1 f=function(f)local e=0x01 local function l(n)e=e+n return f:sub(e-n,e-0x01)end while true do local n=l(0x01)if(n=="\5")then break end local e=h.byte(l(0x01))local e=l(e)if n=="\2"then e=r.ylZBVUob(e)elseif n=="\3"then e=e~="\0"elseif n=="\6"then d[e]=function(n,e)return t(8,nil,t,e,n)end elseif n=="\4"then e=d[e]elseif n=="\0"then e=d[e][l(h.byte(l(0x01)))];end local n=l(0x08)r[n]=e end end end else e=(e*0xb5)%0x1887 n=n+1 local e=56276 if not l[e]then l[e]=0x1 o="\4\8\116\111\110\117\109\98\101\114\121\108\90\66\86\85\111\98\0\6\115\116\114\105\110\103\4\99\104\97\114\81\81\114\70\88\75\87\66\0\6\115\116\114\105\110\103\3\115\117\98\121\116\87\86\82\103\117\70\0\6\115\116\114\105\110\103\4\98\121\116\101\117\76\88\104\82\65\95\71\0\5\116\97\98\108\101\6\99\111\110\99\97\116\102\71\114\103\67\77\119\104\0\5\116\97\98\108\101\6\105\110\115\101\114\116\116\74\112\82\65\122\69\119\5";end end end end end e=(e+783)%47444 end f(o);local e={};for n=0x0,0xff do local l=r.QQrFXKWB(n);e[n]=l;e[l]=n;end local function _(n)return e[n];end local h=(function(t,f)local o,l=0x01,0x10 local n={{},{},{}}local d=-0x01 local e=0x01 local h=t while true do n[0x03][r.ytWVRguF(f,e,(function()e=o+e return e-0x01 end)())]=(function()d=d+0x01 return d end)()if d==(0x0f)then d=""l=0x000 break end end local d=#f while e<d+0x01 do n[0x02][l]=r.ytWVRguF(f,e,(function()e=o+e return e-0x01 end)())l=l+0x01 if l%0x02==0x00 then l=0x00 r.tJpRAzEw(n[0x01],(_((((n[0x03][n[0x02][0x00]]or 0x00)*0x10)+(n[0x03][n[0x02][0x01]]or 0x00)+h)%0x100)));h=t+h;end end return r.fGrgCMwh(n[0x01])end);f(h(164,"N4e7-Z5a&hVL:PsB54"));f(h(213,"VJphDo_)BH*+f^qwp+ofwDpbDH_+H++wB)JpDq)JHw*}q)JpD+oo)q*DqH+_qp)BH_+wwop6h)_f*H^v;pwHD+D^hB_)w^p*Df)f*^fHw*pBhqBo*w++7H+fq^Bo+J^*wfpfoEJH*ff+{Hphoh)oB_f+^Hhyoh_JBo_qH^hJo=Bq*^)o0)p*o_HD+)fDwfJ^D)Bf*+^qqhfqgJHh+Uq*SqhJ_+BhfJ^Hioh*oq)fHwfqq)JhDf_ffhBc*wD__fH+f)wPJpDp___q++wpJDh)_wHoHqBp+pDf_DHYfoqH+oDw)h*7+fqHJfoT_+*L^prJJfooDqhB_owwpho0_fHHffNhpqoB_hHfffwJp)qBJD**^)wHpHo*)wHq^ww)6hD^Bo*f_^H*hpDwBJ*ofqS*hBDo)++f*q^w?+DJJHDB^fw+hHoBpL*f^^L+h__DH)*J+wq_Jp_BHpHD)*"));local e=(-3387+(function()local f,n=0,1;(function(n,l,e)e(n(e,n,e),e(l and l,l,n),l(n,e,e))end)(function(d,e,l)if f>427 then return d end f=f+1 n=(n+932)%6122 if(n%1840)<920 then n=(n+461)%14616 return l else return d(l(l,e and e,d),e(l,e,d),e(l,l,d and e))end return l(l(l and d,d,e and d),e(l,d,d),e(l,e,e))end,function(l,d,e)if f>260 then return l end f=f+1 n=(n+841)%7987 if(n%1894)>=947 then return d else return d(l(d,l,e),d(e,e,e)and d(e and l,l,l),l(e,e and l,e))end return e(d(l,e,l),d(e,l,e and e),e(e,d,l))end,function(e,d,l)if f>288 then return e end f=f+1 n=(n-152)%23706 if(n%652)>326 then n=(n*969)%34297 return e(e(e,e,l and e)and l(d,l,l),l(l,e and l,e)and e(d,e,d),e(l,d and e,l)and e(l,l,d))else return l end return e end)return n;end)())local _=r.wwvVdicn or r.tdnuyiwE;local de=(getfenv)or(function()return _ENV end);local o=4;local b=1;local d=2;local f=3;local function m(u,...)local s=h(e,"9{LJ6h_ :fdWlDZ8fyu_:fblfL{ffh{:fW_Z2D:hL):8{8dJW_6_WfJlW8f J:dDJDf J8l66llZJelhhhDlhLl8h6 h{l :8W ZhhZl Y8DLD8_ lzL ZWlf_SJf:l:fWL&dHL:fl{DW{Lhd Z_l1JhlJJd hLhld6Dl8J ll6D:D6_d_8f:68l 8kLD{  ZZ_88D_63J W{_:h{hLfWJLld8JL8lfDL8f{L_W_JDWJJnWhD__6DfhlD8dh6DlfhDl8h6Z:hlZlJZZ6_ ZW_D:8{ fL{hf:_BK8f_?Df {dfL{6J_l8JfWlJ8u8W6J WfL{W_J W_LDD{hLllh6Dvh8W hWDfhlZ;_llL :8W lfM{ fJ{_ffh8wZfi{J:D7ZdLW66{W JdWDf8{LdD{fWL{_ll6JfWL W LZlDZd 6ZD >8JlW_ Z{ +8 _Z8: W8J hf L:fd{Dd) h%Wff{:f:{hf_LldFLLf6J:W_JldZJ W:DfhDDlh8ZLll6fD:hJdf86  8d D6h:J0_:fgD:8{LfhLddD{Zd{L6d8LddDJtlhJZWfJlW86llh6:lW 6Ddh6D hdZJ_^Z6__Zl_l8J Z8h :8W:6&{:he :dhdf*{Jf_{dfl{8dLJ ZLLWdZJ{l{J WdJDZV_:l_6fll68DLhdD:_DZ:_{Z__ ZW_D8n J8_:f8l 83L: 3::DKZdJLhf {WfDLDdJL_df6lW6JLW_J:WlJZl_66Dfh6lDhJDJh:DfhlD8_LZ:_:Zl_Z86 68f dg8WdKJ::%fff)8fL{hW:h fZLJd6LfddJLWo6hWZJflaJ8lZ6hl:6WlZ_lD6hfDd_{ZX_hZ_:f88_88h h8: W%L:{cdW:*df{{qfh{_fd{ldPLLdh _dWLZW{J W JdWD6UD 6_lZ6ll8hLDhh:DW RZ{_dZ _dZD 48J lLd ly_:L<_::#l:Z{6f6{ Z:{DdvLJdfLfdlL8WL:JW:JWWZ6 l66 ld6D{ZhJD_hfZ{h8ZL_hZZflZZ f86  8d ZXP:h0_:fhd:8{Lfh{8fW{Zd{L68hLddDJ&W:J_WfJllh Jlhh{lWh{D{hhD hlDD_sJ{__Zf_l86 L8h :8Wll){:6U fkkDf&{Jfl6dflLfdLLfd:LldZJLW6J -:JDlz6JlZ6fll68D::_D:__DZ_ Z6_:Zd_Z8e J66 f8l 8zW:hE::WLZWd{6dJ{ddQLHdfL_lfJLd8JZWh66WW6 l{6d8:6dDWhQD:h_DdhlZJ_LZhW_ZW_Z8{  8  d8D:ph{:_Nf:l{JfL{hf:{WZlL{d6L W6LDWRJJW_: WlJ8lLhil:6WlZh{Dfh Z_hDZZ_JZ _fZl J8L:{8: 88Z:{;6: {k:D{lfJ{ ff{Zf86LW8L:W:LZWDJ6WZJdDDhllJhJlfhfl8hWDhh:8{hZ8q_68{_dZD t8J: 8f:f88f{Ah:fjWdZJdf6L6fdLfdxLZd_6fWLL8W8JhlhJWl 6{l6:LldhlD4hZD_hfDlh8Ld_h8h_W8D {8h  8dldN?:JY_:dBl:8{Lfl{:fW{Zd:L6d LddZJmWJJ_WfJlW8JL066ff:{dfDLgdJL_lff8Z__ZZf_lZ8dfL d:L8W!J{W_JW:WUDf0{Jf_{ffl{8ZLL_{LZ LLl6llJWdd llJ6ll_6fll:?4::Dbdf{{_f6{6fDZW_D8; J8_ f8lh86{f6T::WHZf{J f {dfDL,dJL_dfJZWhJLW_J:WZJZl{66DfhflDhLDJhDDfhlD8 6Z__:ZZ_Z8J 68  do8fJ3J:d2f:DU8fL{hf:L^fZL{d6LWddLZWNJJllJfWlJ8lL6hl:6WZihJD6h:Dd_JZ}_JZ_ WQ _886 h8f W8Z:{{_:dPdf!{Nf:{_ff{lW{LZdhLldWJLW{J6W Jdl 6wlJ6_lD6lDohLDh JDWhZZ{_hZ _dZD o88 _8f l}u:L7h::eW:8{{f6{ fW{Dd)LJd_LfdlL8WL6 W:JWWZ66D{6 ld6D{llLJ WD{DlD6WDL6fD8h ZR_L d}D DQr:J6Z8Z f8(:#p6:{88JZ.8fJ{W6d{Jf8L:d6{DhDlL6Dlh6:lW:8J8WD66WWh{lfhLD6JLDb8L l8h :8Wlh__8:hdZ8 8(_ l8f Zf8LJdLLhd: W{dfLLDJdl6JDl06J{:WZJddLJ l 6Zl66{l_Z  6Zd_D8+lhhWZ _PZ6 6D: l8u Zn{ f8W{Dd{LidJL_{s:D{lf W:6{WWJZl{: L8dWJ8W{J_ldJZlZZL_hZh_:ZWDlh_ZW8d Z8D:H<J8D_d8Z DfhLdf:{WfZ_ 1DfhjZ J{fdhLfdD88d LWW{LlfdJ6f66+W:6DD,ZJ_8Z__fZllJhWZLhDlW_D86_D8W J8l Zf_{Dff{lf8_h{6f_{ffJ{6d:Wd6JWD6TlJ: J WhJlWJ6fl{6dllZ6_lZ _dZDW:_:ZJhdZd_ZZW_f:W{J:Z{{f6_O3:fv{6:6{6:l{{JLW8JhW:JWJ+dJJld:JDlUJhl J8WD{_:Z{{fJZ:_WZZ {td  8Z Dy*:Jx_:fLlfh{Lff{:f8{ZddL6dD_LdDJ6WJJWWfJDW86Jlh6lD 6ZD{h6DlhdDZ_MZ  LZf_lZ8 l8h f8W Z{ :6OW:daDfS{Jf_Jflh{8d_LhdlLWW J{D6h6Wd6{l*6 l_hhll_{D6hhDZhWZZ_{Z6_ ZdfD8V  8_ 88l:{(L:WJ8:W{Lf{L{f {WfDLTdJLdWhLld8JLlLJ:WlJZlhhkl 6dlD_{DJh Df_Z{f_LZd_:8__Z8{ 6Of l8D:_FJ::Pf:l,8fL6Wf:LtfZLJd6L:ddLD8DJJW_JfWDJ8lL6hDd:hlZh_D6_:DdhDZ#:J8W_f8{_88  h/L W{1fWF6:DSdfl{efJ{_ffLJf8L dhLddWJqW{6_WdJdlJ6GDh6_lf6ll8hfDhh8DWhZZ{_6Z _dVh >8f _88 l._:L{hf{SWfJ{{f { d+{DlKJld_L8dlJJWLJ_W:JWDd6{ll6 l86DDRhJD_ 6Dl_hZL_DZ:_DZZ {8W  R{ Do{:JX_:f{Zdq{LfD{:dJ{Zd{L6l JZdDJ:WJJZWf6EW8h6D 6:Dh6ZD h6D hdDD_ZZJ_ZZf _Z8 68hf:L6 Z/f:6C8:d{6f7JJdJ{fd6{8ddLhW_LWW6_LW66{WdJDlG66l_6Dll68m8hhD:hWZ}_{Z6_ ZdWW8w J8_ 88l 8KL:hh_:W0Zf{{_f {dfDLk8{L_dfLlWbJLWhJ:WW6:l{6ll h6lDhLDJh_8LhlZ__LZ:_:8J_Z{{:f8 :{8D:_#J:WPf:lLLfL{lf:{DfZLLd6J WfLDW_JJlJJfWDJ8lLhdl:6WlZhLD6h DdhZZ-_JZ__ZZl_88L :R{ W8Z:{6D8dhd8f {<l 8Y :Jf8LLd:LldWLZW{:6LJfWJ_6Jl86_lf6lLJWW6LWDLWlDh6lDhWDJhlDZ8_ d8f l88Dh f8  Wd_{{f6{ fdJJdKLJd_LfdlL8WLJWZ8JWWZ6{D:6 lW6DDKhJDd_hDlh8ZL fZ:_lZZ {^d  8d Do{:Je_:fLlfh{Lfh{:fW{ZdhL6d 6)dDJ{WJJ:WfJlW86:v_6:ll6ZDdh6D:hdDD_CZ  LZf_lZ8 W8h f8W:LjD:6* :d{dfg{6f_{fWL{8dLLhdfLWdZJ{D6JDWdJDl06Jl_6dll hZ{hhD:hW8h_{Zh_ Zl_D86 88_ f8lf_%L:_s::WL6f{{6f {WfDL<dJ6_8ELld8JLWhJ:WZJZl{6:l 6dlDhLDJh Dfhl8h_LZh_:Zl_Z8{ 68 f{8D:{PJ:fxf:lk8dL{8f:{WfZLhd6L:ddJ{WZJJW_JfDJJ8lJ6hl:_{lZh{D6h:DdhDZ?:J88_fZl_88L h8D W8ZW Q6: ud:8{Mf6{_ff_ff8LLdhLfdWLZW{J6W JdWD61l 68lf6ll8hhDfh:DWhZJhDJh_D_8K Z8J _8flZ_68J d8{ D8J:6Dl :H::{Ql::dfLldlL8WLdJ{DWLWZ6{l 6Dld6DDKdJJ lW6{lDh__:83_WZZ {JDZh_D8{_{8{_fZZ48fJ{Lfh{:Zf 8}Z:fddJLdDJqWJ:U{ZdZLd_L{6dZJ{h{Dfh6D hd{8l{6_D{hflDhLDD,V :8W Z{JfZ5 :dxDf_{Jf_{fWlJ dLLhd:LWdZJ6W66fDLJDl{6Jl 6fll68DL_ZD:hWDZ_JZ6_fZdfD8J J8_ fiJ 8Bd:hJ:dL/Zf{{6ff{dd{LMdJJDdfLDd8JLWhJ:WWhZl 66l:6dlZh>Dlh_Zf:LD8_LZh_DZW_88{ 6{8 d8D:r0h:_)f:lP8D8{hf:{Wf8L{d6L ddLDWoJJW_JWWlJ8lL6:DL6WlZh{{:l.6DlQ68D{h6lZ68ZJ8h d8: W8Z8{_h8Y l0P{DfJ{_ff{lWuLLdhL:dWLZW{J6W JWWD6olJ6_lf6ll8_6D:h:DWhZZJ_6Z _dZD:L8J  8f D88:L4h::{h:Z{{f6{ffd{8dcL WJLfdlL8WdJhWfJWDZhdl66lldh{D)h6D_hf{Lh8Z _hZd_WZ8 {8df68d D!V:fK_:dQlf{{LffL6fW{Zd{Ldd LWdDJ/88J_WfJlW86Llh6:lW dD{h6D hWDD_SZJ__J__lZ8 L8_ :8W Zu{:6, :dyDfI{Jf_{ff8{8dLLhd:6{dZJ{W6J WdJDl/6JSf6fll68DJhhDfhWDZdZZ6_ Zd_Z8- J8_ f8l 87L:hz8:WCZf{{ fZ{dfDLEZ_fh{ fd{6fhLfJWlLJZl{660Wd86Yl66hlhhLh8ZD_LZh_:J{D h8D:JDZJ_88J  lf {8h W8_{:dL{WfZL{8ffh38fZLhflL_dfL{dJlh6Dl:6WlZfWJflf6h DL8lf6l_l86_88L hJdDl_{Zl 6Z:_D8:{JfW{_ff{lZ6fJ{df{{WfZ{_f:lZJdWD6NlJ {lf6Dl8hLDhh:DW Z8J_6Z:_dZZ t8f _{f:J88:J0h:fxWf{{{d_{dfdLRdwL:d_LfdlL8W_JhWfJWl{6{l_6 DKhfD4h6D__hDl_vZL_hZ:_88d {86  }_ Dg{:J}_f8alfp{Lfh{:fW{Zl{Ldd LWdDJ{WJJlWfhlZ:6Ll_6:ll6ZD_h68 _ DD_{ZJ_ Zf_ZZ8 LLW :8l ZFJ:6P::dwDd_{Jf {ffD{8dLLhd:J_dZJLW6J:WdJ8lb_JD66flZ68DJhhD8hW8Z_WZ6_fZd_88* 68_ f{_ 8z_:h<d:W1Zf{{6d{{df8LVd L_ddLll8JWWhJdWWJ8l{6:l _dD_h2Dhh_DWhlZm_LZh ZZW L8{  8  d8D:x6W:_KW:l{JfL{_f:{WZWL{d6L dWLDWbJJW_JfWlJ8lJ6hl:6WlZh6D6h DdhD8__JZ__fZl_88L h8:WZ8Z:{B6::-d:Z{!fJ_Jff{lf8LJdhL:dWLZW{J6W JdWD");local n=0;r.XbtpwCjA(function()n=n+1 end)local function e(l,e)if e then return n end;n=l+n;end local l,n,a=t(0,t,e,s,r.uLXhRA_G);local function h()local n,l=r.uLXhRA_G(s,e(1,3),e(5,6)+2);e(2);return(l*256)+n;end;local k=true;local k=0 local function y()local e=n();local n=n();local f=1;local d=(l(n,1,20)*(2^32))+e;local e=l(n,21,31);local n=((-1)^l(n,32));if(e==0)then if(d==k)then return n*0;else e=1;f=0;end;elseif(e==2047)then return(d==0)and(n*(1/0))or(n*(0/0));end;return r.R_UTnbjD(n,e-1023)*(f+(d/(2^52)));end;local g=n;local function p(n)local l;if(not n)then n=g();if(n==0)then return'';end;end;l=r.ytWVRguF(s,e(1,3),e(5,6)+n-1);e(n)local e=""for n=(1+k),#l do e=e..r.ytWVRguF(l,n,n)end return e;end;local k=#r.DfrianiG(c('\49.\48'))~=1 local e=n;local function ne(...)return{...},r.wYdzAGHS('#',...)end local function m()local c={};local s={};local e={};local b={s,c,nil,e};local e=n()local _={}for d=1,e do local l=a();local e;if(l==0)then e=(a()~=#{});elseif(l==1)then local n=y();if k and r._E_BnfIB(r.DfrianiG(n),'.(\48+)$')then n=r.zYLHItsJ(n);end e=n;elseif(l==3)then e=p();end;_[d]=e;end;for c=1,n()do local e=a();if(l(e,1,1)==0)then local t=l(e,2,3);local r=l(e,4,6);local e={h(),h(),nil,nil};if(t==0)then e[f]=h();e[o]=h();elseif(t==#{1})then e[f]=n();elseif(t==u[2])then e[f]=n()-(2^16)elseif(t==u[3])then e[f]=n()-(2^16)e[o]=h();end;if(l(r,1,1)==1)then e[d]=_[e[d]]end if(l(r,2,2)==1)then e[f]=_[e[f]]end if(l(r,3,3)==1)then e[o]=_[e[o]]end s[c]=e;end end;for e=1,n()do c[e-(#{1})]=m();end;b[3]=a();return b;end;local function ee(l,n,e)local d=n;local d=e;return c(r._E_BnfIB(r._E_BnfIB(({r.XbtpwCjA(l)})[2],n),e))end local function k(y,a,c)local function m(...)local h,z,u,ee,le,n,m,j,g,p,s,l;local e=0;while-1<e do if e>2 then if e<5 then if 4~=e then j={};g={...};else p=r.wYdzAGHS('#',...)-1;s={};end else if 2<=e then for n=28,67 do if e~=5 then e=-2;break;end;l=t(7);break;end;else e=-2;end end else if e<=0 then h=t(6,34,1,1,y);z=t(6,68,2,52,y);else if 2>e then u=t(6,74,3,22,y);le=ne ee=0;else n=-41;m=-1;end end end e=e+1;end;for e=0,p do if(e>=u)then j[e-u]=g[e+1];else l[e]=g[e+1];end;end;local e=p-u+1 local e;local t;local function u(...)while true do end end while true do if n<-40 then n=n+42 end e=h[n];t=e[b];if t>38 then if 59<=t then if t>=69 then if t<=73 then if t>70 then if 72>t then local r,_;for t=0,5 do if t>=3 then if t<4 then l[e[d]]=a[e[f]];n=n+1;e=h[n];else if 3<=t then for r=17,70 do if t~=5 then l[e[d]][e[f]]=l[e[o]];n=n+1;e=h[n];break;end;n=e[f];break;end;else n=e[f];end end else if 0<t then if t>=-3 then repeat if t>1 then l[e[d]]=a[e[f]];n=n+1;e=h[n];break;end;r=e[d]l[r](l[r+1])n=n+1;e=h[n];until true;else l[e[d]]=a[e[f]];n=n+1;e=h[n];end else r=e[d];_=l[e[f]];l[r+1]=_;l[r]=_[e[o]];n=n+1;e=h[n];end end end else if t>72 then c[e[f]]=l[e[d]];else local n=e[d]l[n](_(l,n+1,e[f]))end end else if 70>t then for t=0,3 do if 2>t then if-4~=t then repeat if t~=0 then c[e[f]]=l[e[d]];n=n+1;e=h[n];break;end;l[e[d]]=(e[f]~=0);n=n+1;e=h[n];until true;else c[e[f]]=l[e[d]];n=n+1;e=h[n];end else if t~=-1 then for r=19,69 do if 2~=t then if(l[e[d]]~=e[o])then n=n+1;else n=e[f];end;break;end;l[e[d]]=c[e[f]];n=n+1;e=h[n];break;end;else l[e[d]]=c[e[f]];n=n+1;e=h[n];end end end else if(l[e[d]]<=l[e[o]])then n=n+1;else n=e[f];end;end end else if 75>=t then if t>72 then for h=27,92 do if 74~=t then l[e[d]][l[e[f]]]=l[e[o]];break;end;if l[e[d]]then n=n+1;else n=e[f];end;break;end;else l[e[d]][l[e[f]]]=l[e[o]];end else if 77<=t then if t>=74 then repeat if 78~=t then do return end;break;end;local t,_,h,a,o,r;local n=0;while n>-1 do if 4<=n then if 6>n then if n==5 then r=t[_];else o=a[t[h]];end else if n~=5 then repeat if 7~=n then l[r]=o;break;end;n=-2;until true;else l[r]=o;end end else if n<2 then if 1==n then _=d;else t=e;end else if-2<=n then repeat if n<3 then h=f;break;end;a=l;until true;else h=f;end end end n=n+1 end until true;else do return end;end else l[e[d]]={};end end end else if 63<t then if 66>t then if t>62 then for h=18,57 do if 65>t then local e=e[d]l[e]=l[e](l[e+1])break;end;if(l[e[d]]<=l[e[o]])then n=n+1;else n=e[f];end;break;end;else if(l[e[d]]<=l[e[o]])then n=n+1;else n=e[f];end;end else if 67>t then if(l[e[d]]==e[o])then n=n+1;else n=e[f];end;else if t==68 then if(l[e[d]]~=e[o])then n=n+1;else n=e[f];end;else l[e[d]]();end end end else if 61>t then if t>=56 then repeat if t~=59 then local t,a;for r=0,3 do if 2>r then if r~=-1 then repeat if 1>r then t=e[d];a=l[e[f]];l[t+1]=a;l[t]=a[e[o]];n=n+1;e=h[n];break;end;l(e[d],e[f]);n=n+1;e=h[n];until true;else l(e[d],e[f]);n=n+1;e=h[n];end else if r~=1 then repeat if 3~=r then t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];break;end;l[e[d]]=l[e[f]][e[o]];until true;else l[e[d]]=l[e[f]][e[o]];end end end break;end;l[e[d]]=l[e[f]];until true;else local t,a;for r=0,3 do if 2>r then if r~=-1 then repeat if 1>r then t=e[d];a=l[e[f]];l[t+1]=a;l[t]=a[e[o]];n=n+1;e=h[n];break;end;l(e[d],e[f]);n=n+1;e=h[n];until true;else l(e[d],e[f]);n=n+1;e=h[n];end else if r~=1 then repeat if 3~=r then t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];break;end;l[e[d]]=l[e[f]][e[o]];until true;else l[e[d]]=l[e[f]][e[o]];end end end end else if 62>t then l[e[d]]=a[e[f]];else if t>=59 then for n=27,69 do if t<63 then local n=e[d]l[n](_(l,n+1,e[f]))break;end;local d=e[d]local f={l[d](l[d+1])};local n=0;for e=d,e[o]do n=n+1;l[e]=f[n];end break;end;else local n=e[d]l[n](_(l,n+1,e[f]))end end end end end else if 48<t then if 53<t then if t>=56 then if 57<=t then if 53<=t then for r=14,55 do if t<58 then local t,r;t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];l[e[d]]=l[e[f]];n=n+1;e=h[n];t=e[d]l[t](_(l,t+1,e[f]))n=n+1;e=h[n];do return end;break;end;l[e[d]]=c[e[f]];break;end;else l[e[d]]=c[e[f]];end else if not l[e[d]]then n=n+1;else n=e[f];end;end else if 55~=t then local e=e[d]l[e](l[e+1])else if l[e[d]]then n=n+1;else n=e[f];end;end end else if 51>t then if t~=50 then local u=z[e[f]];local _;local t={};_=r.XPTBCQFr({},{__index=function(n,e)local e=t[e];return e[1][e[2]];end,__newindex=function(l,e,n)local e=t[e]e[1][e[2]]=n;end;});for d=1,e[o]do n=n+1;local e=h[n];if e[b]==78 then t[d-1]={l,e[f]};else t[d-1]={a,e[f]};end;s[#s+1]=t;end;l[e[d]]=k(u,_,c);else l[e[d]]={};end else if t<=51 then local e=e[d]l[e]=l[e](l[e+1])else if 51<t then for h=47,67 do if t>52 then n=e[f];break;end;local n=e[d]l[n]=l[n](_(l,n+1,e[f]))break;end;else n=e[f];end end end end else if t<44 then if 41>t then if t<40 then l[e[d]]();else do return l[e[d]]end end else if t>=42 then if t<43 then l[e[d]][l[e[f]]]=l[e[o]];else local t,c;for r=0,5 do if r>=3 then if 4>r then l(e[d],e[f]);n=n+1;e=h[n];else if 0<=r then for o=22,74 do if 5~=r then t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];break;end;if l[e[d]]then n=n+1;else n=e[f];end;break;end;else if l[e[d]]then n=n+1;else n=e[f];end;end end else if r<1 then l[e[d]]=a[e[f]];n=n+1;e=h[n];else if r>-2 then repeat if 2~=r then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];break;end;t=e[d];c=l[e[f]];l[t+1]=c;l[t]=c[e[o]];n=n+1;e=h[n];until true;else l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];end end end end end else local t,r;for _=0,1 do if 0==_ then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];else t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];end end end end else if t<46 then if 40<=t then for h=12,92 do if t~=45 then a[e[f]]=l[e[d]];break;end;if(l[e[d]]~=e[o])then n=n+1;else n=e[f];end;break;end;else a[e[f]]=l[e[d]];end else if t>46 then if t~=47 then local n=e[d]l[n]=l[n](_(l,n+1,e[f]))else do return l[e[d]]end end else l[e[d]]=l[e[f]][e[o]];end end end end end else if t>18 then if 29<=t then if 34>t then if t>30 then if 31>=t then local t,r,_,o,h;local n=0;while n>-1 do if 3>n then if 0<n then if n>-3 then for e=43,60 do if 1~=n then _=f;break;end;r=d;break;end;else _=f;end else t=e;end else if 5>n then if 2<=n then repeat if n>3 then h=t[r];break;end;o=t[_];until true;else h=t[r];end else if 3<=n then repeat if 5<n then n=-2;break;end;l(h,o);until true;else l(h,o);end end end n=n+1 end else if 30<=t then repeat if t>32 then local e=e[d]l[e]=l[e]()break;end;l[e[d]]=c[e[f]];until true;else local e=e[d]l[e]=l[e]()end end else if 26~=t then repeat if 30~=t then local h=e[d];local t=e[o];local d=h+2 local h={l[h](l[h+1],l[d])};for e=1,t do l[d+e]=h[e];end;local h=h[1]if h then l[d]=h n=e[f];else n=n+1;end;break;end;local d=e[d];local n=l[e[f]];l[d+1]=n;l[d]=n[e[o]];until true;else local d=e[d];local n=l[e[f]];l[d+1]=n;l[d]=n[e[o]];end end else if 35>=t then if 31~=t then repeat if t>34 then local o;for t=0,6 do if t>=3 then if t>4 then if 5<t then l[e[d]]=a[e[f]];else o=e[d]l[o](_(l,o+1,e[f]))n=n+1;e=h[n];end else if 4>t then l(e[d],e[f]);n=n+1;e=h[n];else l(e[d],e[f]);n=n+1;e=h[n];end end else if 1>t then l[e[d]]=a[e[f]];n=n+1;e=h[n];else if 0<=t then repeat if t<2 then l(e[d],e[f]);n=n+1;e=h[n];break;end;l(e[d],e[f]);n=n+1;e=h[n];until true;else l(e[d],e[f]);n=n+1;e=h[n];end end end end break;end;local e=e[d]l[e]=l[e]()until true;else local e=e[d]l[e]=l[e]()end else if t>=37 then if t>=34 then for r=12,93 do if t<38 then local t,r;for a=0,6 do if a<3 then if a<1 then t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];else if 0<a then repeat if 2~=a then l(e[d],e[f]);n=n+1;e=h[n];break;end;t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];until true;else t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];end end else if 5<=a then if a==6 then t=e[d]l[t]=l[t](_(l,t+1,e[f]))else l(e[d],e[f]);n=n+1;e=h[n];end else if a>2 then for _=12,59 do if 4>a then l[e[d]]=c[e[f]];n=n+1;e=h[n];break;end;t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];break;end;else t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];end end end end break;end;l[e[d]][e[f]]=l[e[o]];break;end;else l[e[d]][e[f]]=l[e[o]];end else local f=e[f];local n=l[f]for e=f+1,e[o]do n=n..l[e];end;l[e[d]]=n;end end end else if 24>t then if t>20 then if t<=21 then local r,a,_;for t=0,6 do if 3>t then if t>0 then if-3<=t then for o=25,65 do if 1<t then r=e[d]l[r]=l[r](l[r+1])n=n+1;e=h[n];break;end;l(e[d],e[f]);n=n+1;e=h[n];break;end;else r=e[d]l[r]=l[r](l[r+1])n=n+1;e=h[n];end else l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];end else if t<=4 then if t~=-1 then repeat if t~=3 then l[e[d]]=l[e[f]];n=n+1;e=h[n];break;end;l(e[d],e[f]);n=n+1;e=h[n];until true;else l[e[d]]=l[e[f]];n=n+1;e=h[n];end else if t~=5 then l[e[d]][e[f]]=l[e[o]];else a=e[f];_=l[a]for e=a+1,e[o]do _=_..l[e];end;l[e[d]]=_;n=n+1;e=h[n];end end end end else if t>20 then for n=42,65 do if t~=23 then l[e[d]]=a[e[f]];break;end;l[e[d]][e[f]]=l[e[o]];break;end;else l[e[d]][e[f]]=l[e[o]];end end else if t~=17 then repeat if 19~=t then for t=0,1 do if t>=-4 then repeat if 1~=t then l[e[d]]=(e[f]~=0);n=n+1;e=h[n];break;end;l[e[d]]={};until true;else l[e[d]]={};end end break;end;a[e[f]]=l[e[d]];until true;else for t=0,1 do if t>=-4 then repeat if 1~=t then l[e[d]]=(e[f]~=0);n=n+1;e=h[n];break;end;l[e[d]]={};until true;else l[e[d]]={};end end end end else if t>25 then if t<27 then local t;l[e[d]]=c[e[f]];n=n+1;e=h[n];l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];l(e[d],e[f]);n=n+1;e=h[n];t=e[d]l[t]=l[t](l[t+1])n=n+1;e=h[n];l[e[d]][e[f]]=e[o];n=n+1;e=h[n];l[e[d]][e[f]]=e[o];n=n+1;e=h[n];l[e[d]]=a[e[f]];else if 27==t then local s,b,u,r,c,t,o;l(e[d],e[f]);n=n+1;e=h[n];t=0;while t>-1 do if 3<=t then if 5<=t then if 1<t then repeat if 6>t then l(c,r);break;end;t=-2;until true;else l(c,r);end else if t==4 then c=s[b];else r=s[u];end end else if t<=0 then s=e;else if 2~=t then b=d;else u=f;end end end t=t+1 end n=n+1;e=h[n];l(e[d],e[f]);n=n+1;e=h[n];o=e[d]l[o](_(l,o+1,e[f]))n=n+1;e=h[n];l[e[d]]=(e[f]~=0);n=n+1;e=h[n];a[e[f]]=l[e[d]];n=n+1;e=h[n];do return end;else local t,r;l[e[d]]=l[e[f]];n=n+1;e=h[n];t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];l[e[d]]=a[e[f]];n=n+1;e=h[n];l[e[d]]=c[e[f]];n=n+1;e=h[n];t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];l(e[d],e[f]);n=n+1;e=h[n];t=e[d]l[t]=l[t](_(l,t+1,e[f]))end end else if t~=25 then local u=z[e[f]];local _;local t={};_=r.XPTBCQFr({},{__index=function(n,e)local e=t[e];return e[1][e[2]];end,__newindex=function(l,e,n)local e=t[e]e[1][e[2]]=n;end;});for d=1,e[o]do n=n+1;local e=h[n];if e[b]==78 then t[d-1]={l,e[f]};else t[d-1]={a,e[f]};end;s[#s+1]=t;end;l[e[d]]=k(u,_,c);else local n=e[d];local d=l[e[f]];l[n+1]=d;l[n]=d[e[o]];end end end end else if t>8 then if 14<=t then if t>15 then if 16<t then if 16<t then repeat if t~=18 then local t,_,r;l[e[d]]=(e[f]~=0);n=n+1;e=h[n];a[e[f]]=l[e[d]];n=n+1;e=h[n];l[e[d]]=c[e[f]];n=n+1;e=h[n];l[e[d]]=a[e[f]];n=n+1;e=h[n];t=e[d]_={l[t](l[t+1])};r=0;for e=t,e[o]do r=r+1;l[e]=_[r];end n=n+1;e=h[n];n=e[f];break;end;if not l[e[d]]then n=n+1;else n=e[f];end;until true;else if not l[e[d]]then n=n+1;else n=e[f];end;end else l[e[d]]=(e[f]~=0);end else if 10<=t then for h=40,78 do if t~=15 then l[e[d]][e[f]]=e[o];break;end;if(l[e[d]]==e[o])then n=n+1;else n=e[f];end;break;end;else l[e[d]][e[f]]=e[o];end end else if t<11 then if 5<t then for r=39,85 do if 10>t then c[e[f]]=l[e[d]];break;end;local t,r;t=e[d]l[t]=l[t](_(l,t+1,e[f]))n=n+1;e=h[n];l[e[d]][l[e[f]]]=l[e[o]];n=n+1;e=h[n];t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];t=e[d]l[t](l[t+1])n=n+1;e=h[n];l[e[d]][e[f]]=l[e[o]];n=n+1;e=h[n];do return end;break;end;else c[e[f]]=l[e[d]];end else if t<12 then local t,r;for c=0,6 do if 2<c then if 5>c then if c>-1 then repeat if 4>c then l[e[d]]=a[e[f]];n=n+1;e=h[n];break;end;t=e[d]l[t](_(l,t+1,e[f]))n=n+1;e=h[n];until true;else l[e[d]]=a[e[f]];n=n+1;e=h[n];end else if c~=3 then repeat if 6>c then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];break;end;t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];until true;else t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];end end else if 0>=c then t=e[d]l[t]=l[t]()n=n+1;e=h[n];else if-3<c then repeat if 2~=c then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];break;end;t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];until true;else t=e[d];r=l[e[f]];l[t+1]=r;l[t]=r[e[o]];n=n+1;e=h[n];end end end end else if t>12 then do return end;else n=e[f];end end end end else if 3>=t then if 1<t then if 0~=t then for n=25,56 do if 3>t then l(e[d],e[f]);break;end;local d=e[d]local f={l[d](l[d+1])};local n=0;for e=d,e[o]do n=n+1;l[e]=f[n];end break;end;else l(e[d],e[f]);end else if t>=-2 then repeat if 1~=t then local e=e[d]l[e](l[e+1])break;end;local d=e[d];local t=e[o];local h=d+2 local d={l[d](l[d+1],l[h])};for e=1,t do l[h+e]=d[e];end;local d=d[1]if d then l[h]=d n=e[f];else n=n+1;end;until true;else local e=e[d]l[e](l[e+1])end end else if 5<t then if 6<t then if t>=4 then repeat if t<8 then local a,c,s,h,_,r,t;local n=0;while n>-1 do if n>=3 then if n<5 then if 1<=n then for e=15,94 do if 4>n then r=h[a];break;end;t=l[_];for e=1+_,h[s]do t=t..l[e];end;break;end;else r=h[a];end else if 5==n then l[r]=t;else n=-2;end end else if 0>=n then a=d;c=f;s=o;else if n>-2 then for l=24,73 do if 1<n then _=h[c];break;end;h=e;break;end;else h=e;end end end n=n+1 end break;end;l[e[d]][e[f]]=e[o];until true;else l[e[d]][e[f]]=e[o];end else l[e[d]]=l[e[f]][e[o]];end else if t>=3 then for r=48,77 do if t~=4 then local t,a;for r=0,6 do if r>=3 then if 4<r then if 3~=r then for o=30,82 do if r~=6 then l[e[d]]=l[e[f]];n=n+1;e=h[n];break;end;t=e[d]l[t](_(l,t+1,e[f]))break;end;else t=e[d]l[t](_(l,t+1,e[f]))end else if r~=2 then for _=30,73 do if r<4 then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];break;end;t=e[d];a=l[e[f]];l[t+1]=a;l[t]=a[e[o]];n=n+1;e=h[n];break;end;else l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];end end else if r>0 then if r>=0 then repeat if r~=1 then t=e[d]l[t]=l[t]()n=n+1;e=h[n];break;end;l[e[d]]=l[e[f]];n=n+1;e=h[n];until true;else l[e[d]]=l[e[f]];n=n+1;e=h[n];end else t=e[d]l[t](_(l,t+1,e[f]))n=n+1;e=h[n];end end end break;end;l[e[d]]=(e[f]~=0);break;end;else local t,a;for r=0,6 do if r>=3 then if 4<r then if 3~=r then for o=30,82 do if r~=6 then l[e[d]]=l[e[f]];n=n+1;e=h[n];break;end;t=e[d]l[t](_(l,t+1,e[f]))break;end;else t=e[d]l[t](_(l,t+1,e[f]))end else if r~=2 then for _=30,73 do if r<4 then l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];break;end;t=e[d];a=l[e[f]];l[t+1]=a;l[t]=a[e[o]];n=n+1;e=h[n];break;end;else l[e[d]]=l[e[f]][e[o]];n=n+1;e=h[n];end end else if r>0 then if r>=0 then repeat if r~=1 then t=e[d]l[t]=l[t]()n=n+1;e=h[n];break;end;l[e[d]]=l[e[f]];n=n+1;e=h[n];until true;else l[e[d]]=l[e[f]];n=n+1;e=h[n];end else t=e[d]l[t](_(l,t+1,e[f]))n=n+1;e=h[n];end end end end end end end end end n=1+n;end;end;return m end;local f=0xff;local r={};local t=(1);local d='';(function(n)local l=n local h=0x00 local e=0x00 l={(function(o)if h>0x21 then return o end h=h+1 e=(e+0x1202-o)%0x2a return(e%0x03==0x0 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xd0);r[t]=de();t=t+f;end return true end)'njfFb'and l[0x1](0x21f+o))or(e%0x03==0x2 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xf9);end return true end)'nRSrO'and l[0x2](o+0xca))or(e%0x03==0x1 and(function(l)if not n[l]then e=e+0x01 n[l]=(0x2c);d={d..'\58 a',d};r[t]=m();t=t+(1);d[1]='\58'..d[1];f[2]=0xff;end return true end)'yEmzs'and l[0x3](o+0x2de))or o end),(function(d)if h>0x23 then return d end h=h+1 e=(e+0xec3-d)%0x21 return(e%0x03==0x2 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xb8);end return true end)'PykPg'and l[0x3](0x17c+d))or(e%0x03==0x1 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xd7);end return true end)'YwvtU'and l[0x1](d+0x323))or(e%0x03==0x0 and(function(l)if not n[l]then e=e+0x01 n[l]=(0x41);end return true end)'DSKsW'and l[0x2](d+0x3af))or d end),(function(o)if h>0x21 then return o end h=h+1 e=(e+0xa62-o)%0x32 return(e%0x03==0x0 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xd3);d='\37';f={function()f()end};d=d..'\100\43';end return true end)'GfGlY'and l[0x1](0x3c7+o))or(e%0x03==0x2 and(function(l)if not n[l]then e=e+0x01 n[l]=(0xbe);end return true end)'PuOcY'and l[0x2](o+0x1e8))or(e%0x03==0x1 and(function(l)if not n[l]then e=e+0x01 n[l]=(0x72);f[2]=(f[2]*(ee(function()r()end,_(d))-ee(f[1],_(d))))+1;r[t]={};f=f[2];t=t+f;end return true end)'oEMWy'and l[0x3](o+0xc8))or o end)}l[0x3](0xb4d)end){};local e=k(_(r));return e(...);end return m((function()local n={}local e=0x01;local l;if r.FbbpOMHb then l=r.FbbpOMHb(m)else l=''end if r._E_BnfIB(l,r.eknYutUx)then e=e+0;else e=e+1;end n[e]=0x02;n[n[e]+0x01]=0x03;return n;end)(),...)end)((function(n,e,l,d,f,h)local h;if 4>n then if 1<n then if 0<n then repeat if 2<n then do return e(1),e(4,f,d,l,e),e(5,f,d,l)end;break;end;do return 16777216,65536,256 end;until true;else do return e(1),e(4,f,d,l,e),e(5,f,d,l)end;end else if n>-4 then for h=42,82 do if n~=0 then do return function(l,e,n)if n then local e=(l/2^(e-1))%2^((n-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(l%(e+e)>=e)and 1 or 0;end;end;end;break;end;do return e(1),e(4,f,d,l,e),e(5,f,d,l)end;break;end;else do return function(l,e,n)if n then local e=(l/2^(e-1))%2^((n-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(l%(e+e)>=e)and 1 or 0;end;end;end;end end else if 6<=n then if 6<n then if 6<=n then for e=26,76 do if 8~=n then do return setmetatable({},{['__\99\97\108\108']=function(e,l,d,f,n)if n then return e[n]elseif f then return e else e[l]=d end end})end break;end;do return l(n,nil,l);end break;end;else do return setmetatable({},{['__\99\97\108\108']=function(e,l,f,d,n)if n then return e[n]elseif d then return e else e[l]=f end end})end end else do return f[l]end;end else if n==5 then local n=d;do return function()local e=e(l,n(n,n),n(n,n));n(1);return e;end;end;else local n=d;local f,h,d=f(2);do return function()local e,l,o,t=e(l,n(n,n),n(n,n)+3);n(4);return(t*f)+(o*h)+(l*d)+e;end;end;end end end end),...)
end

LocalModules.R15Dojo = function()
    ([[This file was protected with MoonSec V3]]):gsub('.+', (function(a) _LdcjDm_mKqIX = a; end)); return(function(f,...)local _;local l;local t;local b;local r;local o;local e=24915;local n=0;local d={};while n<950 do n=n+1;while n<0x2fa and e%0x4c22<0x2611 do n=n+1 e=(e*321)%15331 local h=n+e if(e%0x2a8c)>0x1546 then e=(e+0x13d)%0x9a8a while n<0x3ab and e%0x3092<0x1849 do n=n+1 e=(e+402)%6839 local t=n+e if(e%0x3396)>=0x19cb then e=(e-0x288)%0x35b1 local e=37493 if not d[e]then d[e]=0x1 l=getfenv and getfenv();end elseif e%2~=0 then e=(e*0xfe)%0x77cf local e=65959 if not d[e]then d[e]=0x1 end else e=(e-0xee)%0x4679 n=n+1 local e=25952 if not d[e]then d[e]=0x1 l=(not l)and _ENV or l;end end end elseif e%2~=0 then e=(e*0x328)%0x2882 while n<0x200 and e%0x1356<0x9ab do n=n+1 e=(e-261)%23635 local l=n+e if(e%0x4838)<0x241c then e=(e-0x1a1)%0x3b60 local e=56552 if not d[e]then d[e]=0x1 b={};end elseif e%2~=0 then e=(e+0x1c5)%0x4a38 local e=10629 if not d[e]then d[e]=0x1 o=string;end else e=(e+0x12a)%0x43ed n=n+1 local e=67933 if not d[e]then d[e]=0x1 end end end else e=(e*0x359)%0xa46e n=n+1 while n<0x213 and e%0x3f4e<0x1fa7 do n=n+1 e=(e*635)%12793 local h=n+e if(e%0x427c)>0x213e then e=(e*0x387)%0x83b5 local e=37892 if not d[e]then d[e]=0x1 _=tonumber;end elseif e%2~=0 then e=(e*0x3cb)%0x4063 local e=63425 if not d[e]then d[e]=0x1 t=function(t)local e=0x01 local function d(n)e=e+n return t:sub(e-n,e-0x01)end while true do local n=d(0x01)if(n=="\5")then break end local e=o.byte(d(0x01))local e=d(e)if n=="\2"then e=b.bMciCBdQ(e)elseif n=="\3"then e=e~="\0"elseif n=="\6"then l[e]=function(n,e)return f(8,nil,f,e,n)end elseif n=="\4"then e=l[e]elseif n=="\0"then e=l[e][d(o.byte(d(0x01)))];end local n=d(0x08)b[n]=e end end end else e=(e-0x175)%0x1b91 n=n+1 local e=83875 if not d[e]then d[e]=0x1 r="\4\8\116\111\110\117\109\98\101\114\98\77\99\105\67\66\100\81\0\6\115\116\114\105\110\103\4\99\104\97\114\102\90\111\75\122\89\69\71\0\6\115\116\114\105\110\103\3\115\117\98\99\117\101\71\113\79\71\85\0\6\115\116\114\105\110\103\4\98\121\116\101\73\89\115\88\113\116\80\103\0\5\116\97\98\108\101\6\99\111\110\99\97\116\79\98\106\69\119\65\90\73\0\5\116\97\98\108\101\6\105\110\115\101\114\116\107\82\70\68\76\116\118\100\5";end end end end end e=(e*133)%31161 end t(r);local e={};for n=0x0,0xff do local d=b.fZoKzYEG(n);e[n]=d;e[d]=n;end local function h(n)return e[n];end local o=(function(r,t)local o,d=0x01,0x10 local n={{},{},{}}local l=-0x01 local e=0x01 local f=r while true do n[0x03][b.cueGqOGU(t,e,(function()e=o+e return e-0x01 end)())]=(function()l=l+0x01 return l end)()if l==(0x0f)then l=""d=0x000 break end end local l=#t while e<l+0x01 do n[0x02][d]=b.cueGqOGU(t,e,(function()e=o+e return e-0x01 end)())d=d+0x01 if d%0x02==0x00 then d=0x00 b.kRFDLtvd(n[0x01],(h((((n[0x03][n[0x02][0x00]]or 0x00)*0x10)+(n[0x03][n[0x02][0x01]]or 0x00)+f)%0x100)));f=r+f;end end return b.ObjEwAZI(n[0x01])end);t(o(252,"7V.U?v_nOwHrDpg>Kw"));t(o(111,"S0rfz+RijEX<4hHLE0rjrR<jzi4LR+HL0hdH<_fE4hRjHiiRHXjjrRXk+iiXq4xjj40<<izjhfRRhHERLRXEfhXRLRj<ji0XXrfj4Lff4sj+LHjX0zEfr<izm<,EE<rX<rzjhrY0LXiLrfXffE4RfH4h+HHEi4fh4rHXiLiELHXrri++zhhRRj(4E+L<<Lzj40RLLEjEnHzrh<hf+RLRjtxEXEri4<zEh<iRxgRL^;<Hzf4LzzH0E<<jzhzXhRR<Lhj40zXXfz44R7LXRrHhXh0i<hHRi4i4LXj4ri<0HfHfRhuZjr0+XHr44zznHLRr0qX+zzRsLfLfih0-Err+<HrhHf+0HQihr<<Hr+idYrLHE00EXLzR4hR8h0jfHXELQXXzHLjrj#pfE<r+<z+R4X+zIHj<rr<++V<+L<E,jXFL<ffjRR+jHLjf0zXjz0Xjz4<LR4JHihri+z"));local e=(-2912+(function()local l,e=0,1;(function(n,d,e)n(n(n and e,e,d),e(e,e,n),n(d,n and e,d))end)(function(t,d,n)if l>434 then return n end l=l+1 e=(e*343)%35835 if(e%362)<181 then e=(e-1022)%18623 return n(n(n,n and d,d),t(t,t,t),n(n and d,n,d))else return d end return n end,function(d,t,n)if l>212 then return d end l=l+1 e=(e*191)%22185 if(e%1806)<=903 then e=(e*901)%31164 return d(n(t,t,d and n),d(d,n,d),d(n and n,t,n))else return n end return n end,function(t,n,d)if l>353 then return d end l=l+1 e=(e-61)%48975 if(e%1084)>542 then return n else return d(n(n,n,n),t(n,n,d),n(d,n and t,n))end return d(d(n,d,d),d(n,d,t),n(t and t,d,d))end)return e;end)())local j=b.InKIUrtJ or b.X_JhJgky;local te=(getfenv)or(function()return _ENV end);local r=4;local t=3;local c=1;local l=2;local function ee(u,...)local h=o(e,"4MV&_j%L{F:QZbYd{Z(%{FxZ{dVQFjM{FQ%QMvF&MjLbMVF&MV{FVb:YV{QXVZQQM&QL&jQ{&ZZ{MYb_jLb{YFL:YdLVdjQQ%&bdL&Yj%:dYLV8Vj_d:LbtM{&:V_Z:{VQ:Y{jMZ:;VbjbV%:Z&V:YYZZ%&&Z{d{ZQjybuj{ZZ_bYMjjbLM%dg%jd&%::jjjd:Lbdd%LdZLbQbL%b%V%QdVZ:d&VVLF:&&Fd&_QLVZQY&%Q_sb{j9{FVM{F:MLFbMZ:_V%:LdL{Ldb{O &YjjjdALVdZjF+jL:1Q%ZMjLR7VVbQ_&&Q%&FV&:OVd::Z{jVZYjMb_F:_FZQ_YZ{_FbbYZL%dVLjd{ZQ%:YVLbYZLZv.M7FYM%FFMZYQFM#{{FMLLYMbFj&RFdVd_9bF_%ZF_ZZdjjbjj{bQjdYM%_YLLZdMLTd&L%d:LZdd{VMLFb8Q{YMMFFMLF:MbZ%VY:%VF:Z&jQV&%Q{&YQY_jbb_LZ:_bb%j&bLjFY;L{YV%jY{LVYYLVd_LLJ{Lbec{&rL{F)Z{dV_:QM{FQMY:jV_:LV:Qd%%Q&&LQF_VQd_VZj%{bM_YbVj_b{j:Yj%.E&%YYF%bYdL&dj{MdQ{_&%{_mF{:1YFTM_F%MQFZMdbVVj:{VQ:d&MQ_&LQ:%bZH_&Z%_FZZ_dbVjjYVjQYM%MY%%LY:%bd#{%d%LZdZ{1zV{%c{:QMFFMMLFLMQFbVV:&_%QdVZQV&VQ{&{ZV&YZLLFZL_dZbjCb&jLbFjbbd%VMj%{YQ%Yd&L_dLL:dbF&q&{FfFFMrdF&MjF{VQFYVM:_V{::VbQT&jQ%&FQZ_VZV_jZ{_QbVjMb_jL_YQYj&ZYY%%bYZ%ddVYZjFY_LV{_9_{Lk:{bMoF&d%b{MZ:%VV:jV{Qb%VQM&_QL&QQb_xZ&%%bj_ZZdjVbjj{bbjYd&LZYL%QYbL&d&L%dFLZoL{V5j{{-b{YMVF_ML:YMb:hV&:%VF:ZVdQV__Q{&QQY_VZ__{Z:_bYbj&b%jFbbjdYV%jY{%QYYLMUrLLd:Lb;A{L-%{FiZY&{MH_{_FQV{:MV_:LLdMQFjV_:QVV:ZVd:LVF_:ZQ_YbLj_bLj:VbZMjjZQjLYwYdLFdjL{dQZML<dVLjYdL.N_M&:VMFFZMdYZ{:M:F%ZY{2M:Fbb:{ddML{Z%jMZZ_dbVF:_Fbr_LbMj_ZZ_Y%bd&L&d%LF%:Y_LF{jfZ{Q YFM%Vd{{L;VVW:QV%:FVZd{:DV{:ZMZ:ZV_:FZLjVZbjcb&F{&:Qd_:bV_%ZQj%%YddL_dLL:_dYjL_dQLVdYL_PjjbdF{FAV{btFVLZMVbQa&&Z{j_QZ&dZV_dZ{_QZYLMY{jLb:jbY^%&YY%FdYLYdVL%d{LZdY{Mg_{LMV{bMJF&M{FFMYFdjV:ZV{:QVYQ:&_Qb&:Ybj=Z&_%ZFj{Zdjjbjj{d{jYYV%_YL%:YbLkM&{QdFLbdd{&>jF&0QFYVYF_MLF:VM:>V_:%VFQ_VdQ&&jQF&QQY_MY_jFZ:_db!j&b%%7bZLdYZ%jY:%QdrLMdFLL<=QVI<{L3%{F+ZF!MVF{M{FQ_{:MV_:LV::b&oQ&&%Y&&ZQd_VZ%_{ZQ_YbM{_bLj:bb%MY&%%YF%Z!QLVdLL{ddLYrV{_VL:ZHbFVM&F%MFFYMdZV_Y:{Vb:Y&&Q_&ZQ:_&dj_&Z:_FZb_db&jjbFjQbYFMY_%LY:%YdqL&d%LFgdLd+_{jhZ{QpdFMM_F{M:FbV>:_V%:FVZQM&VQj&{ZY&YZM__ZL_YZbjJb&:b&:Zjj&%VdS%{YQ%Y&VYV%kYLjYd_%ZdjLLbjL&FVMQF{MQFY%bM&F%M:FVM_&&Z&&FQZ&dGYQ_VF:dgdQd&bZ_&QbM_FbVj_%Fd{%ddVLj_ZY_%QY%j_d%Lbd%{_dZ{j/LMZ:LVV:jV{d&:&MYFjVj:FV%:_Z%Yy%VYj%{YQ%Y&MM:jYd%%_YL%:&&bF%Mb:&dYjLMdjLFZQL&dLLbd{%%sp%zgZ{_MFFZ:Z&&QV&jQ{{QV::V&b_LbV_bbij&MdZL_db&_&b&_Qb>YYL%d_LLd:d2L,Y_LbdL.ZFVMVFjM{0F{&M{V%:LV:Q%&cQ&&%d:::V{:dV%QZ&_Qb&dj_bQj:bb%qjLZLjZbLYd{ndjL{dQZM%FYjLFYQLIJ_L{G{j:/c{&nL{F:{&_:Y&MQ_L:VVFY&V:_VFQb&MZMbjY_F:jre%QbL&_FVF%bdQL&d%LF&bY&%Zd:LQdd%MtMLFdZLYFb_::&V%:FVZZL&VQj&{QQ&YZM__YL%ZZbjpb&j%bF%bbd%{3V%{YQ%YdFL_d{L:dY{;SLFd7F{ZhdF:MjFFMQFY&F:_VL::VbQ8&&Q%jFbY&dZV_jZ{_QbYjMd_{+b:jbYI%&Y%%:YZ%dVJLjd{LQ3f{MK%{LV:Q%M^F_M%FFMZ:LVVQL&Y:Q&MQM&:QL&:Qb_xYF_%Z:_ZbVjVbLj{YMFLYM%jYLL{YbLMd&L%dF{nM{{V1j{{MF{YMVF_MQQ&Mb:)V&QjVF:bVdQV_&Q{&QQY_VZ__LZ:jdbjj&b{jFY%jdYV%jw{%bYYL&d_LFd:{FDtFjh{{Fzd{dVrFjM{FQMYQVV_:FV::d&(Qj&%QFj_Qd_jZj_FZQ_YbM%_d&j:bd%zYj%%YZ%Z0dL%djLQdQLd1M{{RL{:MLFyM{F%MQFZMd:VVjZYVQQM&MQF&LQZ&bZ*_:Z%_ZZZjMbVjjb{jQd_%MYL%LYZ%bdHL&V%LZdZ{V2V{{w{F{ YFMM%FLMbFbVV:&V%:F_ZZ:&VQ{&{QY&YZ:__ZLjbZbj&b&j{bFjbbd%Vd{%{YY%Yd&L_dLL:VbFgf&{FKFFM)d:_MjF{MZFYV_:_VF::VbQBj&Z&&FQd&dZj_jbQ_QY-%Qb_jZb:%_Yw%&Y%%Fdm%ddjLjdbLQdd{MM%:M/:F7M8:VM%FFMZQd&V:jVQ:Q&MQM&dQL_.dV_(ZL_%ZF_ZbujVb%j{bQ{{YM%_YL%ZYbLsd&L%V_LZxV{VHL{{2Z{YMM:VMLF:Mb:MV&:%VF:bVdQV&jQY&QQY_MZ_j&Z:_bbT:L&dZ%_M:djMb{jMbdjLY %VLLdYLb,A{&L:Y:Ldd:MjV_b:F/_%dbQ&{F%F:b&_Q&&%QFQ&V):Q&F_Qd_::%BM%ZZ{VZMFdY&%dYF%ZYdQQ%{Z{%LbdL:YbLjdMhb:VM&F%MFFZ&L:VVj:{VQ:Y&MQ_&bd&&bZ6_&bL_FZb_dbVjjbZL_bY%MY_L{Y:%YdkL&fYLFdZLdNV{jv{{QVYQ&M_FLM:FbVk:FV%:d%j:d&VQj_FQQ&dZM__ZL_YY%jvb&j%Y:jZY+%VYj{5YQ%YdML_dLL:db:8Vj{%nF{Z0dFVM%F{VFQdVM:FVLQLVbQM&&Q%&FZvj{ZV_jZ{j{ZYjVb_jLdVjbY+%&Y%%FYZ%dVV{jd{LQdY{V2_{:=:FdMjF&M%FFMYFdVV:j_{ZbVYQM&_QL&:ZM_KZ&%%ZF_ZZdj&bjjFbQ%Vd:%_YL%:YbL7d_L%dF{:dd{VCj{FnQ{YMMF_MLF:Mb:MV&:%VF:Z&&QV&jQ{{Y&VQr&__Lb&_bb/j&b%LMbZjdYV%jY{%QYYLLVbLLd:Lbq{{&(L{FpZ{dM%:YM{FQMY:FV_:{V::b_{Q&&%QF&ZQd_VZj%{d__YbMj_bLj:bY%PY&FMYF%ZYdL_djLFdQLYT:{_eL{:2bFSM&F%MFZbMd:VVj:{VQ:Y&MQ__jQ:&bZU__Z%_FZZ_dbVjjb{");local n=0;b.fhOvEgjB(function()n=n+1 end)local function e(d,e)if e then return n end;n=d+n;end local d,n,a=f(0,f,e,h,b.IYsXqtPg);local function o()local n,d=b.IYsXqtPg(h,e(1,3),e(5,6)+2);e(2);return(d*256)+n;end;local s=true;local s=0 local function k()local e=n();local n=n();local t=1;local l=(d(n,1,20)*(2^32))+e;local e=d(n,21,31);local n=((-1)^d(n,32));if(e==0)then if(l==s)then return n*0;else e=1;t=0;end;elseif(e==2047)then return(l==0)and(n*(1/0))or(n*(0/0));end;return b.ExpXunma(n,e-1023)*(t+(l/(2^52)));end;local p=n;local function z(n)local d;if(not n)then n=p();if(n==0)then return'';end;end;d=b.cueGqOGU(h,e(1,3),e(5,6)+n-1);e(n)local e=""for n=(1+s),#d do e=e..b.cueGqOGU(d,n,n)end return e;end;local s=#b.nqzQKzSh(_('\49.\48'))~=1 local e=n;local function le(...)return{...},b.WPyekmwK('#',...)end local function y()local j={};local _={};local e={};local c={_,j,nil,e};local e=n()local h={}for l=1,e do local d=a();local n;if(d==2)then n=(a()~=#{});elseif(d==3)then local e=k();if s and b.dKIICEui(b.nqzQKzSh(e),'.(\48+)$')then e=b.zPcEarPi(e);end n=e;elseif(d==0)then n=z();end;h[l]=n;end;c[3]=a();for j=1,n()do local e=a();if(d(e,1,1)==0)then local f=d(e,2,3);local b=d(e,4,6);local e={o(),o(),nil,nil};if(f==0)then e[t]=o();e[r]=o();elseif(f==#{1})then e[t]=n();elseif(f==u[2])then e[t]=n()-(2^16)elseif(f==u[3])then e[t]=n()-(2^16)e[r]=o();end;if(d(b,1,1)==1)then e[l]=h[e[l]]end if(d(b,2,2)==1)then e[t]=h[e[t]]end if(d(b,3,3)==1)then e[r]=h[e[r]]end _[j]=e;end end;for e=1,n()do j[e-(#{1})]=y();end;return c;end;local function ee(d,e,n)local l=e;local l=n;return _(b.dKIICEui(b.dKIICEui(({b.fhOvEgjB(d)})[2],e),n))end local function z(g,h,a)local function de(...)local o,u,s,y,ee,n,ne,p,k,m,_,d;local e=0;while-1<e do if 2<e then if 4<e then if 3<e then repeat if e>5 then e=-2;break;end;d=f(7);until true;else d=f(7);end else if 1~=e then for n=25,66 do if e~=4 then p={};k={...};break;end;m=b.WPyekmwK('#',...)-1;_={};break;end;else p={};k={...};end end else if e>0 then if e~=1 then n=-41;ne=-1;else s=f(6,77,3,69,g);ee=le y=0;end else o=f(6,55,1,4,g);u=f(6,9,2,59,g);end end e=e+1;end;for e=0,m do if(e>=s)then p[e-s]=k[e+1];else d[e]=k[e+1];end;end;local e=m-s+1 local e;local f;local function s(...)while true do end end while true do if n<-40 then n=n+42 end e=o[n];f=e[c];if 28>=f then if f<=13 then if 7>f then if f>2 then if f>=5 then if 5==f then d[e[l]]=a[e[t]];else d[e[l]][e[t]]=d[e[r]];end else if 3<f then if d[e[l]]then n=n+1;else n=e[t];end;else for f=0,3 do if 2>f then if f>=-3 then repeat if f~=0 then a[e[t]]=d[e[l]];n=n+1;e=o[n];break;end;d[e[l]]=(e[t]~=0);n=n+1;e=o[n];until true;else d[e[l]]=(e[t]~=0);n=n+1;e=o[n];end else if f~=2 then if(d[e[l]]==e[r])then n=n+1;else n=e[t];end;else d[e[l]]=a[e[t]];n=n+1;e=o[n];end end end end end else if f>0 then if f~=-1 then for b=45,75 do if f<2 then local b,_;for f=0,5 do if 2>=f then if f>=1 then if-2<f then for h=47,82 do if f~=2 then b=e[l];_=d[e[t]];d[b+1]=_;d[b]=_[e[r]];n=n+1;e=o[n];break;end;d(e[l],e[t]);n=n+1;e=o[n];break;end;else d(e[l],e[t]);n=n+1;e=o[n];end else d[e[l]]=h[e[t]];n=n+1;e=o[n];end else if 3<f then if f~=2 then for b=26,86 do if 5>f then d[e[l]]=a[e[t]];n=n+1;e=o[n];break;end;d[e[l]]=d[e[t]][e[r]];break;end;else d[e[l]]=a[e[t]];n=n+1;e=o[n];end else b=e[l]d[b](j(d,b+1,e[t]))n=n+1;e=o[n];end end end break;end;local b,a;for f=0,6 do if 2>=f then if 1<=f then if 0<f then for r=37,82 do if f~=1 then b=e[l]d[b]=d[b](d[b+1])n=n+1;e=o[n];break;end;d(e[l],e[t]);n=n+1;e=o[n];break;end;else d(e[l],e[t]);n=n+1;e=o[n];end else d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];end else if 5>f then if f~=0 then for b=42,80 do if 3~=f then d[e[l]][e[t]]=d[e[r]];n=n+1;e=o[n];break;end;d[e[l]]=h[e[t]];n=n+1;e=o[n];break;end;else d[e[l]]=h[e[t]];n=n+1;e=o[n];end else if 6>f then b=e[l];a=d[e[t]];d[b+1]=a;d[b]=a[e[r]];n=n+1;e=o[n];else d[e[l]]=d[e[t]];end end end end break;end;else local b,a;for f=0,6 do if 2>=f then if 1<=f then if 0<f then for r=37,82 do if f~=1 then b=e[l]d[b]=d[b](d[b+1])n=n+1;e=o[n];break;end;d(e[l],e[t]);n=n+1;e=o[n];break;end;else d(e[l],e[t]);n=n+1;e=o[n];end else d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];end else if 5>f then if f~=0 then for b=42,80 do if 3~=f then d[e[l]][e[t]]=d[e[r]];n=n+1;e=o[n];break;end;d[e[l]]=h[e[t]];n=n+1;e=o[n];break;end;else d[e[l]]=h[e[t]];n=n+1;e=o[n];end else if 6>f then b=e[l];a=d[e[t]];d[b+1]=a;d[b]=a[e[r]];n=n+1;e=o[n];else d[e[l]]=d[e[t]];end end end end end else d[e[l]]=(e[t]~=0);end end else if f<10 then if f<8 then local f,a;for b=0,6 do if 3>b then if 1>b then h[e[t]]=d[e[l]];n=n+1;e=o[n];else if 1<b then d[e[l]][e[t]]=e[r];n=n+1;e=o[n];else d[e[l]]=h[e[t]];n=n+1;e=o[n];end end else if b<=4 then if 1~=b then repeat if b>3 then f=e[l];a=d[e[t]];d[f+1]=a;d[f]=a[e[r]];n=n+1;e=o[n];break;end;d[e[l]]=h[e[t]];n=n+1;e=o[n];until true;else f=e[l];a=d[e[t]];d[f+1]=a;d[f]=a[e[r]];n=n+1;e=o[n];end else if b>=4 then for r=21,55 do if 6>b then f=e[l]d[f](d[f+1])n=n+1;e=o[n];break;end;d[e[l]]=h[e[t]];break;end;else d[e[l]]=h[e[t]];end end end end else if f>=7 then for n=23,81 do if f~=9 then a[e[t]]=d[e[l]];break;end;for e=e[l],e[t]do d[e]=nil;end;break;end;else for e=e[l],e[t]do d[e]=nil;end;end end else if f<=11 then if 7<=f then for b=22,77 do if 11~=f then local f,b;for h=0,3 do if 1>=h then if h~=-4 then repeat if h~=0 then d[e[l]]();n=n+1;e=o[n];break;end;d[e[l]]=d[e[t]];n=n+1;e=o[n];until true;else d[e[l]]();n=n+1;e=o[n];end else if h>=-1 then for a=22,73 do if 3>h then d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];break;end;f=e[l];b=d[e[t]];d[f+1]=b;d[f]=b[e[r]];break;end;else f=e[l];b=d[e[t]];d[f+1]=b;d[f]=b[e[r]];end end end break;end;d[e[l]][e[t]]=d[e[r]];break;end;else d[e[l]][e[t]]=d[e[r]];end else if 12<f then local n=e[l]d[n]=d[n](j(d,n+1,e[t]))else if(d[e[l]]==e[r])then n=n+1;else n=e[t];end;end end end end else if 21>f then if 17<=f then if 19>f then if f~=16 then repeat if f~=18 then d[e[l]]=d[e[t]][e[r]];break;end;local e=e[l]d[e]=d[e](d[e+1])until true;else local e=e[l]d[e]=d[e](d[e+1])end else if f==20 then a[e[t]]=d[e[l]];else local f;f=e[l]d[f](j(d,f+1,e[t]))n=n+1;e=o[n];do return end;end end else if f<=14 then do return end;else if f==16 then d[e[l]][e[t]]=e[r];else local n=e[l];local l=d[e[t]];d[n+1]=l;d[n]=l[e[r]];end end end else if 25>f then if 22<f then if f~=20 then repeat if 23~=f then d[e[l]]=h[e[t]];break;end;if not d[e[l]]then n=n+1;else n=e[t];end;until true;else d[e[l]]=h[e[t]];end else if f~=18 then repeat if 21~=f then d(e[l],e[t]);break;end;local h,b;for f=0,4 do if f>=2 then if 2>=f then for e=e[l],e[t]do d[e]=nil;end;n=n+1;e=o[n];else if f==3 then d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];else h=e[l];b=d[e[t]];d[h+1]=b;d[h]=b[e[r]];end end else if f>0 then d[e[l]][e[t]]=d[e[r]];n=n+1;e=o[n];else d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];end end end until true;else local h,b;for f=0,4 do if f>=2 then if 2>=f then for e=e[l],e[t]do d[e]=nil;end;n=n+1;e=o[n];else if f==3 then d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];else h=e[l];b=d[e[t]];d[h+1]=b;d[h]=b[e[r]];end end else if f>0 then d[e[l]][e[t]]=d[e[r]];n=n+1;e=o[n];else d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];end end end end end else if 26>=f then if f>24 then repeat if f~=26 then n=e[t];break;end;d[e[l]]=a[e[t]];until true;else d[e[l]]=a[e[t]];end else if f>=23 then repeat if f>27 then local n=e[l]d[n](j(d,n+1,e[t]))break;end;local f;d[e[l]]=a[e[t]];n=n+1;e=o[n];d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];d(e[l],e[t]);n=n+1;e=o[n];f=e[l]d[f]=d[f](d[f+1])n=n+1;e=o[n];d[e[l]][e[t]]=e[r];n=n+1;e=o[n];d[e[l]][e[t]]=e[r];n=n+1;e=o[n];d[e[l]]=h[e[t]];until true;else local n=e[l]d[n](j(d,n+1,e[t]))end end end end end else if f>42 then if f<50 then if 45>=f then if f>43 then if 43<=f then for o=34,92 do if f~=45 then if(d[e[l]]==e[r])then n=n+1;else n=e[t];end;break;end;d[e[l]][e[t]]=e[r];break;end;else d[e[l]][e[t]]=e[r];end else local e=e[l]d[e](d[e+1])end else if f<48 then if f<47 then local e=e[l]d[e]=d[e](d[e+1])else do return end;end else if f>=44 then repeat if f<49 then local f,a,o,b,r,h;local n=0;while n>-1 do if n<4 then if n<=1 then if n>0 then a=l;else f=e;end else if 3==n then b=d;else o=t;end end else if 6>n then if n>3 then for e=39,78 do if n<5 then r=b[f[o]];break;end;h=f[a];break;end;else r=b[f[o]];end else if n==6 then d[h]=r;else n=-2;end end end n=n+1 end break;end;h[e[t]]=d[e[l]];until true;else h[e[t]]=d[e[l]];end end end else if 54<=f then if f>55 then if f~=56 then if d[e[l]]then n=n+1;else n=e[t];end;else h[e[t]]=d[e[l]];end else if f>=53 then repeat if 55>f then for f=0,2 do if f<1 then d[e[l]]=a[e[t]];n=n+1;e=o[n];else if f>=-3 then repeat if f~=1 then d[e[l]]=d[e[t]][e[r]];break;end;d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];until true;else d[e[l]]=d[e[t]][e[r]];end end end break;end;if(e[l]<=d[e[r]])then n=n+1;else n=e[t];end;until true;else if(e[l]<=d[e[r]])then n=n+1;else n=e[t];end;end end else if f>=52 then if 53~=f then local f;d[e[l]]=a[e[t]];n=n+1;e=o[n];d[e[l]]=d[e[t]][e[r]];n=n+1;e=o[n];d(e[l],e[t]);n=n+1;e=o[n];f=e[l]d[f](d[f+1])n=n+1;e=o[n];d[e[l]]=h[e[t]];n=n+1;e=o[n];d[e[l]]();n=n+1;e=o[n];do return end;else local u=u[e[t]];local j;local f={};j=b.CCpd_COx({},{__index=function(n,e)local e=f[e];return e[1][e[2]];end,__newindex=function(d,e,n)local e=f[e]e[1][e[2]]=n;end;});for l=1,e[r]do n=n+1;local e=o[n];if e[c]==48 then f[l-1]={d,e[t]};else f[l-1]={h,e[t]};end;_[#_+1]=f;end;d[e[l]]=z(u,j,a);end else if f>50 then local n=e[l]d[n](j(d,n+1,e[t]))else local f,b,a,h,r,o;local n=0;while n>-1 do if 3<n then if 5<n then if 5<n then for e=10,52 do if 7>n then d[o]=r;break;end;n=-2;break;end;else d[o]=r;end else if 3<n then repeat if 4~=n then o=f[b];break;end;r=h[f[a]];until true;else o=f[b];end end else if 1<n then if n>=-1 then for e=30,62 do if n~=2 then h=d;break;end;a=t;break;end;else h=d;end else if n==0 then f=e;else b=l;end end end n=n+1 end end end end end else if 35>=f then if 31<f then if 34<=f then if 33<f then repeat if 35~=f then d[e[l]]=d[e[t]][e[r]];break;end;d[e[l]]();until true;else d[e[l]]();end else if f>30 then for o=17,61 do if 33>f then d[e[l]]();break;end;if(e[l]<=d[e[r]])then n=n+1;else n=e[t];end;break;end;else d[e[l]]();end end else if f>=30 then if f>=26 then for n=14,57 do if 31~=f then local e=e[l]d[e](d[e+1])break;end;local f,o,b,h,r;local n=0;while n>-1 do if 3>n then if 0>=n then f=e;else if-3~=n then for e=39,74 do if n<2 then o=l;break;end;b=t;break;end;else o=l;end end else if 5<=n then if 1~=n then for e=32,62 do if n~=6 then d(r,h);break;end;n=-2;break;end;else n=-2;end else if 0~=n then repeat if n~=4 then h=f[b];break;end;r=f[o];until true;else r=f[o];end end end n=n+1 end break;end;else local o,f,h,b,r;local n=0;while n>-1 do if 3>n then if 0>=n then o=e;else if-3~=n then for e=39,74 do if n<2 then f=l;break;end;h=t;break;end;else f=l;end end else if 5<=n then if 1~=n then for e=32,62 do if n~=6 then d(r,b);break;end;n=-2;break;end;else n=-2;end else if 0~=n then repeat if n~=4 then b=o[h];break;end;r=o[f];until true;else r=o[f];end end end n=n+1 end end else if not d[e[l]]then n=n+1;else n=e[t];end;end end else if f<=38 then if f<37 then for e=e[l],e[t]do d[e]=nil;end;else if 37<f then local n=e[l]d[n]=d[n](j(d,n+1,e[t]))else d[e[l]]=(e[t]~=0);end end else if f<=40 then if 36<f then for j=13,96 do if f<40 then local u=u[e[t]];local j;local f={};j=b.CCpd_COx({},{__index=function(n,e)local e=f[e];return e[1][e[2]];end,__newindex=function(d,e,n)local e=f[e]e[1][e[2]]=n;end;});for l=1,e[r]do n=n+1;local e=o[n];if e[c]==48 then f[l-1]={d,e[t]};else f[l-1]={h,e[t]};end;_[#_+1]=f;end;d[e[l]]=z(u,j,a);break;end;n=e[t];break;end;else local u=u[e[t]];local j;local f={};j=b.CCpd_COx({},{__index=function(n,e)local e=f[e];return e[1][e[2]];end,__newindex=function(d,e,n)local e=f[e]e[1][e[2]]=n;end;});for l=1,e[r]do n=n+1;local e=o[n];if e[c]==48 then f[l-1]={d,e[t]};else f[l-1]={h,e[t]};end;_[#_+1]=f;end;d[e[l]]=z(u,j,a);end else if f~=40 then repeat if f>41 then d[e[l]]=h[e[t]];break;end;local n=e[l];local l=d[e[t]];d[n+1]=l;d[n]=l[e[r]];until true;else d[e[l]]=h[e[t]];end end end end end end n=1+n;end;end;return de end;local l=0xff;local b={};local o=(1);local t='';(function(n)local d=n local f=0x00 local e=0x00 d={(function(r)if f>0x20 then return r end f=f+1 e=(e+0x113f-r)%0x11 return(e%0x03==0x1 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x19);t={t..'\58 a',t};b[o]=y();o=o+(1);t[1]='\58'..t[1];l[2]=0xff;end return true end)'AQTzc'and d[0x1](0x149+r))or(e%0x03==0x0 and(function(d)if not n[d]then e=e+0x01 n[d]=(0xae);l[2]=(l[2]*(ee(function()b()end,j(t))-ee(l[1],j(t))))+1;b[o]={};l=l[2];o=o+l;end return true end)'qlWWs'and d[0x2](r+0x39f))or(e%0x03==0x2 and(function(d)if not n[d]then e=e+0x01 n[d]=(0xe2);end return true end)'EmbVs'and d[0x3](r+0x21a))or r end),(function(r)if f>0x29 then return r end f=f+1 e=(e+0x60f-r)%0x24 return(e%0x03==0x0 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x95);t='\37';l={function()l()end};t=t..'\100\43';end return true end)'ACebW'and d[0x1](0xc7+r))or(e%0x03==0x1 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x10);b[o]=te();o=o+l;end return true end)'GUlXz'and d[0x3](r+0x151))or(e%0x03==0x2 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x24);end return true end)'iIzRj'and d[0x2](r+0x3d6))or r end),(function(l)if f>0x28 then return l end f=f+1 e=(e+0xe58-l)%0x2b return(e%0x03==0x0 and(function(d)if not n[d]then e=e+0x01 n[d]=(0xd8);end return true end)'ZODQo'and d[0x1](0x83+l))or(e%0x03==0x2 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x86);end return true end)'LltTL'and d[0x2](l+0x1fe))or(e%0x03==0x1 and(function(d)if not n[d]then e=e+0x01 n[d]=(0x65);end return true end)'qSqrK'and d[0x3](l+0x89))or l end)}d[0x2](0x8e2)end){};local e=z(j(b));return e(...);end return ee((function()local n={}local e=0x01;local d;if b.zhfIVcLr then d=b.zhfIVcLr(ee)else d=''end if b.dKIICEui(d,b.GCw_ZSAH)then e=e+0;else e=e+1;end n[e]=0x02;n[n[e]+0x01]=0x03;return n;end)(),...)end)((function(d,e,n,l,t,f)local f;if 4>d then if d>1 then if-2~=d then for f=19,70 do if d>2 then do return e(1),e(4,t,l,n,e),e(5,t,l,n)end;break;end;do return 16777216,65536,256 end;break;end;else do return e(1),e(4,t,l,n,e),e(5,t,l,n)end;end else if-3<=d then for f=49,88 do if d>0 then do return function(n,e,d)if d then local e=(n/2^(e-1))%2^((d-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(n%(e+e)>=e)and 1 or 0;end;end;end;break;end;do return e(1),e(4,t,l,n,e),e(5,t,l,n)end;break;end;else do return e(1),e(4,t,l,n,e),e(5,t,l,n)end;end end else if d<6 then if 3<d then for f=37,63 do if 5>d then local d=l;local o,r,f=t(2);do return function()local t,l,n,e=e(n,d(d,d),d(d,d)+3);d(4);return(e*o)+(n*r)+(l*f)+t;end;end;break;end;local d=l;do return function()local e=e(n,d(d,d),d(d,d));d(1);return e;end;end;break;end;else local d=l;do return function()local e=e(n,d(d,d),d(d,d));d(1);return e;end;end;end else if d>=7 then if d<8 then do return setmetatable({},{['__\99\97\108\108']=function(e,d,l,t,n)if n then return e[n]elseif t then return e else e[d]=l end end})end else do return n(d,nil,n);end end else do return t[n]end;end end end end),...)
end

local function SafeLoad(url, name, localFunc)
    name = name or "远程脚本"

    if type(localFunc) == "function" then
        local ok, err = pcall(localFunc)
        if ok then
            Notify("shible", name .. " 加载成功", 2)
            return true
        else
            warn("[shible] " .. name .. " 本地执行失败: " .. tostring(err))
            Notify("shible", name .. " 本地执行出错", 3)
            return false
        end
    end

    local body = nil
    pcall(function()
        body = game:HttpGet(url)
    end)
    if not body or #body < 10 then
        pcall(function()
            body = HttpService:GetAsync(url)
        end)
    end
    if not body or #body < 10 then
        pcall(function()
            local r = (syn and syn.request) or http_request or request
            if r then
                local resp = r({Url = url, Method = "GET"})
                if resp and (resp.Success or resp.StatusCode == 200) then
                    body = resp.Body
                end
            end
        end)
    end
    if body and #body > 10 then
        local func = loadstring(body)
        if func then
            local ok = pcall(func)
            if ok then
                Notify("shible", name .. " 加载成功", 2)
                return true
            end
        end
    end
    Notify("shible", name .. " 加载失败", 3)
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

local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(0, 30, 0, 30)
avatarFrame.Position = UDim2.new(0, 12, 0, 7)
avatarFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
avatarFrame.BackgroundTransparency = 0.2
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = nav
corner(avatarFrame, 15)

local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(1, 0, 1, 0)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
avatar.Parent = avatarFrame
corner(avatar, 15)

local nameCol = Instance.new("Frame")
nameCol.Name = "NameCol"
nameCol.BackgroundTransparency = 1
nameCol.Position = UDim2.new(0, 48, 0, 7)
nameCol.Size = UDim2.new(1, -96, 0, 30)
nameCol.Parent = nav

local dnLabel = Instance.new("TextLabel")
dnLabel.Name = "DisplayName"
dnLabel.Text = LocalPlayer.DisplayName
dnLabel.Font = Enum.Font.GothamSemibold
dnLabel.TextSize = 14
dnLabel.TextColor3 = Theme.TextPrimary
dnLabel.BackgroundTransparency = 1
dnLabel.Position = UDim2.new(0, 0, 0, 0)
dnLabel.Size = UDim2.new(1, 0, 0, 16)
dnLabel.TextXAlignment = Enum.TextXAlignment.Left
dnLabel.TextTruncate = Enum.TextTruncate.AtEnd
dnLabel.Parent = nameCol

local unLabel = Instance.new("TextLabel")
unLabel.Name = "UserName"
unLabel.Text = "@" .. LocalPlayer.Name
unLabel.Font = Enum.Font.Gotham
unLabel.TextSize = 11
unLabel.TextColor3 = Theme.TextSecondary
unLabel.BackgroundTransparency = 1
unLabel.Position = UDim2.new(0, 0, 0, 16)
unLabel.Size = UDim2.new(1, 0, 0, 14)
unLabel.TextXAlignment = Enum.TextXAlignment.Left
unLabel.TextTruncate = Enum.TextTruncate.AtEnd
unLabel.Parent = nameCol

LocalPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
    dnLabel.Text = LocalPlayer.DisplayName
end)
LocalPlayer:GetPropertyChangedSignal("Name"):Connect(function()
    unLabel.Text = "@" .. LocalPlayer.Name
end)

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
local pgAction = createPage("Action")

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
    BypassAC = true,
    RadarEnabled = false,
    BoxEnabled = false,
    AntiFall = false,
    FlingLoaded = false,
    ESPMaster = false,
}

local animTracks = {}
local cache = {}
local radarPoints = {}

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

local toggleSetters = {}

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
        track.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        thumb.Position = UDim2.new(1, -25, 0, 3)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end

    local function setState(val)
        on = val
        if on then
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(220, 220, 225)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(1, -25, 0, 3)}, 0.2)
            makeTween(thumb, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        else
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
            makeTween(thumb, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end
        safeCall(function()
            onToggle(val)
        end)
    end

    track.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            setState(not on)
        end
    end)

    toggleSetters[labelText] = setState
    return setState
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
        end)
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
    local aimURL = "https://raw.githubusercontent.com/odhdshhe/bu/refs/heads/main/%E6%9C%88%E4%BA%AE%E5%8A%A0%E5%AF%86%E8%BF%87%E7%9A%84%E6%9E%97%E7%9A%84%E8%87%AA%E7%9E%84.lua"

    createToggle(p, y, "静默自瞄", function()
        return scriptLoaded
    end, function(v)
        if v then
            local cam = workspace.CurrentCamera
            if cam then
                originalCameraMode = cam.CameraType
                originalCameraCFrame = cam.CFrame
            end
            scriptLoaded = SafeLoad(aimURL, "静默自瞄", LocalModules.SilentAim)
            if not scriptLoaded then
                toggleSetters["静默自瞄"](false)
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
    local bulletTrackURL = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/%E5%AD%90%E8%BF%BD"

    createToggle(p, y, "子弹追踪", function()
        return bulletTrackLoaded
    end, function(v)
        if v then
            bulletTrackLoaded = SafeLoad(bulletTrackURL, "子弹追踪", LocalModules.BulletTrack)
            if not bulletTrackLoaded then
                toggleSetters["子弹追踪"](false)
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

    createToggle(p, y, "一键启动", function()
        return FuncState.ESPMaster
    end, function(v)
        FuncState.ESPMaster = v
        FuncState.ESPEnabled = v
        FuncState.HealthBarEnabled = v
        FuncState.DistanceEnabled = v
        FuncState.RadarEnabled = v
        FuncState.BoxEnabled = v
        if toggleSetters["全身透视"] then toggleSetters["全身透视"](v) end
        if toggleSetters["人物血量"] then toggleSetters["人物血量"](v) end
        if toggleSetters["距离显示"] then toggleSetters["距离显示"](v) end
        if toggleSetters["玩家雷达"] then toggleSetters["玩家雷达"](v) end
        if toggleSetters["人物方框"] then toggleSetters["人物方框"](v) end
    end)

    y = y + 48
    createToggle(p, y, "全身透视", function()
        return FuncState.ESPEnabled
    end, function(v)
        FuncState.ESPEnabled = v
    end)

    y = y + 48
    createToggle(p, y, "人物血量", function()
        return FuncState.HealthBarEnabled
    end, function(v)
        FuncState.HealthBarEnabled = v
    end)

    y = y + 48
    createToggle(p, y, "距离显示", function()
        return FuncState.DistanceEnabled
    end, function(v)
        FuncState.DistanceEnabled = v
    end)

    y = y + 48
    createToggle(p, y, "玩家雷达", function()
        return FuncState.RadarEnabled
    end, function(v)
        FuncState.RadarEnabled = v
    end)

    y = y + 48
createToggle(p, y, "人物方框", function()
    return FuncState.BoxEnabled
end, function(v)
    FuncState.BoxEnabled = v
end)

    local radarFrame = nil
    local radarRadiusPixels = 85
    local radarWorldRange = 300

    local function createRadar()
        if radarFrame then return end

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
        radarFrame.ZIndex = 0
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

        for _, dist in ipairs({150, 300}) do
            local ratio = dist / radarWorldRange

            local ring = Instance.new("Frame", radarFrame)
            ring.AnchorPoint = Vector2.new(0.5, 0.5)
            ring.Position = UDim2.fromScale(0.5, 0.5)
            ring.Size = UDim2.new(0, radarRadiusPixels * 2 * ratio, 0, radarRadiusPixels * 2 * ratio)
            ring.BackgroundTransparency = 1
            ring.BorderSizePixel = 1
            ring.BorderColor3 = Color3.fromRGB(255, 255, 255)
            ring.ZIndex = 1
            corner(ring, 90)
        end

        local border = Instance.new("Frame", radarFrame)
        border.Size = UDim2.new(1, 0, 1, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 2
        border.BorderColor3 = Color3.fromRGB(255, 255, 255)
        border.BorderMode = Enum.BorderMode.Inset
        border.ZIndex = 1
        corner(border, 90)
    end

    local function updateRadar()
        if not FuncState.RadarEnabled then
            if radarFrame then radarFrame.Visible = false end
            for _, point in pairs(radarPoints) do
                point.Visible = false
            end
            return
        end

        if not radarFrame then createRadar() end
        if not radarFrame then return end

        local myRoot = getRootPart()
        if not myRoot then
            radarFrame.Visible = false
            for _, point in pairs(radarPoints) do
                point.Visible = false
            end
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then
            radarFrame.Visible = false
            return
        end

        radarFrame.Visible = true

        local myPos = myRoot.Position
        local camCF = camera.CFrame

        local look = camCF.LookVector
        local forward = Vector3.new(look.X, 0, look.Z)
        if forward.Magnitude < 0.01 then
            forward = Vector3.new(0, 0, -1)
        end
        forward = forward.Unit

        local right = Vector3.new(-forward.Z, 0, forward.X)

        local maxDist = radarWorldRange
        local R = radarRadiusPixels

        for _, point in pairs(radarPoints) do
            point.Visible = false
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end

            if LocalPlayer.Team and plr.Team and plr.Team == LocalPlayer.Team then
                continue
            end

            local char = plr.Character
            if not char then continue end

            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health <= 0 or not hrp then continue end

            local diff = hrp.Position - myPos
            local horizontalDist = math.sqrt(diff.X ^ 2 + diff.Z ^ 2)
            if horizontalDist > maxDist then continue end

            local dirWorld = Vector3.new(diff.X, 0, diff.Z)
            if dirWorld.Magnitude < 0.01 then continue end
            dirWorld = dirWorld.Unit

            local fwdComp = dirWorld:Dot(forward)
            local rightComp = dirWorld:Dot(right)

            local normalizedDist = horizontalDist / maxDist
            local px = rightComp * normalizedDist * R
            local py = -fwdComp * normalizedDist * R

            local point = radarPoints[plr]
            if not point or not point.Parent then
                point = Instance.new("ImageLabel")
                point.Name = plr.Name
                point.Size = UDim2.new(0, 7, 0, 7)
                point.AnchorPoint = Vector2.new(0.5, 0.5)
                point.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                point.BackgroundTransparency = 0
                point.BorderSizePixel = 0
                point.ZIndex = 3
                point.Parent = radarFrame
                corner(point, 4)
                radarPoints[plr] = point
            end

            point.Position = UDim2.new(0.5, px, 0.5, py)
            point.Visible = true
        end
    end


local boxGui = Instance.new("ScreenGui")
boxGui.Name = "shible_BoxESP"
boxGui.ResetOnSpawn = false
boxGui.IgnoreGuiInset = true
boxGui.DisplayOrder = 999998
boxGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
boxGui.Parent = PlayerGui

local boxCache = {}

local function getOrCreateBox(plr)
    local entry = boxCache[plr]

    if entry and entry.box and entry.box.Parent then
        return entry.box, entry.hpBar
    end

    local box = Instance.new("Frame")
    box.Name = plr.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = boxGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = box

    local hpBar = Instance.new("Frame")
    hpBar.Name = plr.Name .. "_HP"
    hpBar.BackgroundColor3 = Color3.fromRGB(50, 215, 75)
    hpBar.BorderSizePixel = 0
    hpBar.Visible = false
    hpBar.ZIndex = 3
    hpBar.Parent = boxGui

    boxCache[plr] = {
        box = box,
        hpBar = hpBar
    }

    return box, hpBar
end

local function updateBoxESP()
    for _, entry in pairs(boxCache) do
        if entry.box then
            entry.box.Visible = false
        end

        if entry.hpBar then
            entry.hpBar.Visible = false
        end
    end

    if not FuncState.BoxEnabled
        and not FuncState.HealthBarEnabled then
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then
            continue
        end

        if LocalPlayer.Team
            and plr.Team
            and plr.Team == LocalPlayer.Team then
            continue
        end

        local char = plr.Character
        if not char then
            continue
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")

        if not hum or hum.Health <= 0 or not hrp or not head then
            continue
        end

        -- 获取角色上下边界的屏幕坐标
        local topPos = head.Position + Vector3.new(0, 0.7, 0)
        local bottomPos = hrp.Position - Vector3.new(0, 2.6, 0)

        local topScreen, topOn =
            camera:WorldToViewportPoint(topPos)

        local bottomScreen, bottomOn =
            camera:WorldToViewportPoint(bottomPos)

        if not topOn or not bottomOn
            or topScreen.Z <= 0
            or bottomScreen.Z <= 0 then
            continue
        end

        local baseHeight =
            math.abs(bottomScreen.Y - topScreen.Y)

        local height = baseHeight * 1.15
        local width = height * 0.6

        local centerX =
            (topScreen.X + bottomScreen.X) * 0.5

        local centerY =
            (topScreen.Y + bottomScreen.Y) * 0.5

        local leftX = centerX - width * 0.5
        local topY = centerY - height * 0.5

        local box, hpBar = getOrCreateBox(plr)

        if FuncState.BoxEnabled then
            box.Size = UDim2.fromOffset(width, height)
            box.Position = UDim2.fromOffset(leftX, topY)
            box.Visible = true
        end

        if FuncState.HealthBarEnabled then
            local ratio = math.clamp(
                hum.Health / math.max(hum.MaxHealth, 1),
                0,
                1
            )

            local barWidth = 1
            local gap = 2
            local barHeight = height * ratio

            hpBar.Size = UDim2.fromOffset(
                barWidth,
                barHeight
            )

            hpBar.Position = UDim2.fromOffset(
                leftX - gap - barWidth,
                topY + height - barHeight
            )

            if ratio > 0.5 then
                hpBar.BackgroundColor3 =
                    Color3.fromRGB(50, 215, 75)
            elseif ratio > 0.25 then
                hpBar.BackgroundColor3 =
                    Color3.fromRGB(255, 200, 0)
            else
                hpBar.BackgroundColor3 =
                    Color3.fromRGB(255, 50, 50)
            end

            hpBar.Visible = true
        end
    end
end


    local function getOrCreateESP(char)
        if (cache[char] and cache[char].hl and (cache[char].hl.Parent == char)) then
            return cache[char].hl, cache[char].hb
        end
        cache[char] = nil
        local oldHL = char:FindFirstChild("ESP_Highlight")
        if oldHL then oldHL:Destroy() end
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
        cache[char] = {hl = hl, hb = nil}
        return hl, nil
    end

    local function removeESP(char)
        local entry = cache[char]
        if entry then
            pcall(function()
                if entry.hl then entry.hl:Destroy() end
                if entry.hb then entry.hb:Destroy() end
            end)
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = hrp:FindFirstChild("ESP_Distance")
            if d then d:Destroy() end
        end
        cache[char] = nil
    end

    local espFrameCounter = 0
    RunService.RenderStepped:Connect(function()
        espFrameCounter = espFrameCounter + 1
        if espFrameCounter % 2 ~= 0 then return end
        safeCall(function()
            local myRoot = getRootPart()
            for _, model in ipairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
                    local char = model
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local head = char:FindFirstChild("Head")
                    if not hum or hum.Health <= 0 or not head then
                        removeESP(char)
                    else
                        if char == LocalPlayer.Character then
                            continue
                        end
                        local hl, hb = getOrCreateESP(char)
                        if hl then hl.Enabled = FuncState.ESPEnabled end
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
                                distGui.MaxDistance = 0
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
                            if existing then existing:Destroy() end
                        end
                    end
                end
            end
        updateRadar()
        updateBoxESP()
    end)
end)

    Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then removeESP(plr.Character) end
    local point = radarPoints[plr]
    if point then point:Destroy() end
    radarPoints[plr] = nil
    local entry = boxCache[plr]
    if entry then
        if entry.box then pcall(function() entry.box:Destroy() end) end
        if entry.hpBar then pcall(function() entry.hpBar:Destroy() end) end
    end
    boxCache[plr] = nil
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
    execBtn.BackgroundColor3 = Theme.Glass
    execBtn.BackgroundTransparency = 0.2
    execBtn.AutoButtonColor = false
    execBtn.Position = UDim2.new(0, 12, 0, y)
    execBtn.Size = UDim2.new(1, -24, 0, 40)
    corner(execBtn, 10)
    pressEffect(execBtn)

    local flyGui = nil
    local flyConnections = {}
    local flyInstances = {}

    local function cleanupFly()
        for _, conn in ipairs(flyConnections) do
            pcall(function() conn:Disconnect() end)
        end
        flyConnections = {}
        for _, inst in ipairs(flyInstances) do
            pcall(function() inst:Destroy() end)
        end
        flyInstances = {}
        if flyGui then
            pcall(function() flyGui:Destroy() end)
            flyGui = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                        hum:SetStateEnabled(s, true)
                    end
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
            local anim = char:FindFirstChild("Animate")
            if anim then anim.Disabled = false end
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if torso then
                local bg = torso:FindFirstChild("FlyBodyGyro")
                if bg then bg:Destroy() end
                local bv = torso:FindFirstChild("FlyBodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end

    local function notify(title, text)
        task.spawn(function()
            for i = 1, 5 do
                local ok = pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title,
                        Text = text,
                        Duration = 2
                    })
                end)
                if ok then break end
                task.wait(0.2)
            end
        end)
    end

    execBtn.MouseButton1Click:Connect(function()
        makeTween(execBtn, {TextSize = 16}, 0.12)
        task.delay(0.12, function()
            makeTween(execBtn, {TextSize = 14}, 0.15)
        end)

        if flyGui then
            cleanupFly()
            execBtn.Text = "启动飞行"
            notify("飞行", "已关闭")
            return
        end

        notify("IOS脚本", "创作者：shible")

        task.spawn(function()
            local ok, err = pcall(function()
                flyGui = Instance.new("ScreenGui")
                flyGui.Name = "shible_Fly"
                flyGui.ResetOnSpawn = false
                flyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
                table.insert(flyInstances, flyGui)

                local f = Instance.new("Frame", flyGui)
                f.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
                f.BorderColor3 = Color3.fromRGB(103, 221, 213)
                f.Position = UDim2.new(0.1, 0, 0.38, 0)
                f.Size = UDim2.new(0, 190, 0, 57)
                f.Active = true
                f.Draggable = true
                table.insert(flyInstances, f)

                local up = Instance.new("TextButton", f)
                up.Size = UDim2.new(0, 44, 0, 28)
                up.Text = "上升"
                up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
                up.AutoButtonColor = false
                up.Selectable = false
                table.insert(flyInstances, up)

                local down = Instance.new("TextButton", f)
                down.Size = UDim2.new(0, 44, 0, 28)
                down.Position = UDim2.new(0, 0, 0.49, 0)
                down.Text = "下落"
                down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
                down.AutoButtonColor = false
                down.Selectable = false
                table.insert(flyInstances, down)

                local onof = Instance.new("TextButton", f)
                onof.Size = UDim2.new(0, 56, 0, 28)
                onof.Position = UDim2.new(0.7, 0, 0.49, 0)
                onof.Text = "飞"
                onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
                onof.AutoButtonColor = false
                onof.Selectable = false
                table.insert(flyInstances, onof)

                local tl = Instance.new("TextLabel", f)
                tl.Size = UDim2.new(0, 100, 0, 28)
                tl.Position = UDim2.new(0.47, 0, 0, 0)
                tl.Text = "shible"
                tl.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
                tl.TextScaled = true
                table.insert(flyInstances, tl)

                local plus = Instance.new("TextButton", f)
                plus.Size = UDim2.new(0, 45, 0, 28)
                plus.Position = UDim2.new(0.23, 0, 0, 0)
                plus.Text = "+"
                plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
                plus.TextScaled = true
                plus.AutoButtonColor = false
                plus.Selectable = false
                table.insert(flyInstances, plus)

                local spd = Instance.new("TextLabel", f)
                spd.Size = UDim2.new(0, 44, 0, 28)
                spd.Position = UDim2.new(0.47, 0, 0.49, 0)
                spd.Text = "1"
                spd.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
                spd.TextScaled = true
                table.insert(flyInstances, spd)

                local mine = Instance.new("TextButton", f)
                mine.Size = UDim2.new(0, 45, 0, 29)
                mine.Position = UDim2.new(0.23, 0, 0.49, 0)
                mine.Text = "-"
                mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
                mine.TextScaled = true
                mine.AutoButtonColor = false
                mine.Selectable = false
                table.insert(flyInstances, mine)

                local xbtn = Instance.new("TextButton", f)
                xbtn.Size = UDim2.new(0, 45, 0, 28)
                xbtn.Position = UDim2.new(0, 0, -1, 27)
                xbtn.Text = "X"
                xbtn.TextSize = 30
                xbtn.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
                xbtn.AutoButtonColor = false
                xbtn.Selectable = false
                table.insert(flyInstances, xbtn)

                local mini = Instance.new("TextButton", f)
                mini.Size = UDim2.new(0, 45, 0, 28)
                mini.Position = UDim2.new(0, 44, -1, 27)
                mini.Text = "-"
                mini.TextSize = 40
                mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
                mini.AutoButtonColor = false
                mini.Selectable = false
                table.insert(flyInstances, mini)

                local mini2 = Instance.new("TextButton", f)
                mini2.Size = UDim2.new(0, 45, 0, 28)
                mini2.Position = UDim2.new(0, 44, 0, 30)
                mini2.Text = "+"
                mini2.TextSize = 40
                mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
                mini2.Visible = false
                mini2.AutoButtonColor = false
                mini2.Selectable = false
                table.insert(flyInstances, mini2)

                local speeds = 1
                local nowe = false
                local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hum = chr:FindFirstChildOfClass("Humanoid")
                local moveConn, renderConn, bgObj, bvObj

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
                    if anim then anim.Disabled = false end
                end

                local function stopFly()
                    if moveConn then
                        pcall(function() moveConn:Disconnect() end)
                        moveConn = nil
                    end
                    if renderConn then
                        pcall(function() renderConn:Disconnect() end)
                        renderConn = nil
                    end
                    if bgObj then
                        pcall(function() bgObj:Destroy() end)
                        bgObj = nil
                    end
                    if bvObj then
                        pcall(function() bvObj:Destroy() end)
                        bvObj = nil
                    end
                    resetHum()
                end

                local function startFly()
                    stopFly()
                    chr = LocalPlayer.Character
                    hum = chr and chr:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    pcall(function()
                        for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                            hum:SetStateEnabled(s, false)
                        end
                        hum:ChangeState(Enum.HumanoidStateType.Swimming)
                    end)
                    local anim = chr:FindFirstChild("Animate")
                    if anim then anim.Disabled = true end
                    moveConn = RunService.Heartbeat:Connect(function()
                        if (not nowe or not hum or (hum.Health <= 0)) then
                            return
                        end
                        if (hum.MoveDirection.Magnitude > 0) then
                            chr:TranslateBy(hum.MoveDirection * speeds)
                        end
                    end)
                    table.insert(flyConnections, moveConn)
                    local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
                    if torso then
                        bgObj = Instance.new("BodyGyro", torso)
                        bgObj.Name = "FlyBodyGyro"
                        bgObj.P = 90000
                        bgObj.MaxTorque = Vector3.new(8999999488, 8999999488, 8999999488)
                        table.insert(flyInstances, bgObj)
                        bvObj = Instance.new("BodyVelocity", torso)
                        bvObj.Name = "FlyBodyVelocity"
                        bvObj.Velocity = Vector3.zero
                        bvObj.MaxForce = Vector3.new(8999999488, 8999999488, 8999999488)
                        table.insert(flyInstances, bvObj)
                        renderConn = RunService.RenderStepped:Connect(function()
                            if (not nowe or not torso.Parent) then
                                stopFly()
                                return
                            end
                            bgObj.CFrame = workspace.CurrentCamera.CoordinateFrame
                        end)
                        table.insert(flyConnections, renderConn)
                    end
                end

                local charConn = LocalPlayer.CharacterAdded:Connect(function(c)
                    nowe = false
                    onof.Text = "飞"
                    chr = c
                    hum = chr:WaitForChild("Humanoid", 5)
                    stopFly()
                end)
                table.insert(flyConnections, charConn)

                xbtn.MouseButton1Click:Connect(function()
                    cleanupFly()
                    execBtn.Text = "启动飞行"
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

                onof.MouseButton1Click:Connect(function()
                    if not flyGui then return end
                    nowe = not nowe
                    onof.Text = (nowe and "停") or "飞"
                    if nowe then
                        startFly()
                    else
                        stopFly()
                    end
                end)

                execBtn.Text = "关闭飞行"
            end)

            if not ok then
                cleanupFly()
                execBtn.Text = "启动飞行"
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
    createToggle(p, y, "旋转", function() return FuncState.SpinEnabled end, function(v) FuncState.SpinEnabled = v end)
    y = y + 50
    createSlider(p, y, "旋转倍数 (10-999)", 10, 999, 50, function(v) FuncState.SpinSpeed = v end)
    y = y + 50
    createToggle(p, y, "甩飞所有", function() return FuncState.FlingLoaded end, function(v)
        if v then
            FuncState.FlingLoaded = SafeLoad(
    "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/%E7%94%A9%E9%A3%9E",
    "甩飞所有",
    LocalModules.FlingAll
)
            if not FuncState.FlingLoaded then toggleSetters["甩飞所有"](false) end
        else
            pcall(function() getgenv().FlingAllEnabled = false end)
            pcall(function() _G.FlingAllEnabled = false end)
            FuncState.FlingLoaded = false
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
RunService.RenderStepped:Connect(function(dt)
        safeCall(function()
            if not FuncState.SpinEnabled then return end
            local rp = getRootPart()
            if rp then
                rp.CFrame = rp.CFrame * CFrame.Angles(0, math.rad((FuncState.SpinSpeed or 50) * dt * 60), 0)
            end
        end)
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

    createButton(p, y, "r6道馆", function()
        SafeLoad("https://pastefy.app/wa3v2Vgm/raw", "r6道馆", LocalModules.R6Dojo)
    end)
    y = y + 42
    createButton(p, y, "r15道馆", function()
        SafeLoad("https://pastefy.app/YZoglOyJ/raw", "r15道馆", LocalModules.R15Dojo)
    end)
    y = y + 42

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
            pcall(function() track:Stop() track:Destroy() end)
        end
        animTracks = {}
        local char = getChar()
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            pcall(function() hum:LoadAnimation(Instance.new("Animation")):Stop() end)
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
    createToggle(p, y, "开启预防检测", function() return FuncState.AntiDetect end, function(v)
        FuncState.AntiDetect = v
        if v then startAntiDetect() else stopAntiDetect() end
    end)
    y = y + 46
    createToggle(p, y, "管理员检测", function() return FuncState.AdminDetect end, function(v) FuncState.AdminDetect = v end)
    y = y + 46
    createToggle(p, y, "绕过群组检测", function() return FuncState.BypassGroup end, function(v) FuncState.BypassGroup = v end)
    y = y + 46
    createToggle(p, y, "绕过AC检测", function() return FuncState.BypassAC end, function(v) FuncState.BypassAC = v end)
    local info = Instance.new("TextLabel", p)
    info.Text = "默认全部开启，如非必要请勿关闭。"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y + 46)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextWrapped = true
    y = y + 76
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
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
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
    shutdownBtn.MouseButton1Click:Connect(function() game:Shutdown() end)
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

local antiDetectRunning = false
local antiDetectConnections = {}

local function cleanAntiCheatMemory()
    pcall(function()
        local gc = getgc(true)
        for i, v in ipairs(gc) do
            if type(v) == "table" then
                local keys = {"AC_Enabled", "BanDetect", "CheatDetect", "ExploitDetect", "InjectDetect"}
                for _, key in ipairs(keys) do
                    if v[key] ~= nil then
                        v[key] = nil
                    end
                end
            end
        end
    end)
end

local function hookDetectionRemotes()
    pcall(function()
        for _, item in ipairs(game:GetDescendants()) do
            if item:IsA("RemoteEvent") then
                local name = item.Name:lower()
                if name:find("check") or name:find("detect") or name:find("anti") or name:find("ban") then
                    local old = item.OnServerEvent
                    if old then
                        item.OnServerEvent = function() end
                    end
                end
            end
        end
    end)
end

local function blockDetectionScripts()
    pcall(function()
        for _, item in ipairs(game:GetDescendants()) do
            if item:IsA("Script") or item:IsA("LocalScript") then
                local name = item.Name:lower()
                if name:find("anti") or name:find("detect") or name:find("check") or name:find("ban") then
                    pcall(function() item.Disabled = true end)
                end
            end
        end
    end)
end

local function fakeACEnvironment()
    pcall(function()
        if not _G._shible_Fake then
            _G._shible_Fake = {
                Enabled = false,
                Check = function() return false end,
                Report = function() end
            }
        end
        local fake = {
            CheckAC = function() return false end,
            BanCheck = function() return false end,
            AntiCheatCheck = function() return false end
        }
        for name, func in pairs(fake) do
            if not _G[name] then
                _G[name] = func
            end
        end
        local vars = {"AC_Enabled", "AntiCheatEnabled", "BanDetect", "AntiCheat", "AC"}
        for _, var in ipairs(vars) do
            if rawget(_G, var) then
                rawset(_G, var, false)
            end
        end
        _G.AC_Enabled = false
        _G.AntiCheat = nil
        _G.AC = nil
    end)
end

local function monitorNewDetections()
    local conn = game.DescendantAdded:Connect(function(child)
        if not FuncState.AntiDetect then return end
        if child:IsA("Script") or child:IsA("LocalScript") then
            local name = child.Name:lower()
            if name:find("anti") or name:find("detect") or name:find("check") or name:find("ban") then
                pcall(function() child.Disabled = true end)
            end
        end
        if child:IsA("RemoteEvent") then
            local name = child.Name:lower()
            if name:find("check") or name:find("detect") or name:find("anti") or name:find("ban") then
                task.wait(0.1)
                pcall(function() child.OnServerEvent = function() end end)
            end
        end
    end)
    return conn
end

local function startAntiDetect()
    if antiDetectRunning then return end
    antiDetectRunning = true
    pcall(function()
        cleanAntiCheatMemory()
        hookDetectionRemotes()
        blockDetectionScripts()
        fakeACEnvironment()
        local monitorConn = monitorNewDetections()
        table.insert(antiDetectConnections, monitorConn)
    end)
    while antiDetectRunning do
        task.wait(60)
        if FuncState.AntiDetect then
            pcall(function()
                cleanAntiCheatMemory()
                fakeACEnvironment()
                hookDetectionRemotes()
                blockDetectionScripts()
            end)
        end
    end
    Notify("shible", "防检测已启动", 2)
end

local function stopAntiDetect()
    antiDetectRunning = false
    for _, conn in ipairs(antiDetectConnections) do
        pcall(function() conn:Disconnect() end)
    end
    antiDetectConnections = {}
    Notify("shible", "防检测已停止", 2)
end

local function enhancedAdminDetect()
    pcall(function()
        local admins = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local name = plr.Name:lower()
            local adminKeywords = {"admin", "owner", "creator", "dev", "moderator", "staff", "gm", "helper"}
            for _, keyword in ipairs(adminKeywords) do
                if name:find(keyword, 1, true) then
                    table.insert(admins, plr.Name)
                    break
                end
            end
        end
        if #admins > 0 then
            Notify("shible", "⚠️ 检测到管理员: " .. table.concat(admins, ", "), 5)
        end
    end)
end

local function enhancedACBypass()
    pcall(function()
        local vars = {"AC_Enabled", "AntiCheatEnabled", "BanDetect", "AntiCheat", "AC"}
        for _, var in ipairs(vars) do
            if rawget(_G, var) then
                rawset(_G, var, false)
            end
        end
        local funcs = {"CheckAC", "AntiCheatCheck", "BanCheck", "ExploitCheck"}
        for _, func in ipairs(funcs) do
            if type(_G[func]) == "function" then
                _G[func] = function() return false end
            end
        end
        _G.AC_Enabled = false
        _G.AntiCheat = nil
        _G.AC = nil
    end)
end

local function enhancedGroupBypass()
    pcall(function()
        _G.GroupVerified = true
        _G.GroupCheck = function() return true end
        _G.RequireGroup = function() return true end
        if shared then
            shared.GroupVerified = true
            shared.GroupCheck = function() return true end
        end
    end)
end

task.spawn(function()
    while antiDetectRunning do
        task.wait(60)
        pcall(function()
            if FuncState.AdminDetect then enhancedAdminDetect() end
            if FuncState.BypassGroup then enhancedGroupBypass() end
            if FuncState.BypassAC then enhancedACBypass() end
        end)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    task.wait(3)
    if FuncState.AdminDetect then
        pcall(enhancedAdminDetect)
    end
end)

_G._shible_AntiDetect = {
    start = startAntiDetect,
    stop = stopAntiDetect,
    isRunning = function() return antiDetectRunning end
}

task.spawn(function()
    task.wait(0.5)
    if FuncState.AntiDetect then
        startAntiDetect()
    end
end)

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
createFuncItem("飞行", "Fly")
createFuncItem("娱乐", "Fun")
createFuncItem("人物动作", "Action")
createFuncItem("防检测", "Anti")

task.defer(function()
    safeCall(function()
        for _, btn in ipairs(funcList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.MouseButton1Click:Fire()
                break
            end
        end
    end)
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

local funcCloseBtn = Instance.new("TextButton", pageFunction)
funcCloseBtn.Text = "关闭"
funcCloseBtn.Font = Enum.Font.GothamSemibold
funcCloseBtn.TextSize = 14
funcCloseBtn.TextColor3 = Theme.Danger
funcCloseBtn.BackgroundTransparency = 1
funcCloseBtn.Position = UDim2.new(1, -72, 1, -C.BackBtnHeight - 4)
funcCloseBtn.Size = UDim2.new(0, 60, 0, 36)
funcCloseBtn.AutoButtonColor = false
pressEffect(funcCloseBtn)
funcCloseBtn.Visible = false

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
                if clampY then newY = math.max(0, newY) end
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
        end)
    end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

local function cleanupAll()
    pcall(function()
        stopAntiDetect()
        if pgFun._antiFallConn then
            for _, conn in pairs(pgFun._antiFallConn) do
                if conn then conn:Disconnect() end
            end
            pgFun._antiFallConn = {}
        end
        local h = getHumanoid()
        if h then h.WalkSpeed = 16 end
        for _, track in ipairs(animTracks) do
            pcall(function() track:Stop() track:Destroy() end)
        end
        animTracks = {}
        if radarPoints then
            for _, point in pairs(radarPoints) do
                pcall(function() point:Destroy() end)
            end
            radarPoints = {}
        end
        if cache then
            for char, entry in pairs(cache) do
                pcall(function()
                    if entry.hl then entry.hl:Destroy() end
                    if entry.hb then entry.hb:Destroy() end
                end)
            end
            cache = {}
        end
        local boxGuiObj = PlayerGui:FindFirstChild("shible_BoxESP")
if boxGuiObj then pcall(function() boxGuiObj:Destroy() end) end
gui:Destroy()
blur:Destroy()
    end)
end

minBtn.MouseButton1Click:Connect(function()
    root.Visible = false
    mini.Visible = true
    makeTween(blur, {Size = 6}, 0.25)
    mini.Size = UDim2.new(0, 140, 0, 40)
    mini.BackgroundTransparency = 1
    makeTween(mini, {Size = UDim2.new(0, 160, 0, 48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back)
end)

restore.MouseButton1Click:Connect(function()
    mini.Visible = false
    root.Visible = true
    makeTween(blur, {Size = C.Blur}, 0.25)
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.4)
end)

closeBtn.MouseButton1Click:Connect(function()
    cleanupAll()
    pcall(function()
        _G._shible_AntiDetect = nil
        _G._shible_Fake = nil
        getgenv().AimbotEnabled = nil
        getgenv().SilentAim = nil
        getgenv().BulletTrackEnabled = nil
        getgenv().FlingAllEnabled = nil
        _G.BulletTrackEnabled = nil
        _G.FlingAllEnabled = nil
        _G.GroupVerified = nil
        _G.GroupCheck = nil
        _G.RequireGroup = nil
        _G.CheckAC = nil
        _G.AntiCheatCheck = nil
        _G.BanCheck = nil
        _G.ExploitCheck = nil
        _G.AC_Enabled = nil
        _G.AntiCheatEnabled = nil
        _G.BanDetect = nil
        _G.AntiCheat = nil
        _G.AC = nil
    end)
    Notify("shible", "已彻底关闭", 2)
end)

funcCloseBtn.MouseButton1Click:Connect(function()
    cleanupAll()
    pcall(function()
        _G._shible_AntiDetect = nil
        _G._shible_Fake = nil
        getgenv().AimbotEnabled = nil
        getgenv().SilentAim = nil
        getgenv().BulletTrackEnabled = nil
        getgenv().FlingAllEnabled = nil
        _G.BulletTrackEnabled = nil
        _G.FlingAllEnabled = nil
        _G.GroupVerified = nil
        _G.GroupCheck = nil
        _G.RequireGroup = nil
        _G.CheckAC = nil
        _G.AntiCheatCheck = nil
        _G.BanCheck = nil
        _G.ExploitCheck = nil
        _G.AC_Enabled = nil
        _G.AntiCheatEnabled = nil
        _G.BanDetect = nil
        _G.AntiCheat = nil
        _G.AC = nil
    end)
    Notify("shible", "已彻底关闭", 2)
end)

confirm.MouseButton1Click:Connect(function()
    makeTween(confirm, {TextSize = 16}, 0.12)
    task.delay(0.12, function()
        makeTween(confirm, {TextSize = 14}, 0.15)
    end)
    Notify("shible", "正在加载功能，请稍候...", 1)
    task.wait(0.8)
    if toggleSetters["开启预防检测"] then toggleSetters["开启预防检测"](true) end
    if toggleSetters["管理员检测"] then toggleSetters["管理员检测"](true) end
    if toggleSetters["绕过群组检测"] then toggleSetters["绕过群组检测"](true) end
    if toggleSetters["绕过AC检测"] then toggleSetters["绕过AC检测"](true) end
    makeTween(pageMain, {Position = UDim2.new(-1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageFunction.Visible = true
    pageFunction.Position = UDim2.new(1, 0, 0, 0)
    makeTween(pageFunction, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    backBtn.Visible = false
    funcCloseBtn.Visible = true
end)

backBtn.MouseButton1Click:Connect(function()
    makeTween(pageFunction, {Position = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageMain.Visible = true
    pageMain.Position = UDim2.new(-1, 0, 0, 0)
    makeTween(pageMain, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    task.delay(0.3, function()
        pageFunction.Visible = false
    end)
end)

root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundTransparency = 0.18
root.Visible = true
gui.Enabled = true
makeTween(blur, {Size = C.Blur}, 0.5)

Notify("shible", "加载成功", 2)

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        pcall(function()
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
