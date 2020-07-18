import csvkit

if __name__ == '__main__':

	from_ = sys.argv[1]

	filenames = glob.glob("outputs/*_%s_prepared.csv" % from_)

	if (len(filenames) == 0)
		print("Cannot find any outputs/*_%s_prepared.csv files.\n \
				Make sure that you run `make csv from=%s \
				before stacking the CSV files." % (from_, from_))

	param_names = extract_keys(glob.glob("configs/*.json"))

	main()