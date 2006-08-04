#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

//#include <iostream.h>
#include <cstring>
#include "ppport.h"

#include "encoder.h"
using namespace CRFPP;

MODULE = Algorithm::CRF		PACKAGE = Algorithm::CRF		

PROTOTYPES: ENABLE

bool
crfpp_learn( templfile, trainfile, modelfile, textmodelfile, maxitr, freq, eta, C, thread_num , convert)
	const char *templfile
	const char *trainfile
	const char *modelfile
	bool textmodelfile
	size_t maxitr
	size_t freq
	double eta
	double C
	unsigned short thread_num
	int convert
    CODE:
CRFPP::Encoder encoder;
    if (thread_num > 1024)
	fprintf (stderr,"#thread is too big\n",encoder.what());
    if (convert) {
	if (! encoder.convert(templfile, trainfile)) {
	    //cerr << encoder.what() << endl;
	    fprintf (stderr,"%s\n",encoder.what());
	    RETVAL = -1;
	}
    } else {
	if (! encoder.learn ( templfile, 
	trainfile, 
	modelfile, 
	textmodelfile, 
	maxitr, 
	freq, 
	eta, 
	C, 
	thread_num )) {
	    //	cerr << encoder.what() << endl;
	    fprintf (stderr,"%s\n",encoder.what());
	    RETVAL = -1;
	} else
	    RETVAL = 0;
    }
    OUTPUT:
	RETVAL

