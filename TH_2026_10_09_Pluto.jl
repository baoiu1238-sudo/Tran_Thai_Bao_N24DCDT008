### A Pluto.jl notebook ###
# v0.20.0

# ╔═╡ 09102026-0000-4000-8000-000000000001
begin
    using Markdown
    READ_DATA = true
    RUN_APP = true
    ROOT_DATA = joinpath(@__DIR__, "data")
end

# ╔═╡ 09102026-0000-4000-8000-000000000002
AppCore = let
    sandbox = Module(:ThucHanhNgay0910)
    Base.include(sandbox, joinpath(@__DIR__, "TH_2026_10_09_Sinh_vien.jl"))
    Base.invokelatest(getfield, sandbox, :GiaoDon)
end

# ╔═╡ 09102026-0000-4000-8000-000000000003
md"""
# Điều phối giao đơn bằng Julia

Notebook này nạp cùng lõi `TH_2026_10_09_Sinh_vien.jl` của ứng dụng. Luồng dữ liệu là CSV đơn hàng và bản đồ → BFS tìm đường ít cạnh nhất → tính chi phí → quy hoạch động chọn đơn → giao/hoàn tác → xuất CSV.

Dữ liệu MINI001 cần có trong thư mục `data/MINI001`. Chạy `julia TH_2026_10_09_Sinh_vien.jl --data --mini` từ thư mục dự án nếu cần tạo lại CSV đầu vào.
"""

# ╔═╡ 09102026-0000-4000-8000-000000000004
ho_so = AppCore.mini_profile()

# ╔═╡ 09102026-0000-4000-8000-000000000005
du_lieu = READ_DATA ? AppCore.read_data(joinpath(ROOT_DATA, "MINI001")) : nothing

# ╔═╡ 09102026-0000-4000-8000-000000000006
bao_cao = !RUN_APP || du_lieu === nothing ? nothing : let
    s = AppCore.build_session(du_lieu.orders, du_lieu.edges, ho_so)
    r = AppCore.plan!(s)
    trace = NamedTuple[]
    save(label) = push!(trace, (buoc=label, queue=AppCore.queue_values(s.pending),
                               stack=copy(s.completed), spent=s.spent, earned=s.earned))

    save("Sau lập kế hoạch")
    AppCore.deliver!(s)
    save("Sau giao một đơn")
    AppCore.undo!(s)
    save("Sau hoàn tác")
    while s.pending.count > 0
        AppCore.deliver!(s)
    end
    save("Sau giao hết")

    csv_path = AppCore.export_result(s, joinpath(ROOT_DATA, "MINI001", "ket_qua.csv"))
    (chi_phi=copy(s.costs), tuyen=deepcopy(s.routes), chon=copy(s.selected_ids),
     loi_ich_toi_uu=r.optimal.value, truy_vet=trace,
     bat_bien=AppCore.check_invariants(s), csv=csv_path)
end

# ╔═╡ 09102026-0000-4000-8000-000000000007
md"""
## Quy hoạch động và truy vết

Với ngân sách 8, ô `F(2,8)` xét hai phương án: bỏ đơn 2 được `F(1,8)=6`; lấy đơn 2 tốn 5, còn 3 và được `F(1,3)+8=14`. Vì vậy `F(2,8)=14`, nằm tại `table[3,9]` trong Julia.

Nhánh lấy tham chiếu hàng trước để mỗi đơn chỉ được chọn một lần. Kết quả DP được đối chiếu với bộ vét cạn trên cùng dữ liệu.
"""

# ╔═╡ 09102026-0000-4000-8000-000000000008
md"""
## Kết quả và minh chứng

- Đơn được chọn, chi phí, tuyến, trạng thái FIFO và ngăn xếp được hiển thị trong ô kết quả bên dưới.
- CSV kết quả được ghi tại `data/MINI001/ket_qua.csv`.
- Bổ sung link GitHub trực tiếp tới notebook sau khi tải tệp này lên repository; ghi kèm commit chứa notebook trong phiếu.
"""

# ╔═╡ 09102026-0000-4000-8000-000000000009
if RUN_APP && bao_cao !== nothing
    println("Kết quả từ cùng lõi ứng dụng Julia:")
    show(stdout, "text/plain", bao_cao)
    println()
end

# ╔═╡ Cell order:
# ╠═09102026-0000-4000-8000-000000000001
# ╠═09102026-0000-4000-8000-000000000002
# ╠═09102026-0000-4000-8000-000000000003
# ╠═09102026-0000-4000-8000-000000000004
# ╠═09102026-0000-4000-8000-000000000005
# ╠═09102026-0000-4000-8000-000000000006
# ╠═09102026-0000-4000-8000-000000000007
# ╠═09102026-0000-4000-8000-000000000008
# ╠═09102026-0000-4000-8000-000000000009
