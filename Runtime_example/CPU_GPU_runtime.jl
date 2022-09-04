using DFTK
using LinearAlgebra
using MKL

# # For the CPU version, uncomment the following line and launch julia with 8 threads.
DFTK.setup_threading()

# # For the GPU version, uncomment the previous and next line. Launch julia with 1 
# # thread. See also line 28.
# using CUDA

function main()
    a = 10.263141334305942  # Lattice constant in Bohr
    lattice = a / 2 .* [[0 1 1.]; [1 0 1.]; [1 1 0.]]
    Si = ElementPsp(:Si, psp=load_psp("hgh/lda/Si-q4"))
    atoms     = [Si, Si]
    positions = [ones(3)/8, -ones(3)/8]
    pystruct = pymatgen_structure(lattice, atoms, positions)
    super_params = [4,4,2]
    pystruct.make_supercell(super_params)
    lattice   = load_lattice(pystruct)
    positions = load_positions(pystruct)
    atoms     = fill(Si, length(positions))
    terms_LDA = [Kinetic(), AtomicLocal(), AtomicNonlocal()]
    model = Model(lattice, atoms, positions; terms=terms_LDA,symmetries=false)
    
    println("Building basis")
    basis = PlaneWaveBasis(model; Ecut=30, kgrid=(1, 1, 1))
    # # Comment the previous line, and uncomment the next line for the GPU test
    # basis = PlaneWaveBasis(model; Ecut=30, kgrid=(1, 1, 1), array_type = CuArray)
    
    println("Running computations")
    self_consistent_field(basis; tol=1e-3, solver=scf_damping_solver(1.0))
    DFTK.reset_timer!(DFTK.timer)
    # Re-run the computations so as not to count compilation time
    self_consistent_field(basis; tol=1e-3, solver=scf_damping_solver(1.0))
    print(DFTK.timer)
end

main()

