# Konaseema Travels: AI Agentic Project

This project is a demo application for `Konaseema Travels` built on Azure AI Search and Flask. It shows how to integrate Azure Cognitive Search with a Python Flask frontend to create a localized travel search experience focused on the Konaseema region.

<img width="938" height="839" alt="Konaseema Travels" src="static/images/konaseema.jpg" />

<img width="860" height="618" alt="Konaseema Travels logo" src="static/images/logo.png" />

## Features
- **Konaseema Travels Web Experience**: A lightweight Flask app that showcases travel destinations, tours, and local content for Konaseema Travels.
- **Azure Cognitive Search Integration**: Leverage Azure's powerful search capabilities, including filtering, sorting, and faceted navigation for Konaseema travel content.
- **Environment Configuration**: Use `.env` files to securely manage sensitive credentials.
- **Customizable Search Queries**: Modify search parameters such as filters, sort orders, and facets to refine Konaseema travel results.

## Prerequisites
1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure Cognitive Search Service**: Set up a search service in the Azure portal.
3. **Python Environment**: Install Python 3.8 or later.
4. **Dependencies**: Install required Python packages using `pip install -r requirements.txt`.

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd AI-Search-Crash-Course/code
   ```
2. Create a `.env` file in the project root and add the following variables:
   ```env
   SEARCH_SERVICE_ENDPOINT=<your-search-service-endpoint>
   SEARCH_SERVICE_QUERY_KEY=<your-query-key>
   SEARCH_INDEX_NAME=<your-index-name>
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the Flask application:
   ```bash
   python app.py
   ```

## File Structure
- `app.py`: Main Flask application file.
- `templates/`: HTML templates for the web interface.
- `static/`: Static assets like CSS and images.
- `requirements.txt`: Python dependencies.
- `.env`: Environment variables for Azure Cognitive Search credentials.

## Learn More
- [Azure Cognitive Search Documentation](https://learn.microsoft.com/en-us/azure/search/)
- [Flask Documentation](https://flask.palletsprojects.com/)

## License
This project is licensed under the MIT License.
