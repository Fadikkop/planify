public class Services.CalDAV.Providers.GenericProvider : Services.CalDAV.Providers.Base {
    public override string LOGIN_REQUEST {
        get {
            return "<d:propfind xmlns:d=\"DAV:\">\n" +
                   "  <d:prop>\n" +
                   "    <d:current-user-principal/>\n" +
                   "  </d:prop>\n" +
                   "</d:propfind>";
        }
    }

    public override string USER_DATA_REQUEST {
        get {
            return "<d:propfind xmlns:d=\"DAV:\">\n" +
                   "  <d:prop>\n" +
                   "    <d:displayname/>\n" +
                   "  </d:prop>\n" +
                   "</d:propfind>";
        }
    }

    public override string TASKLIST_REQUEST {
        get {
            return "<d:propfind xmlns:d=\"DAV:\">\n" +
                   "  <d:prop>\n" +
                   "    <d:resourcetype/>\n" +
                   "    <d:displayname/>\n" +
                   "  </d:prop>\n" +
                   "</d:propfind>";
        }
    }

    public override string get_server_url(string server_url, string username, string password) {
        return server_url;
    }

    public override string get_account_url(string server_url, string username) {
        return "%s/%s/".printf(server_url, username);
    }

    public override void set_user_data(GXml.DomDocument doc, Objects.Source source) {
        var displayname = doc.get_elements_by_tag_name("d:displayname").get_element(0).text_content;
        source.name = displayname;
    }

    public override string get_all_taskslist_url(string server_url, string username) {
        return "%s/%s/".printf(server_url, username);
    }

    public override Gee.ArrayList<Objects.Project> get_projects_by_doc(GXml.DomDocument doc, Objects.Source source) {
        var projects = new Gee.ArrayList<Objects.Project>();
        var responses = doc.get_elements_by_tag_name("d:response");

        foreach (GXml.DomElement response in responses) {
            var project = new Objects.Project();
            project.name = response.get_elements_by_tag_name("d:displayname").get_element(0).text_content;
            project.source_id = source.id;
            projects.add(project);
        }

        return projects;
    }

    public override bool is_vtodo_calendar(GXml.DomElement element) {
        var resourcetype = element.get_elements_by_tag_name("d:resourcetype").get_element(0);
        return resourcetype.get_elements_by_tag_name("cal:calendar").length > 0;
    }
}