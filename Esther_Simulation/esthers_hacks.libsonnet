{
	"0" : [
		# Base, no hacking
    ],
    "1": [
    	{
        "type": "Outcome Switching",
        "preference": "MinPvalue"
      }
    ],
	"2" : [
        {
          "type": "OptionalStopping",
          "size": 3,
          "attempts": 10
        }
    ],
    "3" : [
        {
          "type": "Outcome Switching",
          "preference": "MinPvalue"
        },
        {
          "type": "OptionalStopping",
          "size": 0,
          "attempts": 3
        }
    ]
}