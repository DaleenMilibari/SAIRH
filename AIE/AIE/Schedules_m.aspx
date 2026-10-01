<%@ Page Title="" Language="C#" MasterPageFile="~/PublicMobile.Master" AutoEventWireup="true" CodeBehind="Schedules_m.aspx.cs" Inherits="AIE.Schedules_m" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section id="subheader" class="text-light" data-bgimage="url(Content/images/background/1.jpg) bottom">
        <div class="center-y relative text-center">
            <div class="container">
                <div class="row">

                    <div class="col text-center">
                       
                        <div class="padding20 bg-color text-light box-rounded">
                             <%--<video controls autoplay style="width:100%">
                                    <source src="Content/video/schedule.mp4"" type="video/mp4">
                                    <source src="movie.ogg" type="video/ogg">
                                </video>--%>
                           
                           
                            <%--<video autoplay loop controls="controls" style="height: 273px; width: 490px; position: relative; top: 138px; left: 0px; ">
                             <source src="http://localhost:49363/Hotel2.mp4" type="video/mp4" /></video>--%>
                              <iframe class="embed-responsive-item" style="width:100%;height:350px" frameborder="0" id="Iframe1" runat="server" src="https://www.youtube.com/embed/U6Sw2dW0D0A?&autoplay=1&loop=1&rel=0&showinfo=0&color=white&iv_load_policy=3&playlist=U6Sw2dW0D0A"
                                allow="accelerometer;  clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

                        </div>
                        <p>Welcome to the Annual Innovation Exhibition </p>
                        <p>16-17 January 2024 (9am-2pm)</p>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </section>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <section aria-label="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-10 offset-md-1">
                            <div class="expand-list">
                                <div class="expand-custom">
                                    <div class="ec-header">
                                        <div class="c3 float-right">
                                            <span class="toggle"></span>
                                        </div>
                                        
                                        <div class="c2">
                                            <h5>Tuesday 16 January 2024 9:00 pm- 2:00 pm</h5>

                                        </div>

                                    </div>
                                    <div class="details" runat="server" id="details1">
                                        <div class="row">

                                            <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Innovation Hall
                                            </div>

                                            <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ds_schedules" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false" ></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Innovation Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="ds_schedules" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="1" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                            <div class="spacer-single"></div>
                                              <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Patent Hall
                                            </div>
                                            <dx:ASPxGridView ID="ASPxGridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <SettingsPager PageSize="50"></SettingsPager>
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Invention Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="2" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-10 offset-md-1">
                            <div class="expand-list">
                                <div class="expand-custom">
                                    <div class="ec-header">
                                        <div class="c3 float-right">
                                            <span class="toggle"></span>
                                        </div>
                                        
                                        <div class="c2">
                                            <h5>Wednesday 17 January 2024 9:00am-11:00am</h5>

                                        </div>

                                    </div>
                                    <div class="details" runat="server" id="details2">
                                        <div class="row">

                                            <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Innovation Hall
                                            </div>

                                            <dx:ASPxGridView ID="ASPxGridView3" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource2" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <SettingsPager PageSize="50"></SettingsPager>
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Innovation Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="3" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                            <div class="spacer-single"></div>
                                            <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Patent Hall
                                            </div>
                                            <dx:ASPxGridView ID="ASPxGridView4" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource3" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <SettingsPager PageSize="50"></SettingsPager>
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Invention Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="4" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-10 offset-md-1">
                            <div class="expand-list">
                                <div class="expand-custom">
                                    <div class="ec-header">
                                        <div class="c3 float-right">
                                            <span class="toggle"></span>
                                        </div>
                                        
                                        <div class="c2">
                                            <h5>Wednesday 17 January 2024 12:00-pm-2:00pm (Exclusive Human Health)</h5>

                                        </div>

                                    </div>
                                    <div class="details" runat="server" id="details3">
                                        <div class="row">

                                            <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Innovation Hall
                                            </div>

                                            <dx:ASPxGridView ID="ASPxGridView5" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource4" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <SettingsPager PageSize="50"></SettingsPager>
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Innovation Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="5" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                            <div class="spacer-single"></div>
                                            <div class="text-center alert alert-primary col-md-12 " style="font-size:larger;">
                                                Patent Hall
                                            </div>
                                            <dx:ASPxGridView ID="ASPxGridView6" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource5" Theme="Material" Width="100%" KeyFieldName="ScheduleID">
                                                <SettingsPager PageSize="50"></SettingsPager>
                                                <Styles>
                                                    <Header Font-Size="Large" HorizontalAlign="Center" CssClass="alert alert-primary"></Header>
                                                </Styles>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="false" AllowHideDataCellsByColumnMinWidth="true"></SettingsAdaptivity>

                                                <Settings ShowColumnHeaders="true" />
                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Sorting" VisibleIndex="1" Caption="No" Width="10px" Visible="false"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn Caption="Invention Project" VisibleIndex="2">
                                                        <DataItemTemplate>
                                                            <asp:LinkButton ID="BtnViewVideo" runat="server" EnableViewState="false" Width="100%" CommandArgument='<%#Eval("VideoLink")+","+Eval("PdfLink")%>'
                                                                OnClick="BtnViewVideo_Click"> 
                                                                 <%#Eval("InnovationZoneEn")%>                            
                                                            </asp:LinkButton>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PriorityEn" VisibleIndex="3" Caption="KSA Research Priority"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PresenterEn" VisibleIndex="3" Caption="Presenter"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CollegeEn" VisibleIndex="4" Caption="College"></dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="DayEn" VisibleIndex="6" GroupIndex="0" Caption="Day"></dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>'
                                                SelectCommand="SELECT [ScheduleID], [Sorting], [InnovationZoneEn], [PresenterEn],[PriorityEn], [CollegeEn],[VideoLink],[PdfLink] FROM [Schedules] WHERE ([SortingGroup] = @SortingGroup)">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="6" Name="SortingGroup" Type="Byte"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>
            </section>

            <cc2:ModalPopupExtender ID="modal_video" runat="server" BackgroundCssClass="modalBg"
                TargetControlID="hf_TargetID"
                PopupControlID="pnl_video"
                DropShadow="false">
            </cc2:ModalPopupExtender>
            <asp:Panel ID="pnl_video" runat="server">
                <!-- Large modal -->


                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLongTitle-3">Video Link</h5>
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="BtnCloseVideo_Click"><span aria-hidden="true">&times;</span></asp:LinkButton>

                        </div>
                        <div class="modal-body">
                            <div runat="server" id="divPDF" visible="false">
                                Download Attachment &nbsp;
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="#" Target="_blank" CssClass="btn btn-primary"><i class="fa fa-file-pdf"></i></asp:HyperLink>
                            </div>
                            

                             <div class="spacer-single"></div>
                            <iframe class="embed-responsive-item" width="350" height="350" frameborder="0" id="viewVideo" runat="server" 
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


                        </div>
                        <div class="modal-footer">

                            <asp:LinkButton ID="BtnCloseVideo" runat="server" OnClick="BtnCloseVideo_Click" CssClass="btn btn-secondary">Close</asp:LinkButton>
                        </div>
                    </div>
                </div>


                <asp:HiddenField ID="hf_TargetID" runat="server" />
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
