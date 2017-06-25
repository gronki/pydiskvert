module slf_bisect

    use iso_fortran_env

    use precision

    implicit none

contains

    subroutine bisect(f,x,xlo0,xhi0,delx)
        real(fp), intent(in) :: xhi0,xlo0,delx
        real(fp), intent(out) :: x
        real(fp) :: xhi,xlo,yhi,ylo,y,s
        integer :: i,n

        interface
            pure subroutine f(x,y)
                import fp
                real(fp), intent(in) :: x
                real(fp), intent(out) :: y
            end subroutine
        end interface

        n = log(abs((xhi0-xlo0)/delx))/log(2.0)

        xlo = xlo0
        xhi = xhi0
        call f(xlo,ylo)
        call f(xhi,yhi)
        s = sign(real(1,fp),yhi-ylo)

        sect_loop: do i = 1, n

            x = ( xhi + xlo ) / 2
            call f(x,y)

            if ( y * s > 0 ) then
                xhi = x
            elseif ( y * s < 0 ) then
                xlo = x
            else
                exit sect_loop
            end if

            if ( abs(xhi-xlo) < abs(delx) ) exit sect_loop
        end do sect_loop

    end subroutine

end module