FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 5011

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["Snai.ApiServiceA.csproj", "Snai.ApiServiceA/"]
RUN dotnet restore "Snai.ApiServiceA/Snai.ApiServiceA.csproj"
COPY . .
WORKDIR "/src/Snai.ApiServiceA"
COPY . .
RUN dotnet build "Snai.ApiServiceA.csproj" -c Release -o /app
COPY . .
FROM build AS publish
RUN dotnet publish "Snai.ApiServiceA.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Snai.ApiServiceA.dll"]