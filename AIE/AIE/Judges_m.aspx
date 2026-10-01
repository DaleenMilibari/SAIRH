<%@ Page Title="" Language="C#" MasterPageFile="~/PublicMobile.Master" AutoEventWireup="true" CodeBehind="Judges_m.aspx.cs" Inherits="AIE.Judges_m" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="container">
                <section aria-label="section" data-bgcolor="#f0f4fd">
                    <div class="padding40 bg-color text-light box-rounded">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-12 text-center">
                                    <h4>From outside Imam Abdularhahman bin Faisal University</h4>
                                </div>


                                <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ds_judges0">
                                    <ItemTemplate>
                                        <div class="col-lg-3 col-md-6 col-sm-6 mb30">
                                            <div class="f-profile text-center">
                                                <div class="fp-wrap f-invert">
                                                    <div class="fpw-overlay">
                                                        <div class="fpwo-wrap">
                                                        </div>
                                                    </div>
                                                    <div class="fpw-overlay-btm">
                                                    </div>

                                                    <img src='<%#Eval("ImagePath") %>' class="fp-image img-fluid" alt="" runat="server">
                                                </div>

                                                <h4><%#Eval("NameEn") %> </h4>
                                                <%#Eval("PositionEn") %>
                                                <br />
                                                <asp:LinkButton ID="BtnReadMoreOut" runat="server" CssClass="btn btn-primary" OnClick="BtnReadMoreOut_Click"
                                                CommandArgument='<%#Eval("PdfImage")+","+Eval("PdfPath")%>'>Read more</asp:LinkButton>
                                                <%--<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%#Eval("PdfPath") %>' Target="_blank" CssClass="btn btn-primary">Read more <i class="fa fa-file-pdf"></i></asp:HyperLink>--%>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>




                                <asp:SqlDataSource runat="server" ID="ds_judges0" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>' SelectCommand="SELECT * FROM [Judges] WHERE ([Category] = @Category)">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="0" Name="Category" Type="Byte"></asp:Parameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </section>
                <section aria-label="section" data-bgcolor="#f0f4fd">
                    <div class="padding40 bg-color text-light box-rounded">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-12 text-center">
                                    <h4>From Imam Abdularhahman bin Faisal University</h4>
                                </div>
                                <asp:Repeater ID="Repeater2" runat="server" DataSourceID="ds_judges1">
                                    <ItemTemplate>
                                        <div class="col-lg-3 col-md-6 col-sm-6 mb30">
                                            <div class="f-profile text-center">
                                                <div class="fp-wrap f-invert">
                                                    <div class="fpw-overlay">
                                                        <div class="fpwo-wrap">
                                                        </div>
                                                    </div>
                                                    <div class="fpw-overlay-btm">
                                                    </div>

                                                    <img src='<%#Eval("ImagePath") %>' class="fp-image img-fluid" alt="" runat="server">
                                                </div>

                                                <h4><%#Eval("NameEn") %> </h4>
                                                <%#Eval("PositionEn") %>
                                                <br />
                                                 <asp:LinkButton ID="BtnReadMore" runat="server" CssClass="btn btn-primary" OnClick="BtnReadMoreOut_Click"
                                                CommandArgument='<%#Eval("PdfImage")+","+Eval("PdfPath")%>'>Read more</asp:LinkButton>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>


                                <asp:SqlDataSource runat="server" ID="ds_judges1" ConnectionString='<%$ ConnectionStrings:AIEConnectionString %>' SelectCommand="SELECT * FROM [Judges] WHERE ([Category] = @Category)">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="1" Name="Category" Type="Byte"></asp:Parameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

              <cc2:ModalPopupExtender ID="modal_info" runat="server" BackgroundCssClass="modalBg"
                TargetControlID="hf_TargetID"
                PopupControlID="pnl_info"
                DropShadow="false">
            </cc2:ModalPopupExtender>
            <asp:Panel ID="pnl_info" runat="server">

                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLongTitle-3">Information Details</h5>
                            
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="BtnCloseInfo_Click"><span aria-hidden="true">&times;</span></asp:LinkButton>

                        </div>
                        <div class="modal-body">
                            <div runat="server" id="divPDF" visible="false">
                                Download Attachment &nbsp;
                           
                            </div>


                            <div class="spacer-single"></div>
                            <div class="padding20 bg-color text-light box-rounded col-md-12">

                                <img src="#" style="width: 100%;height:400px"  runat="server" id="imgInfo" />

                            </div>

                        </div>
                        <div class="modal-footer">
                             <asp:HyperLink ID="HlPdfPath" runat="server" NavigateUrl="#" Target="_blank" CssClass="btn btn-primary"><i class="fa fa-file-pdf"></i></asp:HyperLink>
                            <asp:LinkButton ID="BtnCloseInfo" runat="server" OnClick="BtnCloseInfo_Click" CssClass="btn btn-secondary">Close</asp:LinkButton>
                        </div>
                    </div>
                </div>

                <asp:HiddenField ID="hf_TargetID" runat="server" />
            </asp:Panel>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
