import org.broadinstitute.gatk.queue.QScript
import org.broadinstitute.gatk.queue.extensions.gatk._

class performBaseRecalibration extends QScript {

	qscript =>
	// qscript now equals performBaseRecalibration.this

	@Input(doc="Reference file for the bam files", shortName="R")
	var referenceFile: File = _

	@Input(doc="Input bam file", shortName="I")
	var bamFile: File = _

	@Input(doc="List of known sites", shortName="knownSites")
	var knownSites: List[File] = Nil

	@Input(doc="Output file", shortName="O")
	var outFile: File = _

	@Input(doc="Output file2", shortName="B")
	var outFile2: File = _

	@Input(doc="Output file3", shortName="P")
	var outFile3: File = _

	@Input(doc="Output file4", shortName="Z")
	var outFile4: File = _

	var Scatter = 1

	def script() {

		val baseRecalibrator = new BaseRecalibrator
		baseRecalibrator.scatterCount = Scatter
		baseRecalibrator.reference_sequence = referenceFile
		baseRecalibrator.input_file :+= bamFile
		baseRecalibrator.knownSites = knownSites
		baseRecalibrator.out = new File(outFile)

		val baseRecalibrator2 = new BaseRecalibrator
		baseRecalibrator2.scatterCount = Scatter
		baseRecalibrator2.reference_sequence = referenceFile
		baseRecalibrator2.input_file :+= bamFile
		baseRecalibrator2.knownSites = knownSites
		baseRecalibrator2.BQSR = outFile
		baseRecalibrator2.out = new File(outFile2)

		val AnalyzeCovariates = new AnalyzeCovariates
		AnalyzeCovariates.scatterCount = Scatter
		AnalyzeCovariates.reference_sequence = referenceFile
		AnalyzeCovariates.before = outFile
		AnalyzeCovariates.after = outFile2
		AnalyzeCovariates.plots = outFile3

		val printReads = new PrintReads
		printReads.scatterCount = Scatter
		printReads.reference_sequence = referenceFile
		printReads.input_file :+= bamFile
		printReads.BQSR = outFile
		printReads.DIQ
		printReads.out = new File(outFile4)

		add(baseRecalibrator)
		add(baseRecalibrator2)
		add(AnalyzeCovariates)
		add(printReads)
	}
}
