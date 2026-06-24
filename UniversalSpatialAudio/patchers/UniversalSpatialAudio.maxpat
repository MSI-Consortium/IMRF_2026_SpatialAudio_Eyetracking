{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 9,
			"minor" : 0,
			"revision" : 5,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 346.0, 252.0, 1243.0, 719.0 ],
		"gridsize" : [ 15.0, 15.0 ],
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-17",
					"linecount" : 7,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 735.0, 383.5, 152.0, 100.0 ],
					"text" : "Probably all spalization (binaural, vbap, ambi, allrad, vbip, etc) should be handled using Spat5 instead of the tools we are currently using. But this works for now."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-32",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 492.0, 332.0, 1000.0, 585.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-3",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 299.0, 451.0, 30.0, 30.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 299.0, 451.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-37",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 551.0, 281.0, 599.0, 575.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 54.0, 441.0, 123.0, 22.0 ],
													"text" : "r speakers_ambipoint"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "multichannelsignal" ],
													"patching_rect" : [ 54.0, 537.0, 127.0, 22.0 ],
													"saved_object_attributes" : 													{
														"active" : [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
														"gain" : 1.0,
														"interpolation" : 1,
														"order" : 5,
														"rotate_order" : 0
													}
,
													"text" : "mc.ambidecode~ 5 24"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-14",
													"lastchannelcount" : 36,
													"maxclass" : "mc.live.gain~",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "multichannelsignal", "", "float", "list" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 267.850000000000023, 299.0, 217.0, 122.0 ],
													"saved_attribute_attributes" : 													{
														"valueof" : 														{
															"parameter_longname" : "mc.live.gain~[15]",
															"parameter_mmax" : 6.0,
															"parameter_mmin" : -70.0,
															"parameter_modmode" : 3,
															"parameter_shortname" : "mc.live.gain~[12]",
															"parameter_type" : 0,
															"parameter_unitstyle" : 4
														}

													}
,
													"varname" : "mc.live.gain~"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-11",
													"linecount" : 2,
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 99.0, 161.0, 150.0, 33.0 ],
													"text" : "For some reason this r object does not work??? "
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 173.0, 506.0, 164.0, 22.0 ],
													"presentation" : 1,
													"presentation_linecount" : 3,
													"presentation_rect" : [ 188.0, 485.0, 100.0, 49.0 ],
													"text" : "mc.send~ gm_ambi_decoder"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-5",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 75.0, 206.0, 121.0, 22.0 ],
													"presentation" : 1,
													"presentation_linecount" : 3,
													"presentation_rect" : [ 280.0, 294.0, 100.0, 49.0 ],
													"text" : "r ambi_decoder_gain"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-3",
													"maxclass" : "number",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"parameter_enable" : 0,
													"patching_rect" : [ 242.0, 241.0, 50.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ -13.0, 795.0, 50.0, 22.0 ]
												}

											}
, 											{
												"box" : 												{
													"bgmode" : 0,
													"border" : 0,
													"clickthrough" : 0,
													"enablehscroll" : 0,
													"enablevscroll" : 0,
													"id" : "obj-9",
													"lockeddragscroll" : 0,
													"lockedsize" : 0,
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 7,
													"offset" : [ 0.0, 0.0 ],
													"outlettype" : [ "multichannelsignal", "", "list", "int", "", "", "" ],
													"patching_rect" : [ 367.0, 506.0, 168.0, 22.0 ],
													"save" : [ "#N", "mcs.vst~", "loaduniqueid", 0, 36, 24, "AllRADecoder", ";" ],
													"saved_attribute_attributes" : 													{
														"valueof" : 														{
															"parameter_invisible" : 1,
															"parameter_longname" : "mcs.vst~[1]",
															"parameter_modmode" : 0,
															"parameter_shortname" : "mcs.vst~",
															"parameter_type" : 3
														}

													}
,
													"saved_object_attributes" : 													{
														"parameter_enable" : 1,
														"parameter_mappable" : 0
													}
,
													"snapshot" : 													{
														"filetype" : "C74Snapshot",
														"version" : 2,
														"minorversion" : 0,
														"name" : "snapshotlist",
														"origin" : "mcs.vst~",
														"type" : "list",
														"subtype" : "Undefined",
														"embed" : 1,
														"snapshot" : 														{
															"pluginname" : "AllRADecoder.vst3",
															"plugindisplayname" : "AllRADecoder",
															"pluginsavedname" : "",
															"pluginsaveduniqueid" : 0,
															"version" : 1,
															"isbank" : 0,
															"isbase64" : 1,
															"blob" : "4671.VMjLgXiD...O+fWarAhckI2bo8la8HRLt.iHfTlai8FYo41Y8HRUTYTK3HxO9.BOVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9LCMwfiKV0jZLcFUQMjKt3xSqX1UgIWPnM1ZIIiXugCaggCRRwDctjFRlQEagkFNFk0azDSV3fjTUQUVTszLHg2S43hPOEzcFElTEQTTq0TLgoVUrIVN1MDUAkTUP0TPRokZvjFRpUULXUWTVkEd3nlXpUEahglKnM1Y2Y0XqASZHo2LBwDZ2f1S23RUPIUQTMkYpYTV3fjTYMSPxDFdQcTTq0TLgoVUrIFZtf1XmcmUisFLogzcyHDSncCZOciKUAkTEQ0TlolQYgCRRk0LAISX3E0QSc1ZxDFLQ0FRlg0UXIWUWkENHIESz4RZHU2LC8DTEoFUAACQH8VTV8DZpwVX1U0Qi8TRGk0ZIICUqE0Qi8FMwjEZtf1XmcmUisFLogjcyHDSncCZOciKUAkTEQ0TlolQYgCRRMVdUECUN0zPQglKnM1Y2Y0XqASZHc2LBwDZ2f1S23RUPIUQTMkYpYTV3fDdis1ZwjkaQIiXn4BZic1cVM1ZvjFR2MiPLg1Mn8zM2nGUC0jdgQWVVoUaAgFUq0jUY8VVWkEdAASX3E0UOgldRwDZtfGUqQiQYsVRWIETvjFRn4BdTsFMFk0ZIcDU0kzQigCRRszcHIDRSUEagoVUrI1SMACTAEkQYgWUwHVdvjFR0QDQgIWRUAEQUECV0EkUYgGNngjYLUUVzEkUYg2ZpEldUwlXwTjQggCRRwjctjFR0MyPOwDNVMlZMcjXqUTLZsVRxHVN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5gGS3MiPLglKREkbUw1XmE0UZUGMV8DZ5IESzLCdLQiZS4DMpkVS2Y1TMkmKowjLHIDRRUjQY8VUxHFNHgFSzA0PMYmKCwjctLUSxfTZLYGTS0DMHIDRCclUXQGMVkkbvjFR2gjPHkDLVgUaqwVXmkzUjgCRBwDZtfWTmsFaggCRRwDctjFR0MyPOUzcVk0bUwVX5EjTPUyZVEFLQcjV3fjTLQyLBwDZtHUTxUEaicVTWoUczX0SnomPMQGUogjYHUEVpslUikGLogDdyHES44xPLYmKSwzcPMTS54xTNcmYogjYLQjVmQCags1cV8DZHkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyQTdMQmKogjYTQTXqk0UXo2ZwDFcvjFRxLCdLYmKCwjctLESz3RdMkGTC4TLLkFRlgTUXo1ZVMVdvjFR3MiPLgmZS4DMpMkSxPTdLMiZ40jLDkFRlwDQZcFMrE1Z2Y0SnwTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHkGRosjcHIDREcmUYESQFM1a3vVX3fjTLQyLnwjctLDS14RdMECRS4TdpMTSvfjPHIUQFk0aUIiX3fDZLQGUS0DMpMkSzn1PMgmX40DMTMTS2gjPHMzYVgEczXUVxASZHoGRBgTRvXEVssFagcVRWQFNHIDSn4BdQc1ZrEFNHIESz4RZHU2LC8TQ2YUVyUEagoWPRAUMqYUXvD0QZgCRRszcDk1R1gjPHUzcVkULEYzXugCaggCR3wjLyfWS14xPLYmK40TLHMkS4o1PMACRBgjTEYTVuUkLhgCRnwDcLMTSzn1TNQiZCwjdXkGS3QUZMMCRBgzPmYEVzQiUYIGLogDLHIDRIAiUX01ZrE1YIcEY3fjPLglK3E0YqwVX3fjTLQmKogTcyLzSEcmUYMWUrEldAIET0rlUgASTGoENHI0R2gTZLQmKogjYTQTXqk0UXo2ZwDFcvjFRyQTdMQGUogjYHUEVpslUikGLogDdyfVS44xPLYmKSwzcPMTS54xTNcmYogjYLQjVmQCags1cV8DZXkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyI1TNQmKogjYTQTXqk0UXo2ZwDFcvjFRyQUZKEiZS4DMpMkSy3xTNgGVS0zcLkWSn4BZTcVTVoELMc0SngTZKgGUogjYLQjVmQCags1cV8DZhkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyo1TMQmKogjYTQTXqk0UXo2ZwDFcvjFRwLiTNYmKCwjctLDSzPUdLEiXC0TdHkFRlgTUXo1ZVMVdvjFR3MCZLomKCwjctLDS1o1TMkGV40jdLkFRlwDQZcFMrE1Z2Y0SnYVZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGUo0DctjFRlQEQgsVVWgkdqESXzASZHcmXosjLtLDS14xPLICVowDMLMkS5QUZHYFRUgkZqY0X4ASZHg2L30TLpMkSzn1TNMiKS4DdXMUS2AUZHYFSDo0YzvVXqcmUOglZogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzbpMUSz4RZHYFUDE1ZYcEV5sVLgQGLogTdpk1R54xPLYmKSwDLHMUSyH1PNQCQogjYHUEVpslUikGLogDdyHTSy3xPLYmKCwzcpMDSxvzPMMCVogjYLQjVmQCags1cV8DZDMDSn4hTRMWQwj0azXEV3s1UOglKogjYhQEVuQiUOgFQosjcHg2R4X2TQIWUVE1ZzXzXlQjZj8FLVMldmY0SnQzPMIyLBwDZtHUTxUEaicVTWoUczX0SnomTLEyLRwjctLDS14RdLMCQC0TLpkWS4gjPHIUQFk0aUIiX3fDZLQGVC0jctLDS1QzPLomZCwjdDkWSvfjPHMzYVgEczXUVxASZHcGQogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzbDkVSvLiPLglKREkbUw1XmE0UZUGMV8DZ5IUSzA0PLYmKCwjctLkSvvTZMICT4wDdHIDRRUjQY8VUxHFNHgFSz4RZMQiZS4DMpkGS4gzPMgmXS4zLHIDRCclUXQGMVkkbvjFR2gTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHcGVowDctjFRlQEQgsVVWgkdqESXzASZHEyLR0DMpMkSzn1TNYGTo0TdHMUSwXVZHYFRUgkZqY0X4ASZHg2LRwjdtLDS14xTLYGTS4jcPMESxPUZHYFSDo0YzvVXqcmUOgFQ4wDZtHkTyUTLY8FMVgEdqc0Sn4RZHYlXTg0azX0SnQTZKYGR3sTN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5IESvvTZKYGRBgTQ2YUVwTjQi8FNrEFNHIESwLCdMYmKCwjctjWSwfzTNkmZC0DLHIDRRUjQY8VUxHFNHgFSzA0PMYmKCwjctLUSxfTZLYGTS0DMHIDRCclUXQGMVkkbvjFR2AUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGQo0jcyHDSn4hTQIWUrM1YQckV0QiUOgFS40DcTMkSzn1TNMCT40jdDkFS24xTNglKnQ0YQYkVvzzUOgFRosDdhMkSzn1TNQiXSwTdlMkSxH1TLglK3AkaEwVXzUkQggCRRwDLHIDRIAiUX01ZrE1YIcEY3fjPLglK3E0YqwVX3fjTLQmKogTcyLzSEcmUYMWUrEldAIET0rlUgASTGoENHIUSxLiPLglKREkbUw1XmE0UZUGMV8DZ5IESxLCdMYmKCwjctjWSwfzTNkmZC0DLHIDRRUjQY8VUxHFNHgFSzg0TLQiZS4DMlMjSvP0TMQiKC4DdHIDRCclUXQGMVkkbvjFR2gUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHQCVosjcHIDREcmUYESQFM1a3vVX3fjTKEyL3wjctLDS14xTLQiK40TdPMjSwvTZHYFRUgkZqY0X4ASZHg2LnwDLHIDRCclUXQGMVkkbvjFR2IVZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHICVosjcHIDREcmUYESQFM1a3vVX3fjTNQGQCwjctLDS1wzPNcGTo0DMhkFSxfjPHIUQFk0aUIiX3fDZLQGS4wDMpMkSzn1TLoGQo0DMLMES3gjPHMzYVgEczXUVxASZHcmYogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzcDMkSz4RZHYFUDE1ZYcEV5sVLgQGLogzchk1Ryn1TNQiZS4TLDMjSvvzPLgmXogjYHUEVpslUikGLogDdyfVSw3xPLYmKCwzLTMjS44RZMMiYogjYLQjVmQCags1cV8DZDMkSn4hTRMWQwj0azXEV3s1UOglKogjYhQEVuQiUOgFQosjcHg2R4X2TQIWUVE1ZzXzXlQjZj8FLVMldmY0SnYVdMQmKogjYTQTXqk0UXo2ZwDFcvjFR4IVZKQiKCwjctLESvfzTMMiXC4DMDkFRlgTUXo1ZVMVdvjFR3MCZMcmZS4DMpMjSyP0TMAiZCwzLHkFRlwDQZcFMrE1Z2Y0SngzPLglKRI0bEESVuQiUXg2ZW8DZtjFRlIFUX8FMV8DZDk1R1gDdKkicSEkbUYUXqQiQiYFQpQ1avX0X5clUOgFT4wDctjFRlQEQgsVVWgkdqESXzASZHACVosjcHIDRRUjQY8VUxHFNHgFSzA0TLYmKCwjctLjSvXVdLYGVC4zLHIDRCclUXQGMVkkbvjFR3QTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGT4wDctjFRlQEQgsVVWgkdqESXzASZHACVosjLpMkSzn1TNgGS40jcXMDSvPUZHYFRUgkZqY0X4ASZHg2LRwzLtLDS14xPLECV40DLhkFS1gTZHYFSDo0YzvVXqcmUOgFRowDZtHkTyUTLY8FMVgEdqc0Sn4RZHYlXTg0azX0SnQTZKYGR3sTN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5IES3YVZKYGRBgTQ2YUVwTjQi8FNrEFNHIUS3MiPMYmKCwjcDMUS3Q0PNIiYS4zcHIDRRUjQY8VUxHFNHgFSzQzTMYmKCwjctLkSvvTZMICT4wDdHIDRCclUXQGMVkkbvjFR3wTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHcGSC0DctjFRlQEQgsVVWgkdqESXzASZHACSosjcpMkSzn1PNomXC0zcHMES1oVZHYFRUgkZqY0X4ASZHg2LnwDLHIDRCclUXQGMVkkbvjFR3AUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHY2LBwDZtHUTxUEaicVTWoUczX0SnomTNY2LBwDZtfFUmEkUZASSW8DZDk1R1gjPHMzYVgEczXUVxASZHgGUogjYpQUXmMlUZQWQrIFMvjFR2gjPHcTQVoEcvjFR1MiPLg1Mn8zM2HzT0U0QYkWPWk0YyYUV30TaOcyMRAkb2wFUAEEUYkFNFk0ZI01St3hKt3hKt3hKt3hKJUELPUTPqI1aYcEV5UkQQcVTWgkKDAkKBs1QhcVSxHlKDAkKC4BTG4hKt3hKt3hKt3FUUMTUDQEdqw1XmE0UYQTQFM1YAwyKIMzasA2atUlaz4COuX0TTMCTrU2Yo41TzEFck4C."
														}
,
														"snapshotlist" : 														{
															"current_snapshot" : 0,
															"entries" : [ 																{
																	"filetype" : "C74Snapshot",
																	"version" : 2,
																	"minorversion" : 0,
																	"name" : "AllRADecoder",
																	"origin" : "AllRADecoder.vst3",
																	"type" : "VST3",
																	"subtype" : "AudioEffect",
																	"embed" : 0,
																	"snapshot" : 																	{
																		"pluginname" : "AllRADecoder.vst3",
																		"plugindisplayname" : "AllRADecoder",
																		"pluginsavedname" : "",
																		"pluginsaveduniqueid" : 0,
																		"version" : 1,
																		"isbank" : 0,
																		"isbase64" : 1,
																		"blob" : "4671.VMjLgXiD...O+fWarAhckI2bo8la8HRLt.iHfTlai8FYo41Y8HRUTYTK3HxO9.BOVMEUy.Ea0cVZtMEcgQWY9vSRC8Vav8lak4Fc9LCMwfiKV0jZLcFUQMjKt3xSqX1UgIWPnM1ZIIiXugCaggCRRwDctjFRlQEagkFNFk0azDSV3fjTUQUVTszLHg2S43hPOEzcFElTEQTTq0TLgoVUrIVN1MDUAkTUP0TPRokZvjFRpUULXUWTVkEd3nlXpUEahglKnM1Y2Y0XqASZHo2LBwDZ2f1S23RUPIUQTMkYpYTV3fjTYMSPxDFdQcTTq0TLgoVUrIFZtf1XmcmUisFLogzcyHDSncCZOciKUAkTEQ0TlolQYgCRRk0LAISX3E0QSc1ZxDFLQ0FRlg0UXIWUWkENHIESz4RZHU2LC8DTEoFUAACQH8VTV8DZpwVX1U0Qi8TRGk0ZIICUqE0Qi8FMwjEZtf1XmcmUisFLogjcyHDSncCZOciKUAkTEQ0TlolQYgCRRMVdUECUN0zPQglKnM1Y2Y0XqASZHc2LBwDZ2f1S23RUPIUQTMkYpYTV3fDdis1ZwjkaQIiXn4BZic1cVM1ZvjFR2MiPLg1Mn8zM2nGUC0jdgQWVVoUaAgFUq0jUY8VVWkEdAASX3E0UOgldRwDZtfGUqQiQYsVRWIETvjFRn4BdTsFMFk0ZIcDU0kzQigCRRszcHIDRSUEagoVUrI1SMACTAEkQYgWUwHVdvjFR0QDQgIWRUAEQUECV0EkUYgGNngjYLUUVzEkUYg2ZpEldUwlXwTjQggCRRwjctjFR0MyPOwDNVMlZMcjXqUTLZsVRxHVN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5gGS3MiPLglKREkbUw1XmE0UZUGMV8DZ5IESzLCdLQiZS4DMpkVS2Y1TMkmKowjLHIDRRUjQY8VUxHFNHgFSzA0PMYmKCwjctLUSxfTZLYGTS0DMHIDRCclUXQGMVkkbvjFR2gjPHkDLVgUaqwVXmkzUjgCRBwDZtfWTmsFaggCRRwDctjFR0MyPOUzcVk0bUwVX5EjTPUyZVEFLQcjV3fjTLQyLBwDZtHUTxUEaicVTWoUczX0SnomPMQGUogjYHUEVpslUikGLogDdyHES44xPLYmKSwzcPMTS54xTNcmYogjYLQjVmQCags1cV8DZHkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyQTdMQmKogjYTQTXqk0UXo2ZwDFcvjFRxLCdLYmKCwjctLESz3RdMkGTC4TLLkFRlgTUXo1ZVMVdvjFR3MiPLgmZS4DMpMkSxPTdLMiZ40jLDkFRlwDQZcFMrE1Z2Y0SnwTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHkGRosjcHIDREcmUYESQFM1a3vVX3fjTLQyLnwjctLDS14RdMECRS4TdpMTSvfjPHIUQFk0aUIiX3fDZLQGUS0DMpMkSzn1PMgmX40DMTMTS2gjPHMzYVgEczXUVxASZHoGRBgTRvXEVssFagcVRWQFNHIDSn4BdQc1ZrEFNHIESz4RZHU2LC8TQ2YUVyUEagoWPRAUMqYUXvD0QZgCRRszcDk1R1gjPHUzcVkULEYzXugCaggCR3wjLyfWS14xPLYmK40TLHMkS4o1PMACRBgjTEYTVuUkLhgCRnwDcLMTSzn1TNQiZCwjdXkGS3QUZMMCRBgzPmYEVzQiUYIGLogDLHIDRIAiUX01ZrE1YIcEY3fjPLglK3E0YqwVX3fjTLQmKogTcyLzSEcmUYMWUrEldAIET0rlUgASTGoENHI0R2gTZLQmKogjYTQTXqk0UXo2ZwDFcvjFRyQTdMQGUogjYHUEVpslUikGLogDdyfVS44xPLYmKSwzcPMTS54xTNcmYogjYLQjVmQCags1cV8DZXkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyI1TNQmKogjYTQTXqk0UXo2ZwDFcvjFRyQUZKEiZS4DMpMkSy3xTNgGVS0zcLkWSn4BZTcVTVoELMc0SngTZKgGUogjYLQjVmQCags1cV8DZhkFRloFUgc1XVoEcEwlXz.SZHYGRBgzQEYkVzASZHc2LBwDZ2f1S2PEQgsFLVkEcQcDRA81UZMWUGMlavjFRyo1TMQmKogjYTQTXqk0UXo2ZwDFcvjFRwLiTNYmKCwjctLDSzPUdLEiXC0TdHkFRlgTUXo1ZVMVdvjFR3MCZLomKCwjctLDS1o1TMkGV40jdLkFRlwDQZcFMrE1Z2Y0SnYVZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGUo0DctjFRlQEQgsVVWgkdqESXzASZHcmXosjLtLDS14xPLICVowDMLMkS5QUZHYFRUgkZqY0X4ASZHg2L30TLpMkSzn1TNMiKS4DdXMUS2AUZHYFSDo0YzvVXqcmUOglZogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzbpMUSz4RZHYFUDE1ZYcEV5sVLgQGLogTdpk1R54xPLYmKSwDLHMUSyH1PNQCQogjYHUEVpslUikGLogDdyHTSy3xPLYmKCwzcpMDSxvzPMMCVogjYLQjVmQCags1cV8DZDMDSn4hTRMWQwj0azXEV3s1UOglKogjYhQEVuQiUOgFQosjcHg2R4X2TQIWUVE1ZzXzXlQjZj8FLVMldmY0SnQzPMIyLBwDZtHUTxUEaicVTWoUczX0SnomTLEyLRwjctLDS14RdLMCQC0TLpkWS4gjPHIUQFk0aUIiX3fDZLQGVC0jctLDS1QzPLomZCwjdDkWSvfjPHMzYVgEczXUVxASZHcGQogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzbDkVSvLiPLglKREkbUw1XmE0UZUGMV8DZ5IUSzA0PLYmKCwjctLkSvvTZMICT4wDdHIDRRUjQY8VUxHFNHgFSz4RZMQiZS4DMpkGS4gzPMgmXS4zLHIDRCclUXQGMVkkbvjFR2gTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHcGVowDctjFRlQEQgsVVWgkdqESXzASZHEyLR0DMpMkSzn1TNYGTo0TdHMUSwXVZHYFRUgkZqY0X4ASZHg2LRwjdtLDS14xTLYGTS4jcPMESxPUZHYFSDo0YzvVXqcmUOgFQ4wDZtHkTyUTLY8FMVgEdqc0Sn4RZHYlXTg0azX0SnQTZKYGR3sTN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5IESvvTZKYGRBgTQ2YUVwTjQi8FNrEFNHIESwLCdMYmKCwjctjWSwfzTNkmZC0DLHIDRRUjQY8VUxHFNHgFSzA0PMYmKCwjctLUSxfTZLYGTS0DMHIDRCclUXQGMVkkbvjFR2AUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGQo0jcyHDSn4hTQIWUrM1YQckV0QiUOgFS40DcTMkSzn1TNMCT40jdDkFS24xTNglKnQ0YQYkVvzzUOgFRosDdhMkSzn1TNQiXSwTdlMkSxH1TLglK3AkaEwVXzUkQggCRRwDLHIDRIAiUX01ZrE1YIcEY3fjPLglK3E0YqwVX3fjTLQmKogTcyLzSEcmUYMWUrEldAIET0rlUgASTGoENHIUSxLiPLglKREkbUw1XmE0UZUGMV8DZ5IESxLCdMYmKCwjctjWSwfzTNkmZC0DLHIDRRUjQY8VUxHFNHgFSzg0TLQiZS4DMlMjSvP0TMQiKC4DdHIDRCclUXQGMVkkbvjFR2gUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHQCVosjcHIDREcmUYESQFM1a3vVX3fjTKEyL3wjctLDS14xTLQiK40TdPMjSwvTZHYFRUgkZqY0X4ASZHg2LnwDLHIDRCclUXQGMVkkbvjFR2IVZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHICVosjcHIDREcmUYESQFM1a3vVX3fjTNQGQCwjctLDS1wzPNcGTo0DMhkFSxfjPHIUQFk0aUIiX3fDZLQGS4wDMpMkSzn1TLoGQo0DMLMES3gjPHMzYVgEczXUVxASZHcmYogjYpQUXmMlUZQWQrIFMvjFR1gjPHcTQVoEcvjFR2MiPLg1Mn8zMTQTXqAiUYQWTGgTPuckVyU0Qi4FLogzcDMkSz4RZHYFUDE1ZYcEV5sVLgQGLogzchk1Ryn1TNQiZS4TLDMjSvvzPLgmXogjYHUEVpslUikGLogDdyfVSw3xPLYmKCwzLTMjS44RZMMiYogjYLQjVmQCags1cV8DZDMkSn4hTRMWQwj0azXEV3s1UOglKogjYhQEVuQiUOgFQosjcHg2R4X2TQIWUVE1ZzXzXlQjZj8FLVMldmY0SnYVdMQmKogjYTQTXqk0UXo2ZwDFcvjFR4IVZKQiKCwjctLESvfzTMMiXC4DMDkFRlgTUXo1ZVMVdvjFR3MCZMcmZS4DMpMjSyP0TMAiZCwzLHkFRlwDQZcFMrE1Z2Y0SngzPLglKRI0bEESVuQiUXg2ZW8DZtjFRlIFUX8FMV8DZDk1R1gDdKkicSEkbUYUXqQiQiYFQpQ1avX0X5clUOgFT4wDctjFRlQEQgsVVWgkdqESXzASZHACVosjcHIDRRUjQY8VUxHFNHgFSzA0TLYmKCwjctLjSvXVdLYGVC4zLHIDRCclUXQGMVkkbvjFR3QTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHMGT4wDctjFRlQEQgsVVWgkdqESXzASZHACVosjLpMkSzn1TNgGS40jcXMDSvPUZHYFRUgkZqY0X4ASZHg2LRwzLtLDS14xPLECV40DLhkFS1gTZHYFSDo0YzvVXqcmUOgFRowDZtHkTyUTLY8FMVgEdqc0Sn4RZHYlXTg0azX0SnQTZKYGR3sTN1MUTxUkUgsFMFMlYDoFYuAiUio2YV8DZ5IES3YVZKYGRBgTQ2YUVwTjQi8FNrEFNHIUS3MiPMYmKCwjcDMUS3Q0PNIiYS4zcHIDRRUjQY8VUxHFNHgFSzQzTMYmKCwjctLkSvvTZMICT4wDdHIDRCclUXQGMVkkbvjFR3wTZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHcGSC0DctjFRlQEQgsVVWgkdqESXzASZHACSosjcpMkSzn1PNomXC0zcHMES1oVZHYFRUgkZqY0X4ASZHg2LnwDLHIDRCclUXQGMVkkbvjFR3AUZHYlZTE1YiYkVzUDahQCLogjcHIDRGUjUZQGLogzcyHDSncCZOcCUDE1ZvXUVzE0QHEzaWo0bUczXtASZHY2LBwDZtHUTxUEaicVTWoUczX0SnomTNY2LBwDZtfFUmEkUZASSW8DZDk1R1gjPHMzYVgEczXUVxASZHgGUogjYpQUXmMlUZQWQrIFMvjFR2gjPHcTQVoEcvjFR1MiPLg1Mn8zM2HzT0U0QYkWPWk0YyYUV30TaOcyMRAkb2wFUAEEUYkFNFk0ZI01St3hKt3hKt3hKt3hKJUELPUTPqI1aYcEV5UkQQcVTWgkKDAkKBs1QhcVSxHlKDAkKC4BTG4hKt3hKt3hKt3FUUMTUDQEdqw1XmE0UYQTQFM1YAwyKIMzasA2atUlaz4COuX0TTMCTrU2Yo41TzEFck4C."
																	}
,
																	"fileref" : 																	{
																		"name" : "AllRADecoder",
																		"filename" : "AllRADecoder.maxsnap",
																		"filepath" : "~/Documents/Max 9/Snapshots",
																		"filepos" : -1,
																		"snapshotfileid" : "83d54aea5e52e4837499da196133ff3d"
																	}

																}
 ]
														}

													}
,
													"text" : "mcs.vst~ 36 24 AllRADecoder",
													"varname" : "mcs.vst~",
													"viewvisibility" : 0
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-2",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 367.0, 588.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "multichannelsignal" ],
													"patching_rect" : [ 454.850000000000023, 173.22999999999999, 30.0, 30.0 ]
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-4", 0 ],
													"order" : 1,
													"source" : [ "obj-14", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"order" : 0,
													"source" : [ "obj-14", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-3", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-3", 0 ],
													"source" : [ "obj-5", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-4", 0 ],
													"source" : [ "obj-8", 0 ]
												}

											}
 ],
										"originid" : "pat-20"
									}
,
									"patching_rect" : [ 407.0, 281.0, 100.0, 22.0 ],
									"text" : "p ambi_decoding"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-36",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 415.0, 162.0, 1000.0, 780.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-9",
													"lastchannelcount" : 1,
													"maxclass" : "mc.live.gain~",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "multichannelsignal", "", "float", "list" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 147.0, 179.0, 48.0, 136.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 176.0, 249.0, 48.0, 136.0 ],
													"saved_attribute_attributes" : 													{
														"valueof" : 														{
															"parameter_longname" : "mc.live.gain~[16]",
															"parameter_mmax" : 6.0,
															"parameter_mmin" : -70.0,
															"parameter_modmode" : 3,
															"parameter_shortname" : "mc.live.gain~[11]",
															"parameter_type" : 0,
															"parameter_unitstyle" : 4
														}

													}
,
													"varname" : "mc.live.gain~"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 23.0, 369.0, 164.0, 22.0 ],
													"presentation" : 1,
													"presentation_linecount" : 3,
													"presentation_rect" : [ 88.0, 522.0, 100.0, 49.0 ],
													"text" : "mc.send~ gm_ambi_encoder"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-3",
													"maxclass" : "number",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"parameter_enable" : 0,
													"patching_rect" : [ 123.0, 110.0, 50.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 110.0, 112.0, 50.0, 22.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 33.0, 72.0, 121.0, 22.0 ],
													"presentation" : 1,
													"presentation_linecount" : 3,
													"presentation_rect" : [ 57.0, 789.0, 100.0, 49.0 ],
													"text" : "r ambi_encoder_gain"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 263.0, 274.0, 76.0, 22.0 ],
													"text" : "prepend aed"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-6",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 288.0, 230.0, 79.0, 22.0 ],
													"text" : "r source_aed"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-5",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 226.009999999999991, 531.639999999999986, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-18",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "multichannelsignal" ],
													"patching_rect" : [ 226.009999999999991, 377.0, 110.0, 22.0 ],
													"saved_object_attributes" : 													{
														"active" : [ 1 ],
														"center_att_db" : 6.0,
														"center_curve" : 0.2,
														"center_size" : 1.0,
														"db_unit" : 1.5,
														"dist_att" : 1.0,
														"distance_mode" : 0,
														"exp_curve" : 1.0,
														"exp_cutoff_dist" : 30.0,
														"order" : 5,
														"rotate_order" : 0
													}
,
													"text" : "mc.ambiencode~ 5"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-4",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "signal" ],
													"patching_rect" : [ 186.379999999999995, 87.810000000000002, 30.0, 30.0 ]
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-3", 0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-18", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-3", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-6", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-18", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-18", 0 ],
													"order" : 0,
													"source" : [ "obj-9", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-8", 0 ],
													"order" : 1,
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-22"
									}
,
									"patching_rect" : [ 253.0, 193.0, 139.0, 22.0 ],
									"text" : "p source_direction_ambi"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-2",
									"index" : 2,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 407.0, 44.0, 30.0, 30.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 409.0, 40.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 253.0, 40.0, 30.0, 30.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 409.0, 40.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-37", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-37", 0 ],
									"source" : [ "obj-36", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-37", 0 ]
								}

							}
 ],
						"originid" : "pat-18"
					}
,
					"patching_rect" : [ 577.0, 424.0, 143.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 3,
					"presentation_rect" : [ 877.0, 450.0, 100.0, 49.0 ],
					"text" : "p ambisonics_processing"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-31",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 60.5, 5.0, 89.0, 33.0 ],
					"text" : "Incoming udp command"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-27",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 322.0, 15.0, 150.0, 47.0 ],
					"text" : "Examples and explanations of every different command type"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-22",
					"linecount" : 4,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 92.0, 177.0, 150.0, 60.0 ],
					"text" : "live_monitor gives an overview of ongoing activity within and across subpatchers"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-18",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 635.0, 15.0, 150.0, 47.0 ],
					"text" : "Incoming udp messages are routed according to their first word"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-16",
					"linecount" : 7,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 672.0, 217.0, 150.0, 100.0 ],
					"text" : "HOA playlist output handles pre-encoded Ambisonic spherical harmonic recordings (e.g. from Zylia mic). All other playback is handled via the mono signal."
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-14",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 549.0, 182.0, 93.0, 33.0 ],
					"text" : "5th-Order HOA (36 channels)"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-11",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 444.0, 177.0, 59.0, 33.0 ],
					"text" : "mono signal"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 730.0, 345.0, 1292.0, 817.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 906.0, 563.0, 65.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 965.0, 690.0, 100.0, 22.0 ],
									"text" : "append 10"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 950.0, 615.0, 299.0, 22.0 ],
									"text" : "xyz 24 -0.975244 1.805688 -0.941782"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"linecount" : 13,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 897.0, 370.0, 403.0, 183.0 ],
									"text" : "xyz 1 1.21959 -0.810473 1.951752 xyz 2 -0.691322 -0.167118 2.007746 xyz 3 0.588704 0.257941 1.925563 xyz 4 -1.281135 0.841899 2.050244 xyz 5 0.355691 1.440758 1.829873 xyz 6 2.127138 -0.790856 -1.329184 xyz 7 2.197741 -0.223469 0.427198 xyz 8 2.215314 0.269107 -0.193815 xyz 9 2.187724 0.842172 1.475639 xyz 10 1.909857 1.574766 -0.167091 xyz 11 -1.381453 -0.732111 -2.127252 xyz 12 0.533378 -0.194804 -1.990593 xyz 13 -0.656914 0.245965 -2.021773 xyz 14 1.061015 0.70116 -2.08236 xyz 15 0.617832 1.391131 -1.69748 xyz 16 -2.093299 -0.796567 1.359404 xyz 17 -2.224161 -0.246902 -0.233768 xyz 18 -2.241915 0.37009 0.558972 xyz 19 -2.213873 0.817569 -1.22717 xyz 20 -2.064567 1.609427 0.1082 xyz 21 -0.921387 2.002955 0.988066 xyz 22 0.815213 1.826657 0.874209 xyz 23 1.036126 1.707384 -0.80951 xyz 24 -0.975244 1.805688 -0.941782"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 757.0, 558.0, 61.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 850.0, 564.0, 100.0, 22.0 ],
									"text" : "zl.group 5"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 685.0, 541.0, 25.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 707.0, 553.0, 100.0, 22.0 ],
									"text" : "iter"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 671.0, 509.0, 123.0, 22.0 ],
									"text" : "r speakers_ambipoint"
								}

							}
, 							{
								"box" : 								{
									"grid_display" : 1,
									"id" : "obj-16",
									"maxclass" : "ambimonitor",
									"mode" : 3,
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 671.0, 595.0, 241.5, 120.75 ],
									"zoom_scale" : 0.3
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 388.5, 550.0, 111.0, 22.0 ],
									"text" : "r source_ambipoint"
								}

							}
, 							{
								"box" : 								{
									"grid_display" : 2,
									"id" : "obj-2",
									"maxclass" : "ambimonitor",
									"mode" : 3,
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 388.5, 599.0, 241.5, 120.75 ],
									"zoom_scale" : 0.3
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-56",
									"lastchannelcount" : 2,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 544.0, 85.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[6]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[6]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~[3]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-55",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 544.0, 26.0, 170.0, 22.0 ],
									"text" : "mc.receive~ output_binaural 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-54",
									"lastchannelcount" : 36,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 33.0, 573.0, 230.0, 107.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 160.0, 600.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[5]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[5]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~[2]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-53",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 33.0, 513.0, 184.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 99.0, 589.0, 102.0, 49.0 ],
									"text" : "mc.receive~ raw_ambi_signal 36"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-52",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 456.5, 254.0, 126.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 289.0, 731.0, 100.0, 35.0 ],
									"text" : "mc.receive~ gm_vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 724.0, 254.0, 193.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 274.0, 716.0, 100.0, 49.0 ],
									"text" : "mc.receive~ gm_ambi_decoder 36"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-50",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 501.0, 292.0, 176.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 259.0, 701.0, 100.0, 49.0 ],
									"text" : "mc.receive~ gm_ambi_encoder"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-49",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 300.0, 254.0, 123.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 244.0, 686.0, 100.0, 35.0 ],
									"text" : "mc.receive~ gm_bina"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-48",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 343.0, 292.0, 126.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 229.0, 671.0, 100.0, 35.0 ],
									"text" : "mc.receive~ gm_omni"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 167.0, 292.0, 130.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 214.0, 656.0, 100.0, 35.0 ],
									"text" : "mc.receive~ gm_mono"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-46",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 149.0, 254.0, 126.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 199.0, 641.0, 100.0, 35.0 ],
									"text" : "mc.receive~ gm_input"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-45",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 581.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 433.0, 753.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[9]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[7]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-44",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 495.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 418.0, 738.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[8]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[6]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-43",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 414.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 403.0, 723.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[7]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[5]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-42",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 327.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 388.0, 708.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[6]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[4]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-41",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 238.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 373.0, 693.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[5]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[3]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-40",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 490.0, 447.0, 68.0, 20.0 ],
									"text" : "GM VBAP",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-39",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 409.0, 447.0, 60.0, 20.0 ],
									"text" : "GM Omni",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-38",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 321.0, 447.0, 60.0, 20.0 ],
									"text" : "GM Bina",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-37",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 233.0, 447.0, 64.0, 20.0 ],
									"text" : "GM Mono",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-36",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 149.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 358.0, 678.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[4]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[2]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-35",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 703.0, 447.0, 123.0, 20.0 ],
									"text" : "GM Ambi Decoder",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-33",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 553.0, 447.0, 106.0, 20.0 ],
									"text" : "GM Ambi Encoder",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-30",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 228.0, 487.0, 280.0, 47.0 ],
									"text" : "\"GM\" = Gain-modulated (the input signal can have its gain independently controlled at each stage of processing)"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-24",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 144.0, 447.0, 60.0, 20.0 ],
									"text" : "GM Input",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 33.0, 447.0, 99.0, 20.0 ],
									"text" : "Raw Mono Input ",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"lastchannelcount" : 0,
									"maxclass" : "live.gain~",
									"numinlets" : 2,
									"numoutlets" : 5,
									"outlettype" : [ "signal", "signal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 58.0, 332.0, 49.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 343.0, 663.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "live.gain~[1]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "live.gain~[1]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "live.gain~[1]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"lastchannelcount" : 24,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 675.5, 127.0, 178.0, 94.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 550.0, 573.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[4]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[4]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~[1]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"lastchannelcount" : 36,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 650.0, 332.0, 229.0, 102.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 622.0, 362.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[3]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[3]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 675.5, 70.0, 182.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 770.0, 420.0, 101.0, 49.0 ],
									"text" : "mc.receive~ output_speakers 24"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 58.0, 210.0, 181.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 611.0, 215.0, 100.0, 49.0 ],
									"text" : "mc.receive~ raw_mono_signal 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 94.0, 71.0, 184.0, 20.0 ],
									"text" : "Most recent command message"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 26.0, 149.0, 501.0, 22.0 ],
									"text" : "sfplay play 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 101.0, 93.0, 59.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 439.0, 338.0, 100.0, 22.0 ],
									"text" : "r udpmsg"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 1 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-10", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-16", 0 ],
									"order" : 1,
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"order" : 0,
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 1 ],
									"order" : 0,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"order" : 1,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-46", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-47", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-48", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-42", 0 ],
									"source" : [ "obj-49", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-50", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-51", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-44", 0 ],
									"source" : [ "obj-52", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-54", 0 ],
									"source" : [ "obj-53", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-56", 0 ],
									"source" : [ "obj-55", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-8", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
 ],
						"originid" : "pat-24"
					}
,
					"patching_rect" : [ 92.0, 153.0, 83.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 953.0, 410.0, 100.0, 22.0 ],
					"text" : "p live_monitor"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 423.0, 288.0, 1000.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 444.75, 4.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-70",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 153.0, 98.0, 103.0, 20.0 ],
									"text" : "Runtime Editable"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-68",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 153.0, 54.0, 88.0, 20.0 ],
									"text" : "Default values"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-66",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 699.0, 53.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-64",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 640.0, 53.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-62",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 580.0, 53.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-60",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 521.0, 53.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-58",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 459.0, 53.0, 29.5, 22.0 ],
									"text" : "-20"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-56",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 397.0, 53.0, 29.5, 22.0 ],
									"text" : "-5"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-54",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 335.0, 53.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-52",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 271.0, 53.0, 29.5, 22.0 ],
									"text" : "-30"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-50",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 640.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-49",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 680.5, 554.0, 123.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 511.0, 605.0, 100.0, 50.0 ],
									"text" : "s ambi_decoder_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-48",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 640.0, 293.0, 132.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 597.0, 244.0, 100.0, 36.0 ],
									"text" : "prepend ambi_decoder"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-45",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 271.0, 300.0, 69.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 725.0, 152.0, 100.0, 22.0 ],
									"text" : "r command"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 659.0, 386.0, 71.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 651.0, 267.0, 100.0, 22.0 ],
									"text" : "s command"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-42",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 397.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-41",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 459.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-40",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 699.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-39",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 580.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-38",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 521.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-37",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 335.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-36",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 271.0, 97.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-35",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 699.0, 323.0, 105.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 582.0, 229.0, 100.0, 36.0 ],
									"text" : "prepend speakers"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-34",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 580.0, 265.0, 132.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 582.0, 229.0, 100.0, 36.0 ],
									"text" : "prepend ambi_encoder"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-33",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 521.0, 239.0, 82.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 582.0, 229.0, 100.0, 22.0 ],
									"text" : "prepend vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-32",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 459.0, 213.0, 82.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 582.0, 229.0, 100.0, 22.0 ],
									"text" : "prepend omni"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 397.0, 187.0, 79.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 522.0, 280.0, 100.0, 22.0 ],
									"text" : "prepend bina"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-30",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 335.0, 161.0, 86.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 319.0, 275.0, 100.0, 22.0 ],
									"text" : "prepend mono"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-29",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 271.0, 132.0, 79.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 319.0, 275.0, 100.0, 22.0 ],
									"text" : "prepend gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-22",
									"linecount" : 7,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 823.0, 441.5, 153.0, 103.0 ],
									"text" : "if the initial command is just \"gain 100\" or another value, the input to this patcher is just the number, which will be used to set the initial gain on the input signal"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 877.0, 602.0, 63.0, 22.0 ],
									"text" : "s init_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 805.5, 578.0, 96.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 22.0 ],
									"text" : "s speakers_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 555.5, 530.0, 123.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 50.0 ],
									"text" : "s ambi_encoder_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 480.5, 506.0, 73.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 22.0 ],
									"text" : "s vbap_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 406.0, 482.0, 73.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 22.0 ],
									"text" : "s omni_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 334.0, 460.0, 70.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 22.0 ],
									"text" : "s bina_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 255.0, 441.5, 77.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 496.0, 590.0, 100.0, 22.0 ],
									"text" : "s mono_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 193.0, 417.0, 63.0, 22.0 ],
									"text" : "s init_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 9,
									"numoutlets" : 9,
									"outlettype" : [ "", "", "", "", "", "", "", "", "" ],
									"patching_rect" : [ 193.0, 374.0, 391.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 5,
									"presentation_rect" : [ 841.0, 506.0, 100.0, 77.0 ],
									"text" : "route gain mono bina omni vbap ambi_encoder ambi_decoder speakers"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-4",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 193.0, 139.0, 30.0, 30.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 601.0, 163.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-52", 0 ],
									"order" : 7,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-54", 0 ],
									"order" : 6,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-56", 0 ],
									"order" : 5,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-58", 0 ],
									"order" : 4,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-60", 0 ],
									"order" : 3,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-62", 0 ],
									"order" : 2,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-64", 0 ],
									"order" : 1,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-66", 0 ],
									"order" : 0,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-29", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-30", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-31", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-32", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-33", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-34", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-35", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-36", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-37", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-33", 0 ],
									"source" : [ "obj-38", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-34", 0 ],
									"source" : [ "obj-39", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-35", 0 ],
									"source" : [ "obj-40", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-41", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-42", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-45", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-48", 0 ],
									"source" : [ "obj-50", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-52", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-37", 0 ],
									"source" : [ "obj-54", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-42", 0 ],
									"source" : [ "obj-56", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-58", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-38", 0 ],
									"source" : [ "obj-60", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-39", 0 ],
									"source" : [ "obj-62", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-50", 0 ],
									"source" : [ "obj-64", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-40", 0 ],
									"source" : [ "obj-66", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-9", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-9", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-9", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-9", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-9", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-9", 7 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-9", 8 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-9", 6 ]
								}

							}
 ],
						"originid" : "pat-28"
					}
,
					"patching_rect" : [ 943.0, 153.0, 93.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1054.0, 313.0, 100.0, 22.0 ],
					"text" : "p gain_handling"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-1",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 943.0, 99.0, 62.0, 22.0 ],
					"text" : "route gain"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 109.0, 96.0, 1446.0, 816.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1017.0, 76.0, 29.5, 22.0 ],
									"text" : "set"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"linecount" : 3,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 808.0, 569.0, 505.0, 49.0 ],
									"text" : "32. -19.4 -19. -4.5 17. 7.3 -32. 19.2 11. 37.7 122. -17.5 79. -5.7 95. 6.9 56. 17.7 95. 39.4 -147. -16.1 165. -5.4 -162. 6.6 153. 16.7 160. 37.6 -57. -17.7 -96. -6.3 -76. 9.1 -119. 17.9 -87. 37.9 -43. 56. 43. 56.8 128. 52.4 -134. 53.1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"linecount" : 10,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 709.0, 199.0, 536.0, 143.0 ],
									"text" : "xyz 1 1.21959 -0.810473 1.951752 xyz 2 -0.691322 -0.167118 2.007746 xyz 3 0.588704 0.257941 1.925563 xyz 4 -1.281135 0.841899 2.050244 xyz 5 0.355691 1.440758 1.829873 xyz 6 2.127138 -0.790856 -1.329184 xyz 7 2.197741 -0.223469 0.427198 xyz 8 2.215314 0.269107 -0.193815 xyz 9 2.187724 0.842172 1.475639 xyz 10 1.909857 1.574766 -0.167091 xyz 11 -1.381453 -0.732111 -2.127252 xyz 12 0.533378 -0.194804 -1.990593 xyz 13 -0.656914 0.245965 -2.021773 xyz 14 1.061015 0.70116 -2.08236 xyz 15 0.617832 1.391131 -1.69748 xyz 16 -2.093299 -0.796567 1.359404 xyz 17 -2.224161 -0.246902 -0.233768 xyz 18 -2.241915 0.37009 0.558972 xyz 19 -2.213873 0.817569 -1.22717 xyz 20 -2.064567 1.609427 0.1082 xyz 21 -0.921387 2.002955 0.988066 xyz 22 0.815213 1.826657 0.874209 xyz 23 1.036126 1.707384 -0.80951 xyz 24 -0.975244 1.805688 -0.941782"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 57.0, 224.0, 726.0, 790.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-32",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 525.0, 776.0, 50.0, 22.0 ],
													"text" : "48"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-30",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 494.0, 707.0, 37.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 494.0, 707.0, 100.0, 22.0 ],
													"text" : "zl.len"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-29",
													"linecount" : 3,
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 219.0, 624.0, 414.0, 50.0 ],
													"text" : "32. -19.4 -19. -4.5 17. 7.3 -32. 19.2 11. 37.7 122. -17.5 79. -5.7 95. 6.9 56. 17.7 95. 39.4 -147. -16.1 165. -5.4 -162. 6.6 153. 16.7 160. 37.6 -57. -17.7 -96. -6.3 -76. 9.1 -119. 17.9 -87. 37.9 -43. 56. 43. 56.8 128. 52.4 -134. 53.1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-24",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 367.0, 273.0, 50.0, 22.0 ],
													"text" : "120"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-22",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 268.0, 261.0, 39.0, 22.0 ],
													"text" : "48"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-15",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 549.730000000000018, 91.0, 150.0, 20.0 ],
													"text" : "Original list"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-13",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 384.5, 91.0, 150.0, 20.0 ],
													"text" : "List being created"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-11",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "int", "bang" ],
													"patching_rect" : [ 451.5, 345.0, 29.5, 22.0 ],
													"text" : "t i b"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 451.5, 299.0, 83.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 779.0, 286.0, 100.0, 22.0 ],
													"text" : "expr int($f1/2)"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 451.5, 203.0, 37.0, 22.0 ],
													"text" : "zl.len"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-5",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 347.0, 735.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-3",
													"index" : 2,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 554.0, 113.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 608.0, 117.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 451.5, 113.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 479.0, 108.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-16",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 543.5, 405.0, 29.5, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 590.0, 400.0, 100.0, 22.0 ],
													"text" : "i"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 554.0, 299.0, 83.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 764.0, 271.0, 100.0, 22.0 ],
													"text" : "expr int($f1/5)"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-44",
													"linecount" : 2,
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 569.0, 479.0, 150.0, 34.0 ],
													"text" : "check if list is finished processing"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-42",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "" ],
													"patching_rect" : [ 533.0, 515.0, 34.0, 22.0 ],
													"text" : "sel 1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-41",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 533.0, 484.0, 29.5, 22.0 ],
													"text" : "=="
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-39",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 554.0, 203.0, 37.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 697.0, 294.0, 100.0, 22.0 ],
													"text" : "zl.len"
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-29", 1 ],
													"order" : 0,
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-8", 0 ],
													"order" : 1,
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-16", 0 ],
													"source" : [ "obj-11", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-41", 0 ],
													"source" : [ "obj-11", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-41", 1 ],
													"source" : [ "obj-16", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-30", 0 ],
													"order" : 0,
													"source" : [ "obj-29", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-5", 0 ],
													"order" : 1,
													"source" : [ "obj-29", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-39", 0 ],
													"source" : [ "obj-3", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-32", 1 ],
													"source" : [ "obj-30", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-24", 1 ],
													"order" : 1,
													"source" : [ "obj-39", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"order" : 0,
													"source" : [ "obj-39", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-42", 0 ],
													"source" : [ "obj-41", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-29", 0 ],
													"source" : [ "obj-42", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"order" : 0,
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-22", 1 ],
													"order" : 1,
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-16", 1 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-32"
									}
,
									"patching_rect" : [ 493.0, 502.0, 128.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 754.0, 478.0, 100.0, 49.0 ],
									"text" : "p VerifyListCompletion"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 413.0, 233.0, 1000.0, 780.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-25",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 781.0, 738.0, 50.0, 22.0 ],
													"text" : "48"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-23",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 710.0, 668.0, 37.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 766.0, 683.0, 100.0, 22.0 ],
													"text" : "zl.len"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-22",
													"linecount" : 3,
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 123.0, 702.0, 495.0, 49.0 ],
													"text" : "32 -19.4 341 -4.5 17 7.3 328 19.2 11 37.7 122 -17.5 79 -5.7 95 6.9 56 17.7 95 39.4 213 -16.1 165 -5.4 198 6.6 153 16.7 160 37.6 303 -17.7 264 -6.3 284 9.1 241 17.9 273 37.9 317 56 43 56.8 128 52.4 226 53.1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-21",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 422.0, 291.5, 22.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 575.0, 378.0, 100.0, 22.0 ],
													"text" : "t b"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-20",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 422.0, 324.0, 29.5, 22.0 ],
													"text" : "2"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-18",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 271.0, 273.0, 29.5, 22.0 ],
													"text" : "1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-16",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 483.5, 269.0, 42.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 661.0, 476.0, 100.0, 22.0 ],
													"text" : "gate 2"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-15",
													"linecount" : 3,
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 104.0, 611.0, 495.0, 49.0 ],
													"text" : "32. -19.4 -19. -4.5 17. 7.3 -32. 19.2 11. 37.7 122. -17.5 79. -5.7 95. 6.9 56. 17.7 95. 39.4 -147. -16.1 165. -5.4 -162. 6.6 153. 16.7 160. 37.6 -57. -17.7 -96. -6.3 -76. 9.1 -119. 17.9 -87. 37.9 -43. 56. 43. 56.8 128. 52.4"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-13",
													"linecount" : 2,
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 606.0, 285.0, 50.0, 35.0 ],
													"text" : "-134. 53.1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-11",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 486.0, 346.0, 22.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 403.0, 268.0, 100.0, 22.0 ],
													"text" : "t b"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-10",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 304.0, 225.0, 43.0, 22.0 ],
													"text" : "zlclear"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 175.0, 186.0, 150.0, 20.0 ],
													"text" : "initial clearning bang"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-5",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 295.0, 181.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 295.0, 181.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-4",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 422.0, 162.0, 150.0, 34.0 ],
													"text" : "incoming pair\n"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-2",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 478.0, 569.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 453.0, 665.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-1",
													"index" : 2,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 390.0, 164.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 390.0, 164.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-37",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 390.0, 416.0, 38.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 639.0, 651.0, 100.0, 22.0 ],
													"text" : "zl.reg"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-34",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 478.0, 479.0, 53.0, 22.0 ],
													"text" : "zl.join"
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-13", 1 ],
													"order" : 0,
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-16", 1 ],
													"order" : 1,
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-37", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-37", 0 ],
													"source" : [ "obj-11", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-23", 0 ],
													"source" : [ "obj-15", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-11", 0 ],
													"order" : 1,
													"source" : [ "obj-16", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-21", 0 ],
													"order" : 0,
													"source" : [ "obj-16", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-34", 1 ],
													"order" : 0,
													"source" : [ "obj-16", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-37", 1 ],
													"order" : 1,
													"source" : [ "obj-16", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-16", 0 ],
													"source" : [ "obj-18", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-16", 0 ],
													"source" : [ "obj-20", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-20", 0 ],
													"source" : [ "obj-21", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-23", 0 ],
													"source" : [ "obj-22", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-25", 1 ],
													"source" : [ "obj-23", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"order" : 0,
													"source" : [ "obj-34", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-37", 1 ],
													"order" : 1,
													"source" : [ "obj-34", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-15", 1 ],
													"order" : 0,
													"source" : [ "obj-37", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-34", 0 ],
													"order" : 1,
													"source" : [ "obj-37", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"order" : 0,
													"source" : [ "obj-5", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-18", 0 ],
													"order" : 1,
													"source" : [ "obj-5", 0 ]
												}

											}
 ],
										"originid" : "pat-34"
									}
,
									"patching_rect" : [ 333.0, 436.0, 106.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 803.0, 555.0, 100.0, 35.0 ],
									"text" : "p ConstructAeList"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 782.0, 212.0, 600.0, 780.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-15",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 305.0, 548.0, 150.0, 20.0 ],
													"text" : "strip distance"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-6",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 211.0, 383.0, 62.0, 20.0 ],
													"text" : "strip ID #"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-13",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 333.0, 252.0, 25.0, 22.0 ],
													"text" : "iter"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-11",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 333.0, 293.0, 61.0, 22.0 ],
													"text" : "zl.group 5"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-2",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 400.0, 659.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 350.0, 669.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 333.0, 201.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 484.0, 212.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-48",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patcher" : 													{
														"fileversion" : 1,
														"appversion" : 														{
															"major" : 9,
															"minor" : 0,
															"revision" : 5,
															"architecture" : "x64",
															"modernui" : 1
														}
,
														"classnamespace" : "box",
														"rect" : [ 266.0, 283.0, 616.0, 346.0 ],
														"gridsize" : [ 15.0, 15.0 ],
														"boxes" : [ 															{
																"box" : 																{
																	"id" : "obj-10",
																	"maxclass" : "newobj",
																	"numinlets" : 3,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 250.0, 209.0, 54.0, 22.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 328.0, 238.0, 100.0, 22.0 ],
																	"text" : "pack f f f"
																}

															}
, 															{
																"box" : 																{
																	"id" : "obj-9",
																	"maxclass" : "newobj",
																	"numinlets" : 1,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 241.5, 168.0, 39.0, 22.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 441.0, 254.0, 100.0, 22.0 ],
																	"text" : "z.rtod"
																}

															}
, 															{
																"box" : 																{
																	"id" : "obj-8",
																	"maxclass" : "newobj",
																	"numinlets" : 1,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 201.0, 168.0, 39.0, 22.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 426.0, 239.0, 100.0, 22.0 ],
																	"text" : "z.rtod"
																}

															}
, 															{
																"box" : 																{
																	"id" : "obj-7",
																	"maxclass" : "newobj",
																	"numinlets" : 1,
																	"numoutlets" : 3,
																	"outlettype" : [ "float", "float", "float" ],
																	"patching_rect" : [ 220.0, 124.0, 67.0, 22.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 261.0, 118.0, 100.0, 22.0 ],
																	"text" : "unpack f f f"
																}

															}
, 															{
																"box" : 																{
																	"comment" : "",
																	"id" : "obj-6",
																	"index" : 1,
																	"maxclass" : "outlet",
																	"numinlets" : 1,
																	"numoutlets" : 0,
																	"patching_rect" : [ 220.0, 258.0, 30.0, 30.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 348.0, 196.0, 30.0, 30.0 ]
																}

															}
, 															{
																"box" : 																{
																	"comment" : "",
																	"id" : "obj-4",
																	"index" : 1,
																	"maxclass" : "inlet",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 220.0, 68.0, 30.0, 30.0 ],
																	"presentation" : 1,
																	"presentation_rect" : [ 265.0, 167.0, 30.0, 30.0 ]
																}

															}
 ],
														"lines" : [ 															{
																"patchline" : 																{
																	"destination" : [ "obj-6", 0 ],
																	"source" : [ "obj-10", 0 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-7", 0 ],
																	"source" : [ "obj-4", 0 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-10", 2 ],
																	"source" : [ "obj-7", 2 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-8", 0 ],
																	"source" : [ "obj-7", 0 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-9", 0 ],
																	"source" : [ "obj-7", 1 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-10", 0 ],
																	"source" : [ "obj-8", 0 ]
																}

															}
, 															{
																"patchline" : 																{
																	"destination" : [ "obj-10", 1 ],
																	"source" : [ "obj-9", 0 ]
																}

															}
 ],
														"originid" : "pat-38"
													}
,
													"patching_rect" : [ 314.0, 461.0, 89.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 296.0, 622.0, 100.0, 22.0 ],
													"text" : "p aed_rad2deg"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-5",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 314.0, 420.0, 76.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 15.0, 827.0, 100.0, 22.0 ],
													"text" : "z.3Dcartopol"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-33",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 400.0, 584.0, 51.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 475.0, 610.0, 100.0, 22.0 ],
													"text" : "pack f f"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-31",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "float", "float", "float" ],
													"patching_rect" : [ 400.0, 547.0, 83.0, 22.0 ],
													"text" : "unpack f f f"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-26",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 364.0, 383.0, 55.0, 22.0 ],
													"text" : "zl.slice 1"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-14",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "" ],
													"patching_rect" : [ 333.0, 343.0, 81.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 379.0, 556.0, 100.0, 22.0 ],
													"text" : "route xyz aed"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-12",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 278.0, 383.0, 55.0, 22.0 ],
													"text" : "zl.slice 1"
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-13", 0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-11", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-12", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-13", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-12", 0 ],
													"source" : [ "obj-14", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-26", 0 ],
													"source" : [ "obj-14", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-31", 0 ],
													"source" : [ "obj-26", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-33", 1 ],
													"source" : [ "obj-31", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-33", 0 ],
													"source" : [ "obj-31", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-33", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-31", 0 ],
													"source" : [ "obj-48", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-48", 0 ],
													"source" : [ "obj-5", 0 ]
												}

											}
 ],
										"originid" : "pat-36"
									}
,
									"patching_rect" : [ 366.0, 366.0, 105.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 993.0, 519.0, 100.0, 35.0 ],
									"text" : "p GenerateAePair"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-74",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 236.0, 220.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-53",
									"linecount" : 5,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 360.0, 67.0, 357.0, 74.0 ],
									"text" : "if message begins with \"ambi\" or \"vbap\" only the named pipeline is affected, otherwise both. In practice, this allows regular updating of vbap matrices while subjects move, without changing ambisonic processing (which is presumably much more time consuming)"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 257.0, 80.0, 95.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 737.0, 155.0, 100.0, 22.0 ],
									"text" : "route ambi vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-50",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 311.0, 16.0, 150.0, 47.0 ],
									"text" : "Currently this assumes a list of ambipoints (aed/xyz ID# X/A Y/E Z/D)"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 493.0, 598.0, 177.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 610.0, 740.0, 100.0, 49.0 ],
									"text" : "prepend define_loudspeakers 3"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-28",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 482.0, 269.0, 139.0, 33.0 ],
									"text" : "process each ambipoint separately"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-25",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 391.0, 157.0, 150.0, 33.0 ],
									"text" : "processing for vbap handler"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 56.0, 99.0, 150.0, 47.0 ],
									"text" : "message can be sent directly to ambisonics handler"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-21",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 391.0, 227.0, 74.0, 20.0 ],
									"text" : "Initialize list"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "", "" ],
									"patching_rect" : [ 333.0, 163.0, 40.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 539.0, 245.0, 100.0, 22.0 ],
									"text" : "t b l l"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 493.0, 634.0, 99.0, 22.0 ],
									"text" : "s speakers_vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 152.0, 163.0, 125.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 363.0, 320.0, 100.0, 49.0 ],
									"text" : "s speakers_ambipoint"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 257.0, 16.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-51", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 1 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 0 ],
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-19", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"order" : 0,
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 1 ],
									"source" : [ "obj-19", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-74", 0 ],
									"order" : 1,
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-47", 0 ],
									"order" : 1,
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 1 ],
									"order" : 0,
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"order" : 1,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"order" : 0,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-47", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"order" : 1,
									"source" : [ "obj-51", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-51", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 1 ],
									"order" : 0,
									"source" : [ "obj-51", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"order" : 2,
									"source" : [ "obj-51", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-51", 0 ]
								}

							}
 ],
						"originid" : "pat-30"
					}
,
					"patching_rect" : [ 754.0, 153.0, 161.0, 22.0 ],
					"text" : "p speaker_position_handling"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-8",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 754.0, 99.0, 88.0, 22.0 ],
					"text" : "route speakers"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-43",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 608.0, 227.0, 719.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-4",
									"linecount" : 4,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 535.039999999999964, 88.530000000000001, 151.0, 62.0 ],
									"text" : "need to get this implemented and updated with proper speaker distances"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-3",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 97.0, 242.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 86.609999999999999, 77.719999999999999, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-154",
									"maxclass" : "newobj",
									"numinlets" : 24,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 166.0, 787.0, 260.5, 22.0 ],
									"text" : "mc.pack~ 24"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-5",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 587.0, 647.0, 106.0, 43.0 ],
									"text" : "(speed of sound in dry air at 20 °C: 1127.95 feet/s)"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-144",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 365.0, 656.0, 94.0, 43.0 ],
									"text" : "speed of sound in dry air at 20 °C: 343.8 m/s"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-145",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 354.0, 612.0, 95.0, 21.0 ],
									"text" : "loadmess 48000."
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-146",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 166.0, 587.0, 72.0, 21.0 ],
									"text" : "t l l"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-147",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 305.0, 647.0, 56.0, 21.0 ],
									"text" : "t 343.8 f"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-148",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 24,
									"outlettype" : [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
									"patching_rect" : [ 166.0, 751.0, 260.5, 21.0 ],
									"text" : "cycle 24 1"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 305.0, 670.0, 52.0, 21.0 ],
									"text" : "/ 48000."
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 166.0, 694.0, 30.0, 21.0 ],
									"text" : "/ 1."
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-149",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 166.0, 612.0, 52.0, 21.0 ],
									"text" : "zl iter 1"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-150",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "int", "float", "int", "int" ],
									"patching_rect" : [ 292.0, 612.0, 59.0, 21.0 ],
									"text" : "dspstate~"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-151",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 166.0, 645.0, 33.0, 21.0 ],
									"text" : "!- 1."
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-152",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "int", "int" ],
									"patching_rect" : [ 219.0, 612.0, 61.0, 21.0 ],
									"text" : "maximum"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-50",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 200.0, 647.0, 78.0, 43.0 ],
									"text" : "difference from farthest speaker"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-153",
									"linecount" : 5,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 471.0, 661.0, 83.0, 67.0 ],
									"text" : "change to corresponding value for feet if distance is defined in feet"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-142",
									"linecount" : 3,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 258.0, 463.0, 290.0, 50.0 ],
									"text" : "2.44 2.13 2.03 2.56 2.356 2.63 2.25 2.24 2.77 2.481 2.64 2.07 2.14 2.44 2.28 2.62 2.25 2.34 2.66 2.62 2.416 2.183 2.155 2.258"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-137",
									"maxclass" : "newobj",
									"numinlets" : 24,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 221.0, 359.0, 360.166666666666742, 21.0 ],
									"text" : "pak 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-136",
									"maxclass" : "newobj",
									"numinlets" : 25,
									"numoutlets" : 25,
									"outlettype" : [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
									"patching_rect" : [ 221.0, 276.0, 375.0, 22.0 ],
									"text" : "route 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 324.0, 159.0, 33.0, 21.0 ],
									"text" : "* 1."
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-133",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 269.0, 223.0, 74.0, 21.0 ],
									"text" : "pack i f"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-134",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "int", "float", "float", "float" ],
									"patching_rect" : [ 269.0, 111.0, 74.0, 21.0 ],
									"text" : "unpack i f f f"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-135",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 269.0, 86.0, 59.0, 21.0 ],
									"text" : "route aed"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-136", 0 ],
									"source" : [ "obj-133", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-133", 0 ],
									"source" : [ "obj-134", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-16", 0 ],
									"source" : [ "obj-134", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-134", 0 ],
									"source" : [ "obj-135", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 23 ],
									"source" : [ "obj-136", 23 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 22 ],
									"source" : [ "obj-136", 22 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 21 ],
									"source" : [ "obj-136", 21 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 20 ],
									"source" : [ "obj-136", 20 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 19 ],
									"source" : [ "obj-136", 19 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 18 ],
									"source" : [ "obj-136", 18 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 17 ],
									"source" : [ "obj-136", 17 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 16 ],
									"source" : [ "obj-136", 16 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 15 ],
									"source" : [ "obj-136", 15 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 14 ],
									"source" : [ "obj-136", 14 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 13 ],
									"source" : [ "obj-136", 13 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 12 ],
									"source" : [ "obj-136", 12 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 11 ],
									"source" : [ "obj-136", 11 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 10 ],
									"source" : [ "obj-136", 10 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 9 ],
									"source" : [ "obj-136", 9 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 8 ],
									"source" : [ "obj-136", 8 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 7 ],
									"source" : [ "obj-136", 7 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 6 ],
									"source" : [ "obj-136", 6 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 5 ],
									"source" : [ "obj-136", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 4 ],
									"source" : [ "obj-136", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 3 ],
									"source" : [ "obj-136", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 2 ],
									"source" : [ "obj-136", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 1 ],
									"source" : [ "obj-136", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-137", 0 ],
									"source" : [ "obj-136", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-142", 1 ],
									"order" : 0,
									"source" : [ "obj-137", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-146", 0 ],
									"order" : 1,
									"source" : [ "obj-137", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-147", 0 ],
									"midpoints" : [ 363.5, 643.0, 314.5, 643.0 ],
									"source" : [ "obj-145", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-149", 0 ],
									"source" : [ "obj-146", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-152", 0 ],
									"source" : [ "obj-146", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 1 ],
									"source" : [ "obj-147", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 0 ],
									"source" : [ "obj-147", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 23 ],
									"source" : [ "obj-148", 23 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 22 ],
									"source" : [ "obj-148", 22 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 21 ],
									"source" : [ "obj-148", 21 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 20 ],
									"source" : [ "obj-148", 20 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 19 ],
									"source" : [ "obj-148", 19 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 18 ],
									"source" : [ "obj-148", 18 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 17 ],
									"source" : [ "obj-148", 17 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 16 ],
									"source" : [ "obj-148", 16 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 15 ],
									"source" : [ "obj-148", 15 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 14 ],
									"source" : [ "obj-148", 14 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 13 ],
									"source" : [ "obj-148", 13 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 12 ],
									"source" : [ "obj-148", 12 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 11 ],
									"source" : [ "obj-148", 11 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 10 ],
									"source" : [ "obj-148", 10 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 9 ],
									"source" : [ "obj-148", 9 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 8 ],
									"source" : [ "obj-148", 8 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 7 ],
									"source" : [ "obj-148", 7 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 6 ],
									"source" : [ "obj-148", 6 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 5 ],
									"source" : [ "obj-148", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 4 ],
									"source" : [ "obj-148", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 3 ],
									"source" : [ "obj-148", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 2 ],
									"source" : [ "obj-148", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 1 ],
									"source" : [ "obj-148", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-154", 0 ],
									"source" : [ "obj-148", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-151", 0 ],
									"source" : [ "obj-149", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-147", 0 ],
									"source" : [ "obj-150", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-151", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-151", 1 ],
									"midpoints" : [ 228.5, 637.5, 189.5, 637.5 ],
									"source" : [ "obj-152", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-133", 1 ],
									"source" : [ "obj-16", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 1 ],
									"midpoints" : [ 314.5, 690.0, 186.5, 690.0 ],
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-148", 0 ],
									"source" : [ "obj-21", 0 ]
								}

							}
 ],
						"originid" : "pat-46"
					}
,
					"patching_rect" : [ 378.5, 527.0, 194.0, 22.0 ],
					"text" : "p speaker_distance_compensation"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-39",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 571.0, 41.0, 59.0, 22.0 ],
					"text" : "r udpmsg"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-38",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 590.0, 203.0, 1000.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 123.0, 704.0, 153.0, 22.0 ],
									"text" : "mc.send~ output_speakers"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 136.0, 425.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 85.0, 335.0, 94.0, 22.0 ],
									"text" : "r speakers_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"lastchannelcount" : 24,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 224.5, 480.0, 173.0, 129.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 343.5, 704.0, 54.0, 22.0 ],
									"text" : "mc.dac~"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-4",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 334.0, 299.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"order" : 0,
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"order" : 1,
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
 ],
						"originid" : "pat-48"
					}
,
					"patching_rect" : [ 378.5, 585.0, 120.0, 22.0 ],
					"text" : "p all_speaker_output"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-35",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 239.0, 248.0, 1011.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"grid_display" : 2,
									"id" : "obj-25",
									"maxclass" : "ambimonitor",
									"mode" : 3,
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 441.75, 152.0, 241.5, 120.75 ],
									"zoom_scale" : 0.3
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 857.0, 505.0, 616.0, 346.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 250.0, 209.0, 54.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 328.0, 238.0, 100.0, 22.0 ],
													"text" : "pack f f f"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.5, 168.0, 39.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 441.0, 254.0, 100.0, 22.0 ],
													"text" : "z.dtor"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 201.0, 168.0, 39.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 426.0, 239.0, 100.0, 22.0 ],
													"text" : "z.dtor"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "float", "float", "float" ],
													"patching_rect" : [ 220.0, 124.0, 67.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 261.0, 118.0, 100.0, 22.0 ],
													"text" : "unpack f f f"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-6",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 220.0, 258.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 348.0, 196.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-4",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 220.0, 68.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 265.0, 167.0, 30.0, 30.0 ]
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 2 ],
													"source" : [ "obj-7", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-8", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-7", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 1 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-52"
									}
,
									"patching_rect" : [ 306.0, 324.0, 89.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 281.0, 607.0, 100.0, 22.0 ],
									"text" : "p aed_deg2rad"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 266.0, 283.0, 616.0, 346.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 250.0, 209.0, 54.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 328.0, 238.0, 100.0, 22.0 ],
													"text" : "pack f f f"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.5, 168.0, 39.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 441.0, 254.0, 100.0, 22.0 ],
													"text" : "z.rtod"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 201.0, 168.0, 39.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 426.0, 239.0, 100.0, 22.0 ],
													"text" : "z.rtod"
												}

											}
, 											{
												"box" : 												{
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "float", "float", "float" ],
													"patching_rect" : [ 220.0, 124.0, 67.0, 22.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 261.0, 118.0, 100.0, 22.0 ],
													"text" : "unpack f f f"
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-6",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 220.0, 258.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 348.0, 196.0, 30.0, 30.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "",
													"id" : "obj-4",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 220.0, 68.0, 30.0, 30.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 265.0, 167.0, 30.0, 30.0 ]
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 2 ],
													"source" : [ "obj-7", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-8", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-7", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 1 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-58"
									}
,
									"patching_rect" : [ 221.0, 380.0, 89.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 266.0, 592.0, 100.0, 22.0 ],
									"text" : "p aed_rad2deg"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 306.0, 433.0, 76.0, 22.0 ],
									"text" : "z.3Dpoltocar"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 209.5, 324.0, 76.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ -15.0, 797.0, 100.0, 22.0 ],
									"text" : "z.3Dcartopol"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-32",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 693.0, 486.0, 76.0, 22.0 ],
									"text" : "prepend aed"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 692.0, 561.0, 113.0, 22.0 ],
									"text" : "s source_ambipoint"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-24",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 725.0, 453.0, 37.0, 22.0 ],
									"text" : "join 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 675.0, 324.0, 68.0, 22.0 ],
									"text" : "r source_id"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 750.0, 324.0, 79.0, 22.0 ],
									"text" : "r source_aed"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 718.0, 416.0, 51.0, 22.0 ],
									"text" : "buddy 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 148.0, 354.0, 89.0, 47.0 ],
									"text" : "Unity and Max swap Y/Z coordinates"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 95.0, 409.0, 67.0, 22.0 ],
									"text" : "pack f f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 95.0, 324.0, 67.0, 22.0 ],
									"text" : "unpack f f f"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 302.0, 261.0, 55.0, 22.0 ],
									"text" : "zl.slice 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 59.0, 561.0, 70.0, 22.0 ],
									"text" : "s source_id"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 59.0, 271.0, 55.0, 22.0 ],
									"text" : "zl.slice 1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 12.0, 147.0, 239.0, 47.0 ],
									"text" : "Takes xyz and aed source coordinates, formatted as ambipoints, updates all source positional values accordingly"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 410.0, 403.0, 87.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 239.0, 207.0, 81.0, 22.0 ],
									"text" : "route xyz aed"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-2",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 257.0, 147.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 239.0, 561.0, 81.0, 22.0 ],
									"text" : "s source_aed"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 144.0, 561.0, 79.0, 22.0 ],
									"text" : "s source_xyz"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-22",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 574.0, 561.0, 105.0, 22.0 ],
									"text" : "s source_distance"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 449.0, 561.0, 109.0, 22.0 ],
									"text" : "s source_elevation"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 330.0, 561.0, 103.0, 22.0 ],
									"text" : "s source_azimuth"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"order" : 2,
									"source" : [ "obj-12", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-12", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"order" : 1,
									"source" : [ "obj-12", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"order" : 0,
									"source" : [ "obj-12", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"order" : 1,
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"order" : 0,
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 1 ],
									"source" : [ "obj-14", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 2 ],
									"source" : [ "obj-14", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 1 ],
									"source" : [ "obj-18", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-18", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 1 ],
									"source" : [ "obj-19", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-25", 0 ],
									"order" : 0,
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"order" : 1,
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-24", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-3", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-28", 0 ],
									"source" : [ "obj-32", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"order" : 1,
									"source" : [ "obj-4", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"order" : 0,
									"source" : [ "obj-4", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-16", 0 ],
									"source" : [ "obj-7", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-7", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
 ],
						"originid" : "pat-50"
					}
,
					"patching_rect" : [ 571.0, 153.0, 155.0, 22.0 ],
					"text" : "p source_location_handling"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-29",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 6,
					"outlettype" : [ "signal", "signal", "signal", "signal", "signal", "signal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 622.0, 186.0, 913.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-30",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 23.0, 341.0, 174.0, 34.0 ],
									"text" : "Routes input audio on the basis of the current play mode"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-29",
									"index" : 6,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 436.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-28",
									"index" : 5,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 394.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-27",
									"index" : 4,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 352.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-26",
									"index" : 3,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 309.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-25",
									"index" : 2,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 267.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-24",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 226.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 6,
									"outlettype" : [ "signal", "signal", "signal", "signal", "signal", "signal" ],
									"patching_rect" : [ 442.0, 493.0, 71.5, 22.0 ],
									"text" : "gate~ 6 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 436.0, 423.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 394.25, 423.0, 29.5, 22.0 ],
									"text" : "5"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 352.25, 423.0, 29.5, 22.0 ],
									"text" : "4"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 309.25, 423.0, 29.5, 22.0 ],
									"text" : "3"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 267.25, 423.0, 29.5, 22.0 ],
									"text" : "2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 226.25, 423.0, 29.5, 22.0 ],
									"text" : "1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 6,
									"outlettype" : [ "", "", "", "", "", "" ],
									"patching_rect" : [ 226.0, 287.0, 227.125, 22.0 ],
									"text" : "route mono bina omni vbap ambi"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 226.0, 228.0, 75.0, 22.0 ],
									"text" : "r play_mode"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 494.5, 220.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 1 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-12", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-23", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-23", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-26", 0 ],
									"source" : [ "obj-23", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-27", 0 ],
									"source" : [ "obj-23", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-28", 0 ],
									"source" : [ "obj-23", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-23", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-3", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-3", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-3", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-3", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-3", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
 ],
						"originid" : "pat-68"
					}
,
					"patching_rect" : [ 394.700000000000045, 347.0, 107.0, 22.0 ],
					"text" : "p play_mode_gate"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-7",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 518.0, 222.0, 1000.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-3",
									"lastchannelcount" : 1,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 313.0, 308.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[13]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[13]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 253.0, 501.0, 114.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 150.0, 601.0, 100.0, 36.0 ],
									"text" : "mc.send~ gm_omni"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 112.0, 216.399999999999977, 71.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 126.0, 383.0, 100.0, 22.0 ],
									"text" : "r omni_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 232.0, 261.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 402.0, 501.0, 72.0, 22.0 ],
									"text" : "mc.dup~ 24"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-2",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 402.0, 584.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 405.939999999999998, 212.400000000000006, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-10", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"order" : 0,
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"order" : 1,
									"source" : [ "obj-3", 0 ]
								}

							}
 ],
						"originid" : "pat-70"
					}
,
					"patching_rect" : [ 300.0, 424.0, 151.0, 22.0 ],
					"text" : "p omnichannel_processing"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-34",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 6,
					"outlettype" : [ "signal", "signal", "signal", "signal", "signal", "signal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 860.0, 269.0, 600.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-30",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 23.0, 341.0, 174.0, 34.0 ],
									"text" : "Routes input audio on the basis of the current play mode"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-29",
									"index" : 6,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 436.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-28",
									"index" : 5,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 394.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-27",
									"index" : 4,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 352.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-26",
									"index" : 3,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 309.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-25",
									"index" : 2,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 267.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-24",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 226.0, 574.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 6,
									"outlettype" : [ "signal", "signal", "signal", "signal", "signal", "signal" ],
									"patching_rect" : [ 442.0, 493.0, 71.5, 22.0 ],
									"text" : "gate~ 6 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-15",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 436.0, 423.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 394.25, 423.0, 29.5, 22.0 ],
									"text" : "5"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 352.25, 423.0, 29.5, 22.0 ],
									"text" : "4"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 309.25, 423.0, 29.5, 22.0 ],
									"text" : "3"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 267.25, 423.0, 29.5, 22.0 ],
									"text" : "2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 226.25, 423.0, 29.5, 22.0 ],
									"text" : "1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 6,
									"outlettype" : [ "", "", "", "", "", "" ],
									"patching_rect" : [ 226.0, 287.0, 227.125, 22.0 ],
									"text" : "route mono bina omni vbap ambi"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 226.0, 228.0, 75.0, 22.0 ],
									"text" : "r play_mode"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 494.5, 220.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 1 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-12", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-23", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-23", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-26", 0 ],
									"source" : [ "obj-23", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-27", 0 ],
									"source" : [ "obj-23", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-28", 0 ],
									"source" : [ "obj-23", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-23", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-3", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-3", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-3", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-3", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-3", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
 ],
						"originid" : "pat-72"
					}
,
					"patching_rect" : [ 324.300000000000011, 217.0, 107.0, 22.0 ],
					"text" : "p play_mode_gate"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-33",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 327.5, 153.0, 77.0, 22.0 ],
					"text" : "s play_mode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-28",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 185.0, 231.0, 600.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-4",
									"lastchannelcount" : 1,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 297.0, 287.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[14]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[14]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 182.5, 586.0, 147.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 161.0, 656.0, 100.0, 36.0 ],
									"text" : "mc.send~ output_binaural"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 201.0, 518.0, 110.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 166.0, 578.0, 100.0, 36.0 ],
									"text" : "mc.send~ gm_bina"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-70",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 47.0, 128.0, 68.0, 22.0 ],
									"text" : "r bina_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-66",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 162.0, 181.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-68",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 281.0, 124.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 354.0, 586.0, 54.0, 22.0 ],
									"text" : "mc.dac~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 354.0, 514.0, 65.0, 22.0 ],
									"text" : "mc.dup~ 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"linecount" : 6,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 410.0, 349.0, 150.0, 89.0 ],
									"text" : "currently just duplicates mono input across two channels. Should be modified to actually used proper ITD/ILD binauralization techniques"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"order" : 1,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"order" : 0,
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-66", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-68", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-66", 0 ],
									"source" : [ "obj-70", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"order" : 0,
									"source" : [ "obj-9", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"order" : 1,
									"source" : [ "obj-9", 0 ]
								}

							}
 ],
						"originid" : "pat-74"
					}
,
					"patching_rect" : [ 189.0, 424.0, 101.0, 22.0 ],
					"text" : "p binaural_output"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-19",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 1044.0, 193.0, 600.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-75",
									"lastchannelcount" : 1,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 258.0, 252.690000000000055, 48.0, 136.0 ],
									"presentation" : 1,
									"presentation_rect" : [ -16.0, 649.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[8]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[8]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-71",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 199.0, 493.0, 118.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 370.0, 535.0, 100.0, 36.0 ],
									"text" : "mc.send~ gm_mono"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-70",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 43.0, 124.0, 75.0, 22.0 ],
									"text" : "r mono_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-66",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 162.0, 181.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-68",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 281.0, 124.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"linecount" : 6,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 189.0, 617.0, 150.0, 89.0 ],
									"text" : "Trying to figure best way to output single channel signal with zeroed out multichannel, for display on the live gain on main screen"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 43.0, 534.0, 154.0, 22.0 ],
									"text" : "mc.resize~ 24 @replicate 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 55.0, 593.0, 77.0, 22.0 ],
									"text" : "mc.selector~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 183.0, 575.0, 60.0, 22.0 ],
									"text" : "mc.pack~"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-10",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 114.0, 663.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"linecount" : 8,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 712.639999999999986, 257.050000000000011, 160.0, 117.0 ],
									"text" : "Single channel output is set using an OSC message like \"mode mono 1\", which will activate a sender with the \"mono 1\" part of the message, which will set current speaker output to channel 1."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 365.589999999999975, 514.779999999999973, 54.0, 22.0 ],
									"text" : "mc.dac~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 393.45999999999998, 398.259999999999991, 72.0, 22.0 ],
									"text" : "prepend set"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 536.769999999999982, 324.490000000000009, 29.5, 22.0 ],
									"text" : "1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 376.70999999999998, 309.689999999999998, 69.0, 22.0 ],
									"text" : "route mono"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 520.200000000000045, 257.149999999999977, 58.0, 22.0 ],
									"text" : "loadbang"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 373.04000000000002, 242.090000000000003, 75.0, 22.0 ],
									"text" : "r play_mode"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-75", 0 ],
									"source" : [ "obj-66", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-75", 0 ],
									"source" : [ "obj-68", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-66", 0 ],
									"source" : [ "obj-70", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-71", 0 ],
									"order" : 1,
									"source" : [ "obj-75", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"order" : 0,
									"source" : [ "obj-75", 0 ]
								}

							}
 ],
						"originid" : "pat-76"
					}
,
					"patching_rect" : [ 43.0, 424.0, 132.0, 22.0 ],
					"text" : "p singlechannel_output"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-12",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "multichannelsignal", "multichannelsignal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 34.0, 218.0, 1000.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-21",
									"lastchannelcount" : 1,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 503.0, 496.0, 48.0, 136.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 639.0, 562.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[7]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[7]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 93.0, 513.0, 154.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 117.0, 530.0, 100.0, 35.0 ],
									"text" : "mc.send~ raw_ambi_signal"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 305.0, 513.0, 158.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 668.0, 448.0, 100.0, 49.0 ],
									"text" : "mc.send~ raw_mono_signal"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 268.0, 732.0, 114.0, 22.0 ],
									"text" : "mc.send~ gm_input"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 471.0, 659.0, 150.0, 20.0 ],
									"text" : "I hate this crossover"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 503.0, 452.0, 61.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 558.0, 530.0, 100.0, 22.0 ],
									"text" : "r init_gain"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-14",
									"index" : 2,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 491.0, 724.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-13",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 163.0, 728.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 18.0, 205.0, 150.0, 20.0 ],
									"text" : "Stops all current playback"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 136.0, 261.0, 41.0, 22.0 ],
									"text" : "loop 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 93.0, 261.0, 29.5, 22.0 ],
									"text" : "0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 192.0, 178.0, 62.0, 22.0 ],
									"text" : "route stop"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 386.0, 296.0, 449.0, 33.0 ],
									"text" : "Both the mc.sfplay and regular sfplay commands are sent in the expected format, except play commands need to be stripped of the word \"play\""
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "multichannelsignal", "bang" ],
									"patching_rect" : [ 218.0, 452.0, 83.0, 22.0 ],
									"text" : "mc.sfplay~ 36"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "bang" ],
									"patching_rect" : [ 371.0, 452.0, 47.0, 22.0 ],
									"text" : "sfplay~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 305.0, 295.0, 61.0, 22.0 ],
									"text" : "route play"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 246.0, 242.0, 65.0, 22.0 ],
									"text" : "route ambi"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 225.0, 295.0, 61.0, 22.0 ],
									"text" : "route play"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 192.0, 134.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-10", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"order" : 0,
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"order" : 1,
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-2", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"order" : 1,
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-18", 0 ],
									"order" : 0,
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-3", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-4", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-19", 0 ],
									"order" : 1,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"order" : 0,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"order" : 0,
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-20", 0 ],
									"order" : 1,
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-11", 0 ],
									"order" : 0,
									"source" : [ "obj-8", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-8", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"order" : 1,
									"source" : [ "obj-8", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-5", 0 ],
									"order" : 0,
									"source" : [ "obj-9", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-6", 0 ],
									"order" : 1,
									"source" : [ "obj-9", 0 ]
								}

							}
 ],
						"originid" : "pat-78"
					}
,
					"patching_rect" : [ 438.0, 153.0, 107.0, 22.0 ],
					"text" : "p playlist_handling"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 438.0, 99.0, 71.0, 22.0 ],
					"text" : "route sfplay"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-26",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 608.0, 177.0, 1439.0, 854.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-22",
									"linecount" : 11,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 881.0, 420.0, 419.0, 131.0 ],
									"text" : "speakers xyz 1 1.21959 -0.810473 1.951752 xyz 2 -0.691322 -0.167118 2.007746 xyz 3 0.588704 0.257941 1.925563 xyz 4 -1.281135 0.841899 2.050244 xyz 5 0.355691 1.440758 1.829873 xyz 6 2.127138 -0.790856 -1.329184 xyz 7 2.197741 -0.223469 0.427198 xyz 8 2.215314 0.269107 -0.193815 xyz 9 2.187724 0.842172 1.475639 xyz 10 1.909857 1.574766 -0.167091 xyz 11 -1.381453 -0.732111 -2.127252 xyz 12 0.533378 -0.194804 -1.990593 xyz 13 -0.656914 0.245965 -2.021773 xyz 14 1.061015 0.70116 -2.08236 xyz 15 0.617832 1.391131 -1.69748 xyz 16 -2.093299 -0.796567 1.359404 xyz 17 -2.224161 -0.246902 -0.233768 xyz 18 -2.241915 0.37009 0.558972 xyz 19 -2.213873 0.817569 -1.22717 xyz 20 -2.064567 1.609427 0.1082 xyz 21 -0.921387 2.002955 0.988066 xyz 22 0.815213 1.826657 0.874209 xyz 23 1.036126 1.707384 -0.80951 xyz 24 -0.975244 1.805688 -0.941782"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-55",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 247.0, 749.5, 78.0, 22.0 ],
									"text" : "gain gain -30"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-112",
									"linecount" : 9,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 719.0, 432.5, 143.0, 107.0 ],
									"text" : "Sets the position of each speaker.\n\nID# corresponds to output channel # (e.g. Dante Controller). \n\nCoordinate system is the same as Source Control."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-110",
									"linecount" : 4,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 829.5, 743.0, 189.5, 60.0 ],
									"text" : "\"gain\" + ambi_encoder/decoder applies to the mono signal or HOA signal incoming to the ambisonic encoding/decoding"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-105",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 526.0, 749.5, 283.0, 47.0 ],
									"text" : "\"gain\" + mono/bina/omni/vbap + int applies to the mono signal incoming to the appropriate subpatcher"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-102",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 353.5, 749.5, 150.0, 47.0 ],
									"text" : "\"gain speakers\" + int applies to the final outgoing signal"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-98",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 277.0, 706.0, 71.0, 22.0 ],
									"text" : "gain vbap 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-54",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 185.0, 706.0, 81.0, 22.0 ],
									"text" : "gain omni -20"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-51",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 100.0, 706.0, 75.0, 22.0 ],
									"text" : "gain mono 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-30",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 29.0, 706.0, 52.0, 22.0 ],
									"text" : "gain -30"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-103",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 66.0, 213.0, 65.0, 22.0 ],
									"text" : "mode bina"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-99",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 377.0, 706.0, 259.0, 33.0 ],
									"text" : "\"gain + int\" applies an initial gain to the incoming mono signal"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-72",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 85.0, 762.0, 100.0, 22.0 ],
									"text" : "s command_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-52",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 727.0, 706.0, 98.0, 22.0 ],
									"text" : "r command_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-37",
									"linecount" : 3,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 47.75, 418.5, 181.0, 49.0 ],
									"text" : "sfplay preload 1 whitenoise_10s_400_to_16Khz_ramped.wav"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-33",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 430.0, 205.5, 153.0, 47.0 ],
									"text" : "this needs to be done on a playlist-object specific manner"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"linecount" : 5,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 523.0, 527.0, 155.0, 74.0 ],
									"text" : "ultimately multiple playlists would be helpful? currently one for ambi encoded, one for mono. Could add dolby etc"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1159.0, 647.0, 124.0, 22.0 ],
									"text" : "r command_speakers"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-107",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 940.0, 580.0, 126.0, 22.0 ],
									"text" : "s command_speakers"
								}

							}
, 							{
								"box" : 								{
									"bubbleusescolors" : 1,
									"fontsize" : 24.0,
									"id" : "obj-108",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 706.0, 341.0, 479.0, 33.0 ],
									"text" : "Speaker Control",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-116",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 869.0, 397.0, 150.0, 22.0 ],
									"text" : "Position - XYZ/AED",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-117",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 869.0, 397.0, 455.0, 175.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-118",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 719.0, 420.0, 368.0, 18.0 ]
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-119",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 715.0, 397.0, 150.0, 22.0 ],
									"text" : "Details",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-120",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 715.0, 397.0, 149.0, 175.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"border" : 4,
									"bordercolor" : [ 0.713725490196078, 0.788235294117647, 0.905882352941176, 1.0 ],
									"id" : "obj-121",
									"maxclass" : "panel",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 695.0, 325.0, 650.0, 291.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-92",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1174.0, 227.0, 150.0, 20.0 ],
									"text" : "Back left and low"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-91",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1174.0, 197.0, 150.0, 20.0 ],
									"text" : "Right and up"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-90",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1174.0, 168.0, 150.0, 20.0 ],
									"text" : "Directly in front"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-69",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1029.5, 226.0, 132.0, 22.0 ],
									"text" : "source aed 1 220 -15 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-68",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1037.0, 196.0, 121.0, 22.0 ],
									"text" : "source aed 1 90 30 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-67",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 860.0, 226.0, 168.0, 22.0 ],
									"text" : "source xyz 1 -1.24 -0.52 -1.48"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-66",
									"linecount" : 4,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1187.0, 53.0, 154.0, 60.0 ],
									"text" : "We want the abiliy to tie ID# to playlist # - can then preset positions of items in a playlist independently"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-65",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 881.0, 196.0, 123.0, 22.0 ],
									"text" : "source xyz 1 1.73 1 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-64",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1043.5, 167.0, 108.0, 22.0 ],
									"text" : "source aed 1 0 0 2"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 940.0, 269.0, 113.0, 22.0 ],
									"text" : "s command_source"
								}

							}
, 							{
								"box" : 								{
									"bubbleusescolors" : 1,
									"fontsize" : 24.0,
									"id" : "obj-10",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 706.0, 30.0, 479.0, 33.0 ],
									"text" : "Source Control",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-34",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1027.0, 145.0, 141.5, 18.0 ],
									"text" : "\"source aed \" + ID + A E D"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-35",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1027.0, 109.0, 145.0, 40.0 ],
									"text" : "Sets the position of the next ambisonic or vbap output using polar coordinates"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-40",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1023.0, 86.0, 150.0, 22.0 ],
									"text" : "Position - AED",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-41",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1023.0, 86.0, 149.0, 178.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-42",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 873.0, 145.0, 141.5, 18.0 ],
									"text" : "\"source xyz \" + ID + X Y Z"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-47",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 873.0, 109.0, 145.0, 40.0 ],
									"text" : "Sets the position of the next ambisonic or vbap output using Cartesian coordinates"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-48",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 881.0, 167.0, 106.0, 22.0 ],
									"text" : "source xyz 1 0 0 2"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-49",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 869.0, 86.0, 150.0, 22.0 ],
									"text" : "Position - XYZ",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-50",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 869.0, 86.0, 150.0, 178.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-53",
									"linecount" : 12,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 719.0, 109.0, 144.0, 141.0 ],
									"text" : "Cartesian (XYZ) and polar distance (D) coordinates are in meters. \n\nAzimuth (A) can either be expressed as 0 to 360 or -180 to 180. \n\nThe origin of both coordinate systems is the listener's head - typically  (0, 1.2, 0) in Unity's coordinate system"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-56",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 715.0, 86.0, 150.0, 22.0 ],
									"text" : "Details",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-62",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 715.0, 86.0, 149.0, 175.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"border" : 4,
									"bordercolor" : [ 0.713725490196078, 0.788235294117647, 0.905882352941176, 1.0 ],
									"id" : "obj-63",
									"maxclass" : "panel",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 695.0, 14.0, 650.0, 291.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1023.0, 647.0, 111.0, 22.0 ],
									"text" : "r command_source"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-71",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 888.0, 647.0, 107.0, 22.0 ],
									"text" : "r command_sfplay"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-44",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 757.0, 647.0, 105.0, 22.0 ],
									"text" : "r command_mode"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 289.5, 218.5, 107.0, 22.0 ],
									"text" : "s command_mode"
								}

							}
, 							{
								"box" : 								{
									"bubbleusescolors" : 1,
									"fontsize" : 24.0,
									"id" : "obj-38",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 189.0, 27.0, 479.0, 33.0 ],
									"text" : "Mode Selection",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-25",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 503.0, 145.0, 141.5, 18.0 ],
									"text" : "\"mode ambi\""
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-26",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 503.0, 109.0, 145.0, 40.0 ],
									"text" : "The next sound played will be spatialized using Ambisonics and ALLRAD"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-27",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 540.0, 167.0, 68.0, 22.0 ],
									"text" : "mode ambi"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-28",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 499.0, 86.0, 150.0, 22.0 ],
									"text" : "Ambisonics",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-29",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 499.0, 86.0, 150.0, 115.5 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-18",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 350.0, 145.0, 141.5, 18.0 ],
									"text" : "\"mode vbap\""
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-19",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 350.0, 109.0, 145.0, 29.0 ],
									"text" : "The next sound played will be spatialized using VBAP"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-20",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 387.0, 167.0, 68.0, 22.0 ],
									"text" : "mode vbap"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-21",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 346.0, 86.0, 150.0, 22.0 ],
									"text" : "VBAP",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-23",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 346.0, 86.0, 150.0, 115.5 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-8",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 196.0, 145.0, 141.5, 18.0 ],
									"text" : "\"mode omni\""
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-12",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 196.0, 109.0, 145.0, 29.0 ],
									"text" : "The next sound will play from all speakers equally"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-14",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 233.0, 167.0, 68.0, 22.0 ],
									"text" : "mode omni"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-15",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 192.0, 86.0, 150.0, 22.0 ],
									"text" : "Omnisonic",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-16",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 192.0, 86.0, 150.0, 115.5 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-36",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 42.0, 86.0, 141.5, 18.0 ],
									"text" : "\"mode mono \" + channel #"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-24",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 72.0, 172.0, 89.0, 22.0 ],
									"text" : "mode mono 17"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-17",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 42.0, 50.0, 142.0, 29.0 ],
									"text" : "The next sound will play from a single speaker."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 72.0, 140.0, 82.0, 22.0 ],
									"text" : "mode mono 8"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 72.0, 108.0, 82.0, 22.0 ],
									"text" : "mode mono 1"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-4",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 38.0, 27.0, 150.0, 22.0 ],
									"text" : "Single Speaker",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 995.0, 702.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-3",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 38.0, 27.0, 149.0, 175.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"border" : 4,
									"bordercolor" : [ 0.713725490196078, 0.788235294117647, 0.905882352941176, 1.0 ],
									"id" : "obj-31",
									"maxclass" : "panel",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 18.0, 14.0, 650.0, 238.0 ]
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-93",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 34.5, 610.0, 206.0, 18.0 ],
									"text" : "\"sfplay stop\""
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-94",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 36.5, 572.0, 206.0, 40.0 ],
									"text" : "Stops all active playback. The equivalent of sending \"play 0\", \"ambi play 0\", \"loop 0\" and \"ambi loop 0\" all at once."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-95",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 46.5, 633.0, 66.0, 22.0 ],
									"text" : "sfplay stop"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-96",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 32.5, 549.0, 208.0, 22.0 ],
									"text" : "Stop",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-97",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 32.5, 549.0, 211.0, 125.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-82",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 474.0, 492.5, 105.0, 22.0 ],
									"text" : "sfplay ambi loop 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-83",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 560.0, 432.5, 76.0, 22.0 ],
									"text" : "sfplay loop 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-84",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 475.0, 464.5, 105.0, 22.0 ],
									"text" : "sfplay ambi loop 1"
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-85",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 463.0, 372.5, 206.0, 29.0 ],
									"text" : "\"sfplay loop \" + Playlist position\n\"sfplay ambi loop \" + Playlist position"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-86",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 465.0, 334.5, 204.0, 40.0 ],
									"text" : "Plays the desired playlist track on a continuous loop. Playing track 0 stops active playback."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-87",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 475.0, 432.5, 76.0, 22.0 ],
									"text" : "sfplay loop 1"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-88",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 461.0, 311.5, 208.0, 22.0 ],
									"text" : "Loop",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-89",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 461.0, 311.5, 211.0, 213.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-81",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 260.0, 492.5, 105.0, 22.0 ],
									"text" : "sfplay ambi play 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-80",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 346.0, 432.5, 75.0, 22.0 ],
									"text" : "sfplay play 0"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-74",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 261.0, 464.5, 184.0, 22.0 ],
									"text" : "sfplay ambi play 1"
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-75",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 249.0, 372.5, 206.0, 29.0 ],
									"text" : "\"sfplay play \" + Playlist position\n\"sfplay ambi play \" + Playlist position"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-76",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 251.0, 334.5, 204.0, 29.0 ],
									"text" : "Plays the desired playlist track. Playing track 0 stops active playback."
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-77",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 261.0, 432.5, 75.0, 22.0 ],
									"text" : "sfplay play 1"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-78",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 247.0, 311.5, 208.0, 22.0 ],
									"text" : "Play",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-79",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 247.0, 311.5, 211.0, 213.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-73",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 49.75, 485.0, 198.0, 22.0 ],
									"text" : "sfplay ambi preload 1 quicktest.wav"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-45",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 410.0, 565.0, 109.0, 22.0 ],
									"text" : "s command_sfplay"
								}

							}
, 							{
								"box" : 								{
									"bubbleusescolors" : 1,
									"fontsize" : 24.0,
									"id" : "obj-46",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 247.0, 268.0, 425.0, 33.0 ],
									"text" : "Playlist Control",
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"fontface" : 3,
									"fontsize" : 10.0,
									"id" : "obj-57",
									"linecount" : 4,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 34.5, 326.5, 206.0, 51.0 ],
									"text" : "\"sfplay preload \" + Playlist position + filename\n\"sfplay ambi preload \" + Playlist position + filename"
								}

							}
, 							{
								"box" : 								{
									"fontsize" : 10.0,
									"id" : "obj-58",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 36.5, 288.5, 204.0, 29.0 ],
									"text" : "Preloads a mono file or HOA ambisonic file to appropriate playlist"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-59",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 46.5, 386.5, 177.0, 22.0 ],
									"text" : "sfplay preload 1 drumLoop.aif"
								}

							}
, 							{
								"box" : 								{
									"bgcolor" : [ 0.184313725490196, 0.086274509803922, 0.086274509803922, 0.0 ],
									"bubble_bgcolor" : [ 0.368627450980392, 0.368627450980392, 0.368627450980392, 1.0 ],
									"fontface" : 1,
									"fontsize" : 14.0,
									"id" : "obj-60",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 32.5, 265.5, 208.0, 22.0 ],
									"text" : "Preload",
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"textjustification" : 1
								}

							}
, 							{
								"box" : 								{
									"angle" : 270.0,
									"bgcolor" : [ 0.352941176470588, 0.349019607843137, 0.349019607843137, 1.0 ],
									"border" : 2,
									"bordercolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"id" : "obj-61",
									"maxclass" : "panel",
									"mode" : 0,
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 33.0, 266.0, 210.5, 276.0 ],
									"proportion" : 0.5
								}

							}
, 							{
								"box" : 								{
									"border" : 4,
									"bordercolor" : [ 0.713725490196078, 0.788235294117647, 0.905882352941176, 1.0 ],
									"id" : "obj-70",
									"maxclass" : "panel",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 19.0, 256.0, 669.0, 430.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-39",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 514.0, 463.0, 150.0, 20.0 ],
									"text" : "Ambisonic Sound Control"
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-103", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-20", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-107", 0 ],
									"source" : [ "obj-22", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-24", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-27", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-30", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-37", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-44", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-48", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-51", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-52", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-54", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-55", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-59", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-64", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-65", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-67", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-68", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-69", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-7", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-71", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-73", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-74", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-77", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-80", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-81", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-82", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-83", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-84", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-87", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-45", 0 ],
									"source" : [ "obj-95", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-98", 0 ]
								}

							}
 ],
						"originid" : "pat-80",
						"boxgroups" : [ 							{
								"boxes" : [ "obj-31", "obj-23", "obj-20", "obj-18", "obj-19", "obj-21", "obj-29", "obj-27", "obj-25", "obj-26", "obj-28", "obj-43", "obj-16", "obj-14", "obj-8", "obj-12", "obj-15", "obj-3", "obj-11", "obj-24", "obj-5", "obj-36", "obj-17", "obj-4", "obj-38" ]
							}
, 							{
								"boxes" : [ "obj-63", "obj-41", "obj-34", "obj-35", "obj-40", "obj-2", "obj-50", "obj-48", "obj-42", "obj-47", "obj-49", "obj-62", "obj-53", "obj-56", "obj-10", "obj-69", "obj-92", "obj-67", "obj-65", "obj-68", "obj-91", "obj-64", "obj-90", "obj-66" ]
							}
, 							{
								"boxes" : [ "obj-121", "obj-107", "obj-117", "obj-116", "obj-120", "obj-118", "obj-119", "obj-108" ]
							}
, 							{
								"boxes" : [ "obj-70", "obj-88", "obj-86", "obj-85", "obj-87", "obj-84", "obj-89", "obj-83", "obj-82", "obj-39", "obj-45", "obj-78", "obj-76", "obj-75", "obj-77", "obj-74", "obj-79", "obj-80", "obj-81", "obj-60", "obj-58", "obj-57", "obj-59", "obj-73", "obj-61", "obj-96", "obj-94", "obj-93", "obj-95", "obj-97", "obj-46" ]
							}
 ]
					}
,
					"patching_rect" : [ 168.0, 41.0, 152.0, 22.0 ],
					"text" : "p udp_command_overview"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 60.5, 94.0, 61.0, 22.0 ],
					"text" : "s udpmsg"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-21",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 60.5, 41.0, 97.0, 22.0 ],
					"text" : "udpreceive 7374"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-24",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 571.0, 99.0, 75.0, 22.0 ],
					"text" : "route source"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-10",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 327.5, 99.0, 69.0, 22.0 ],
					"text" : "route mode"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "multichannelsignal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 221.0, 96.0, 995.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"visible" : 1,
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-25",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 338.0, 431.0, 35.0, 22.0 ],
									"text" : "clear"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-18",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 760.0, 157.0, 29.5, 22.0 ],
									"text" : "set"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-12",
									"linecount" : 4,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 539.0, 255.0, 402.0, 62.0 ],
									"text" : "define_loudspeakers 3 32. -19.4 -19. -4.5 17. 7.3 -32. 19.2 11. 37.7 122. -17.5 79. -5.7 95. 6.9 56. 17.7 95. 39.4 -147. -16.1 165. -5.4 -162. 6.6 153. 16.7 160. 37.6 -57. -17.7 -96. -6.3 -76. 9.1 -119. 17.9 -87. 37.9 -43. 56. 43. 56.8 128. 52.4 -134. 53.1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 207.0, 431.0, 61.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 207.0, 431.0, 100.0, 22.0 ],
									"text" : "vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 465.0, 347.0, 22.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 624.0, 415.0, 100.0, 22.0 ],
									"text" : "t b"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 334.0, 347.0, 22.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 609.0, 400.0, 100.0, 22.0 ],
									"text" : "t b"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "bang" ],
									"patching_rect" : [ 172.0, 201.0, 42.0, 22.0 ],
									"text" : "edge~"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 267.5, 233.0, 97.0, 22.0 ],
									"text" : "r speakers_vbap"
								}

							}
, 							{
								"box" : 								{
									"format" : 6,
									"id" : "obj-15",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 389.0, 365.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"format" : 6,
									"id" : "obj-14",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 267.5, 377.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-24",
									"lastchannelcount" : 1,
									"maxclass" : "mc.live.gain~",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "multichannelsignal", "", "float", "list" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 136.0, 278.0, 48.0, 136.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 136.0, 278.0, 48.0, 136.0 ],
									"saved_attribute_attributes" : 									{
										"valueof" : 										{
											"parameter_longname" : "mc.live.gain~[10]",
											"parameter_mmax" : 6.0,
											"parameter_mmin" : -70.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "mc.live.gain~[10]",
											"parameter_type" : 0,
											"parameter_unitstyle" : 4
										}

									}
,
									"varname" : "mc.live.gain~[1]"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 45.0, 465.0, 114.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 45.0, 465.0, 100.0, 35.0 ],
									"text" : "mc.send~ gm_vbap"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-22",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 82.0, 128.0, 50.0, 22.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2.0, 81.0, 71.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 65.0, 258.0, 100.0, 22.0 ],
									"text" : "r vbap_gain"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-10",
									"linecount" : 4,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 231.0, 152.0, 331.0, 62.0 ],
									"text" : "define_loudspeakers 3 32 -19.4 341 -4.5 17 7.3 328 19.2 11 37.7 122 -17.5 79 -5.7 95 6.9 56 17.7 95 39.4 213 -16.1 165 -5.4 198 6.6 153 16.7 160 37.6 303 -17.7 264 -6.3 284 9.1 241 17.9 273 37.9 317 56 43 56.8 128 52.4 226 53.1"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-7",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 587.0, 68.0, 293.0, 47.0 ],
									"text" : "Handles VBAP localization of incoming audio. Currently speaker locations are hard coded, need to implement properly"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 231.0, 104.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 389.0, 315.0, 107.0, 22.0 ],
									"text" : "r source_elevation"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 267.5, 315.0, 101.0, 22.0 ],
									"text" : "r source_azimuth"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-31",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 156.0, 673.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 24,
									"numoutlets" : 1,
									"outlettype" : [ "multichannelsignal" ],
									"patching_rect" : [ 156.0, 626.0, 260.5, 22.0 ],
									"text" : "mc.combine~ 24"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 25,
									"outlettype" : [ "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "signal", "" ],
									"patching_rect" : [ 156.0, 487.0, 271.0, 22.0 ],
									"text" : "matrix~ 1 24 1"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 156.0, 23.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"order" : 1,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-9", 0 ],
									"order" : 0,
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-11", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"order" : 1,
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-25", 0 ],
									"order" : 0,
									"source" : [ "obj-13", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 1 ],
									"source" : [ "obj-14", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 2 ],
									"source" : [ "obj-15", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 1 ],
									"order" : 0,
									"source" : [ "obj-16", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"order" : 1,
									"source" : [ "obj-16", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-17", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-18", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-13", 0 ],
									"order" : 0,
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-14", 0 ],
									"order" : 1,
									"source" : [ "obj-2", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-21", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-22", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-23", 0 ],
									"order" : 1,
									"source" : [ "obj-24", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"order" : 0,
									"source" : [ "obj-24", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-25", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 23 ],
									"source" : [ "obj-3", 23 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 22 ],
									"source" : [ "obj-3", 22 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 21 ],
									"source" : [ "obj-3", 21 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 20 ],
									"source" : [ "obj-3", 20 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 19 ],
									"source" : [ "obj-3", 19 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 18 ],
									"source" : [ "obj-3", 18 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 17 ],
									"source" : [ "obj-3", 17 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 16 ],
									"source" : [ "obj-3", 16 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 15 ],
									"source" : [ "obj-3", 15 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 14 ],
									"source" : [ "obj-3", 14 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 13 ],
									"source" : [ "obj-3", 13 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 12 ],
									"source" : [ "obj-3", 12 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 11 ],
									"source" : [ "obj-3", 11 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 10 ],
									"source" : [ "obj-3", 10 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 9 ],
									"source" : [ "obj-3", 9 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 8 ],
									"source" : [ "obj-3", 8 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 7 ],
									"source" : [ "obj-3", 7 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 6 ],
									"source" : [ "obj-3", 6 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 5 ],
									"source" : [ "obj-3", 5 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 4 ],
									"source" : [ "obj-3", 4 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 3 ],
									"source" : [ "obj-3", 3 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 2 ],
									"source" : [ "obj-3", 2 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 1 ],
									"source" : [ "obj-3", 1 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-3", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-4", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-15", 0 ],
									"order" : 1,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-17", 0 ],
									"order" : 0,
									"source" : [ "obj-5", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-6", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-9", 0 ]
								}

							}
 ],
						"originid" : "pat-82"
					}
,
					"patching_rect" : [ 461.099999999999966, 424.0, 109.0, 22.0 ],
					"text" : "p vbap_processing"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-2",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patcher" : 					{
						"fileversion" : 1,
						"appversion" : 						{
							"major" : 9,
							"minor" : 0,
							"revision" : 5,
							"architecture" : "x64",
							"modernui" : 1
						}
,
						"classnamespace" : "box",
						"rect" : [ 536.0, 230.0, 1000.0, 780.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [ 							{
								"box" : 								{
									"id" : "obj-4",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 452.0, 256.0, 150.0, 34.0 ],
									"text" : "very simple distance attenuation"
								}

							}
, 							{
								"box" : 								{
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 312.0, 196.0, 79.0, 22.0 ],
									"text" : "r source_aed"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 10.0, 59.0, 425.0, 365.0 ],
										"default_fontsize" : 11.0,
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "signal" ],
													"patching_rect" : [ 112.0, 226.0, 58.0, 19.0 ],
													"text" : "onepole~"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "signal" ],
													"patching_rect" : [ 112.0, 201.0, 33.0, 19.0 ],
													"text" : "sig~"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-3",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "signal" ],
													"patching_rect" : [ 32.0, 263.0, 65.0, 19.0 ],
													"text" : "tapout~ 0."
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "tapconnect" ],
													"patching_rect" : [ 32.0, 226.0, 73.0, 19.0 ],
													"text" : "tapin~ 2000"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-5",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 285.0, 93.0, 93.0, 19.0 ],
													"text" : "radius in metres"
												}

											}
, 											{
												"box" : 												{
													"comment" : "metres per unit",
													"id" : "obj-6",
													"index" : 3,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 259.0, 92.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 112.0, 121.0, 48.0, 19.0 ],
													"text" : "zl nth 3"
												}

											}
, 											{
												"box" : 												{
													"comment" : "aed coordinate triplet",
													"id" : "obj-8",
													"index" : 2,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 112.0, 92.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 112.0, 152.0, 32.5, 19.0 ],
													"text" : "* 1."
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 112.0, 176.0, 54.0, 19.0 ],
													"text" : "/ 0.3438"
												}

											}
, 											{
												"box" : 												{
													"comment" : "signal out",
													"id" : "obj-11",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 32.0, 287.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "signal in",
													"id" : "obj-12",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 32.0, 58.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-13",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 23.0, 22.0, 73.0, 19.0 ],
													"text" : "doppler shift"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-14",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 59.0, 59.0, 52.0, 19.0 ],
													"text" : "signal in"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-15",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 139.0, 92.0, 114.0, 19.0 ],
													"text" : "aed coordinate input"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-16",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 175.0, 176.0, 242.0, 19.0 ],
													"text" : "speed of sound in dry air at 20 °C: 343.8 m/s"
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-3", 0 ],
													"midpoints" : [ 121.5, 251.0, 41.5, 251.0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-10", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-4", 0 ],
													"source" : [ "obj-12", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-2", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-3", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-3", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 1 ],
													"midpoints" : [ 268.5, 148.0, 135.0, 148.0 ],
													"source" : [ "obj-6", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-86"
									}
,
									"patching_rect" : [ 296.0, 311.0, 158.0, 21.0 ],
									"saved_object_attributes" : 									{
										"fontsize" : 11.0
									}
,
									"text" : "p dopplershift"
								}

							}
, 							{
								"box" : 								{
									"fontname" : "Verdana",
									"fontsize" : 10.0,
									"id" : "obj-58",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patcher" : 									{
										"fileversion" : 1,
										"appversion" : 										{
											"major" : 9,
											"minor" : 0,
											"revision" : 5,
											"architecture" : "x64",
											"modernui" : 1
										}
,
										"classnamespace" : "box",
										"rect" : [ 1191.0, 293.0, 441.0, 428.0 ],
										"default_fontsize" : 11.0,
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [ 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 63.0, 119.0, 55.0, 21.0 ],
													"text" : "clip 0. 1."
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 63.0, 97.0, 49.0, 21.0 ],
													"text" : "zl nth 3"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-3",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "int", "int" ],
													"patching_rect" : [ 109.0, 215.0, 38.0, 21.0 ],
													"text" : "t 1 1"
												}

											}
, 											{
												"box" : 												{
													"comment" : "aed coordinate triplet",
													"id" : "obj-4",
													"index" : 2,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 63.0, 68.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-5",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 109.0, 193.0, 57.0, 21.0 ],
													"text" : "loadbang"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-6",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 5,
													"outlettype" : [ "signal", "signal", "signal", "signal", "signal" ],
													"patching_rect" : [ 63.0, 238.0, 111.0, 21.0 ],
													"text" : "filtercoeff~ lowpass"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "signal" ],
													"patching_rect" : [ 40.0, 267.0, 134.0, 21.0 ],
													"text" : "biquad~"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 63.0, 140.0, 57.0, 21.0 ],
													"text" : "* 17000."
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 63.0, 161.0, 59.0, 21.0 ],
													"text" : "!- 18000."
												}

											}
, 											{
												"box" : 												{
													"comment" : "filtered signal",
													"id" : "obj-10",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 40.0, 292.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"comment" : "signal in",
													"id" : "obj-11",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 40.0, 36.0, 25.0, 25.0 ]
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-12",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 15.0, 6.0, 293.0, 19.0 ],
													"text" : "high-frequency absorption by air as function of distance"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-13",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 67.0, 39.0, 53.0, 19.0 ],
													"text" : "signal in"
												}

											}
, 											{
												"box" : 												{
													"fontname" : "Verdana",
													"fontsize" : 10.0,
													"id" : "obj-14",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 91.0, 71.0, 115.0, 19.0 ],
													"text" : "aed coordinate input"
												}

											}
 ],
										"lines" : [ 											{
												"patchline" : 												{
													"destination" : [ "obj-8", 0 ],
													"source" : [ "obj-1", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-11", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-2", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-6", 2 ],
													"source" : [ "obj-3", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-6", 1 ],
													"source" : [ "obj-3", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-4", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-3", 0 ],
													"source" : [ "obj-5", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 5 ],
													"source" : [ "obj-6", 4 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 4 ],
													"source" : [ "obj-6", 3 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 3 ],
													"source" : [ "obj-6", 2 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 2 ],
													"source" : [ "obj-6", 1 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-7", 1 ],
													"source" : [ "obj-6", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-7", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-8", 0 ]
												}

											}
, 											{
												"patchline" : 												{
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-9", 0 ]
												}

											}
 ],
										"originid" : "pat-88"
									}
,
									"patching_rect" : [ 251.0, 269.0, 73.0, 21.0 ],
									"saved_object_attributes" : 									{
										"fontsize" : 11.0
									}
,
									"text" : "p absorption"
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-2",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 189.0, 400.0, 30.0, 30.0 ]
								}

							}
, 							{
								"box" : 								{
									"comment" : "",
									"id" : "obj-1",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 189.0, 166.0, 30.0, 30.0 ]
								}

							}
 ],
						"lines" : [ 							{
								"patchline" : 								{
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-1", 0 ]
								}

							}
, 							{
								"patchline" : 								{
									"destination" : [ "obj-58", 1 ],
									"source" : [ "obj-3", 0 ]
								}

							}
 ],
						"originid" : "pat-84"
					}
,
					"patching_rect" : [ 394.700000000000045, 295.0, 187.0, 22.0 ],
					"text" : "p source_distance_compensation"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"source" : [ "obj-10", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 1 ],
					"source" : [ "obj-12", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-34", 0 ],
					"source" : [ "obj-12", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-29", 0 ],
					"source" : [ "obj-2", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"source" : [ "obj-21", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-35", 0 ],
					"source" : [ "obj-24", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-25", 0 ],
					"source" : [ "obj-26", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-29", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"source" : [ "obj-29", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-6", 0 ],
					"source" : [ "obj-29", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 0 ],
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-19", 0 ],
					"source" : [ "obj-34", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"source" : [ "obj-34", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"source" : [ "obj-34", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-2", 0 ],
					"source" : [ "obj-34", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-7", 0 ],
					"source" : [ "obj-34", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-1", 0 ],
					"order" : 0,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-10", 0 ],
					"order" : 4,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-24", 0 ],
					"order" : 2,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-5", 0 ],
					"order" : 3,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-8", 0 ],
					"order" : 1,
					"source" : [ "obj-39", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-38", 0 ],
					"source" : [ "obj-43", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-12", 0 ],
					"source" : [ "obj-5", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 0 ],
					"source" : [ "obj-6", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-43", 0 ],
					"source" : [ "obj-7", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-9", 0 ],
					"source" : [ "obj-8", 0 ]
				}

			}
 ],
		"originid" : "pat-16",
		"parameters" : 		{
			"obj-12::obj-21" : [ "mc.live.gain~[7]", "mc.live.gain~[7]", 0 ],
			"obj-13::obj-14" : [ "mc.live.gain~[3]", "mc.live.gain~[3]", 0 ],
			"obj-13::obj-15" : [ "mc.live.gain~[4]", "mc.live.gain~[4]", 0 ],
			"obj-13::obj-18" : [ "live.gain~[1]", "live.gain~[1]", 0 ],
			"obj-13::obj-36" : [ "live.gain~[4]", "live.gain~[1]", 0 ],
			"obj-13::obj-41" : [ "live.gain~[5]", "live.gain~[1]", 0 ],
			"obj-13::obj-42" : [ "live.gain~[6]", "live.gain~[1]", 0 ],
			"obj-13::obj-43" : [ "live.gain~[7]", "live.gain~[1]", 0 ],
			"obj-13::obj-44" : [ "live.gain~[8]", "live.gain~[1]", 0 ],
			"obj-13::obj-45" : [ "live.gain~[9]", "live.gain~[1]", 0 ],
			"obj-13::obj-54" : [ "mc.live.gain~[5]", "mc.live.gain~[5]", 0 ],
			"obj-13::obj-56" : [ "mc.live.gain~[6]", "mc.live.gain~[6]", 0 ],
			"obj-19::obj-75" : [ "mc.live.gain~[8]", "mc.live.gain~[8]", 0 ],
			"obj-28::obj-4" : [ "mc.live.gain~[14]", "mc.live.gain~[14]", 0 ],
			"obj-32::obj-36::obj-9" : [ "mc.live.gain~[16]", "mc.live.gain~[11]", 0 ],
			"obj-32::obj-37::obj-14" : [ "mc.live.gain~[15]", "mc.live.gain~[12]", 0 ],
			"obj-32::obj-37::obj-9" : [ "mcs.vst~[1]", "mcs.vst~", 0 ],
			"obj-38::obj-17" : [ "mc.live.gain~", "mc.live.gain~", 0 ],
			"obj-6::obj-24" : [ "mc.live.gain~[10]", "mc.live.gain~[10]", 0 ],
			"obj-7::obj-3" : [ "mc.live.gain~[13]", "mc.live.gain~[13]", 0 ],
			"parameterbanks" : 			{
				"0" : 				{
					"index" : 0,
					"name" : "",
					"parameters" : [ "-", "-", "-", "-", "-", "-", "-", "-" ]
				}

			}
,
			"inherited_shortname" : 1
		}
,
		"dependency_cache" : [ 			{
				"name" : "AllRADecoder.maxsnap",
				"bootpath" : "~/Documents/Max 9/Snapshots",
				"patcherrelativepath" : "../../../../../Max 9/Snapshots",
				"type" : "mx@s",
				"implicit" : 1
			}
, 			{
				"name" : "ambimonitor.mxo",
				"type" : "iLaX"
			}
, 			{
				"name" : "mc.ambidecode~.mxo",
				"type" : "iLaX"
			}
, 			{
				"name" : "mc.ambiencode~.mxo",
				"type" : "iLaX"
			}
, 			{
				"name" : "z.3Dcartopol.maxpat",
				"bootpath" : "~/Documents/GitHub/SpatialAudioTesting/Max9/Library/z.abstractions_patches/z.3D.cartopol",
				"patcherrelativepath" : "../../Library/z.abstractions_patches/z.3D.cartopol",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "z.3Dpoltocar.maxpat",
				"bootpath" : "~/Documents/GitHub/SpatialAudioTesting/Max9/Library/z.abstractions_patches/z.3D.poltocar",
				"patcherrelativepath" : "../../Library/z.abstractions_patches/z.3D.poltocar",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "z.dtor.maxpat",
				"bootpath" : "~/Documents/GitHub/SpatialAudioTesting/Max9/Library/z.abstractions_patches/z.dtor",
				"patcherrelativepath" : "../../Library/z.abstractions_patches/z.dtor",
				"type" : "JSON",
				"implicit" : 1
			}
, 			{
				"name" : "z.rtod.maxpat",
				"bootpath" : "~/Documents/GitHub/SpatialAudioTesting/Max9/Library/z.abstractions_patches/z.rtod",
				"patcherrelativepath" : "../../Library/z.abstractions_patches/z.rtod",
				"type" : "JSON",
				"implicit" : 1
			}
 ],
		"autosave" : 0
	}

}
