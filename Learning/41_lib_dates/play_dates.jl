# play_dates.jl
# Test with Julia dates
#
# 2024-05-11    PV

using Dates

french_months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
french_months_abbrev =  ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"]
french_days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
french_days_abbrev = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]
Dates.LOCALES["french"] = Dates.DateLocale(french_months, french_months_abbrev, french_days, french_days_abbrev)


println(Date("02-03-2024", dateformat"d-m-y"))                  # 2024-03-02, decode using European format
println(Date("02-03-2024", dateformat"m-d-y"))                  # 2024-02-03, decode using US format
println()

d = DateTime("2024-04-28 16:25:12", "yyyy-mm-dd HH:MM:SS")
println(Dates.format(d, "e d u Y, H:MM:SS", locale="french"))   # Dim 28 Avr 2024, 16:25:12
println(Dates.format(d, "E d U Y, H:MM", locale="french"))      # Dimanche 28 Avril 2024, 16:25
println()

println(parse(Date, "06.23.2013", dateformat"m.d.y"))           # 2013-06-23            In case of error, throws ArgumentError: Unable to parse date time.
println(tryparse(DateTime, "1999-12-31T23:59:59"))              # 1999-12-31T23:59:59   Uses the default format. tryparse returns nothing in case of error
println()

# Next Friday 13th
nextFriday13 = Dates.tonext(Dates.today()) do d
    Dates.dayofweek(d)==Dates.Friday && Dates.day(d)==13
end
println(Dates.format(nextFriday13, "e d u yy"))
println(Dates.format(nextFriday13, "E d U yyyy"))
println()

# First friday of current month
firstFriday = tonext(d -> dayofweek(d)==Friday, firstdayofmonth(today()))
println("First Friday of ", monthname(today()), ' ', year(today()), ": ", firstFriday)
# Last friday of current month
lastFriday = tonext(d -> dayofweekofmonth(d)==daysofweekinmonth(d), firstFriday, step=Week(1))
@assert dayofweek(lastFriday)==Friday
println("Last Friday of ", monthname(today()), ' ', year(today()), ": ", lastFriday)
println()

# Pack in a function
last_weekday_of_current_month(weekDay::Int) = tonext(d -> dayofweekofmonth(d)==daysofweekinmonth(d) && dayofweek(d)==weekDay, firstdayofmonth(today()))
@assert last_weekday_of_current_month(Friday)==lastFriday

println("Trimestre courant: ", Dates.format(firstdayofquarter(today()), "E d U yyyy"), " - ",  Dates.format(lastdayofquarter(today()), "E d U yyyy"), '\n')

dd = today()-Date("1965-02-26")          # 21625 days
dt = Date(0)+dd                          # 0059-03-17
println(year(dt), " ans, ", month(dt), " mois, ", day(dt), " jour(s)\n")
