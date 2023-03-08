jobs = {
    [1] = {"Charika Jihaweya Lel Na9l","Transport the passengers.","Bus driver"},
    [2] = {"Transporteur Fel Bort","Unpack the boxes from the ship.","Dock worker"},
    [3] = {"3amel Bel STEG","Repair the electrical network.","Electrician"},
    [4] = {"Fosfat gafsa","Mining precious ores.","Miner"},
    [5] = {"7attab","Cut down the trees and transport them.","lumberjack"},
    --[6] = {"Chili Dogs Co.","Serve the people."}
}

function getJobName(id)
    if jobs[id] then 
        return jobs[id][3];
    else 
        return "Unknown";
    end
end