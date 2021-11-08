program foo
  use iso_fortran_env, only: int64, real64
#ifdef DCAF_ACC
  use openacc
#endif
#ifdef DCAF_OMP
  use omp_lib
#endif
  ! use mpi_f08
  implicit none
  integer :: n
  integer :: m
  integer, allocatable, dimension(:,:) :: A, B, C, D, E, F
  integer, allocatable :: recv(:,:)[:]
  character(20) :: argv
  integer :: i, j, num, num_d, me, me_d, ierr, tag
  integer :: report, f
  integer :: count_max, count_rate, count_start, count_end
  real    :: start, end, time


  call get_command_argument(1, argv)
  read(argv, *) n
  m = n

  call system_clock(count_start, count_rate, count_max)

  allocate(A(n,m))
  allocate(B(n,m))
  allocate(C(n,m))
  ! allocate(D(n,m))
  ! allocate(E(n,m))
  ! allocate(F(n,m))
  allocate(recv(n,m)[*])


  me = this_image()
  ! call MPI_Init(ierr)
  ! call MPI_Comm_rank(MPI_COMM_WORLD, me, ierr)
  ! call MPI_Comm_size(MPI_COMM_WORLD, num, ierr)
  A = 0
  B = me
  C = me


  sync all

#ifdef DCAF_ACC

  call acc_set_device_num(me-1, ACC_DEVICE_NVIDIA)
  ! num_d = acc_get_num_devices(ACC_DEVICE_NVIDIA)
  ! me_d  = acc_get_device_num(ACC_DEVICE_NVIDIA)
  ! print *, me, "num devices", num_d, "first get device num", me_d
  ! print *, me, "get_num_devices", acc_get_num_devices(ACC_DEVICE_NVIDIA), &
  !      "get_device_num", acc_get_device_num(ACC_DEVICE_NVIDIA)
#endif

  ! print *, me, ": num images", num_images()
  sync all

  ! call MPI_Barrier(MPI_COMM_WORLD)



  ! if (me == 2) then
#ifdef DCAF_DC
  do concurrent (i=1:n,j=1:m)
#endif
#ifdef DCAF_ACC
  !$acc parallel loop
  do j=1,n
      do i=1,m
#endif
#ifdef DCAF_OMP
  !$omp target parallel do simd
  do j=1,n
      do i=1,m
#endif
#ifdef DCAF_DO
  do j=1,n
      do i=1,m
#endif
        A(i,j) = B(i,j) + C(i,j)
        ! A(i,j) = B(i,j) + C(i,j)
        ! report = acc_get_device_num(ACC_DEVICE_NVIDIA)

#ifdef DCAF_ACC
      end do
  end do
  !$acc end parallel loop
#endif
#ifdef DCAF_OMP
      end do
  end do
  !$acc end target parallel
#endif
#ifdef DCAF_DC
  end do
#endif
#ifdef DCAF_DO
      end do
  end do
#endif

  if (me .eq. 2) then
     recv(:,:)[1] = A
     sync all
  else
     sync all
     A = recv
  end if

  sync all
  call system_clock(count_end, count_rate, count_max)

  start = real(count_start)/ count_rate
  end = real(count_end)/ count_rate
  time = end-start

  if (me == 1) then
      f = 7
      open(f, file="output.txt", status="old", access="append")
      write(f, '(i15,i15,f20.10)') n, m, time
      close(f)
  end if


  print *, "fin"
end program
