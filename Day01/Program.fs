open System
open System.IO

let getTotalCalories elf =
    elf |> Array.map int |> Array.sum

let findSortedElfTotals (input: string) =
    input.Split([| "\n\n" |], StringSplitOptions.None)
    |> Array.map (fun e -> e.Split [| '\n' |])
    |> Array.map getTotalCalories
    |> Array.sortDescending

let elfTotals = File.ReadAllText "input" |> findSortedElfTotals

printfn $"The elf with the most calories has {elfTotals[0]} calories"
printfn $"The top three elves are carrying {elfTotals[0] + elfTotals[1] + elfTotals[2]} calories"
