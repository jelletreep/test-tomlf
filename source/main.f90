program main

    use, intrinsic :: iso_fortran_env, only: stderr => error_unit
    use tomlf
    implicit none

    integer                       :: fu, rc
    logical                       :: file_exists
    type(toml_table), allocatable :: table
    type(toml_table), pointer     :: child
    
    character(len=*), parameter :: FILE_NAME = 'settings/model-settings.toml'
    character(len=:), allocatable :: ice

    inquire (file=FILE_NAME, exist=file_exists)
    
        if (.not. file_exists) then
        write (stderr, '("Error: TOML file ", a, " not found")') FILE_NAME
        stop
    end if

    open (action='read', file=FILE_NAME, iostat=rc, newunit=fu)

    if (rc /= 0) then
        write (stderr, '("Error: Reading TOML file ", a, " failed")') FILE_NAME
        stop
    end if

    call toml_parse(table, fu)
    close (fu)

    if (.not. allocated(table)) then
        write (stderr, '("Error: Parsing failed")')
        stop
    end if

    ! find section.
    call get_value(table, 'thermal_conductivity', child, requested=.false.)

    if (associated(child)) then
        ! get value
        call get_value(child, 'ice', ice, 'N/A')
        print *, " "
        print *, "----- Using thermal conductivity of ice: ", ice
    end if

    deallocate (table)
    
end program main
