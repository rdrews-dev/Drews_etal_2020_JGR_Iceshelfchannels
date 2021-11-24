!-------------------------------------------------------------------------------
! File: MeltingRD.f90
! Written by: ML, June 2018
! Modified by: -
!-------------------------------------------------------------------------------
FUNCTION MeltingRD(Model, n, f) RESULT(g)
USE DefUtils
TYPE(Model_t) :: Model
INTEGER :: n
REAL(KIND=dp) :: f, g, x

x = Model % Nodes % x(n)
!write(*,*) 'This is 50.0 *f', 5.0*f
g = 0.3 + 1.0*EXP(-((x-15.0*f)**2)/300000.0)
END FUNCTION MeltingRD
