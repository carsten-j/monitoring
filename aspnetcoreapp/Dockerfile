FROM microsoft/aspnetcore:2.0.0-preview1
LABEL name "aspnetcoreapp"

ENV ASPNETCORE_URLS http://*:5000
EXPOSE 5000

COPY *.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish --output /out/ --configuration Release