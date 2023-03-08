function getRandomName(ped,gender)
    if not gender then gender = "male" end;
    fetchRemote("https://randomuser.me/api/?format=json&nat=US&gender="..gender.."&inc=gender,name,nat",function(data)
        local temp = fromJSON(data);
        setElementData(ped,"ped >> name", firstToUpper(temp["results"][1]["name"]["first"]) .. " " .. firstToUpper(temp["results"][1]["name"]["last"]) );
    end,nil,true);
end
