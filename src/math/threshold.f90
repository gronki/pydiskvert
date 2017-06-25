module slf_threshold

    use iso_fortran_env
    
    use precision

    implicit none

    real(fp), parameter, private :: pi = 4*atan(real(1,fp))

contains

    elemental real(fp) function THRSTEP(x) result(y)
        real(fp), intent(in) :: x
        if ( x .ge. 0 ) then
            y = 1.
        else
            y = 0.
        end if
    end function

    elemental real(fp) function THRLIN(x) result(y)
        real(fp), intent(in) :: x
        if ( x < -0.5_fp) then
            y = 0
        elseif ( x > 0.5_fp) then
            y = 1
        else
            y = x + 0.5_fp
        end if
    end function

    elemental real(fp) function THR2POLY(x,ord) result(y)
        real(fp), intent(in) :: x
        integer, intent(in), optional :: ord
        integer :: n
        real(fp) :: a, b

        n = 3
        if ( present(ord) )   n = ord

        a = THRLIN(0.5 + 2*x/n)
        b = THRLIN(0.5 - 2*x/n)

        y = (a**n - b**n + 1) / 2
    end function

    elemental real(fp) function THR4POLY(x,ord) result(y)
        real(fp), intent(in) :: x
        integer, intent(in), optional :: ord
        integer :: n
        real(fp) :: a, b, c

        n = 3
        if ( present(ord) )   n = ord

        a = THRLIN((3 + x*4)/2)
        b = 2*THRLIN(x) - 1
        c = THRLIN((3 - x*4)/2)

        y = (a**n - c**n + b*(2*n - abs(b)**(n-1)) + 2*n)/(4*n)

    end function

    elemental real(fp) function THRSIN(x) result(y)
        real(fp), intent(in) :: x
        real(fp) :: z

        z = 2*THRLIN(x / 2) - 1
        y =  (sin( pi * z) / pi + z + 1) / 2
    end function

    elemental real(fp) function THRATAN(x) result(y)
        real(fp), intent(in) :: x
        y = atan(x*pi) / pi + 0.5
    end function

    elemental real(fp) function thrsqrt(x) result(y)
        real(fp), intent(in) :: x
        y = 0.5_fp +  x / sqrt( 1 + 4 * x**2 )
    end function

    elemental real(fp) function thrtanh(x) result(y)
        real(fp), intent(in) :: x
        y = 1d0 / ( 1d0 + exp(-4*x) )
    end function




end module