/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.submit.step;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.app.util.Util;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.*;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.submit.AbstractProcessingStep;
import org.dspace.content.factory.ContentServiceFactory;


/**
 * Non-Interactive step for DSpace submission process. Handles the gathering of
 * descriptive information (i.e. metadata) for an item being submitted into
 * DSpace.
 * <P>
 * This class performs all the behind-the-scenes processing that
 * this particular step requires.  This class's methods are utilized
 * by both the JSP-UI and the Manakin XML-UI
 * <P>
 *
 * @see org.dspace.app.util.SubmissionConfig
 * @see org.dspace.app.util.SubmissionStepConfig
 * @see org.dspace.submit.AbstractProcessingStep
 *
 * @author Tim Donohue
 * @version $Revision$
 */
public class OMALSNonInteractiveStep extends AbstractProcessingStep
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(DescribeStep.class);
    
    /** hash of all submission forms details */
    private static DCInputsReader inputsReader = null;
    
    /***************************************************************************
     * STATUS / ERROR FLAGS (returned by doProcessing() if an error occurs or
     * additional user interaction may be required)
     *
     * (Do NOT use status of 0, since it corresponds to STATUS_COMPLETE flag
     * defined in the JSPStepManager class)
     **************************************************************************/
    // user requested an extra input field to be displayed
    //public static final int STATUS_MORE_INPUT_REQUESTED = 1;
    
    /** Constructor */
    public OMALSNonInteractiveStep() throws ServletException
    {
        //load the DCInputsReader
        getInputsReader();
    }
    
    /**
     * Do any processing of the information input by the user, and/or perform
     * step processing (if no user interaction required)
     * <P>
     * It is this method's job to save any data to the underlying database, as
     * necessary, and return error messages (if any) which can then be processed
     * by the appropriate user interface (JSP-UI or XML-UI)
     * <P>
     * NOTE: If this step is a non-interactive step (i.e. requires no UI), then
     * it should perform *all* of its processing in this method!
     *
     * @param context
     *            current DSpace context
     * @param request
     *            current servlet request object
     * @param response
     *            current servlet response object
     * @param subInfo
     *            submission info object
     * @return Status or error flag which will be processed by
     *         doPostProcessing() below! (if STATUS_COMPLETE or 0 is returned,
     *         no errors occurred!)
     */
    @Override
    public int doProcessing(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {
    	/*
        if(!request.getParameterNames().hasMoreElements()){
            //In case of an empty request do NOT just remove all metadata, just return to the submission page
            return STATUS_MORE_INPUT_REQUESTED;
        }
        */

        // get the item and current page
        Item item = subInfo.getSubmissionItem().getItem();
  
        
        // Added Step 4:
        // Add default metadata values
        addDefaultData(context, item);

        // Step 5:
        // Save changes to database
        ContentServiceFactory.getInstance().getInProgressSubmissionService(subInfo.getSubmissionItem()).update(context, subInfo.getSubmissionItem());

        // commit changes
        context.dispatchEvents();

        // completed without errors
        return STATUS_COMPLETE;
    }

    /**
     * Retrieves the number of pages that this "step" extends over. This method
     * is used to build the progress bar.
     * <P>
     * This method may just return 1 for most steps (since most steps consist of
     * a single page). But, it should return a number greater than 1 for any
     * "step" which spans across a number of HTML pages. For example, the
     * configurable "Describe" step (configured using input-forms.xml) overrides
     * this method to return the number of pages that are defined by its
     * configuration file.
     * <P>
     * Steps which are non-interactive (i.e. they do not display an interface to
     * the user) should return a value of 1, so that they are only processed
     * once!
     * 
     * @param request
     *            The HTTP Request
     * @param subInfo
     *            The current submission information object
     * 
     * @return the number of pages in this step
     */
    public int getNumberOfPages(HttpServletRequest request,
            SubmissionInfo subInfo) throws ServletException
    {
        // always just one page for verify step
        return 1;
    }
    
    /**
    *
    * @return the current DCInputsReader
    */
   public static DCInputsReader getInputsReader() throws ServletException
   {
       // load inputsReader only the first time
       if (inputsReader == null)
       {
           // read configurable submissions forms data
           try
           {
               inputsReader = new DCInputsReader();
           }
           catch (DCInputsReaderException e)
           {
               throw new ServletException(e);
           }
       }
       
       return inputsReader;
   }
   
   /**
    * Fill out some metadata date fields with default value from a form. 
    *
    * @param item
    *            the item to update
    * @throws SQLException
    */
   protected void addDefaultData(Context context, Item item) throws SQLException
   {
	   // dc.description.degree, dc.publisher, thesis.degree.name, thesis.degree.level, thesis.degree.grantor
       itemService.clearMetadata(context, item, "dc", "description", "degree", Item.ANY);
       itemService.addMetadata(context, item, "dc", "description", "degree", "en_US", "MALS");
	   
       itemService.clearMetadata(context, item, "dc", "publisher", null, Item.ANY);
       itemService.addMetadata(context, item, "dc", "publisher", null, "en_US", "Virginia Tech");
       
       itemService.clearMetadata(context, item, "thesis", "degree", "name", Item.ANY);
       itemService.addMetadata(context, item, "thesis", "degree", "name", "en_US", "Master of Agricultural and Life Sciences");
       
       itemService.clearMetadata(context, item, "thesis", "degree", "level", Item.ANY);
       itemService.addMetadata(context, item, "thesis", "degree", "level", "en_US", "masters");
       
       itemService.clearMetadata(context, item, "thesis", "degree", "grantor", Item.ANY);
       itemService.addMetadata(context, item, "thesis", "degree", "grantor", "en_US", "Virginia Polytechnic Institute and State University");
       
       /*
	   // remove dc.rights, dc.rights.uri
       item.clearMetadata("dc", "rights", null, Item.ANY);
       item.addMetadata("dc", "rights", null, "en_US", "In Copyright (InC)");
       item.addMetadata("dc", "rights", null, "en_US", "This Item is protected by copyright and/or related rights. Some uses of this Item may be deemed fair and permitted by law even without permission from the rights holder(s). For other uses, you need to obtain permission from the rights holder(s).");
       
       item.clearMetadata("dc", "rights", "uri", Item.ANY);
       item.addMetadata("dc", "rights", "uri", null, "http://rightsstatements.org/vocab/InC/1.0/");
       */
   }

}
