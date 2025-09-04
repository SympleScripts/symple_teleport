
Symple_teleport,
A standalone teleport system designed for police departments in FiveM, allowing officers to quickly travel to the north end of the map and return to their original location.

Features,
Quick North Travel: Instantly teleport to the north end of the map,
Return Function: Go back to your previous location with ease,
Police Department Focus: Designed specifically for law enforcement roleplay,
Standalone: No dependencies required - plug and play,
Customizable Locations: Easily modify teleport coordinates in the client file,
Lightweight: Minimal resource usage,

Installation,
Download the script,
Extract the symple_teleport folder to your FiveM server's resources directory,
Add ensure symple_teleport to your server.cfg,
Restart your server or use refresh and start symple_teleport,

Configuration,
All teleport locations can be customized within the client file. Simply edit the coordinates to match your server's specific needs:

-- Example coordinates (modify as needed)
local northLocation = {x = 0.0, y = 8000.0, z = 0.0}  -- North end of map
local returnLocation = {x = 0.0, y = 0.0, z = 0.0}    -- Return point


Usage,
The script provides commands or key bindings (depending on implementation) that allow police officers to:

Teleport to the designated north location,
Return to their previous position,

Note: Specific usage instructions may vary based on your server's command structure.

Requirements,
FiveM Server,
No additional dependencies required,

Compatibility,
 Standalone script,
 Works with most FiveM frameworks,
 ESX compatible,
 QBCore compatible,
 Vanilla FiveM servers,

Support,
If you encounter any issues or have suggestions for improvements, please open a ticket on discord https://discord.gg/rX7bWcNm
