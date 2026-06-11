      module memory_pool
        implicit none
            real*8, allocatable :: evalv(:,:,:,:)
            real*8, allocatable :: ovv(:,:,:,:,:,:)
            real*8, allocatable :: rotm(:,:,:,:)
            real*8, allocatable :: rott(:,:,:,:,:)
            real*8, allocatable :: tori(:,:,:,:,:,:)
            real*8, allocatable :: mvec(:,:,:)
            real*8, allocatable :: dnvtmp(:,:)
            real*8, allocatable :: dnvsav(:,:)
            real*8, allocatable :: dnv(:,:,:)
            real*8, allocatable :: darot(:,:,:)
            real*8, allocatable :: h(:,:)
            real*8, allocatable :: hs(:,:,:,:)
            real*8, allocatable :: zr(:,:)
            real*8, allocatable :: zi(:,:)
            real*8, allocatable :: zrs(:,:,:,:)
            real*8, allocatable :: zis(:,:,:,:)
      end module memory_pool