module rk4settings

    use iso_fortran_env, only: r64 => real64

    implicit none

    !   którego równania użyc?
    integer, parameter ::   EQUATION_EQUILIBR   = 0, &
                        &   EQUATION_COMPTON    = 1, &
                        &   EQUATION_BALANCE    = 2
    integer :: cfg_temperature_method = EQUATION_EQUILIBR

    !   czy w rownaniach bilansu ma byc czlon comptonowski
    logical :: cfg_compton_term = .true.

    !   czy stosowac schemat eulera zamiast rk4
    logical :: cfg_euler_integration = .false.

    !   czy przeliczyc raz z danymi wartosciami centralnymi czy iterowac
    !   dla spelneia warunkow brzegowych?
    logical :: cfg_single_run = .false.

    !   jaki jest dopuszczalny blad iteracji
    real(r64) :: max_iteration_error = 1e-6

    !  czy rozwiazywac wolniejsza metoda dajaca wszystkie rozwiazania
    logical :: cfg_balance_multi = .false.

    !   czy umozliwic wylaczenie MRI?
    logical :: cfg_allow_mri_shutdown = .false.

contains

    subroutine CMDLINE_RK4
        integer :: i,errno
        character(2**8) :: arg, nextarg

        iterate_cmdline_arguments: do i = 1, command_argument_count()
            call get_command_argument(i, arg)
            select case (arg)
            case ("-dynamo-shutdown","-shutdown")
                cfg_allow_mri_shutdown = .TRUE.
            case ("-no-dynamo-shutdown","-no-shutdown")
                cfg_allow_mri_shutdown = .FALSE.
            case ("-single")
                cfg_single_run = .TRUE.
            case ("-euler","-no-rk4")
                cfg_euler_integration = .TRUE.
            case ("-no-euler","-rk4")
                cfg_euler_integration = .FALSE.
            case ("-compton")
                cfg_temperature_method = EQUATION_COMPTON
            case ("-balance")
                cfg_temperature_method = EQUATION_BALANCE
                cfg_balance_multi = .false.
            case ("-balance-multi")
                cfg_temperature_method = EQUATION_BALANCE
                cfg_balance_multi = .true.
            case ("-equilibrium")
                cfg_temperature_method = EQUATION_EQUILIBR
            case ("-max-iteration-error","-precision")
                call get_command_argument(i+1,nextarg)
                read (nextarg,*,iostat=errno) max_iteration_error
                if ( errno .ne. 0 ) then
                    error stop "-precision must be followed by an argument" &
                                & // " (relative error to be reached until " &
                                & // " iteration stops)"
                end if

            end select
        end do iterate_cmdline_arguments
    end subroutine

end module
