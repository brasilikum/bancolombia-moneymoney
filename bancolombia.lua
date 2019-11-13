Importer{version=1.00, format="Bancolombia 'Excel'", fileExtension="xls"}

local function strToDate (str)
  -- Helper function for converting localized date strings to timestamps.
  local y, m, d = string.match(str, "(%d%d%d%d)/(%d%d)/(%d%d)")
  return os.time{year=y, month=m, day=d}
end

function ReadTransactions (account)
  -- Read transactions from a file with the format "date<TAB>amount<TAB>purpose".
  local transactions = {}
  local linecount = 0
  for line in assert(io.lines()) do
    print(linecount)
    if linecount ~= 0 then --ignore description
        local values = {}
        for value in string.gmatch(line, "[^\t]+") do
            table.insert(values, value)
        end
        if #values >= 4 then
        
        print(values[1], "-", values[2], "-", values[3], "-", values[4], "-", values[5])
        local amountString = values[5]:gsub(",", "")
        local transaction = {
            bookingDate = strToDate(values[1]),
            -- values[2] is empty
            name = values[3],
            purpose = values[4],
            amount = tonumber(amountString),--tonumber gets confused by commas
            currency = "COP"
        }
        print(tonumber(values[5]))
        table.insert(transactions, transaction)
        end
    end
    linecount = linecount + 1
  end
  return transactions
end
